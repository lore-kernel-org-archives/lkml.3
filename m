Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3HUOq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:46:56 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17631 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab3HUOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:46:52 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-76-5214d2d9cb1c
Message-id: <5214D2D8.7010106@samsung.com>
Date: Wed, 21 Aug 2013 16:46:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH V2] i2c: move of helpers into the core
References: <1377092832-3417-1-git-send-email-wsa@the-dreams.de>
In-reply-to: <1377092832-3417-1-git-send-email-wsa@the-dreams.de>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t/xq7o3L4kEGRzdYWNx7lYDq8X8I+dY
	LZbv62e02PT4GqvFwrYlLBYdf78wWlzeNYfNomfDVlaL2Uv6WSxmnN/HZNH5ZRabxe/v/1gt
	Vp6YxezA6zFnWhOLx+Yl9R7nZyxk9Dh56gmLx+dNcgGsUVw2Kak5mWWpRfp2CVwZ99edZilo
	1quYv2cNcwPjSqUuRk4OCQETiU9tG9khbDGJC/fWs3UxcnEICSxllJg1/wILhPOJUeJ093MW
	kCpeAS2Jb1dnMoLYLAKqEr9P9IDZbAKGEr1H+8BsUYEAicVLzrFD1AtK/Jh8D6xXREBFonP9
	f7ChzAJtzBLH+o8zgSSEBawkTv4FWc0BtM1BomNuAEiYU8BRYuGbQ2AzmQV0JPa3TmODsOUl
	Nq95yzyBUWAWkhWzkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkZIhHzdwbj0
	mNUhRgEORiUe3gs7RYKEWBPLiitzDzFKcDArifAWngQK8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YJzHmco2W+3Z47BDJx/Ok0xWXitcl7Gi4mxi38/650f4Nd5bzm+95fIucJfpjFcPee+Wn5N9
	e6Nd6//kdQsMH7SF9f6VfXBb7mPunbXO74xLHIt366pzNAe8uqFpInbC7r3Q8/QHZ87wVwXv
	E5KfcL/s5oPHAcXr3fO/2G/eHJw02at87dS5Yj1KLMUZiYZazEXFiQBBqkhHbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 03:47 PM, Wolfram Sang wrote:
> I2C of helpers used to live in of_i2c.c but experience (from SPI) shows
> that it is much cleaner to have this in the core. This also removes a
> circular dependency between the helpers and the core, and so we can
> finally register child nodes in the core instead of doing this manually
> in each driver. So, fix the drivers and documentation, too.
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@amsung.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

With this patch there are still couple of of_i2c.h header file
inclusions:

$ git grep of_i2c.h
arch/powerpc/platforms/44x/warp.c:#include <linux/of_i2c.h>
drivers/gpu/drm/tilcdc/tilcdc_slave.c:#include <linux/of_i2c.h>
drivers/gpu/drm/tilcdc/tilcdc_tfp410.c:#include <linux/of_i2c.h>
drivers/gpu/host1x/drm/output.c:#include <linux/of_i2c.h>
drivers/media/platform/exynos4-is/fimc-is.c:#include <linux/of_i2c.h>
drivers/media/platform/exynos4-is/media-dev.c:#include <linux/of_i2c.h>
drivers/staging/imx-drm/imx-tve.c:#include <linux/of_i2c.h>
sound/soc/fsl/imx-sgtl5000.c:#include <linux/of_i2c.h>
sound/soc/fsl/imx-wm8962.c:#include <linux/of_i2c.h>


Please include also this chunk, without it I'm getting build errors.

--------------8<---------------------
diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index ca07b48..e38e9dc 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -11,6 +11,7 @@
  */

 #include <linux/clk.h>
