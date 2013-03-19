Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab3CSLq1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:46:27 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:50798
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753143Ab3CSLqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:46:25 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ahbe9i1155h)
Subject: Re: [Patch v1] rtc: fix for the DA9052 rtc device registration
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <p_gortmaker@yahoo.com>, <dchen@diasemi.com>,
        <rtc-linux@googlegroups.com>, Alessandro Zummo <a.zummo@towertech.it>
In-Reply-To: <20130318152145.3a458537db6c4799311a2143@linux-foundation.org>
References: <1363336179.30613.18.camel@dhruva>
	 <20130318152145.3a458537db6c4799311a2143@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Mar 2013 17:12:45 +0530
Message-ID: <1363693365.6897.1.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-18 at 15:21 -0700, Andrew Morton wrote:
> On Fri, 15 Mar 2013 13:59:39 +0530 Ashish Jangam <ashish.jangam@kpitcummins.com> wrote:
> 
> > DA9052/53 MFD core handles only virtual irq therefore rtc driver needs
> > to be updated to work on virtual irq. Without this update DA9052/53 rtc 
> > driver will fail during its registration.
> > Also getting irq by it name is no longer supported in DA9052/53 core.
> > 
> > ...
> >
> > --- a/drivers/rtc/rtc-da9052.c
> > +++ b/drivers/rtc/rtc-da9052.c
> > @@ -239,10 +239,10 @@ static int da9052_rtc_probe(struct platform_device *pdev)
> >  
> >  	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
> >  	platform_set_drvdata(pdev, rtc);
> > -	rtc->irq = platform_get_irq_byname(pdev, "ALM");
> > -	ret = request_threaded_irq(rtc->irq, NULL, da9052_rtc_irq,
> > -				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> > -				   "ALM", rtc);
> > +	rtc->irq =  DA9052_IRQ_ALARM;
> > +
> > +	ret = da9052_request_irq(rtc->da9052, rtc->irq, "ALM",
> > +				da9052_rtc_irq, rtc);
> >  	if (ret != 0) {
> >  		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
> >  		return ret;
> 
> drivers/rtc/rtc-da9052.c was converted to use
> devm_request_threaded_irq() after linux-3.8, so I cannot apply this
> patch to mainline.  Can you please prepare a patch against 3.9-rc3?
Yes.
> 
> Do you believe that the patch should be backported into -stable
> kernels?  If so, Greg will need a different version of it - ie, the one
> you have just sent.  Please send that to him at the appropriate time
> (say, when you see me drop the 3.9-rc3 version from the -mm tree).
Ok, I will do the necessary.


