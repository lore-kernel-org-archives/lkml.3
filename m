Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3H0U0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:26:12 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:52077 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab3H0U0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:26:10 -0400
Message-ID: <521D0B41.7080706@ti.com>
Date: Wed, 28 Aug 2013 01:55:37 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH v3 6/7] ARM: davinci: dmxxx: gpio device creation
References: <1376803143-13738-1-git-send-email-prabhakar.csengg@gmail.com> <1376803143-13738-7-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1376803143-13738-7-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/18/2013 10:49 AM, Lad, Prabhakar wrote:
> From: Philip Avinash <avinashphilip@ti.com>
> 
> Create davinci gpio device and remove gpio references in
> davinci_soc_info structure for dmxxx platforms. Also add Memory and IRQ
> resources for GPIO platform device. Also rearrange header file inclusion
> in group basis.
> 
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  arch/arm/mach-davinci/board-dm355-evm.c           |   33 +++++++-----
>  arch/arm/mach-davinci/board-dm355-leopard.c       |   30 ++++++-----
>  arch/arm/mach-davinci/board-dm365-evm.c           |   30 ++++++-----
>  arch/arm/mach-davinci/board-dm644x-evm.c          |   40 ++++++++------
>  arch/arm/mach-davinci/board-dm646x-evm.c          |   37 +++++++------
>  arch/arm/mach-davinci/board-neuros-osd2.c         |   18 ++++---
>  arch/arm/mach-davinci/davinci.h                   |   17 +++---
>  arch/arm/mach-davinci/dm355.c                     |   54 +++++++++++++------
>  arch/arm/mach-davinci/dm365.c                     |   58 ++++++++++++++-------
>  arch/arm/mach-davinci/dm644x.c                    |   47 ++++++++++++-----
>  arch/arm/mach-davinci/dm646x.c                    |   47 ++++++++++++-----
>  arch/arm/mach-davinci/include/mach/common.h       |    2 +
>  arch/arm/mach-davinci/include/mach/gpio-davinci.h |    2 -
>  13 files changed, 272 insertions(+), 143 deletions(-)
> 
> +int __init dm355_gpio_register()

This line and other lines like this for other SoCs causes
compiler warning.

