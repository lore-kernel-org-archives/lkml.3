Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750978AbaEWHzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:55:47 -0400
Received: from 18.mo4.mail-out.ovh.net ([188.165.54.143]:51616 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750790AbaEWHzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:55:46 -0400
X-Greylist: delayed 1206 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 May 2014 03:55:46 EDT
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E03048449F075@US01WEMBX2.internal.synopsys.com>
References: <1400760610-13815-1-git-send-email-jjhiblot@traphandler.com>
	<A2CA0424C0A6F04399FB9E1CD98E03048449F075@US01WEMBX2.internal.synopsys.com>
Date: Fri, 23 May 2014 09:17:41 +0200
Message-ID: <CACh+v5P10mZk5WVZ8Gi09T+nsQ-EsVrpS=T2ZOEjotGS41UP9g@mail.gmail.com>
Subject: Re: [PATCH] DWC2: intializes the spin_lock earlier in the probe
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
X-Ovh-Tracer-Id: 17732642059759802392
X-Ovh-Remote: 209.85.213.170 (mail-ig0-f170.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejvddrheehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My mistake. It actually comes not from the mainline but from the altera tree.
Sorry for the noise

2014-05-22 20:48 GMT+02:00 Paul Zimmerman <Paul.Zimmerman@synopsys.com>:
>
>> From: Jean-Jacques Hiblot [mailto:jjhiblot@traphandler.com]
>> Sent: Thursday, May 22, 2014 5:10 AM
>>
>> The spinlock hsotg->lock is intialized at the end of the probe. However it
>> may be used from within dwc2_hcd_init(). This patch moves the
>> initialization before the call to dwc2_hcd_init(). This make the locking
>> correctness validator happy.
>>
>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>> ---
>>  drivers/usb/dwc2/platform.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
>> index 37a8ab0..55fb30d 100644
>> --- a/drivers/usb/dwc2/platform.c
>> +++ b/drivers/usb/dwc2/platform.c
>> @@ -156,6 +156,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
>>               params.dma_desc_enable = prop;
>>       }
>>
>> +     spin_lock_init(&hsotg->lock);
>> +
>>       if (IS_ENABLED(CONFIG_USB_DWC2_HOST)) {
>>               retval = dwc2_hcd_init(hsotg, irq, &params);
>>               if (retval)
>> @@ -175,7 +177,6 @@ static int dwc2_driver_probe(struct platform_device *dev)
>>               if (retval)
>>                       return retval;
>>       }
>> -     spin_lock_init(&hsotg->lock);
>>
>>       platform_set_drvdata(dev, hsotg);
>>       return retval;
>> --
>
> Hmm. What tree is this against? platform.c in both Linus' tree and in
> Greg's usb-next tree does not have a call to spin_lock_init().
>
> --
> Paul
>
