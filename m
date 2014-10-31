Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbaJaQV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 12:21:29 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:59322 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbaJaQV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:21:28 -0400
MIME-Version: 1.0
In-Reply-To: <1413908845-11526-1-git-send-email-matthias.bgg@gmail.com>
References: <1413908845-11526-1-git-send-email-matthias.bgg@gmail.com>
Date: Fri, 31 Oct 2014 17:21:26 +0100
Message-ID: <CABuKBeJNqTvf=t7tN4CWN4RLKvqQihxC9Ysk3OD6Ow6+2A+Q1w@mail.gmail.com>
Subject: Re: [PATCH] of: Request and map make argument name constant
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Matthias Brugger <matthias.bgg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

2014-10-21 18:27 GMT+02:00 Matthias Brugger <matthias.bgg@gmail.com>:
> This patch makes the name argument from of_io_request_and_map constant.

Any comments on this patch?

Thanks,
Matthias

>
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  drivers/of/address.c       | 2 +-
>  include/linux/of_address.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/of/address.c b/drivers/of/address.c
> index afdb782..e02828f 100644
> --- a/drivers/of/address.c
> +++ b/drivers/of/address.c
> @@ -871,7 +871,7 @@ EXPORT_SYMBOL(of_iomap);
>   *             return PTR_ERR(base);
>   */
>  void __iomem *of_io_request_and_map(struct device_node *np, int index,
> -                                       char *name)
> +                                       const char *name)
>  {
>         struct resource res;
>         void __iomem *mem;
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 8cb14eb..d88e81b 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -106,7 +106,7 @@ extern int of_address_to_resource(struct device_node *dev, int index,
>                                   struct resource *r);
>  void __iomem *of_iomap(struct device_node *node, int index);
>  void __iomem *of_io_request_and_map(struct device_node *device,
> -                                       int index, char *name);
> +                                       int index, const char *name);
>  #else
>
>  #include <linux/io.h>
> @@ -123,7 +123,7 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
>  }
>
>  static inline void __iomem *of_io_request_and_map(struct device_node *device,
> -                                       int index, char *name)
> +                                       int index, const char *name)
>  {
>         return IOMEM_ERR_PTR(-EINVAL);
>  }
> --
> 1.9.1
>



-- 
motzblog.wordpress.com
