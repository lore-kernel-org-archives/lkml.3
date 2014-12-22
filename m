Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaLVJCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:02:45 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:58710 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaLVJCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:02:40 -0500
MIME-Version: 1.0
In-Reply-To: <1419114611-11608-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419114611-11608-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
From: Vasily Khoruzhick <anarsoul@gmail.com>
Date: Mon, 22 Dec 2014 12:02:19 +0300
Message-ID: <CA+E=qVcpcnJ7WD7M6he=CA+6rK6ZHjTZfWv+2Szp2LvqsFiVbw@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: udc: s3c2410_udc.c: Remove some unused functions
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, Michal Sojka <sojka@merica.cz>,
        Arnd Bergmann <arnd@arndb.de>, linux-usb@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 1:30 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> Removes some functions that are not used anywhere:
> s3c2410_udc_clear_ep_state() s3c2410_udc_set_ep0_sse_out()
>
> This was partially found by using a static code analysis program called cppcheck.

Looks OK to me.

> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/usb/gadget/udc/s3c2410_udc.c |   20 --------------------
>  1 file changed, 20 deletions(-)
>
> diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/udc/s3c2410_udc.c
> index ff423d1..41b60cd 100644
> --- a/drivers/usb/gadget/udc/s3c2410_udc.c
> +++ b/drivers/usb/gadget/udc/s3c2410_udc.c
> @@ -238,14 +238,6 @@ static inline void s3c2410_udc_set_ep0_de_out(void __iomem *base)
>                         S3C2410_UDC_EP0_CSR_REG);
>  }
>
> -static inline void s3c2410_udc_set_ep0_sse_out(void __iomem *base)
> -{
> -       udc_writeb(base, S3C2410_UDC_INDEX_EP0, S3C2410_UDC_INDEX_REG);
> -       udc_writeb(base, (S3C2410_UDC_EP0_CSR_SOPKTRDY
> -                               | S3C2410_UDC_EP0_CSR_SSE),
> -                       S3C2410_UDC_EP0_CSR_REG);
> -}
> -
>  static inline void s3c2410_udc_set_ep0_de_in(void __iomem *base)
>  {
>         udc_writeb(base, S3C2410_UDC_INDEX_EP0, S3C2410_UDC_INDEX_REG);
> @@ -291,18 +283,6 @@ static void s3c2410_udc_nuke(struct s3c2410_udc *udc,
>         }
>  }
>
> -static inline void s3c2410_udc_clear_ep_state(struct s3c2410_udc *dev)
> -{
> -       unsigned i;
> -
> -       /* hardware SET_{CONFIGURATION,INTERFACE} automagic resets endpoint
> -        * fifos, and pending transactions mustn't be continued in any case.
> -        */
> -
> -       for (i = 1; i < S3C2410_ENDPOINTS; i++)
> -               s3c2410_udc_nuke(dev, &dev->ep[i], -ECONNABORTED);
> -}
> -
>  static inline int s3c2410_udc_fifo_count_out(void)
>  {
>         int tmp;
> --
> 1.7.10.4
>
