Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641AbaFKI7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:59:21 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56395 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932596AbaFKI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:15 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 34/36] ARM: OMAP2+: gpmc: Make externally unused functions/defines private
Date: Wed, 11 Jun 2014 11:56:39 +0300
Message-ID: <1402477001-31132-35-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the GPMC functions are now not used by other drivers.
Make them private.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 84 ++++++++++++++++++++++++++++++----------------
 arch/arm/mach-omap2/gpmc.h | 63 ----------------------------------
 2 files changed, 56 insertions(+), 91 deletions(-)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 7a667ca..9173f71 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -80,6 +80,45 @@
 #define GPMC_ECC_CTRL_ECCREG8		0x008
 #define GPMC_ECC_CTRL_ECCREG9		0x009
 
+/* ECC commands */
+#define GPMC_ECC_READ		0 /* Reset Hardware ECC for read */
+#define GPMC_ECC_WRITE		1 /* Reset Hardware ECC for write */
+#define GPMC_ECC_READSYN	2 /* Reset before syndrom is read back */
+
+/* CS CONFIG registers */
+#define GPMC_CS_CONFIG1		0x00
+#define GPMC_CS_CONFIG2		0x04
+#define GPMC_CS_CONFIG3		0x08
+#define GPMC_CS_CONFIG4		0x0c
+#define GPMC_CS_CONFIG5		0x10
+#define GPMC_CS_CONFIG6		0x14
+#define GPMC_CS_CONFIG7		0x18
+
+#define GPMC_CONFIG1_WRAPBURST_SUPP     (1 << 31)
+#define GPMC_CONFIG1_READMULTIPLE_SUPP  (1 << 30)
+#define GPMC_CONFIG1_READTYPE_ASYNC     (0 << 29)
+#define GPMC_CONFIG1_READTYPE_SYNC      (1 << 29)
+#define GPMC_CONFIG1_WRITEMULTIPLE_SUPP (1 << 28)
+#define GPMC_CONFIG1_WRITETYPE_ASYNC    (0 << 27)
+#define GPMC_CONFIG1_WRITETYPE_SYNC     (1 << 27)
+#define GPMC_CONFIG1_CLKACTIVATIONTIME(val) ((val & 3) << 25)
+#define GPMC_CONFIG1_PAGE_LEN(val)      ((val & 3) << 23)
+#define GPMC_CONFIG1_WAIT_READ_MON      (1 << 22)
+#define GPMC_CONFIG1_WAIT_WRITE_MON     (1 << 21)
+#define GPMC_CONFIG1_WAIT_MON_IIME(val) ((val & 3) << 18)
+#define GPMC_CONFIG1_WAIT_PIN_SEL(val)  ((val & 3) << 16)
+#define GPMC_CONFIG1_DEVICESIZE(val)    ((val & 3) << 12)
+#define GPMC_CONFIG1_DEVICESIZE_16      GPMC_CONFIG1_DEVICESIZE(1)
+#define GPMC_CONFIG1_DEVICETYPE(val)    ((val & 3) << 10)
+#define GPMC_CONFIG1_DEVICETYPE_NOR     GPMC_CONFIG1_DEVICETYPE(0)
+#define GPMC_CONFIG1_MUXTYPE(val)       ((val & 3) << 8)
+#define GPMC_CONFIG1_TIME_PARA_GRAN     (1 << 4)
+#define GPMC_CONFIG1_FCLK_DIV(val)      (val & 3)
+#define GPMC_CONFIG1_FCLK_DIV2          (GPMC_CONFIG1_FCLK_DIV(1))
+#define GPMC_CONFIG1_FCLK_DIV3          (GPMC_CONFIG1_FCLK_DIV(2))
+#define GPMC_CONFIG1_FCLK_DIV4          (GPMC_CONFIG1_FCLK_DIV(3))
+#define GPMC_CONFIG7_CSVALID		(1 << 6)
+
 #define	GPMC_CONFIG2_CSEXTRADELAY		BIT(7)
 #define	GPMC_CONFIG3_ADVEXTRADELAY		BIT(7)
 #define	GPMC_CONFIG4_OEEXTRADELAY		BIT(7)
@@ -87,6 +126,12 @@
 #define	GPMC_CONFIG6_CYCLE2CYCLEDIFFCSEN	BIT(6)
 #define	GPMC_CONFIG6_CYCLE2CYCLESAMECSEN	BIT(7)
 
+#define GPMC_DEVICETYPE_NOR		0
+#define GPMC_DEVICETYPE_NAND		2
+#define WR_RD_PIN_MONITORING		0x00600000
+#define GPMC_IRQ_FIFOEVENTENABLE	0x01
+#define GPMC_IRQ_COUNT_EVENT		0x02
+
 #define GPMC_CS0_OFFSET		0x60
 #define GPMC_CS_SIZE		0x30
 #define	GPMC_BCH_SIZE		0x10
