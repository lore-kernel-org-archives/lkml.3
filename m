Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaILQTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:19:05 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54455 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaILQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:19:02 -0400
X-AuditID: cbfee61a-f79e46d00000134f-11-54131cf4dd5e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 04/12] usb: dwc2: Add the appropriate init calls in
 platform code
Date: Fri, 12 Sep 2014 18:18:58 +0200
Message-id: <1609564.lrfde17RTW@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-5-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-5-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t9jAd0vMsIhBmuvKlscvF9vMWndASaL
	s8sOslms+rSG2WLlSW2L5sXr2SwuL7zEarFt+k8ga9ccNotFy1qZLRa+vsZisX3KdCaLB4d3
	sluc/NPLaPHqYBuLA7/H7IaLLB5/V71g9tg56y67x51re9g89s9dw+7Rf20Su8ffWftZPPq2
	rGL0+PLjH4vHlv2fGT2O39jO5PF5k5zHxrmhAbxRXDYpqTmZZalF+nYJXBkfV05gKvgrV3H3
	ymOWBsbjkl2MnBwSAiYS/158YIawxSQu3FvPBmILCSxilPj9M7GLkQvIbmGS2DJ9D1iCTcBK
	YmL7KkYQW0RASaJ31UsWkCJmgbNMEit2rQWbJCwQKfH3bRsriM0ioCqx//AWsGZeAU2JE42L
	WEBsUQFPiR3bV4LFOQX8JR7un8QGsW0yo8Se7Z3MEA2CEj8m3wNrYBaQl9i3fyorhK0jsb91
	GtsERoFZSMpmISmbhaRsASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgGHwmtYNxZYPF
	IUYBDkYlHt4KFsEQIdbEsuLK3EOMEhzMSiK8iqLCIUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
	D7RaBwoJpCeWpGanphakFsFkmTg4pRoYbVK5q6ReKyjcz5lySr6XecGey8e/vH4h3XDcotxE
	5eKDU+wv2A8JXDkW5c4Z/Ib9tdkpm8fu5nyerPO+vDc2jVs67TzzhauWUw8tmdUqKVEzZU3e
	iXubJjJubjdduDq058lG7aTmiu3SRyZ4Gm84Z+fEcrF66qsXLq5M9R1CtsqCfnIOGkaMSizF
	GYmGWsxFxYkAjzrfzL0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:19:55 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Add the proper init calls for either host, gadget or both in platform.c
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>  drivers/usb/dwc2/core.h     | 13 +++++++++++++
>  drivers/usb/dwc2/gadget.c   |  2 +-
>  drivers/usb/dwc2/platform.c | 28 ++++++++++++++++++++++++----

Where are correspoding changes to pci.c?

I cannot find them in your patchset.

>  3 files changed, 38 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index f55e62d..3a49a00 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -960,6 +960,19 @@ extern void dwc2_dump_global_registers(struct dwc2_hsotg *hsotg);
>   */
>  extern u16 dwc2_get_otg_version(struct dwc2_hsotg *hsotg);
>  
> +/* Gadget defines */
> +#if defined(CONFIG_USB_DWC2_PERIPHERAL) || defined(CONFIG_USB_DWC2_DUAL_ROLE)
> +extern int s3c_hsotg_remove(struct dwc2_hsotg *hsotg);
> +extern void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2);
> +extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
> +#else
> +static inline void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {}
> +static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
> +{ return 0; }
> +static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
> +{ return 0; }
> +#endif
> +
>  #if defined(CONFIG_USB_DWC2_HOST) || defined(CONFIG_USB_DWC2_DUAL_ROLE)
>  /**
>   * dwc2_hcd_get_frame_number() - Returns current frame number
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 96f868f..efa68a0 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -3572,7 +3572,7 @@ err_clk:
>   * s3c_hsotg_remove - remove function for hsotg driver
>   * @pdev: The platform information for the driver
>   */
> -static int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
> +int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
>  {
>  	usb_del_gadget_udc(&hsotg->gadget);
>  
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index dd2f8f5..2871f351 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -92,7 +92,14 @@ static int dwc2_driver_remove(struct platform_device *dev)
>  {
>  	struct dwc2_hsotg *hsotg = platform_get_drvdata(dev);
>  
> -	dwc2_hcd_remove(hsotg);
> +	if (IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL))
> +		s3c_hsotg_remove(hsotg);
> +	else if (IS_ENABLED(CONFIG_USB_DWC2_HOST))
> +		dwc2_hcd_remove(hsotg);
> +	else { /* dual role */
> +		dwc2_hcd_remove(hsotg);
> +		s3c_hsotg_remove(hsotg);

Why not simply always call:

		dwc2_hcd_remove(hsotg);
		s3c_hsotg_remove(hsotg);

and add appropriate stub for dwc2_hcd_remove() for
CONFIG_USB_DWC2_PERIPHERAL=y?

> +	}
>  
>  	return 0;
>  }
> @@ -176,9 +183,22 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  
>  	hsotg->dr_mode = of_usb_get_dr_mode(dev->dev.of_node);
>  
> -	retval = dwc2_hcd_init(hsotg, irq, params);
> -	if (retval)
> -		return retval;
> +	if (IS_ENABLED(CONFIG_USB_DWC2_DUAL_ROLE)) {
> +		retval = dwc2_gadget_init(hsotg, irq);
> +		if (retval)
> +			return retval;
> +		retval = dwc2_hcd_init(hsotg, irq, params);
> +		if (retval)
> +			return retval;
> +	} else if (IS_ENABLED(CONFIG_USB_DWC2_HOST)) {
> +		retval = dwc2_hcd_init(hsotg, irq, params);
> +		if (retval)
> +			return retval;
> +	} else if (IS_ENABLED(CONFIG_USB_DWC2_PERIPHERAL)) {
> +		retval = dwc2_gadget_init(hsotg, irq);
> +		if (retval)
> +			return retval;
> +	}

ditto but for dwc2_hcd_init().

>  	platform_set_drvdata(dev, hsotg);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

