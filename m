Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaKDQA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:00:59 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:47544 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311AbaKDQAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:00:54 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: Request and map make argument name constant
To: Matthias Brugger <matthias.bgg@gmail.com>, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <1413908845-11526-1-git-send-email-matthias.bgg@gmail.com>
References: <1413908845-11526-1-git-send-email-matthias.bgg@gmail.com>
Date: Tue, 04 Nov 2014 16:00:48 +0000
Message-Id: <20141104160048.10D57C423D0@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 18:27:25 +0200
, Matthias Brugger <matthias.bgg@gmail.com>
 wrote:
> This patch makes the name argument from of_io_request_and_map constant.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

Applied, thanks.

g.

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
>   *		return PTR_ERR(base);
>   */
>  void __iomem *of_io_request_and_map(struct device_node *np, int index,
> -					char *name)
> +					const char *name)
>  {
>  	struct resource res;
>  	void __iomem *mem;
> diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> index 8cb14eb..d88e81b 100644
> --- a/include/linux/of_address.h
> +++ b/include/linux/of_address.h
> @@ -106,7 +106,7 @@ extern int of_address_to_resource(struct device_node *dev, int index,
>  				  struct resource *r);
>  void __iomem *of_iomap(struct device_node *node, int index);
>  void __iomem *of_io_request_and_map(struct device_node *device,
> -					int index, char *name);
> +					int index, const char *name);
>  #else
>  
>  #include <linux/io.h>
> @@ -123,7 +123,7 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
>  }
>  
>  static inline void __iomem *of_io_request_and_map(struct device_node *device,
> -					int index, char *name)
> +					int index, const char *name)
>  {
>  	return IOMEM_ERR_PTR(-EINVAL);
>  }
> -- 
> 1.9.1
> 

