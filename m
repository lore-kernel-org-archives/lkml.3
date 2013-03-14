Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964844Ab3CNRPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:15:06 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874Ab3CNRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:15:03 -0400
Date: Thu, 14 Mar 2013 18:14:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Fabio Porcedda <fabio.porcedda@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Josh Wu <josh.wu@atmel.com>, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v2 1/8] drivers: media: use module_platform_driver_probe()
In-Reply-To: <1363280978-24051-2-git-send-email-fabio.porcedda@gmail.com>
Message-ID: <Pine.LNX.4.64.1303141814290.22728@axis700.grange>
References: <1363280978-24051-1-git-send-email-fabio.porcedda@gmail.com>
 <1363280978-24051-2-git-send-email-fabio.porcedda@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:P5Om0fe6XZJ6ivb6L3K61wZbCi+/ULtnOh563m/WOtD
 wmC/ZXaV0GQxMvwIy6PEWVnmJLVeD0Fof95asnFdqEE5IXJj/9
 c+sEsrZ5n+8YwQeFuMznOvDAOsR1CZxyggv8zb1k+aGd8m3w0d
 A/cblw//Nq91nPYLw7O3WGOYUmdyWtPjqsH9+TIyKUWz0NtX3v
 YpJgxbrZQDtQiId7eZ+z/WXAQ8YlOgca5z2d5Ck5rF7SqXL07R
 B45Z3hK7XIgmN5BOWhrkE04WPMUl9Jr4ji+63osGa1raLAiCN0
 GcmLyF5irr2SI5R4S0upTwYRnOp8b099fvfnHP0Yf0xCHLMM2d
 vYoHsgr+Mg2lTM5XBs8URy0Yzj2h4UAJ/3FnC3OfHgIFZm9tdK
 TIkemxQ5Wn8+w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Mar 2013, Fabio Porcedda wrote:

> This patch converts the drivers to use the
> module_platform_driver_probe() macro which makes the code smaller and
> a bit simpler.
> 
> Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>

Thanks, will queue for 3.10.

Regards
Guennadi

> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Josh Wu <josh.wu@atmel.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: linux-media@vger.kernel.org
> ---
>  drivers/media/platform/soc_camera/atmel-isi.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 82dbf99..12ba31d 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -1081,17 +1081,7 @@ static struct platform_driver atmel_isi_driver = {
>  	},
>  };
>  
> -static int __init atmel_isi_init_module(void)
> -{
> -	return  platform_driver_probe(&atmel_isi_driver, &atmel_isi_probe);
> -}
> -
> -static void __exit atmel_isi_exit(void)
> -{
> -	platform_driver_unregister(&atmel_isi_driver);
> -}
> -module_init(atmel_isi_init_module);
> -module_exit(atmel_isi_exit);
> +module_platform_driver_probe(atmel_isi_driver, atmel_isi_probe);
>  
>  MODULE_AUTHOR("Josh Wu <josh.wu@atmel.com>");
>  MODULE_DESCRIPTION("The V4L2 driver for Atmel Linux");
> -- 
> 1.8.1.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