> --- a/arch/arm/mach-davinci/include/mach/common.h
> +++ b/arch/arm/mach-davinci/include/mach/common.h
> @@ -38,6 +38,8 @@ struct davinci_timer_info {
>  
>  struct davinci_gpio_controller;
>  
> +#define DAVINCI_GPIO_BASE 0x01c67000

No need to place this in a globally visible header.
There is a local davinci.h just for this purpose.

So here is the updated patch with all the SoC bits
of this patch moved.

Thanks,
Sekhar

---8<---
>From a01133ae68247d762b491a56bbf9fc8d94b389c4 Mon Sep 17 00:00:00 2001
From: Philip Avinash <avinashphilip@ti.com>
Date: Sun, 18 Aug 2013 10:49:02 +0530
Subject: [PATCH 6/7] ARM: davinci: board: gpio device creation

Create GPIO device for existing DaVinci boards.

While at it, group related header files together and
sort in alphabetic order within the group. This will
help in future in avoiding duplicate header files.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
[nsekhar@ti.com: remove soc bits from this patch and simplify
		 commit message]
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/mach-davinci/board-dm355-evm.c     |   33 +++++++++++++---------
 arch/arm/mach-davinci/board-dm355-leopard.c |   30 ++++++++++++--------
 arch/arm/mach-davinci/board-dm365-evm.c     |   30 ++++++++++++--------
 arch/arm/mach-davinci/board-dm644x-evm.c    |   40 +++++++++++++++++----------
 arch/arm/mach-davinci/board-dm646x-evm.c    |   37 ++++++++++++++-----------
 arch/arm/mach-davinci/board-neuros-osd2.c   |   18 ++++++++----
 6 files changed, 114 insertions(+), 74 deletions(-)

diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
index 42b23a3..4712fb4 100644
--- a/arch/arm/mach-davinci/board-dm355-evm.c
+++ b/arch/arm/mach-davinci/board-dm355-evm.c
@@ -8,29 +8,31 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/err.h>
-#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
-#include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/clk.h>
+#include <linux/mtd/partitions.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
+#include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 #include <linux/videodev2.h>
+
 #include <media/tvp514x.h>
-#include <linux/spi/spi.h>
-#include <linux/spi/eeprom.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <linux/platform_data/i2c-davinci.h>
+#include <mach/common.h>
 #include <mach/serial.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
@@ -375,6 +377,11 @@ static struct spi_board_info dm355_evm_spi_info[] __initconst = {
 static __init void dm355_evm_init(void)
 {
 	struct clk *aemif;
+	int ret;
+
+	ret = dm355_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
 
 	gpio_request(1, "dm9000");
 	gpio_direction_input(1);
diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
index d9eb1c9..fbaeea8 100644
--- a/arch/arm/mach-davinci/board-dm355-leopard.c
+++ b/arch/arm/mach-davinci/board-dm355-leopard.c
@@ -7,27 +7,28 @@
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/err.h>
-#include <linux/platform_device.h>
+#include <linux/gpio.h>
+#include <linux/i2c.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/mtd/mtd.h>
-#include <linux/mtd/partitions.h>
 #include <linux/mtd/nand.h>
-#include <linux/i2c.h>
-#include <linux/gpio.h>
-#include <linux/clk.h>
-#include <linux/spi/spi.h>
+#include <linux/mtd/partitions.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
 #include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <linux/platform_data/i2c-davinci.h>
+#include <mach/common.h>
 #include <mach/serial.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
 
 #include "davinci.h"
 
@@ -233,6 +234,11 @@ static struct spi_board_info dm355_leopard_spi_info[] __initconst = {
 static __init void dm355_leopard_init(void)
 {
 	struct clk *aemif;
+	int ret;
+
+	ret = dm355_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
 
 	gpio_request(9, "dm9000");
 	gpio_direction_input(9);
diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
index 000e2ab..9c1dd31 100644
--- a/arch/arm/mach-davinci/board-dm365-evm.c
+++ b/arch/arm/mach-davinci/board-dm365-evm.c
@@ -12,33 +12,33 @@
  * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
-#include <linux/io.h>
-#include <linux/clk.h>
 #include <linux/i2c/at24.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/leds.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
 #include <linux/slab.h>
-#include <linux/mtd/nand.h>
-#include <linux/input.h>
-#include <linux/spi/spi.h>
 #include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 #include <linux/v4l2-dv-timings.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
-#include <mach/mux.h>
 #include <mach/common.h>
-#include <linux/platform_data/i2c-davinci.h>
+#include <mach/mux.h>
 #include <mach/serial.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/keyscan-davinci.h>
 
 #include <media/ths7303.h>
 #include <media/tvp514x.h>
@@ -743,6 +743,12 @@ static struct spi_board_info dm365_evm_spi_info[] __initconst = {
 
 static __init void dm365_evm_init(void)
 {
+	int ret;
+
+	ret = dm365_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	evm_init_i2c();
 	davinci_serial_init(dm365_serial_device);
 
diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
index 462812b..d0894d8 100644
--- a/arch/arm/mach-davinci/board-dm644x-evm.c
+++ b/arch/arm/mach-davinci/board-dm644x-evm.c
@@ -8,37 +8,42 @@
  * is licensed "as is" without any warranty of any kind, whether express
  * or implied.
  */
-#include <linux/kernel.h>
-#include <linux/init.h>
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
-#include <linux/platform_device.h>
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
-#include <linux/i2c/pcf857x.h>
 #include <linux/i2c/at24.h>
+#include <linux/i2c/pcf857x.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mtd/physmap.h>
 #include <linux/phy.h>
-#include <linux/clk.h>
-#include <linux/videodev2.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/keyscan-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/slab.h>
+#include <linux/spi/eeprom.h>
+#include <linux/spi/spi.h>
 #include <linux/v4l2-dv-timings.h>
-#include <linux/export.h>
-
-#include <media/tvp514x.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/common.h>
-#include <linux/platform_data/i2c-davinci.h>
-#include <mach/serial.h>
 #include <mach/mux.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
-#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <mach/serial.h>
+
+#include <media/tvp514x.h>
 
 #include "davinci.h"
 
@@ -753,9 +758,14 @@ static int davinci_phy_fixup(struct phy_device *phydev)
 
 static __init void davinci_evm_init(void)
 {
+	int ret;
 	struct clk *aemif_clk;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = dm644x_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	aemif_clk = clk_get(NULL, "aemif");
 	clk_prepare_enable(aemif_clk);
 
diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
index 734cc02..fe79d8d 100644
--- a/arch/arm/mach-davinci/board-dm646x-evm.c
+++ b/arch/arm/mach-davinci/board-dm646x-evm.c
@@ -16,37 +16,37 @@
  * Included Files
  **************************************************************************/
 
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/leds.h>
+#include <linux/clk.h>
+#include <linux/export.h>
 #include <linux/gpio.h>
-#include <linux/platform_device.h>
 #include <linux/i2c.h>
 #include <linux/i2c/at24.h>
 #include <linux/i2c/pcf857x.h>
-
-#include <media/tvp514x.h>
-#include <media/adv7343.h>
-
+#include <linux/init.h>
+#include <mach/irqs.h>
+#include <linux/kernel.h>
+#include <linux/leds.h>
 #include <linux/mtd/mtd.h>
 #include <linux/mtd/nand.h>
 #include <linux/mtd/partitions.h>
-#include <linux/clk.h>
-#include <linux/export.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/mtd-davinci-aemif.h>
+#include <linux/platform_device.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
+#include <mach/cdce949.h>
+#include <mach/clock.h>
 #include <mach/common.h>
 #include <mach/serial.h>
-#include <linux/platform_data/i2c-davinci.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <mach/clock.h>
-#include <mach/cdce949.h>
-#include <linux/platform_data/mtd-davinci-aemif.h>
 
-#include "davinci.h"
+#include <media/tvp514x.h>
+#include <media/adv7343.h>
+
 #include "clock.h"
+#include "davinci.h"
 
 #define NAND_BLOCK_SIZE		SZ_128K
 
@@ -785,8 +785,13 @@ static struct edma_rsv_info dm646x_edma_rsv[] = {
 
 static __init void evm_init(void)
 {
+	int ret;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = dm646x_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	evm_init_i2c();
 	davinci_serial_init(dm646x_serial_device);
 	dm646x_init_mcasp0(&dm646x_evm_snd_data[0]);
diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
index 8e156e0..322eabd 100644
--- a/arch/arm/mach-davinci/board-neuros-osd2.c
+++ b/arch/arm/mach-davinci/board-neuros-osd2.c
@@ -23,20 +23,21 @@
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
  */
-#include <linux/platform_device.h>
 #include <linux/gpio.h>
 #include <linux/mtd/partitions.h>
+#include <linux/platform_data/gpio-davinci.h>
+#include <linux/platform_data/i2c-davinci.h>
+#include <linux/platform_data/mmc-davinci.h>
+#include <linux/platform_data/mtd-davinci.h>
+#include <linux/platform_data/usb-davinci.h>
+#include <linux/platform_device.h>
 
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include <mach/common.h>
-#include <linux/platform_data/i2c-davinci.h>
-#include <mach/serial.h>
 #include <mach/mux.h>
-#include <linux/platform_data/mtd-davinci.h>
-#include <linux/platform_data/mmc-davinci.h>
-#include <linux/platform_data/usb-davinci.h>
+#include <mach/serial.h>
 
 #include "davinci.h"
 
@@ -168,9 +169,14 @@ static struct davinci_mmc_config davinci_ntosd2_mmc_config = {
 
 static __init void davinci_ntosd2_init(void)
 {
+	int ret;
 	struct clk *aemif_clk;
 	struct davinci_soc_info *soc_info = &davinci_soc_info;
 
+	ret = dm644x_gpio_register();
+	if (ret)
+		pr_warn("%s: GPIO init failed: %d\n", __func__, ret);
+
 	aemif_clk = clk_get(NULL, "aemif");
 	clk_prepare_enable(aemif_clk);
 
-- 
1.7.10.1

