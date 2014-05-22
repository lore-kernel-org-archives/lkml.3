Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaEVSs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:48:56 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:34036 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaEVSsy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:48:54 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [PATCH] DWC2: intializes the spin_lock earlier in the probe
Thread-Topic: [PATCH] DWC2: intializes the spin_lock earlier in the probe
Thread-Index: AQHPdbeQEO8eKAcUaEu1Ru1KeWBgoZtM8OBQ
Date: Thu, 22 May 2014 18:48:45 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E03048449F075@US01WEMBX2.internal.synopsys.com>
References: <1400760610-13815-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1400760610-13815-1-git-send-email-jjhiblot@traphandler.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jean-Jacques Hiblot [mailto:jjhiblot@traphandler.com]
> Sent: Thursday, May 22, 2014 5:10 AM
> 
> The spinlock hsotg->lock is intialized at the end of the probe. However it
> may be used from within dwc2_hcd_init(). This patch moves the
> initialization before the call to dwc2_hcd_init(). This make the locking
> correctness validator happy.
> 
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
> ---
>  drivers/usb/dwc2/platform.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 37a8ab0..55fb30d 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -156,6 +156,8 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  		params.dma_desc_enable = prop;
>  	}
> 
> +	spin_lock_init(&hsotg->lock);
> +
>  	if (IS_ENABLED(CONFIG_USB_DWC2_HOST)) {
>  		retval = dwc2_hcd_init(hsotg, irq, &params);
>  		if (retval)
> @@ -175,7 +177,6 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  		if (retval)
>  			return retval;
>  	}
> -	spin_lock_init(&hsotg->lock);
> 
>  	platform_set_drvdata(dev, hsotg);
>  	return retval;
> --

Hmm. What tree is this against? platform.c in both Linus' tree and in
Greg's usb-next tree does not have a call to spin_lock_init().

-- 
Paul