@@ -163,7 +208,7 @@ static u32 gpmc_read_reg(int idx)
 	return __raw_readl(gpmc_base + idx);
 }
 
-void gpmc_cs_write_reg(int cs, int idx, u32 val)
+static void gpmc_cs_write_reg(int cs, int idx, u32 val)
 {
 	void __iomem *reg_addr;
 
@@ -215,11 +260,6 @@ static unsigned int gpmc_ps_to_ticks(unsigned int time_ps)
 	return (time_ps + tick_ps - 1) / tick_ps;
 }
 
-unsigned int gpmc_ticks_to_ns(unsigned int ticks)
-{
-	return ticks * gpmc_get_fclk_period() / 1000;
-}
-
 static unsigned int gpmc_ticks_to_ps(unsigned int ticks)
 {
 	return ticks * gpmc_get_fclk_period();
@@ -315,7 +355,7 @@ static int set_gpmc_timing_reg(int cs, int reg, int st_bit, int end_bit,
 		return -1
 #endif
 
-int gpmc_calc_divider(unsigned int sync_clk)
+static int gpmc_calc_divider(unsigned int sync_clk)
 {
 	int div;
 	u32 l;
@@ -330,7 +370,7 @@ int gpmc_calc_divider(unsigned int sync_clk)
 	return div;
 }
 
-int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t)
+static int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t)
 {
 	int div;
 	u32 l;
@@ -537,7 +577,7 @@ static int gpmc_cs_remap(int cs, u32 base)
 	return 0;
 }
 
-int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
+static int gpmc_cs_request(int cs, unsigned long size, unsigned long *base)
 {
 	struct resource *res = &gpmc_cs_mem[cs];
 	int r = -1;
@@ -575,9 +615,8 @@ out:
 	spin_unlock(&gpmc_mem_lock);
 	return r;
 }
-EXPORT_SYMBOL(gpmc_cs_request);
 
-void gpmc_cs_free(int cs)
+static void gpmc_cs_free(int cs)
 {
 	struct resource	*res = &gpmc_cs_mem[cs];
 
@@ -594,18 +633,6 @@ void gpmc_cs_free(int cs)
 	gpmc_cs_set_reserved(cs, 0);
 	spin_unlock(&gpmc_mem_lock);
 }
-EXPORT_SYMBOL(gpmc_cs_free);
-
-void gpmc_get_mem_resource(struct resource *res)
-{
-	res->start =  phys_base;
-	res->end = res->start + mem_size - 1;
-}
-
-int gpmc_get_irq(void)
-{
-	return gpmc_irq;
-}
 
 static void gpmc_mem_exit(void)
 {
@@ -937,9 +964,9 @@ static void gpmc_convert_ps_to_ns(struct gpmc_timings *t)
 	t->wr_data_mux_bus /= 1000;
 }
 
