Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3CMJM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:12:26 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:33530 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab3CMJMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:12:24 -0400
MIME-Version: 1.0
In-Reply-To: <1362230724-21017-1-git-send-email-gautam.vivek@samsung.com>
References: <CAFp+6iGGAY=nMg03-bqHz=XuNP+1t9mQR=M53HGoqCXv=t+f0Q@mail.gmail.com>
	<1362230724-21017-1-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 13 Mar 2013 14:42:22 +0530
Message-ID: <CAFp+6iFjiOPbZhdpWCq0agWBeSC+Vc19Ff++_3vxa6r-MburWg@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc3: Set DWC3 context's mode based on selected mode.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbi,


On Sat, Mar 2, 2013 at 6:55 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Now that machines may select the mode of working of DWC3 (HOST only,
> GADGET only or DUAL_ROLE), lets set DWC3 mode based on that
> rather than fixing it to whatever DWC3 hardware says.
> This way we can skip initializing Gadget/Host in case
> we are using Host-only/Gadget-only mode respectively.
>

Hope this patch if fine, and mainlinable ?

> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>
> Changes from RFC patch "usb: dwc3: Set GCTL.PrtCapDir based on selected mode"
>  - Setting the mode in dwc3 context structure based on
>    selected mode in machine, rather than programming PrtCapDir
>
>  drivers/usb/dwc3/core.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 79f335f..be0672f 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -478,7 +478,12 @@ static int dwc3_probe(struct platform_device *pdev)
>                 goto err1;
>         }
>
> -       mode = DWC3_MODE(dwc->hwparams.hwparams0);
> +       if (IS_ENABLED(CONFIG_USB_DWC3_HOST))
> +               mode = DWC3_MODE_HOST;
> +       else if (IS_ENABLED(CONFIG_USB_DWC3_GADGET))
> +               mode = DWC3_MODE_DEVICE;
> +       else
> +               mode = DWC3_MODE_DRD;
>
>         switch (mode) {
>         case DWC3_MODE_DEVICE:
> --
> 1.7.6.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks & Regards
Vivek
