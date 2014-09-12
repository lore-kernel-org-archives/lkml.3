Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaILQgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 12:36:42 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61153 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaILQgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 12:36:40 -0400
X-AuditID: cbfee61a-f79e46d00000134f-b1-54132115a4cd
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: dinguyen@opensource.altera.com
Cc: paulz@synopsys.com, gregkh@linuxfoundation.org, balbi@ti.com,
        dinh.linux@gmail.com, swarren@wwwdotorg.org, matthijs@stdin.nl,
        r.baldyga@samsung.com, jg1.han@samsung.com, sachin.kamat@linaro.org,
        ben-linux@fluff.org, dianders@chromium.org, kever.yang@rock-chips.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 10/12] usb: dwc2: Add suspend/resume for gadget
Date: Fri, 12 Sep 2014 18:36:35 +0200
Message-id: <1684243.Plm2d5fvK6@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1409070003-21195-11-git-send-email-dinguyen@opensource.altera.com>
References: <1409070003-21195-1-git-send-email-dinguyen@opensource.altera.com>
 <1409070003-21195-11-git-send-email-dinguyen@opensource.altera.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t9jAV1RReEQg8/tZhYH79dbTFp3gMni
	7LKDbBarPq1htlh5UtuiefF6NovLCy+xWmyb/hPI2jWHzWLRslZmi4Wvr7FYbJ8yncniweGd
	7BYn//QyWrw62MbiwO8xu+Eii8ffVS+YPXbOusvucefaHjaP/XPXsHv0X5vE7vF31n4Wj74t
	qxg9vvz4x+KxZf9nRo/jN7YzeXzeJOexcW5oAG8Ul01Kak5mWWqRvl0CV0bbqp2sBYvkKvZv
	bmJpYPws0cXIySEhYCKxY80ZNghbTOLCvfVANheHkMAiRolzX2cyQjgtTBKthxawg1SxCVhJ
	TGxfxQhiiwgoSfSueskCUsQscJZJYsWutcxdjBwcwgKuErf+KoDUsAioShzfux6sl1dAU2Lm
	ik6wXlEBT4kd21eygZRzCgRIbJ2bA7FrCqPEpJ6vTBD1ghI/Jt9jAbGZBeQl9u2fygph60js
	b53GNoFRYBaSsllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgCn0ntYFzZ
	YHGIUYCDUYmHt4JFMESINbGsuDL3EKMEB7OSCK+iqHCIEG9KYmVValF+fFFpTmrxIUZpDhYl
	cd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBsZgzThTmVPCjo2Ff7jmzdlfEHboV6bwHjPPFD8m
	g7aFH5ep/MncHfD0/9ZZSQ95DFe9W/psU5Tt1Z9N6yrec95zczxxjVchoFSysd47JrJ7TpYl
	40zmOxwtL7ZdVUzfOj/6Xidj2mx38ebXorYOt8XvFar8nvCpJuLphft9iU7TXhaXvJ74SFqJ
	pTgj0VCLuag4EQA7nnu5vAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added linux-kernel ML to cc: ]

Hi,

On Tuesday, August 26, 2014 11:20:01 AM dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Move suspend/resume code to common platform code.

This should be done at the same time that gadget/host probing is merged
to preserve bisectability.

> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Acked-by: Paul Zimmerman <paulz@synopsys.com>
> ---
>  drivers/usb/dwc2/core.h     |  6 ++++++
>  drivers/usb/dwc2/gadget.c   |  4 ++--
>  drivers/usb/dwc2/platform.c | 23 +++++++++++++++++++++++
>  3 files changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index bbb0f52..5bb7e801 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -964,12 +964,18 @@ extern u16 dwc2_get_otg_version(struct dwc2_hsotg *hsotg);
>  #if defined(CONFIG_USB_DWC2_PERIPHERAL) || defined(CONFIG_USB_DWC2_DUAL_ROLE)
>  extern int s3c_hsotg_remove(struct dwc2_hsotg *hsotg);
>  extern void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2);
> +extern int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2);
> +extern int s3c_hsotg_resume(struct dwc2_hsotg *dwc2);
>  extern int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq);
>  irqreturn_t s3c_hsotg_irq(int irq, void *pw);
>  #else
>  static inline void s3c_hsotg_core_init(struct dwc2_hsotg *dwc2) {}
>  static inline int s3c_hsotg_remove(struct dwc2_hsotg *dwc2)
>  { return 0; }
> +static inline int s3c_hsotg_suspend(struct dwc2_hsotg *dwc2)
> +{ return 0; }
> +static inline int s3c_hsotg_resume(struct dwc2_hsotg *dwc2)
> +{ return 0; }
>  static inline int dwc2_gadget_init(struct dwc2_hsotg *hsotg, int irq)
>  { return 0; }
>  static inline irqreturn_t s3c_hsotg_irq(int irq, void *pw)
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index aab1b45..09d591e 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -3552,7 +3552,7 @@ int s3c_hsotg_remove(struct dwc2_hsotg *hsotg)
>  	return 0;
>  }
>  
> -static int s3c_hsotg_suspend(struct dwc2_hsotg *hsotg)
> +int s3c_hsotg_suspend(struct dwc2_hsotg *hsotg)
>  {
>  	unsigned long flags;
>  	int ret = 0;
> @@ -3581,7 +3581,7 @@ static int s3c_hsotg_suspend(struct dwc2_hsotg *hsotg)
>  	return ret;
>  }
>  
> -static int s3c_hsotg_resume(struct dwc2_hsotg *hsotg)
> +int s3c_hsotg_resume(struct dwc2_hsotg *hsotg)
>  {
>  	unsigned long flags;
>  	int ret = 0;
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 278135d..59265ad 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -206,6 +206,27 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  	return retval;
>  }
>  
> +static int dwc2_suspend(struct platform_device *dev, pm_message_t state)
> +{
> +	struct dwc2_hsotg *dwc2 = platform_get_drvdata(dev);
> +	int ret = 0;
> +
> +	if (dwc2_is_device_mode(dwc2))
> +		ret = s3c_hsotg_suspend(dwc2);
> +	return ret;
> +}
> +
> +static int dwc2_resume(struct platform_device *dev)
> +{
> +	struct dwc2_hsotg *dwc2 = platform_get_drvdata(dev);
> +	int ret = 0;
> +
> +	if (dwc2_is_device_mode(dwc2))
> +		ret = s3c_hsotg_resume(dwc2);
> +
> +	return ret;
> +}
> +
>  static struct platform_driver dwc2_platform_driver = {
>  	.driver = {
>  		.name = dwc2_driver_name,
> @@ -213,6 +234,8 @@ static struct platform_driver dwc2_platform_driver = {
>  	},
>  	.probe = dwc2_driver_probe,
>  	.remove = dwc2_driver_remove,
> +	.suspend = dwc2_suspend,
> +	.resume = dwc2_resume,

Please use the new PM API (struct dev_pm_ops).

>  };
>  
>  module_platform_driver(dwc2_platform_driver);

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

