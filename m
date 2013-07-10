Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329Ab3GJVwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 17:52:24 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40427 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab3GJVwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 17:52:22 -0400
Message-ID: <51DDD792.7000300@cogentembedded.com>
Date: Thu, 11 Jul 2013 01:52:18 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Yuan-Hsin Chen <yhchen@faraday-tech.com>, Felipe Balbi <balbi@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: fotg210-udc: Remove bogus __init/__exit
 annotations
References: <1373492716-14684-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1373492716-14684-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 01:45 AM, Geert Uytterhoeven wrote:

> When builtin (CONFIG_USB_FOTG210_UDC=y):

>    LD      drivers/usb/gadget/built-in.o
> WARNING: drivers/usb/gadget/built-in.o(.data+0xbf8): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

>    LD      drivers/usb/built-in.o
> WARNING: drivers/usb/built-in.o(.data+0x14684): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

>    LD      drivers/built-in.o
> WARNING: drivers/built-in.o(.data+0x8b0c8): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

>    CHK     include/generated/uapi/linux/version.h
>    LINK    vmlinux
>    LD      vmlinux.o
>    MODPOST vmlinux.o
> WARNING: vmlinux.o(.data+0xc6730): Section mismatch in reference from the variable fotg210_driver to the function .init.text:fotg210_udc_probe()
> The variable fotg210_driver references
> the function __init fotg210_udc_probe()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

>    GEN     .version
>    CHK     include/generated/compile.h
>    UPD     include/generated/compile.h
>    CC      init/version.o
>    LD      init/built-in.o
> `.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o
> make[3]: *** [vmlinux] Error 1

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>   drivers/usb/gadget/fotg210-udc.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/usb/gadget/fotg210-udc.c b/drivers/usb/gadget/fotg210-udc.c
> index cce5535..10cd18d 100644
> --- a/drivers/usb/gadget/fotg210-udc.c
> +++ b/drivers/usb/gadget/fotg210-udc.c
> @@ -1074,7 +1074,7 @@ static struct usb_gadget_ops fotg210_gadget_ops = {
>   	.udc_stop		= fotg210_udc_stop,
>   };
>
> -static int __exit fotg210_udc_remove(struct platform_device *pdev)
> +static int fotg210_udc_remove(struct platform_device *pdev)

    I think you can leave __exit annotation here, if you enclose the 
reference in the driver structure in __exit_p()...

WBR, Sergei

