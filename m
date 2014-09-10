Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaIJIMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:12:14 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:46354 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaIJIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:12:09 -0400
Date: Wed, 10 Sep 2014 09:12:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Carlo Caione <carlo@caione.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>
Subject: Re: [PATCH v2 1/4] mfd/axp20x: rename files to support more devices
Message-ID: <20140910081201.GK30307@lee--X1>
References: <1410267775-4683-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410267775-4683-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410267775-4683-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Sep 2014, Jacob Pan wrote:

> More XPowers PMIC devices can be supported by extending this driver, so
> rename it to axp2xx to cover axp288 variant.
> 
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/mfd/Kconfig                      | 7 ++++---
>  drivers/mfd/Makefile                     | 2 +-
>  drivers/mfd/{axp20x.c => axp2xx.c}       | 2 +-
>  include/linux/mfd/{axp20x.h => axp2xx.h} | 0
>  4 files changed, 6 insertions(+), 5 deletions(-)
>  rename drivers/mfd/{axp20x.c => axp2xx.c} (99%)
>  rename include/linux/mfd/{axp20x.h => axp2xx.h} (100%)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index de5abf2..42a70a3 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -67,14 +67,15 @@ config MFD_BCM590XX
>  	help
>  	  Support for the BCM590xx PMUs from Broadcom
>  
> -config MFD_AXP20X
> -	bool "X-Powers AXP20X"
> +config MFD_AXP2XX
> +	bool "X-Powers AXP2XX"
>  	select MFD_CORE
>  	select REGMAP_I2C
>  	select REGMAP_IRQ
>  	depends on I2C=y
>  	help
> -	  If you say Y here you get support for the X-Powers AXP202 and AXP209.
> +	  If you say Y here you get support for the X-Powers AXP202, AXP209 and
> +	  AXP288 power management IC (PMIC).
>  	  This driver include only the core APIs. You have to select individual
>  	  components like regulators or the PEK (Power Enable Key) under the
>  	  corresponding menus.
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index f001487..55d76b3 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -103,7 +103,7 @@ obj-$(CONFIG_PMIC_DA9052)	+= da9052-irq.o
>  obj-$(CONFIG_PMIC_DA9052)	+= da9052-core.o
>  obj-$(CONFIG_MFD_DA9052_SPI)	+= da9052-spi.o
>  obj-$(CONFIG_MFD_DA9052_I2C)	+= da9052-i2c.o
> -obj-$(CONFIG_MFD_AXP20X)	+= axp20x.o
> +obj-$(CONFIG_MFD_AXP2XX)	+= axp2xx.o
>  
>  obj-$(CONFIG_MFD_LP3943)	+= lp3943.o
>  obj-$(CONFIG_MFD_LP8788)	+= lp8788.o lp8788-irq.o
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp2xx.c
> similarity index 99%
> rename from drivers/mfd/axp20x.c
> rename to drivers/mfd/axp2xx.c
> index dee6539..c534443 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp2xx.c
> @@ -21,7 +21,7 @@
>  #include <linux/regmap.h>
>  #include <linux/slab.h>
>  #include <linux/regulator/consumer.h>
> -#include <linux/mfd/axp20x.h>
> +#include <linux/mfd/axp2xx.h>
>  #include <linux/mfd/core.h>
>  #include <linux/of_device.h>
>  #include <linux/of_irq.h>
> diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp2xx.h
> similarity index 100%
> rename from include/linux/mfd/axp20x.h
> rename to include/linux/mfd/axp2xx.h

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
