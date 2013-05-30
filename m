Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967465Ab3E3DGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:06:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:16462 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967347Ab3E3DDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:03:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,768,1363158000"; 
   d="scan'208";a="342312625"
From: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
To: x86@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        linux-kernel@vger.kernel.org, mark.gross@intel.com,
        len.brown@intel.com, david.a.cohen@intel.com, fei.yang@intel.com,
        sathyanarayanan.kuppuswamy@intel.com
Subject: [PATCH v1 02/13] mrst: Fixed indentation issues
Date: Wed, 29 May 2013 19:45:12 -0700
Message-Id: <1369881923-27067-3-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
References: <1369881923-27067-1-git-send-email-sathyanarayanan.kuppuswamy@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indentation issues reported by checkpatch script in
mrst related files.

Change-Id: I4deceed3ff2fc92bdb8118300f18eed963b9b988
Signed-off-by: Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>
---
 arch/x86/pci/mrst.c                        |    4 ++--
 arch/x86/platform/mrst/early_printk_mrst.c |    3 ++-
 arch/x86/platform/mrst/mrst.c              |   24 +++++++++++++-----------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index a08cf1b..66a672e 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -251,8 +251,8 @@ static void pci_d3delay_fixup(struct pci_dev *dev)
 {
 	/* PCI fixups are effectively decided compile time. If we have a dual
 	   SoC/non-SoC kernel we don't want to mangle d3 on non SoC devices */
-        if (!pci_soc_mode)
-            return;
+	if (!pci_soc_mode)
+		return;
 	/* true pci devices in lincroft should allow type 1 access, the rest
 	 * are langwell fake pci devices.
 	 */
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
index fbfbe36..58cdfd1 100644
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