-int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
-		      struct gpmc_settings *gpmc_s,
-		      struct gpmc_device_timings *dev_t)
+static int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
+			     struct gpmc_settings *gpmc_s,
+			     struct gpmc_device_timings *dev_t)
 {
 	bool mux = false, sync = false;
 
@@ -980,7 +1007,7 @@ int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
  * register will be initialised to zero by this function. Returns 0 on
  * success and appropriate negative error code on failure.
  */
-int gpmc_cs_program_settings(int cs, struct gpmc_settings *p)
+static int gpmc_cs_program_settings(int cs, struct gpmc_settings *p)
 {
 	u32 config1;
 
@@ -1073,7 +1100,8 @@ MODULE_DEVICE_TABLE(of, gpmc_dt_ids);
  * structure is initialised to zero by this function and so any
  * previously stored settings will be cleared.
  */
-void gpmc_read_settings_dt(struct device_node *np, struct gpmc_settings *p)
+static void gpmc_read_settings_dt(struct device_node *np,
+				  struct gpmc_settings *p)
 {
 	memset(p, 0, sizeof(struct gpmc_settings));
 
diff --git a/arch/arm/mach-omap2/gpmc.h b/arch/arm/mach-omap2/gpmc.h
index 301bc66..c8af000 100644
--- a/arch/arm/mach-omap2/gpmc.h
+++ b/arch/arm/mach-omap2/gpmc.h
@@ -11,77 +11,14 @@
 #ifndef __OMAP2_GPMC_H
 #define __OMAP2_GPMC_H
 
-#include <linux/platform_data/mtd-nand-omap2.h>
 #include <linux/platform_data/gpmc-omap.h>
 
-#define GPMC_CS_CONFIG1		0x00
-#define GPMC_CS_CONFIG2		0x04
-#define GPMC_CS_CONFIG3		0x08
-#define GPMC_CS_CONFIG4		0x0c
-#define GPMC_CS_CONFIG5		0x10
-#define GPMC_CS_CONFIG6		0x14
-#define GPMC_CS_CONFIG7		0x18
-
-/* ECC commands */
-#define GPMC_ECC_READ		0 /* Reset Hardware ECC for read */
-#define GPMC_ECC_WRITE		1 /* Reset Hardware ECC for write */
-#define GPMC_ECC_READSYN	2 /* Reset before syndrom is read back */
-
-#define GPMC_CONFIG1_WRAPBURST_SUPP     (1 << 31)
-#define GPMC_CONFIG1_READMULTIPLE_SUPP  (1 << 30)
-#define GPMC_CONFIG1_READTYPE_ASYNC     (0 << 29)
-#define GPMC_CONFIG1_READTYPE_SYNC      (1 << 29)
-#define GPMC_CONFIG1_WRITEMULTIPLE_SUPP (1 << 28)
-#define GPMC_CONFIG1_WRITETYPE_ASYNC    (0 << 27)
-#define GPMC_CONFIG1_WRITETYPE_SYNC     (1 << 27)
-#define GPMC_CONFIG1_CLKACTIVATIONTIME(val) ((val & 3) << 25)
-#define GPMC_CONFIG1_PAGE_LEN(val)      ((val & 3) << 23)
-#define GPMC_CONFIG1_WAIT_READ_MON      (1 << 22)
-#define GPMC_CONFIG1_WAIT_WRITE_MON     (1 << 21)
-#define GPMC_CONFIG1_WAIT_MON_IIME(val) ((val & 3) << 18)
-#define GPMC_CONFIG1_WAIT_PIN_SEL(val)  ((val & 3) << 16)
-#define GPMC_CONFIG1_DEVICESIZE(val)    ((val & 3) << 12)
-#define GPMC_CONFIG1_DEVICESIZE_16      GPMC_CONFIG1_DEVICESIZE(1)
-#define GPMC_CONFIG1_DEVICETYPE(val)    ((val & 3) << 10)
-#define GPMC_CONFIG1_DEVICETYPE_NOR     GPMC_CONFIG1_DEVICETYPE(0)
-#define GPMC_CONFIG1_MUXTYPE(val)       ((val & 3) << 8)
-#define GPMC_CONFIG1_TIME_PARA_GRAN     (1 << 4)
-#define GPMC_CONFIG1_FCLK_DIV(val)      (val & 3)
-#define GPMC_CONFIG1_FCLK_DIV2          (GPMC_CONFIG1_FCLK_DIV(1))
-#define GPMC_CONFIG1_FCLK_DIV3          (GPMC_CONFIG1_FCLK_DIV(2))
-#define GPMC_CONFIG1_FCLK_DIV4          (GPMC_CONFIG1_FCLK_DIV(3))
-#define GPMC_CONFIG7_CSVALID		(1 << 6)
-
-#define GPMC_DEVICETYPE_NOR		0
-#define GPMC_DEVICETYPE_NAND		2
-#define WR_RD_PIN_MONITORING		0x00600000
-#define GPMC_IRQ_FIFOEVENTENABLE	0x01
-#define GPMC_IRQ_COUNT_EVENT		0x02
-
-extern int gpmc_calc_timings(struct gpmc_timings *gpmc_t,
-			     struct gpmc_settings *gpmc_s,
-			     struct gpmc_device_timings *dev_t);
-
-void gpmc_get_mem_resource(struct resource *res);
-int gpmc_get_irq(void);
-
-extern unsigned int gpmc_ticks_to_ns(unsigned int ticks);
-
-extern void gpmc_cs_write_reg(int cs, int idx, u32 val);
-extern int gpmc_calc_divider(unsigned int sync_clk);
-extern int gpmc_cs_set_timings(int cs, const struct gpmc_timings *t);
-extern int gpmc_cs_program_settings(int cs, struct gpmc_settings *p);
-extern int gpmc_cs_request(int cs, unsigned long size, unsigned long *base);
-extern void gpmc_cs_free(int cs);
 extern void omap3_gpmc_save_context(void);
 extern void omap3_gpmc_restore_context(void);
-extern void gpmc_read_settings_dt(struct device_node *np,
-				  struct gpmc_settings *p);
 int gpmc_generic_init(int cs, bool is_nand,
 		      struct gpmc_settings *settings,
 		      struct gpmc_device_timings *device_timings,
 		      struct gpmc_timings *gpmc_timings,
 		      struct platform_device *pdev,
 		      unsigned pdata_size);
-
 #endif
-- 
1.8.3.2