+#include <linux/i2c.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
diff --git a/drivers/media/platform/exynos4-is/fimc-is.c
b/drivers/media/platform/exynos4-is/fimc-is.c
index 6743ae3..63e4f1d 100644
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/of_i2c.h>
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 #include <linux/of_platform.h>
diff --git a/drivers/media/platform/exynos4-is/media-dev.c
b/drivers/media/platform/exynos4-is/media-dev.c
index c10dee2..00e5f91 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -22,7 +22,6 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
-#include <linux/of_i2c.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/types.h>
--------------8<---------------------

> ---
> 
> V1 -> V2: * Add #else branch to #if CONFIG_OF
> 	  * EXPORT_SYMBOLs got attached to wrong functions
> 	  * cosmetic change (of -> OF)
> 	  * properly based on 3.11-rc4
> 
>  Documentation/acpi/enumeration.txt              |    1 -
>  drivers/i2c/busses/i2c-at91.c                   |    3 -
>  drivers/i2c/busses/i2c-cpm.c                    |    6 --
>  drivers/i2c/busses/i2c-davinci.c                |    2 -
>  drivers/i2c/busses/i2c-designware-platdrv.c     |    2 -
>  drivers/i2c/busses/i2c-gpio.c                   |    3 -
>  drivers/i2c/busses/i2c-i801.c                   |    2 -
>  drivers/i2c/busses/i2c-ibm_iic.c                |    4 -
>  drivers/i2c/busses/i2c-imx.c                    |    3 -
>  drivers/i2c/busses/i2c-mpc.c                    |    2 -
>  drivers/i2c/busses/i2c-mv64xxx.c                |    3 -
>  drivers/i2c/busses/i2c-mxs.c                    |    3 -
>  drivers/i2c/busses/i2c-nomadik.c                |    3 -
>  drivers/i2c/busses/i2c-ocores.c                 |    3 -
>  drivers/i2c/busses/i2c-octeon.c                 |    3 -
>  drivers/i2c/busses/i2c-omap.c                   |    3 -
>  drivers/i2c/busses/i2c-pnx.c                    |    3 -
>  drivers/i2c/busses/i2c-powermac.c               |    9 +-
>  drivers/i2c/busses/i2c-pxa.c                    |    2 -
>  drivers/i2c/busses/i2c-s3c2410.c                |    2 -
>  drivers/i2c/busses/i2c-sh_mobile.c              |    2 -
>  drivers/i2c/busses/i2c-sirf.c                   |    3 -
>  drivers/i2c/busses/i2c-stu300.c                 |    2 -
>  drivers/i2c/busses/i2c-tegra.c                  |    3 -
>  drivers/i2c/busses/i2c-versatile.c              |    2 -
>  drivers/i2c/busses/i2c-wmt.c                    |    3 -
>  drivers/i2c/busses/i2c-xiic.c                   |    3 -
>  drivers/i2c/i2c-core.c                          |  109 +++++++++++++++++++++-
>  drivers/i2c/i2c-mux.c                           |    3 -
>  drivers/i2c/muxes/i2c-arb-gpio-challenge.c      |    1 -
>  drivers/i2c/muxes/i2c-mux-gpio.c                |    1 -
>  drivers/i2c/muxes/i2c-mux-pinctrl.c             |    1 -
>  drivers/media/platform/exynos4-is/fimc-is-i2c.c |    3 -
>  drivers/of/Kconfig                              |    6 --
>  drivers/of/Makefile                             |    1 -
>  drivers/of/of_i2c.c                             |  114 -----------------------
>  include/linux/i2c.h                             |   20 ++++
>  include/linux/of_i2c.h                          |   46 ---------
>  38 files changed, 132 insertions(+), 253 deletions(-)
>  delete mode 100644 drivers/of/of_i2c.c
>  delete mode 100644 include/linux/of_i2c.h

I've tested this patch on Exynos4412 SoC based board, so this covers
i2c-s3c2410 and fimc-is-i2c. Compiled with CONFIG_OF enabled.

I guess after removing all remaining occurrences of
#include <linux/of_i2c.h> you could add:

Tested-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--
Thanks,
Sylwester

