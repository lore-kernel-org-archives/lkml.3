Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaILP5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 11:57:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56549 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbaILP47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 11:56:59 -0400
X-AuditID: cbfee61b-f79f86d00000144c-40-541317c96deb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 02/12] usb: dwc2: move "samsung,s3c6400-hsotg" into
 common platform
Date: Fri, 12 Sep 2014 17:56:54 +0200
Message-id: <1813730.yGZdjFHdNk@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-3-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-3-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jQd2T4sIhBj0vTCwO3q+3mLTuAJPF
	2WUH2SxWfVrDbLHypLZF8+L1bBaXF15itdg2/SeQtWsOm8WiZa3MFgtfX2Ox2D5lOpPFg8M7
	2S1O/ulltHh1sI3Fgd9jdsNFFo+/q14we+ycdZfd4861PWwe++euYffovzaJ3ePvrP0sHn1b
	VjF6fPnxj8Vjy/7PjB7Hb2xn8vi8Sc5j49zQAN4oLpuU1JzMstQifbsErozjTdUFm/krprYv
	ZG9gvMnTxcjJISFgIrF3dSsbhC0mceHeeiCbi0NIYDqjxMfOQ4wQTguTRPP1B6wgVWwCVhIT
	21cxgtgiAkoSvatesoAUMQucZZJYsWstM0hCWCBaovffFiYQm0VAVeJLx1sWEJtXQFNi3vuF
	YM2iAp4SO7avBFvNKeAvMfvmTnaIbZOBVr/Zwg7RICjxY/I9sGZmAXmJffunskLYOhL7W6ex
	TWAUmIWkbBaSsllIyhYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7BZ9I7GFc1WBxi
	FOBgVOLhrWQRDBFiTSwrrsw9xCjBwawkwqsoKhwixJuSWFmVWpQfX1Sak1p8iFGag0VJnPdg
	q3WgkEB6YklqdmpqQWoRTJaJg1OqgXFS/jHHhrV5F85ekGRKVpiwt3ux5s4XmhIiTBfqpWr3
	qHpWBkexC1fufFeTXfOrrnvmcVNx2/nr3p8zF3Tua+95ZxmdUZPQcP7XgvfvA53+Ni26JyN4
	4v3GTr/SzUrXF7/InGQt2tW3pqRIsEeqd2PvGU6z2E+LdXW7RGet2f5q4dM90zfZVimxFGck
	GmoxFxUnAgANsN8LvQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:19:53 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Move the "samsung,s3c6400-hsotg" binding as the probe function in the gadget
> driver will get removed when the dual-role driver is implemented.

Sorry but no.  In the current form this just breaks gadget support for
Samsung devices as probe function for gadget will no longer be called.

[ This should be done in the same patch that aggregates gadget and host
  initializations into one driver. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>  drivers/usb/dwc2/gadget.c   | 1 -
>  drivers/usb/dwc2/platform.c | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 94f7a3f..8c45b4c 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -3674,7 +3674,6 @@ static int s3c_hsotg_resume(struct platform_device *pdev)
>  
>  #ifdef CONFIG_OF
>  static const struct of_device_id s3c_hsotg_of_ids[] = {
> -	{ .compatible = "samsung,s3c6400-hsotg", },
>  	{ .compatible = "snps,dwc2", },
>  	{ /* sentinel */ }
>  };
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 5f0c4bb..dd2f8f5 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -100,6 +100,7 @@ static int dwc2_driver_remove(struct platform_device *dev)
>  static const struct of_device_id dwc2_of_match_table[] = {
>  	{ .compatible = "brcm,bcm2835-usb", .data = &params_bcm2835 },
>  	{ .compatible = "snps,dwc2", .data = NULL },
> +	{ .compatible = "samsung,s3c6400-hsotg", .data = NULL},
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, dwc2_of_match_table);

