Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3JKWbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 18:31:24 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17236 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3JKWbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 18:31:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 Oct 2013 15:27:05 -0700
Message-ID: <52587C37.3070606@nvidia.com>
Date: Fri, 11 Oct 2013 15:31:19 -0700
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] gpiolib: add gpiod_get() and gpiod_put() functions
References: <1381515273-25466-1-git-send-email-acourbot@nvidia.com> <1381515273-25466-4-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1381515273-25466-4-git-send-email-acourbot@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#else
> +static struct device_node *of_find_gpio(struct device *dev, const char *id
> +					unsigned int idx, unsigned long flags)
> +{
> +	return ERR_PTR(-ENODEV);
> +}
> +#endif

... and of course I forgot to fix the main compilation error. Linus, 
would you mind squashing what follows into this patch? Apologies for
the inconvenience.

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 05b9981..e1d1a15 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2172,8 +2172,8 @@ static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
 	return desc;
 }
 #else
-static struct device_node *of_find_gpio(struct device *dev, const char *id
-					unsigned int idx, unsigned long flags)
+static struct gpio_desc *of_find_gpio(struct device *dev, const char *con_id,
+				      unsigned int idx, unsigned long *flags)
 {
 	return ERR_PTR(-ENODEV);
 }

