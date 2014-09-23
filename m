Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaIWH04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 03:26:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbaIWH0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 03:26:54 -0400
Date: Tue, 23 Sep 2014 15:24:26 +0800
From: Dave Young <dyoung@redhat.com>
To: Mark Salter <msalter@redhat.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        Daniel Kiper <daniel.kiper@oracle.com>, Russ Anderson <rja@sgi.com>,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH 7/7] efi_rtc: probe function error out in case no efi
 runtime enabled
Message-ID: <20140923072426.GB3916@darkstar.nay.redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
 <1408007953-15151-1-git-send-email-dyoung@redhat.com>
 <1411403609.25340.55.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411403609.25340.55.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mark

On 09/22/14 at 12:33pm, Mark Salter wrote:
> On Thu, 2014-08-14 at 17:19 +0800, Dave Young wrote:
> > efi rtc depends on efi runtime services, so if efi runtime services are not
> > usable it should error out.
> > 
> > Without this patch rtc-efi will panic with 'noefi' boot
> 
> Is this still needed after commit da167ad7638759:
> 
>   rtc: ia64: allow other architectures to use EFI RTC
> 
> That should keep efi_rtc_probe from being called if runtime services
> are not available.

If that's the case then this patch should be unnecessary, I have no machine
to test it currently though.

> 
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  drivers/rtc/rtc-efi.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
> > index c4c3843..ca2487b 100644
> > --- a/drivers/rtc/rtc-efi.c
> > +++ b/drivers/rtc/rtc-efi.c
> > @@ -191,6 +191,9 @@ static int __init efi_rtc_probe(struct platform_device *dev)
> >  {
> >  	struct rtc_device *rtc;
> >  
> > +	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > +		return -ENODEV;
> > +
> >  	rtc = devm_rtc_device_register(&dev->dev, "rtc-efi", &efi_rtc_ops,
> >  					THIS_MODULE);
> >  	if (IS_ERR(rtc))
> 
> 
