Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3FAOJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 10:09:01 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:36251 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3FAOIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 10:08:54 -0400
MIME-Version: 1.0
In-Reply-To: <1370038972-2318779-16-git-send-email-arnd@arndb.de>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
	<1370038972-2318779-16-git-send-email-arnd@arndb.de>
Date: Sat, 1 Jun 2013 09:01:07 -0500
Message-ID: <CAL_Jsq+-7RizbVQSA-JnJRZFc9-3RFCXuCOXP=GfCin2Losfeg@mail.gmail.com>
Subject: Re: [PATCH 15/15] OF: remove #ifdef from linux/of_platform.h
From: Rob Herring <robherring2@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, patches@lists.linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 5:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> A lot of code uses the functions from of_platform.h when built for
> devicetree-enabled platforms but can also be built without them.
> In order to avoid using #ifdef everywhere in drivers, this
> makes all the function declarations visible, which means we
> can use "if (IS_ENABLED(CONFIG_OF))" in driver code and get build
> coverage over the code but let the compiler drop the reference
> in the object code.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>

I've got a more complete series for 3.11 that removes OF_DEVICE and
of_platform_driver completely. I'm waiting on ack from Ben H.

Rob

> ---
>  include/linux/of_platform.h | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
> index 2a93b64..7747ad0 100644
> --- a/include/linux/of_platform.h
> +++ b/include/linux/of_platform.h
> @@ -13,8 +13,6 @@
>
>  #include <linux/device.h>
>  #include <linux/mod_devicetable.h>
> -
> -#ifdef CONFIG_OF_DEVICE
>  #include <linux/pm.h>
>  #include <linux/of_device.h>
>  #include <linux/platform_device.h>
> @@ -82,7 +80,6 @@ extern struct platform_device *of_device_alloc(struct device_node *np,
>                                          struct device *parent);
>  extern struct platform_device *of_find_device_by_node(struct device_node *np);
>
> -#ifdef CONFIG_OF_ADDRESS /* device reg helpers depend on OF_ADDRESS */
>  /* Platform devices and busses creation */
>  extern struct platform_device *of_platform_device_create(struct device_node *np,
>                                                    const char *bus_id,
> @@ -91,17 +88,12 @@ extern struct platform_device *of_platform_device_create(struct device_node *np,
>  extern int of_platform_bus_probe(struct device_node *root,
>                                  const struct of_device_id *matches,
>                                  struct device *parent);
> +#ifdef CONFIG_OF_ADDRESS
>  extern int of_platform_populate(struct device_node *root,
>                                 const struct of_device_id *matches,
>                                 const struct of_dev_auxdata *lookup,
>                                 struct device *parent);
> -#endif /* CONFIG_OF_ADDRESS */
> -
> -#endif /* CONFIG_OF_DEVICE */
> -
> -#if !defined(CONFIG_OF_ADDRESS)
> -struct of_dev_auxdata;
> -struct device_node;
> +#else
>  static inline int of_platform_populate(struct device_node *root,
>                                         const struct of_device_id *matches,
>                                         const struct of_dev_auxdata *lookup,
> @@ -109,6 +101,6 @@ static inline int of_platform_populate(struct device_node *root,
>  {
>         return -ENODEV;
>  }
> -#endif /* !CONFIG_OF_ADDRESS */
> +#endif
>
>  #endif /* _LINUX_OF_PLATFORM_H */
> --
> 1.8.1.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
