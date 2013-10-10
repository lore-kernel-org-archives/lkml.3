Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab3JJF54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:57:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:30735 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab3JJF4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1069,1371106800"; 
   d="scan'208";a="417008914"
From: David Cohen <david.a.cohen@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        platform-driver-x86@vger.kernel.org,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v2 02/10] mrst: Fixed indentation issues
Date: Wed,  9 Oct 2013 22:59:59 -0700
Message-Id: <1381384807-14146-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1381384807-14146-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

Fixed indentation issues reported by checkpatch script in
mrst related files.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/mrst/early_printk_mrst.c |    3 ++-
 arch/x86/platform/mrst/mrst.c              |   24 +++++++++++++-----------
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/arch/x86/platform/mrst/early_printk_mrst.c b/arch/x86/platform/mrst/early_printk_mrst.c
index 95880f7..39ecc27 100644
--- a/arch/x86/platform/mrst/early_printk_mrst.c
+++ b/arch/x86/platform/mrst/early_printk_mrst.c
@@ -219,7 +219,8 @@ static void early_mrst_spi_putc(char c)
 }
 
 /* Early SPI only uses polling mode */
-static void early_mrst_spi_write(struct console *con, const char *str, unsigned n)
+static void early_mrst_spi_write(struct console *con, const char *str,
+					unsigned n)
 {
 	int i;
 
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index b9aeb54..235a742 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -131,7 +131,7 @@ struct sfi_timer_table_entry *sfi_get_mtmr(int hint)
 	int i;
 	if (hint < sfi_mtimer_num) {
 		if (!sfi_mtimer_usage[hint]) {
-			pr_debug("hint taken for timer %d irq %d\n",\
+			pr_debug("hint taken for timer %d irq %d\n",
 				hint, sfi_mtimer_array[hint].irq);
 			sfi_mtimer_usage[hint] = 1;
 			return &sfi_mtimer_array[hint];
@@ -679,14 +679,14 @@ static void *msic_thermal_platform_data(void *info)
 /* tc35876x DSI-LVDS bridge chip and panel platform data */
 static void *tc35876x_platform_data(void *data)
 {
-       static struct tc35876x_platform_data pdata;
+	static struct tc35876x_platform_data pdata;
 
-       /* gpio pins set to -1 will not be used by the driver */
-       pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
-       pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
-       pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
+	/* gpio pins set to -1 will not be used by the driver */
+	pdata.gpio_bridge_reset = get_gpio_by_name("LCMB_RXEN");
+	pdata.gpio_panel_bl_en = get_gpio_by_name("6S6P_BL_EN");
+	pdata.gpio_panel_vadd = get_gpio_by_name("EN_VREG_LCD_V3P3");
 
-       return &pdata;
+	return &pdata;
 }
 
 static const struct devs_id __initconst device_ids[] = {
@@ -729,7 +729,7 @@ static int i2c_next_dev;
 
 static void __init intel_scu_device_register(struct platform_device *pdev)
 {
-	if(ipc_next_dev == MAX_IPCDEVS)
+	if (ipc_next_dev == MAX_IPCDEVS)
 		pr_err("too many SCU IPC devices");
 	else
 		ipc_devs[ipc_next_dev++] = pdev;
@@ -872,7 +872,8 @@ static void __init sfi_handle_spi_dev(struct spi_board_info *spi_info)
 
 	while (dev->name[0]) {
 		if (dev->type == SFI_DEV_TYPE_SPI &&
-				!strncmp(dev->name, spi_info->modalias, SFI_NAME_LEN)) {
+			!strncmp(dev->name, spi_info->modalias,
+						SFI_NAME_LEN)) {
 			pdata = dev->get_platform_data(spi_info);
 			break;
 		}
@@ -904,7 +905,7 @@ static void __init sfi_handle_i2c_dev(int bus, struct i2c_board_info *i2c_info)
 		intel_scu_i2c_device_register(bus, i2c_info);
 	else
 		i2c_register_board_info(bus, i2c_info, 1);
- }
+}
 
 
 static int __init sfi_parse_devs(struct sfi_table_header *table)
@@ -1034,7 +1035,8 @@ static int __init pb_keys_init(void)
 	num = sizeof(gpio_button) / sizeof(struct gpio_keys_button);
 	for (i = 0; i < num; i++) {
 		gb[i].gpio = get_gpio_by_name(gb[i].desc);
-		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc, gb[i].gpio);
+		pr_debug("info[%2d]: name = %s, gpio = %d\n", i, gb[i].desc,
+					gb[i].gpio);
 		if (gb[i].gpio == -1)
 			continue;
 
-- 
1.7.9.5

