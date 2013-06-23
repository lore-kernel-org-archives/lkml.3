Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3FWHDx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 03:03:53 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:33304 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab3FWHDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 03:03:47 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 3/6] Staging: silicom: remove the bpctl_dev_t typdef
Date: Sun, 23 Jun 2013 02:02:25 -0500
Message-Id: <1371970948-26802-4-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371970948-26802-1-git-send-email-chad@dahc.us>
References: <1371970948-26802-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the bpctl_dev_t typdef in bpctl_mod.c with struct bpctl_dev
for coding style compliance.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 552 ++++++++++++++++++------------------
 1 file changed, 276 insertions(+), 276 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 96cda96..6945d3c 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -64,7 +64,7 @@ struct bypass_pfs_sd {
 	struct proc_dir_entry *bypass_entry;
 };
 
-typedef struct _bpctl_dev {
+struct bpctl_dev {
 	char *name;
 	char *desc;
 	struct pci_dev *pdev;	/* PCI device */
@@ -107,26 +107,26 @@ typedef struct _bpctl_dev {
 	char *bp_tx_data;
 	struct bypass_pfs_sd bypass_pfs_set;
 
-} bpctl_dev_t;
+};
 
-static bpctl_dev_t *bpctl_dev_arr;
+static struct bpctl_dev *bpctl_dev_arr;
 
 static struct semaphore bpctl_sema;
 static int device_num;
 
 static int get_dev_idx(int ifindex);
-static bpctl_dev_t *get_master_port_fn(bpctl_dev_t *pbpctl_dev);
-static int disc_status(bpctl_dev_t *pbpctl_dev);
-static int bypass_status(bpctl_dev_t *pbpctl_dev);
-static int wdt_timer(bpctl_dev_t *pbpctl_dev, int *time_left);
-static bpctl_dev_t *get_status_port_fn(bpctl_dev_t *pbpctl_dev);
+static struct bpctl_dev *get_master_port_fn(struct bpctl_dev *pbpctl_dev);
+static int disc_status(struct bpctl_dev *pbpctl_dev);
+static int bypass_status(struct bpctl_dev *pbpctl_dev);
+static int wdt_timer(struct bpctl_dev *pbpctl_dev, int *time_left);
+static struct bpctl_dev *get_status_port_fn(struct bpctl_dev *pbpctl_dev);
 static void if_scan_init(void);
 
-int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block);
-int bypass_proc_remove_dev_sd(bpctl_dev_t *pbp_device_block);
+int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
+int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
 int bp_proc_create(void);
 
-int is_bypass_fn(bpctl_dev_t *pbpctl_dev);
+int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
 int get_dev_idx_bsf(int bus, int slot, int func);
 
 static unsigned long str_to_hex(char *p);
@@ -134,7 +134,7 @@ static int bp_device_event(struct notifier_block *unused,
 			   unsigned long event, void *ptr)
 {
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	static bpctl_dev_t *pbpctl_dev, *pbpctl_dev_m;
+	static struct bpctl_dev *pbpctl_dev, *pbpctl_dev_m;
 	int dev_num = 0, ret = 0, ret_d = 0, time_left = 0;
 	/* printk("BP_PROC_SUPPORT event =%d %s %d\n", event,dev->name, dev->ifindex ); */
 	/* return NOTIFY_DONE; */
@@ -289,17 +289,17 @@ static struct notifier_block bp_notifier_block = {
 	.notifier_call = bp_device_event,
 };
 
-int is_bypass_fn(bpctl_dev_t *pbpctl_dev);
-int wdt_time_left(bpctl_dev_t *pbpctl_dev);
+int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
+int wdt_time_left(struct bpctl_dev *pbpctl_dev);
 
-static void write_pulse(bpctl_dev_t *pbpctl_dev,
+static void write_pulse(struct bpctl_dev *pbpctl_dev,
 			unsigned int ctrl_ext,
 			unsigned char value, unsigned char len)
 {
 	unsigned char ctrl_val = 0;
 	unsigned int i = len;
 	unsigned int ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_c = NULL;
+	struct bpctl_dev *pbpctl_dev_c = NULL;
 
 	if (pbpctl_dev->bp_i80)
 		ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
@@ -595,13 +595,13 @@ static void write_pulse(bpctl_dev_t *pbpctl_dev,
 	}
 }
 
-static int read_pulse(bpctl_dev_t *pbpctl_dev, unsigned int ctrl_ext,
+static int read_pulse(struct bpctl_dev *pbpctl_dev, unsigned int ctrl_ext,
 		      unsigned char len)
 {
 	unsigned char ctrl_val = 0;
 	unsigned int i = len;
 	unsigned int ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_c = NULL;
+	struct bpctl_dev *pbpctl_dev_c = NULL;
 
 	if (pbpctl_dev->bp_i80)
 		ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
@@ -770,11 +770,11 @@ static int read_pulse(bpctl_dev_t *pbpctl_dev, unsigned int ctrl_ext,
 	return ctrl_val;
 }
 
-static void write_reg(bpctl_dev_t *pbpctl_dev, unsigned char value,
+static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 		      unsigned char addr)
 {
 	uint32_t ctrl_ext = 0, ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_c = NULL;
+	struct bpctl_dev *pbpctl_dev_c = NULL;
 	unsigned long flags;
 	if (pbpctl_dev->bp_10g9) {
 		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
@@ -939,15 +939,15 @@ static void write_reg(bpctl_dev_t *pbpctl_dev, unsigned char value,
 
 }
 
-static void write_data(bpctl_dev_t *pbpctl_dev, unsigned char value)
+static void write_data(struct bpctl_dev *pbpctl_dev, unsigned char value)
 {
 	write_reg(pbpctl_dev, value, CMND_REG_ADDR);
 }
 
-static int read_reg(bpctl_dev_t *pbpctl_dev, unsigned char addr)
+static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 {
 	uint32_t ctrl_ext = 0, ctrl = 0, ctrl_value = 0;
-	bpctl_dev_t *pbpctl_dev_c = NULL;
+	struct bpctl_dev *pbpctl_dev_c = NULL;
 
 #ifdef BP_SYNC_FLAG
 	unsigned long flags;
@@ -1213,10 +1213,10 @@ static int read_reg(bpctl_dev_t *pbpctl_dev, unsigned char addr)
 	return ctrl_value;
 }
 
-static int wdt_pulse(bpctl_dev_t *pbpctl_dev)
+static int wdt_pulse(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_c = NULL;
+	struct bpctl_dev *pbpctl_dev_c = NULL;
 
 #ifdef BP_SYNC_FLAG
 	unsigned long flags;
@@ -1429,7 +1429,7 @@ static int wdt_pulse(bpctl_dev_t *pbpctl_dev)
 	return 0;
 }
 
-static void data_pulse(bpctl_dev_t *pbpctl_dev, unsigned char value)
+static void data_pulse(struct bpctl_dev *pbpctl_dev, unsigned char value)
 {
 
 	uint32_t ctrl_ext = 0;
@@ -1495,7 +1495,7 @@ static void data_pulse(bpctl_dev_t *pbpctl_dev, unsigned char value)
 
 }
 
-static int send_wdt_pulse(bpctl_dev_t *pbpctl_dev)
+static int send_wdt_pulse(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1529,7 +1529,7 @@ static int send_wdt_pulse(bpctl_dev_t *pbpctl_dev)
 	return 0;
 }
 
-void send_bypass_clear_pulse(bpctl_dev_t *pbpctl_dev, unsigned int value)
+void send_bypass_clear_pulse(struct bpctl_dev *pbpctl_dev, unsigned int value)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1555,7 +1555,7 @@ void send_bypass_clear_pulse(bpctl_dev_t *pbpctl_dev, unsigned int value)
 /*  #endif  OLD_FW */
 #ifdef BYPASS_DEBUG
 
-int pulse_set_fn(bpctl_dev_t *pbpctl_dev, unsigned int counter)
+int pulse_set_fn(struct bpctl_dev *pbpctl_dev, unsigned int counter)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1583,7 +1583,7 @@ int pulse_set_fn(bpctl_dev_t *pbpctl_dev, unsigned int counter)
 	return 0;
 }
 
-int zero_set_fn(bpctl_dev_t *pbpctl_dev)
+int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
 	if (!pbpctl_dev)
@@ -1608,7 +1608,7 @@ int zero_set_fn(bpctl_dev_t *pbpctl_dev)
 	return ctrl_value;
 }
 
-int pulse_get2_fn(bpctl_dev_t *pbpctl_dev)
+int pulse_get2_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
 	if (!pbpctl_dev)
@@ -1623,7 +1623,7 @@ int pulse_get2_fn(bpctl_dev_t *pbpctl_dev)
 	return ctrl_value;
 }
 
-int pulse_get1_fn(bpctl_dev_t *pbpctl_dev)
+int pulse_get1_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
 	if (!pbpctl_dev)
@@ -1640,7 +1640,7 @@ int pulse_get1_fn(bpctl_dev_t *pbpctl_dev)
 	return ctrl_value;
 }
 
-int gpio6_set_fn(bpctl_dev_t *pbpctl_dev)
+int gpio6_set_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1651,7 +1651,7 @@ int gpio6_set_fn(bpctl_dev_t *pbpctl_dev)
 	return 0;
 }
 
-int gpio7_set_fn(bpctl_dev_t *pbpctl_dev)
+int gpio7_set_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1662,7 +1662,7 @@ int gpio7_set_fn(bpctl_dev_t *pbpctl_dev)
 	return 0;
 }
 
-int gpio7_clear_fn(bpctl_dev_t *pbpctl_dev)
+int gpio7_clear_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1673,7 +1673,7 @@ int gpio7_clear_fn(bpctl_dev_t *pbpctl_dev)
 	return 0;
 }
 
-int gpio6_clear_fn(bpctl_dev_t *pbpctl_dev)
+int gpio6_clear_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0;
 
@@ -1685,9 +1685,9 @@ int gpio6_clear_fn(bpctl_dev_t *pbpctl_dev)
 }
 #endif				/*BYPASS_DEBUG */
 
-static bpctl_dev_t *lookup_port(bpctl_dev_t *dev)
+static struct bpctl_dev *lookup_port(struct bpctl_dev *dev)
 {
-	bpctl_dev_t *p;
+	struct bpctl_dev *p;
 	int n;
 	for (n = 0, p = bpctl_dev_arr; n < device_num && p->pdev; n++) {
 		if (p->bus == dev->bus
@@ -1698,7 +1698,7 @@ static bpctl_dev_t *lookup_port(bpctl_dev_t *dev)
 	return NULL;
 }
 
-static bpctl_dev_t *get_status_port_fn(bpctl_dev_t *pbpctl_dev)
+static struct bpctl_dev *get_status_port_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev) {
 		if (pbpctl_dev->func == 0 || pbpctl_dev->func == 2)
@@ -1707,7 +1707,7 @@ static bpctl_dev_t *get_status_port_fn(bpctl_dev_t *pbpctl_dev)
 	return NULL;
 }
 
-static bpctl_dev_t *get_master_port_fn(bpctl_dev_t *pbpctl_dev)
+static struct bpctl_dev *get_master_port_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev) {
 		if (pbpctl_dev->func == 1 || pbpctl_dev->func == 3)
@@ -1720,7 +1720,7 @@ static bpctl_dev_t *get_master_port_fn(bpctl_dev_t *pbpctl_dev)
 /**************INTEL API***************/
 /**************************************/
 
-static void write_data_port_int(bpctl_dev_t *pbpctl_dev,
+static void write_data_port_int(struct bpctl_dev *pbpctl_dev,
 				unsigned char ctrl_value)
 {
 	uint32_t value;
@@ -1745,9 +1745,9 @@ static void write_data_port_int(bpctl_dev_t *pbpctl_dev,
 
 }
 
-static int write_data_int(bpctl_dev_t *pbpctl_dev, unsigned char value)
+static int write_data_int(struct bpctl_dev *pbpctl_dev, unsigned char value)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 	if (!pbpctl_dev_b)
@@ -1760,7 +1760,7 @@ static int write_data_int(bpctl_dev_t *pbpctl_dev, unsigned char value)
 	return 0;
 }
 
-static int wdt_pulse_int(bpctl_dev_t *pbpctl_dev)
+static int wdt_pulse_int(struct bpctl_dev *pbpctl_dev)
 {
 
 	if ((atomic_read(&pbpctl_dev->wdt_busy)) == 1)
@@ -1784,7 +1784,7 @@ static int wdt_pulse_int(bpctl_dev_t *pbpctl_dev)
 /*************************************/
 
 /* CMND_ON  0x4 (100)*/
-int cmnd_on(bpctl_dev_t *pbpctl_dev)
+int cmnd_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1801,7 +1801,7 @@ int cmnd_on(bpctl_dev_t *pbpctl_dev)
 }
 
 /* CMND_OFF  0x2 (10)*/
-int cmnd_off(bpctl_dev_t *pbpctl_dev)
+int cmnd_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1819,7 +1819,7 @@ int cmnd_off(bpctl_dev_t *pbpctl_dev)
 }
 
 /* BYPASS_ON (0xa)*/
-int bypass_on(bpctl_dev_t *pbpctl_dev)
+int bypass_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1840,7 +1840,7 @@ int bypass_on(bpctl_dev_t *pbpctl_dev)
 }
 
 /* BYPASS_OFF (0x8 111)*/
-int bypass_off(bpctl_dev_t *pbpctl_dev)
+int bypass_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -1863,7 +1863,7 @@ int bypass_off(bpctl_dev_t *pbpctl_dev)
 }
 
 /* TAP_OFF (0x9)*/
-int tap_off(bpctl_dev_t *pbpctl_dev)
+int tap_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
@@ -1876,7 +1876,7 @@ int tap_off(bpctl_dev_t *pbpctl_dev)
 }
 
 /* TAP_ON (0xb)*/
-int tap_on(bpctl_dev_t *pbpctl_dev)
+int tap_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
@@ -1889,7 +1889,7 @@ int tap_on(bpctl_dev_t *pbpctl_dev)
 }
 
 /* DISC_OFF (0x9)*/
-int disc_off(bpctl_dev_t *pbpctl_dev)
+int disc_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
@@ -1901,7 +1901,7 @@ int disc_off(bpctl_dev_t *pbpctl_dev)
 }
 
 /* DISC_ON (0xb)*/
-int disc_on(bpctl_dev_t *pbpctl_dev)
+int disc_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
@@ -1913,10 +1913,10 @@ int disc_on(bpctl_dev_t *pbpctl_dev)
 }
 
 /* DISC_PORT_ON */
-int disc_port_on(bpctl_dev_t *pbpctl_dev)
+int disc_port_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
@@ -1938,10 +1938,10 @@ int disc_port_on(bpctl_dev_t *pbpctl_dev)
 }
 
 /* DISC_PORT_OFF */
-int disc_port_off(bpctl_dev_t *pbpctl_dev)
+int disc_port_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
@@ -1963,10 +1963,10 @@ int disc_port_off(bpctl_dev_t *pbpctl_dev)
 }
 
 /*TWO_PORT_LINK_HW_EN (0xe)*/
-int tpl_hw_on(bpctl_dev_t *pbpctl_dev)
+int tpl_hw_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0, ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 	if (!pbpctl_dev_b)
@@ -1991,10 +1991,10 @@ int tpl_hw_on(bpctl_dev_t *pbpctl_dev)
 }
 
 /*TWO_PORT_LINK_HW_DIS (0xc)*/
-int tpl_hw_off(bpctl_dev_t *pbpctl_dev)
+int tpl_hw_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0, ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 	if (!pbpctl_dev_b)
@@ -2017,7 +2017,7 @@ int tpl_hw_off(bpctl_dev_t *pbpctl_dev)
 }
 
 /* WDT_OFF (0x6 110)*/
-int wdt_off(bpctl_dev_t *pbpctl_dev)
+int wdt_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -2040,7 +2040,7 @@ int wdt_off(bpctl_dev_t *pbpctl_dev)
 static unsigned int
     wdt_val_array[] = { 1000, 1500, 2000, 3000, 4000, 8000, 16000, 32000, 0 };
 
-int wdt_on(bpctl_dev_t *pbpctl_dev, unsigned int timeout)
+int wdt_on(struct bpctl_dev *pbpctl_dev, unsigned int timeout)
 {
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -2092,7 +2092,7 @@ int wdt_on(bpctl_dev_t *pbpctl_dev, unsigned int timeout)
 	return BP_NOT_CAP;
 }
 
-void bp75_put_hw_semaphore_generic(bpctl_dev_t *pbpctl_dev)
+void bp75_put_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
 {
 	u32 swsm;
 
@@ -2103,7 +2103,7 @@ void bp75_put_hw_semaphore_generic(bpctl_dev_t *pbpctl_dev)
 	BPCTL_WRITE_REG(pbpctl_dev, SWSM, swsm);
 }
 
-s32 bp75_get_hw_semaphore_generic(bpctl_dev_t *pbpctl_dev)
+s32 bp75_get_hw_semaphore_generic(struct bpctl_dev *pbpctl_dev)
 {
 	u32 swsm;
 	s32 ret_val = 0;
@@ -2151,7 +2151,7 @@ s32 bp75_get_hw_semaphore_generic(bpctl_dev_t *pbpctl_dev)
 	return ret_val;
 }
 
-static void bp75_release_phy(bpctl_dev_t *pbpctl_dev)
+static void bp75_release_phy(struct bpctl_dev *pbpctl_dev)
 {
 	u16 mask = BPCTLI_SWFW_PHY0_SM;
 	u32 swfw_sync;
@@ -2171,7 +2171,7 @@ static void bp75_release_phy(bpctl_dev_t *pbpctl_dev)
 	bp75_put_hw_semaphore_generic(pbpctl_dev);
 }
 
-static s32 bp75_acquire_phy(bpctl_dev_t *pbpctl_dev)
+static s32 bp75_acquire_phy(struct bpctl_dev *pbpctl_dev)
 {
 	u16 mask = BPCTLI_SWFW_PHY0_SM;
 	u32 swfw_sync;
@@ -2217,7 +2217,7 @@ static s32 bp75_acquire_phy(bpctl_dev_t *pbpctl_dev)
 	return ret_val;
 }
 
-s32 bp75_read_phy_reg_mdic(bpctl_dev_t *pbpctl_dev, u32 offset, u16 *data)
+s32 bp75_read_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset, u16 *data)
 {
 	u32 i, mdic = 0;
 	s32 ret_val = 0;
@@ -2250,7 +2250,7 @@ s32 bp75_read_phy_reg_mdic(bpctl_dev_t *pbpctl_dev, u32 offset, u16 *data)
 	return ret_val;
 }
 
-s32 bp75_write_phy_reg_mdic(bpctl_dev_t *pbpctl_dev, u32 offset, u16 data)
+s32 bp75_write_phy_reg_mdic(struct bpctl_dev *pbpctl_dev, u32 offset, u16 data)
 {
 	u32 i, mdic = 0;
 	s32 ret_val = 0;
@@ -2283,7 +2283,7 @@ s32 bp75_write_phy_reg_mdic(bpctl_dev_t *pbpctl_dev, u32 offset, u16 data)
 	return ret_val;
 }
 
-static s32 bp75_read_phy_reg(bpctl_dev_t *pbpctl_dev, u32 offset, u16 *data)
+static s32 bp75_read_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset, u16 *data)
 {
 	s32 ret_val = 0;
 
@@ -2309,7 +2309,7 @@ static s32 bp75_read_phy_reg(bpctl_dev_t *pbpctl_dev, u32 offset, u16 *data)
 	return ret_val;
 }
 
-static s32 bp75_write_phy_reg(bpctl_dev_t *pbpctl_dev, u32 offset, u16 data)
+static s32 bp75_write_phy_reg(struct bpctl_dev *pbpctl_dev, u32 offset, u16 data)
 {
 	s32 ret_val = 0;
 
@@ -2337,10 +2337,10 @@ static s32 bp75_write_phy_reg(bpctl_dev_t *pbpctl_dev, u32 offset, u16 data)
 }
 
 /* SET_TX  (non-Bypass command :)) */
-static int set_tx(bpctl_dev_t *pbpctl_dev, int tx_state)
+static int set_tx(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
 	int ret = 0, ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -2537,7 +2537,7 @@ static int set_tx(bpctl_dev_t *pbpctl_dev, int tx_state)
 }
 
 /* SET_FORCE_LINK  (non-Bypass command :)) */
-static int set_bp_force_link(bpctl_dev_t *pbpctl_dev, int tx_state)
+static int set_bp_force_link(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
 	int ret = 0, ctrl = 0;
 
@@ -2561,7 +2561,7 @@ static int set_bp_force_link(bpctl_dev_t *pbpctl_dev, int tx_state)
 }
 
 /*RESET_CONT 0x20 */
-int reset_cont(bpctl_dev_t *pbpctl_dev)
+int reset_cont(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -2578,7 +2578,7 @@ int reset_cont(bpctl_dev_t *pbpctl_dev)
 }
 
 /*DIS_BYPASS_CAP 0x22 */
-int dis_bypass_cap(bpctl_dev_t *pbpctl_dev)
+int dis_bypass_cap(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & BP_DIS_CAP) {
@@ -2597,7 +2597,7 @@ int dis_bypass_cap(bpctl_dev_t *pbpctl_dev)
 }
 
 /*EN_BYPASS_CAP 0x24 */
-int en_bypass_cap(bpctl_dev_t *pbpctl_dev)
+int en_bypass_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & BP_DIS_CAP) {
 		if (INTEL_IF_SERIES(pbpctl_dev->subdevice)) {
@@ -2613,7 +2613,7 @@ int en_bypass_cap(bpctl_dev_t *pbpctl_dev)
 }
 
 /* BYPASS_STATE_PWRON 0x26*/
-int bypass_state_pwron(bpctl_dev_t *pbpctl_dev)
+int bypass_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & BP_PWUP_CTL_CAP) {
 		write_data(pbpctl_dev, BYPASS_STATE_PWRON);
@@ -2627,7 +2627,7 @@ int bypass_state_pwron(bpctl_dev_t *pbpctl_dev)
 }
 
 /* NORMAL_STATE_PWRON 0x28*/
-int normal_state_pwron(bpctl_dev_t *pbpctl_dev)
+int normal_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if ((pbpctl_dev->bp_caps & BP_PWUP_CTL_CAP)
 	    || (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP)) {
@@ -2642,7 +2642,7 @@ int normal_state_pwron(bpctl_dev_t *pbpctl_dev)
 }
 
 /* BYPASS_STATE_PWROFF 0x27*/
-int bypass_state_pwroff(bpctl_dev_t *pbpctl_dev)
+int bypass_state_pwroff(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP) {
 		write_data(pbpctl_dev, BYPASS_STATE_PWROFF);
@@ -2653,7 +2653,7 @@ int bypass_state_pwroff(bpctl_dev_t *pbpctl_dev)
 }
 
 /* NORMAL_STATE_PWROFF 0x29*/
-int normal_state_pwroff(bpctl_dev_t *pbpctl_dev)
+int normal_state_pwroff(struct bpctl_dev *pbpctl_dev)
 {
 	if ((pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP)) {
 		write_data(pbpctl_dev, NORMAL_STATE_PWROFF);
@@ -2664,7 +2664,7 @@ int normal_state_pwroff(bpctl_dev_t *pbpctl_dev)
 }
 
 /*TAP_STATE_PWRON 0x2a*/
-int tap_state_pwron(bpctl_dev_t *pbpctl_dev)
+int tap_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP) {
 		write_data(pbpctl_dev, TAP_STATE_PWRON);
@@ -2675,7 +2675,7 @@ int tap_state_pwron(bpctl_dev_t *pbpctl_dev)
 }
 
 /*DIS_TAP_CAP 0x2c*/
-int dis_tap_cap(bpctl_dev_t *pbpctl_dev)
+int dis_tap_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_DIS_CAP) {
 		write_data(pbpctl_dev, DIS_TAP_CAP);
@@ -2686,7 +2686,7 @@ int dis_tap_cap(bpctl_dev_t *pbpctl_dev)
 }
 
 /*EN_TAP_CAP 0x2e*/
-int en_tap_cap(bpctl_dev_t *pbpctl_dev)
+int en_tap_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_DIS_CAP) {
 		write_data(pbpctl_dev, EN_TAP_CAP);
@@ -2697,7 +2697,7 @@ int en_tap_cap(bpctl_dev_t *pbpctl_dev)
 }
 
 /*DISC_STATE_PWRON 0x2a*/
-int disc_state_pwron(bpctl_dev_t *pbpctl_dev)
+int disc_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -2710,7 +2710,7 @@ int disc_state_pwron(bpctl_dev_t *pbpctl_dev)
 }
 
 /*DIS_DISC_CAP 0x2c*/
-int dis_disc_cap(bpctl_dev_t *pbpctl_dev)
+int dis_disc_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_DIS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -2723,10 +2723,10 @@ int dis_disc_cap(bpctl_dev_t *pbpctl_dev)
 }
 
 /*DISC_STATE_PWRON 0x2a*/
-int disc_port_state_pwron(bpctl_dev_t *pbpctl_dev)
+int disc_port_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 
 	return BP_NOT_CAP;
 
@@ -2749,10 +2749,10 @@ int disc_port_state_pwron(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int normal_port_state_pwron(bpctl_dev_t *pbpctl_dev)
+int normal_port_state_pwron(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 	return BP_NOT_CAP;
 
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
@@ -2775,7 +2775,7 @@ int normal_port_state_pwron(bpctl_dev_t *pbpctl_dev)
 }
 
 /*EN_TAP_CAP 0x2e*/
-int en_disc_cap(bpctl_dev_t *pbpctl_dev)
+int en_disc_cap(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_DIS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -2787,7 +2787,7 @@ int en_disc_cap(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int std_nic_on(bpctl_dev_t *pbpctl_dev)
+int std_nic_on(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & STD_NIC_CAP) {
@@ -2841,7 +2841,7 @@ int std_nic_on(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int std_nic_off(bpctl_dev_t *pbpctl_dev)
+int std_nic_off(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & STD_NIC_CAP) {
@@ -2893,7 +2893,7 @@ int std_nic_off(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int wdt_time_left(bpctl_dev_t *pbpctl_dev)
+int wdt_time_left(struct bpctl_dev *pbpctl_dev)
 {
 
 	/* unsigned long curr_time=((long long)(jiffies*1000))/HZ, delta_time=0,wdt_on_time=((long long)(pbpctl_dev->bypass_wdt_on_time*1000))/HZ; */
@@ -2925,7 +2925,7 @@ int wdt_time_left(bpctl_dev_t *pbpctl_dev)
 	return time_left;
 }
 
-static int wdt_timer(bpctl_dev_t *pbpctl_dev, int *time_left)
+static int wdt_timer(struct bpctl_dev *pbpctl_dev, int *time_left)
 {
 	int ret = 0;
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -2941,7 +2941,7 @@ static int wdt_timer(bpctl_dev_t *pbpctl_dev, int *time_left)
 	return ret;
 }
 
-static int wdt_timer_reload(bpctl_dev_t *pbpctl_dev)
+static int wdt_timer_reload(struct bpctl_dev *pbpctl_dev)
 {
 
 	int ret = 0;
@@ -2965,7 +2965,7 @@ static int wdt_timer_reload(bpctl_dev_t *pbpctl_dev)
 
 static void wd_reset_timer(unsigned long param)
 {
-	bpctl_dev_t *pbpctl_dev = (bpctl_dev_t *) param;
+	struct bpctl_dev *pbpctl_dev = (struct bpctl_dev *) param;
 #ifdef BP_SELF_TEST
 	struct sk_buff *skb_tmp;
 #endif
@@ -3004,7 +3004,7 @@ static void wd_reset_timer(unsigned long param)
 }
 
 /*WAIT_AT_PWRUP 0x80   */
-int bp_wait_at_pwup_en(bpctl_dev_t *pbpctl_dev)
+int bp_wait_at_pwup_en(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3019,7 +3019,7 @@ int bp_wait_at_pwup_en(bpctl_dev_t *pbpctl_dev)
 }
 
 /*DIS_WAIT_AT_PWRUP       0x81 */
-int bp_wait_at_pwup_dis(bpctl_dev_t *pbpctl_dev)
+int bp_wait_at_pwup_dis(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3036,7 +3036,7 @@ int bp_wait_at_pwup_dis(bpctl_dev_t *pbpctl_dev)
 
 /*EN_HW_RESET  0x82   */
 
-int bp_hw_reset_en(bpctl_dev_t *pbpctl_dev)
+int bp_hw_reset_en(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3052,7 +3052,7 @@ int bp_hw_reset_en(bpctl_dev_t *pbpctl_dev)
 
 /*DIS_HW_RESET             0x83   */
 
-int bp_hw_reset_dis(bpctl_dev_t *pbpctl_dev)
+int bp_hw_reset_dis(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3067,7 +3067,7 @@ int bp_hw_reset_dis(bpctl_dev_t *pbpctl_dev)
 }
 
 
-int wdt_exp_mode(bpctl_dev_t *pbpctl_dev, int mode)
+int wdt_exp_mode(struct bpctl_dev *pbpctl_dev, int mode)
 {
 	uint32_t status_reg = 0, status_reg1 = 0;
 
@@ -3118,7 +3118,7 @@ int wdt_exp_mode(bpctl_dev_t *pbpctl_dev, int mode)
 	return BP_NOT_CAP;
 }
 
-int bypass_fw_ver(bpctl_dev_t *pbpctl_dev)
+int bypass_fw_ver(struct bpctl_dev *pbpctl_dev)
 {
 	if (is_bypass_fn(pbpctl_dev))
 		return read_reg(pbpctl_dev, VER_REG_ADDR);
@@ -3126,7 +3126,7 @@ int bypass_fw_ver(bpctl_dev_t *pbpctl_dev)
 		return BP_NOT_CAP;
 }
 
-int bypass_sign_check(bpctl_dev_t *pbpctl_dev)
+int bypass_sign_check(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (is_bypass_fn(pbpctl_dev))
@@ -3136,10 +3136,10 @@ int bypass_sign_check(bpctl_dev_t *pbpctl_dev)
 		return BP_NOT_CAP;
 }
 
-static int tx_status(bpctl_dev_t *pbpctl_dev)
+static int tx_status(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl = 0;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -3223,7 +3223,7 @@ static int tx_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-static int bp_force_link_status(bpctl_dev_t *pbpctl_dev)
+static int bp_force_link_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (DBI_IF_SERIES(pbpctl_dev->subdevice)) {
@@ -3237,10 +3237,10 @@ static int bp_force_link_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bypass_from_last_read(bpctl_dev_t *pbpctl_dev)
+int bypass_from_last_read(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0;
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
 		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
@@ -3257,9 +3257,9 @@ int bypass_from_last_read(bpctl_dev_t *pbpctl_dev)
 		return BP_NOT_CAP;
 }
 
-int bypass_status_clear(bpctl_dev_t *pbpctl_dev)
+int bypass_status_clear(struct bpctl_dev *pbpctl_dev)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
 		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
@@ -3271,7 +3271,7 @@ int bypass_status_clear(bpctl_dev_t *pbpctl_dev)
 		return BP_NOT_CAP;
 }
 
-int bypass_flag_status(bpctl_dev_t *pbpctl_dev)
+int bypass_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if ((pbpctl_dev->bp_caps & BP_CAP)) {
@@ -3284,7 +3284,7 @@ int bypass_flag_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bypass_flag_status_clear(bpctl_dev_t *pbpctl_dev)
+int bypass_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & BP_CAP) {
@@ -3299,7 +3299,7 @@ int bypass_flag_status_clear(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bypass_change_status(bpctl_dev_t *pbpctl_dev)
+int bypass_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -3318,7 +3318,7 @@ int bypass_change_status(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int bypass_off_status(bpctl_dev_t *pbpctl_dev)
+int bypass_off_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & BP_CAP) {
@@ -3330,12 +3330,12 @@ int bypass_off_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-static int bypass_status(bpctl_dev_t *pbpctl_dev)
+static int bypass_status(struct bpctl_dev *pbpctl_dev)
 {
 	u32 ctrl_ext = 0;
 	if (pbpctl_dev->bp_caps & BP_CAP) {
 
-		bpctl_dev_t *pbpctl_dev_b = NULL;
+		struct bpctl_dev *pbpctl_dev_b = NULL;
 
 		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 		if (!pbpctl_dev_b)
@@ -3413,7 +3413,7 @@ static int bypass_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int default_pwron_status(bpctl_dev_t *pbpctl_dev)
+int default_pwron_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3431,7 +3431,7 @@ int default_pwron_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-static int default_pwroff_status(bpctl_dev_t *pbpctl_dev)
+static int default_pwroff_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	/*if ((!pbpctl_dev->bp_caps&BP_DIS_CAP)&&
@@ -3445,7 +3445,7 @@ static int default_pwroff_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int dis_bypass_cap_status(bpctl_dev_t *pbpctl_dev)
+int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & BP_DIS_CAP) {
@@ -3458,7 +3458,7 @@ int dis_bypass_cap_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int cmd_en_status(bpctl_dev_t *pbpctl_dev)
+int cmd_en_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3470,7 +3470,7 @@ int cmd_en_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int wdt_en_status(bpctl_dev_t *pbpctl_dev)
+int wdt_en_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -3482,7 +3482,7 @@ int wdt_en_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int wdt_programmed(bpctl_dev_t *pbpctl_dev, int *timeout)
+int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
 {
 	int ret = 0;
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -3508,7 +3508,7 @@ int wdt_programmed(bpctl_dev_t *pbpctl_dev, int *timeout)
 	return ret;
 }
 
-int bypass_support(bpctl_dev_t *pbpctl_dev)
+int bypass_support(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 
@@ -3525,7 +3525,7 @@ int bypass_support(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int tap_support(bpctl_dev_t *pbpctl_dev)
+int tap_support(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 
@@ -3541,7 +3541,7 @@ int tap_support(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int normal_support(bpctl_dev_t *pbpctl_dev)
+int normal_support(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 
@@ -3557,7 +3557,7 @@ int normal_support(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int get_bp_prod_caps(bpctl_dev_t *pbpctl_dev)
+int get_bp_prod_caps(struct bpctl_dev *pbpctl_dev)
 {
 	if ((pbpctl_dev->bp_caps & SW_CTL_CAP) &&
 	    (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER))
@@ -3566,7 +3566,7 @@ int get_bp_prod_caps(bpctl_dev_t *pbpctl_dev)
 
 }
 
-int tap_flag_status(bpctl_dev_t *pbpctl_dev)
+int tap_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & TAP_STATUS_CAP) {
@@ -3578,7 +3578,7 @@ int tap_flag_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tap_flag_status_clear(bpctl_dev_t *pbpctl_dev)
+int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
 	if (pbpctl_dev->bp_caps & TAP_STATUS_CAP) {
@@ -3592,7 +3592,7 @@ int tap_flag_status_clear(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tap_change_status(bpctl_dev_t *pbpctl_dev)
+int tap_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
@@ -3609,7 +3609,7 @@ int tap_change_status(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int tap_off_status(bpctl_dev_t *pbpctl_dev)
+int tap_off_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)
@@ -3619,12 +3619,12 @@ int tap_off_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tap_status(bpctl_dev_t *pbpctl_dev)
+int tap_status(struct bpctl_dev *pbpctl_dev)
 {
 	u32 ctrl_ext = 0;
 
 	if (pbpctl_dev->bp_caps & TAP_CAP) {
-		bpctl_dev_t *pbpctl_dev_b = NULL;
+		struct bpctl_dev *pbpctl_dev_b = NULL;
 
 		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 		if (!pbpctl_dev_b)
@@ -3658,7 +3658,7 @@ int tap_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int default_pwron_tap_status(bpctl_dev_t *pbpctl_dev)
+int default_pwron_tap_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)
@@ -3669,7 +3669,7 @@ int default_pwron_tap_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int dis_tap_cap_status(bpctl_dev_t *pbpctl_dev)
+int dis_tap_cap_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & TAP_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)
@@ -3680,7 +3680,7 @@ int dis_tap_cap_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_flag_status(bpctl_dev_t *pbpctl_dev)
+int disc_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3692,7 +3692,7 @@ int disc_flag_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_flag_status_clear(bpctl_dev_t *pbpctl_dev)
+int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3706,7 +3706,7 @@ int disc_flag_status_clear(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_change_status(bpctl_dev_t *pbpctl_dev)
+int disc_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3717,9 +3717,9 @@ int disc_change_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_off_status(bpctl_dev_t *pbpctl_dev)
+int disc_off_status(struct bpctl_dev *pbpctl_dev)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 	u32 ctrl_ext = 0;
 
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3801,7 +3801,7 @@ int disc_off_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-static int disc_status(bpctl_dev_t *pbpctl_dev)
+static int disc_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ctrl = 0;
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
@@ -3813,7 +3813,7 @@ static int disc_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int default_pwron_disc_status(bpctl_dev_t *pbpctl_dev)
+int default_pwron_disc_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DISC_PWUP_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8)
@@ -3824,7 +3824,7 @@ int default_pwron_disc_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int dis_disc_cap_status(bpctl_dev_t *pbpctl_dev)
+int dis_disc_cap_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & DIS_DISC_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8)
@@ -3835,10 +3835,10 @@ int dis_disc_cap_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int disc_port_status(bpctl_dev_t *pbpctl_dev)
+int disc_port_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
@@ -3859,10 +3859,10 @@ int disc_port_status(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int default_pwron_disc_port_status(bpctl_dev_t *pbpctl_dev)
+int default_pwron_disc_port_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
-	bpctl_dev_t *pbpctl_dev_m;
+	struct bpctl_dev *pbpctl_dev_m;
 
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
@@ -3883,7 +3883,7 @@ int default_pwron_disc_port_status(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int wdt_exp_mode_status(bpctl_dev_t *pbpctl_dev)
+int wdt_exp_mode_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver <= PXG2BPI_VER)
@@ -3906,7 +3906,7 @@ int wdt_exp_mode_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tpl2_flag_status(bpctl_dev_t *pbpctl_dev)
+int tpl2_flag_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
@@ -3917,9 +3917,9 @@ int tpl2_flag_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int tpl_hw_status(bpctl_dev_t *pbpctl_dev)
+int tpl_hw_status(struct bpctl_dev *pbpctl_dev)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 	if (!pbpctl_dev_b)
@@ -3932,7 +3932,7 @@ int tpl_hw_status(bpctl_dev_t *pbpctl_dev)
 }
 
 
-int bp_wait_at_pwup_status(bpctl_dev_t *pbpctl_dev)
+int bp_wait_at_pwup_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8)
@@ -3943,7 +3943,7 @@ int bp_wait_at_pwup_status(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int bp_hw_reset_status(bpctl_dev_t *pbpctl_dev)
+int bp_hw_reset_status(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
@@ -3957,7 +3957,7 @@ int bp_hw_reset_status(bpctl_dev_t *pbpctl_dev)
 }
 
 
-int std_nic_status(bpctl_dev_t *pbpctl_dev)
+int std_nic_status(struct bpctl_dev *pbpctl_dev)
 {
 	int status_val = 0;
 
@@ -4005,10 +4005,10 @@ int std_nic_status(bpctl_dev_t *pbpctl_dev)
 /******************************************************/
 /**************SW_INIT*********************************/
 /******************************************************/
-void bypass_caps_init(bpctl_dev_t *pbpctl_dev)
+void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 {
 	u_int32_t ctrl_ext = 0;
-	bpctl_dev_t *pbpctl_dev_m = NULL;
+	struct bpctl_dev *pbpctl_dev_m = NULL;
 
 #ifdef BYPASS_DEBUG
 	int ret = 0;
@@ -4223,7 +4223,7 @@ void bypass_caps_init(bpctl_dev_t *pbpctl_dev)
 	}
 }
 
-int bypass_off_init(bpctl_dev_t *pbpctl_dev)
+int bypass_off_init(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = cmnd_on(pbpctl_dev);
 	if (ret < 0)
@@ -4239,10 +4239,10 @@ int bypass_off_init(bpctl_dev_t *pbpctl_dev)
 	return 0;
 }
 
-void remove_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
+void remove_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
 {
 #ifdef BP_SELF_TEST
-	bpctl_dev_t *pbpctl_dev_sl = NULL;
+	struct bpctl_dev *pbpctl_dev_sl = NULL;
 #endif
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -4268,7 +4268,7 @@ void remove_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
 
 }
 
-int init_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
+int init_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		init_timer(&pbpctl_dev->bp_timer);
@@ -4282,7 +4282,7 @@ int init_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
 #ifdef BP_SELF_TEST
 int bp_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	bpctl_dev_t *pbpctl_dev = NULL, *pbpctl_dev_m = NULL;
+	struct bpctl_dev *pbpctl_dev = NULL, *pbpctl_dev_m = NULL;
 	int idx_dev = 0;
 	struct ethhdr *eth = (struct ethhdr *)skb->data;
 
@@ -4315,7 +4315,7 @@ int bp_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 }
 #endif
 
-int set_bypass_wd_auto(bpctl_dev_t *pbpctl_dev, unsigned int param)
+int set_bypass_wd_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->reset_time != param) {
@@ -4334,7 +4334,7 @@ int set_bypass_wd_auto(bpctl_dev_t *pbpctl_dev, unsigned int param)
 	return BP_NOT_CAP;
 }
 
-int get_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
+int get_bypass_wd_auto(struct bpctl_dev *pbpctl_dev)
 {
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP)
 		return pbpctl_dev->reset_time;
@@ -4344,9 +4344,9 @@ int get_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
 
 #ifdef BP_SELF_TEST
 
-int set_bp_self_test(bpctl_dev_t *pbpctl_dev, unsigned int param)
+int set_bp_self_test(struct bpctl_dev *pbpctl_dev, unsigned int param)
 {
-	bpctl_dev_t *pbpctl_dev_sl = NULL;
+	struct bpctl_dev *pbpctl_dev_sl = NULL;
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		pbpctl_dev->bp_self_test_flag = param == 0 ? 0 : 1;
@@ -4379,7 +4379,7 @@ int set_bp_self_test(bpctl_dev_t *pbpctl_dev, unsigned int param)
 	return BP_NOT_CAP;
 }
 
-int get_bp_self_test(bpctl_dev_t *pbpctl_dev)
+int get_bp_self_test(struct bpctl_dev *pbpctl_dev)
 {
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
@@ -4397,7 +4397,7 @@ int get_bp_self_test(bpctl_dev_t *pbpctl_dev)
 /************************* API ********************************/
 /**************************************************************/
 
-int is_bypass_fn(bpctl_dev_t *pbpctl_dev)
+int is_bypass_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4405,7 +4405,7 @@ int is_bypass_fn(bpctl_dev_t *pbpctl_dev)
 	return (((pbpctl_dev->func == 0) || (pbpctl_dev->func == 2)) ? 1 : 0);
 }
 
-int set_bypass_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
+int set_bypass_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
 
@@ -4423,12 +4423,12 @@ int set_bypass_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 	return ret;
 }
 
-int get_bypass_fn(bpctl_dev_t *pbpctl_dev)
+int get_bypass_fn(struct bpctl_dev *pbpctl_dev)
 {
 	return bypass_status(pbpctl_dev);
 }
 
-int get_bypass_change_fn(bpctl_dev_t *pbpctl_dev)
+int get_bypass_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4436,7 +4436,7 @@ int get_bypass_change_fn(bpctl_dev_t *pbpctl_dev)
 	return bypass_change_status(pbpctl_dev);
 }
 
-int set_dis_bypass_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
+int set_dis_bypass_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4455,7 +4455,7 @@ int set_dis_bypass_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
 	return ret;
 }
 
-int get_dis_bypass_fn(bpctl_dev_t *pbpctl_dev)
+int get_dis_bypass_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4463,7 +4463,7 @@ int get_dis_bypass_fn(bpctl_dev_t *pbpctl_dev)
 	return dis_bypass_cap_status(pbpctl_dev);
 }
 
-int set_bypass_pwoff_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
+int set_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4482,7 +4482,7 @@ int set_bypass_pwoff_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 	return ret;
 }
 
-int get_bypass_pwoff_fn(bpctl_dev_t *pbpctl_dev)
+int get_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4490,7 +4490,7 @@ int get_bypass_pwoff_fn(bpctl_dev_t *pbpctl_dev)
 	return default_pwroff_status(pbpctl_dev);
 }
 
-int set_bypass_pwup_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
+int set_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4509,7 +4509,7 @@ int set_bypass_pwup_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 	return ret;
 }
 
-int get_bypass_pwup_fn(bpctl_dev_t *pbpctl_dev)
+int get_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4517,7 +4517,7 @@ int get_bypass_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	return default_pwron_status(pbpctl_dev);
 }
 
-int set_bypass_wd_fn(bpctl_dev_t *pbpctl_dev, int timeout)
+int set_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int timeout)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4539,7 +4539,7 @@ int set_bypass_wd_fn(bpctl_dev_t *pbpctl_dev, int timeout)
 	return ret;
 }
 
-int get_bypass_wd_fn(bpctl_dev_t *pbpctl_dev, int *timeout)
+int get_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int *timeout)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4547,7 +4547,7 @@ int get_bypass_wd_fn(bpctl_dev_t *pbpctl_dev, int *timeout)
 	return wdt_programmed(pbpctl_dev, timeout);
 }
 
-int get_wd_expire_time_fn(bpctl_dev_t *pbpctl_dev, int *time_left)
+int get_wd_expire_time_fn(struct bpctl_dev *pbpctl_dev, int *time_left)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4555,7 +4555,7 @@ int get_wd_expire_time_fn(bpctl_dev_t *pbpctl_dev, int *time_left)
 	return wdt_timer(pbpctl_dev, time_left);
 }
 
-int reset_bypass_wd_timer_fn(bpctl_dev_t *pbpctl_dev)
+int reset_bypass_wd_timer_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4563,7 +4563,7 @@ int reset_bypass_wd_timer_fn(bpctl_dev_t *pbpctl_dev)
 	return wdt_timer_reload(pbpctl_dev);
 }
 
-int get_wd_set_caps_fn(bpctl_dev_t *pbpctl_dev)
+int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int bp_status = 0;
 
@@ -4587,7 +4587,7 @@ int get_wd_set_caps_fn(bpctl_dev_t *pbpctl_dev)
 	return bp_status;
 }
 
-int set_std_nic_fn(bpctl_dev_t *pbpctl_dev, int nic_mode)
+int set_std_nic_fn(struct bpctl_dev *pbpctl_dev, int nic_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4607,7 +4607,7 @@ int set_std_nic_fn(bpctl_dev_t *pbpctl_dev, int nic_mode)
 	return ret;
 }
 
-int get_std_nic_fn(bpctl_dev_t *pbpctl_dev)
+int get_std_nic_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4615,7 +4615,7 @@ int get_std_nic_fn(bpctl_dev_t *pbpctl_dev)
 	return std_nic_status(pbpctl_dev);
 }
 
-int set_tap_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
+int set_tap_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4631,7 +4631,7 @@ int set_tap_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
 	return BP_NOT_CAP;
 }
 
-int get_tap_fn(bpctl_dev_t *pbpctl_dev)
+int get_tap_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4639,7 +4639,7 @@ int get_tap_fn(bpctl_dev_t *pbpctl_dev)
 	return tap_status(pbpctl_dev);
 }
 
-int set_tap_pwup_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
+int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4657,7 +4657,7 @@ int set_tap_pwup_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
 	return ret;
 }
 
-int get_tap_pwup_fn(bpctl_dev_t *pbpctl_dev)
+int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4669,7 +4669,7 @@ int get_tap_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	return ((ret == 0) ? 1 : 0);
 }
 
-int get_tap_change_fn(bpctl_dev_t *pbpctl_dev)
+int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4677,7 +4677,7 @@ int get_tap_change_fn(bpctl_dev_t *pbpctl_dev)
 	return tap_change_status(pbpctl_dev);
 }
 
-int set_dis_tap_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
+int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4694,7 +4694,7 @@ int set_dis_tap_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
 		return BP_NOT_CAP;
 }
 
-int get_dis_tap_fn(bpctl_dev_t *pbpctl_dev)
+int get_dis_tap_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4702,7 +4702,7 @@ int get_dis_tap_fn(bpctl_dev_t *pbpctl_dev)
 	return dis_tap_cap_status(pbpctl_dev);
 }
 
-int set_disc_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
+int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4719,7 +4719,7 @@ int set_disc_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
 	return BP_NOT_CAP;
 }
 
-int get_disc_fn(bpctl_dev_t *pbpctl_dev)
+int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4730,7 +4730,7 @@ int get_disc_fn(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int set_disc_pwup_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
+int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4748,7 +4748,7 @@ int set_disc_pwup_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
 	return ret;
 }
 
-int get_disc_pwup_fn(bpctl_dev_t *pbpctl_dev)
+int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4758,7 +4758,7 @@ int get_disc_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	return (ret == 0 ? 1 : (ret < 0 ? BP_NOT_CAP : 0));
 }
 
-int get_disc_change_fn(bpctl_dev_t *pbpctl_dev)
+int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4768,7 +4768,7 @@ int get_disc_change_fn(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int set_dis_disc_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
+int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4786,7 +4786,7 @@ int set_dis_disc_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
 		return BP_NOT_CAP;
 }
 
-int get_dis_disc_fn(bpctl_dev_t *pbpctl_dev)
+int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4797,7 +4797,7 @@ int get_dis_disc_fn(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int set_disc_port_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
+int set_disc_port_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	int ret = BP_NOT_CAP;
 	if (!pbpctl_dev)
@@ -4811,7 +4811,7 @@ int set_disc_port_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
 	return ret;
 }
 
-int get_disc_port_fn(bpctl_dev_t *pbpctl_dev)
+int get_disc_port_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4819,7 +4819,7 @@ int get_disc_port_fn(bpctl_dev_t *pbpctl_dev)
 	return disc_port_status(pbpctl_dev);
 }
 
-int set_disc_port_pwup_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
+int set_disc_port_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	int ret = BP_NOT_CAP;
 	if (!pbpctl_dev)
@@ -4833,7 +4833,7 @@ int set_disc_port_pwup_fn(bpctl_dev_t *pbpctl_dev, int disc_mode)
 	return ret;
 }
 
-int get_disc_port_pwup_fn(bpctl_dev_t *pbpctl_dev)
+int get_disc_port_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4845,7 +4845,7 @@ int get_disc_port_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	return ((ret == 0) ? 1 : 0);
 }
 
-int get_wd_exp_mode_fn(bpctl_dev_t *pbpctl_dev)
+int get_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4853,7 +4853,7 @@ int get_wd_exp_mode_fn(bpctl_dev_t *pbpctl_dev)
 	return wdt_exp_mode_status(pbpctl_dev);
 }
 
-int set_wd_exp_mode_fn(bpctl_dev_t *pbpctl_dev, int param)
+int set_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev, int param)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4861,7 +4861,7 @@ int set_wd_exp_mode_fn(bpctl_dev_t *pbpctl_dev, int param)
 	return wdt_exp_mode(pbpctl_dev, param);
 }
 
-int reset_cont_fn(bpctl_dev_t *pbpctl_dev)
+int reset_cont_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -4873,10 +4873,10 @@ int reset_cont_fn(bpctl_dev_t *pbpctl_dev)
 	return reset_cont(pbpctl_dev);
 }
 
-int set_tx_fn(bpctl_dev_t *pbpctl_dev, int tx_state)
+int set_tx_fn(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
 
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4896,7 +4896,7 @@ int set_tx_fn(bpctl_dev_t *pbpctl_dev, int tx_state)
 
 int set_bp_force_link_fn(int dev_num, int tx_state)
 {
-	static bpctl_dev_t *bpctl_dev_curr;
+	static struct bpctl_dev *bpctl_dev_curr;
 
 	if ((dev_num < 0) || (dev_num > device_num)
 	    || (bpctl_dev_arr[dev_num].pdev == NULL))
@@ -4906,7 +4906,7 @@ int set_bp_force_link_fn(int dev_num, int tx_state)
 	return set_bp_force_link(bpctl_dev_curr, tx_state);
 }
 
-int set_wd_autoreset_fn(bpctl_dev_t *pbpctl_dev, int param)
+int set_wd_autoreset_fn(struct bpctl_dev *pbpctl_dev, int param)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4914,7 +4914,7 @@ int set_wd_autoreset_fn(bpctl_dev_t *pbpctl_dev, int param)
 	return set_bypass_wd_auto(pbpctl_dev, param);
 }
 
-int get_wd_autoreset_fn(bpctl_dev_t *pbpctl_dev)
+int get_wd_autoreset_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4923,7 +4923,7 @@ int get_wd_autoreset_fn(bpctl_dev_t *pbpctl_dev)
 }
 
 #ifdef BP_SELF_TEST
-int set_bp_self_test_fn(bpctl_dev_t *pbpctl_dev, int param)
+int set_bp_self_test_fn(struct bpctl_dev *pbpctl_dev, int param)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4931,7 +4931,7 @@ int set_bp_self_test_fn(bpctl_dev_t *pbpctl_dev, int param)
 	return set_bp_self_test(pbpctl_dev, param);
 }
 
-int get_bp_self_test_fn(bpctl_dev_t *pbpctl_dev)
+int get_bp_self_test_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4941,7 +4941,7 @@ int get_bp_self_test_fn(bpctl_dev_t *pbpctl_dev)
 
 #endif
 
-int get_bypass_caps_fn(bpctl_dev_t *pbpctl_dev)
+int get_bypass_caps_fn(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4950,7 +4950,7 @@ int get_bypass_caps_fn(bpctl_dev_t *pbpctl_dev)
 
 }
 
-int get_bypass_slave_fn(bpctl_dev_t *pbpctl_dev, bpctl_dev_t **pbpctl_dev_out)
+int get_bypass_slave_fn(struct bpctl_dev *pbpctl_dev, struct bpctl_dev **pbpctl_dev_out)
 {
 	int idx_dev = 0;
 	if (!pbpctl_dev)
@@ -4982,7 +4982,7 @@ int get_bypass_slave_fn(bpctl_dev_t *pbpctl_dev, bpctl_dev_t **pbpctl_dev_out)
 		return 0;
 }
 
-int is_bypass(bpctl_dev_t *pbpctl_dev)
+int is_bypass(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -4993,9 +4993,9 @@ int is_bypass(bpctl_dev_t *pbpctl_dev)
 		return 0;
 }
 
-int get_tx_fn(bpctl_dev_t *pbpctl_dev)
+int get_tx_fn(struct bpctl_dev *pbpctl_dev)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 	if (!pbpctl_dev)
 		return -1;
 
@@ -5015,7 +5015,7 @@ int get_tx_fn(bpctl_dev_t *pbpctl_dev)
 
 int get_bp_force_link_fn(int dev_num)
 {
-	static bpctl_dev_t *bpctl_dev_curr;
+	static struct bpctl_dev *bpctl_dev_curr;
 
 	if ((dev_num < 0) || (dev_num > device_num)
 	    || (bpctl_dev_arr[dev_num].pdev == NULL))
@@ -5025,7 +5025,7 @@ int get_bp_force_link_fn(int dev_num)
 	return bp_force_link_status(bpctl_dev_curr);
 }
 
-static int get_bypass_link_status(bpctl_dev_t *pbpctl_dev)
+static int get_bypass_link_status(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5041,9 +5041,9 @@ static int get_bypass_link_status(bpctl_dev_t *pbpctl_dev)
 
 static void bp_tpl_timer_fn(unsigned long param)
 {
-	bpctl_dev_t *pbpctl_dev = (bpctl_dev_t *) param;
+	struct bpctl_dev *pbpctl_dev = (struct bpctl_dev *) param;
 	uint32_t link1, link2;
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
 	if (!pbpctl_dev_b)
@@ -5076,9 +5076,9 @@ static void bp_tpl_timer_fn(unsigned long param)
 	mod_timer(&pbpctl_dev->bp_tpl_timer, jiffies + BP_LINK_MON_DELAY * HZ);
 }
 
-void remove_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev)
+void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 	if (!pbpctl_dev)
 		return;
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
@@ -5094,7 +5094,7 @@ void remove_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev)
 	return;
 }
 
-int init_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev)
+int init_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5107,7 +5107,7 @@ int init_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int set_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev, unsigned int param)
+int set_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5125,7 +5125,7 @@ int set_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev, unsigned int param)
 	return BP_NOT_CAP;
 }
 
-int get_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev)
+int get_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5135,10 +5135,10 @@ int get_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev)
 	return BP_NOT_CAP;
 }
 
-int set_tpl_fn(bpctl_dev_t *pbpctl_dev, int tpl_mode)
+int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 {
 
-	bpctl_dev_t *pbpctl_dev_b = NULL;
+	struct bpctl_dev *pbpctl_dev_b = NULL;
 	if (!pbpctl_dev)
 		return -1;
 
@@ -5165,7 +5165,7 @@ int set_tpl_fn(bpctl_dev_t *pbpctl_dev, int tpl_mode)
 	return BP_NOT_CAP;
 }
 
-int get_tpl_fn(bpctl_dev_t *pbpctl_dev)
+int get_tpl_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
 	if (!pbpctl_dev)
@@ -5179,7 +5179,7 @@ int get_tpl_fn(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int set_bp_wait_at_pwup_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
+int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5199,7 +5199,7 @@ int set_bp_wait_at_pwup_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
 	return BP_NOT_CAP;
 }
 
-int get_bp_wait_at_pwup_fn(bpctl_dev_t *pbpctl_dev)
+int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -5212,7 +5212,7 @@ int get_bp_wait_at_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	return ret;
 }
 
-int set_bp_hw_reset_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
+int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	if (!pbpctl_dev)
 		return -1;
@@ -5232,7 +5232,7 @@ int set_bp_hw_reset_fn(bpctl_dev_t *pbpctl_dev, int tap_mode)
 	return BP_NOT_CAP;
 }
 
-int get_bp_hw_reset_fn(bpctl_dev_t *pbpctl_dev)
+int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
 	if (!pbpctl_dev)
@@ -5247,7 +5247,7 @@ int get_bp_hw_reset_fn(bpctl_dev_t *pbpctl_dev)
 }
 
 
-int get_bypass_info_fn(bpctl_dev_t *pbpctl_dev, char *dev_name,
+int get_bypass_info_fn(struct bpctl_dev *pbpctl_dev, char *dev_name,
 		       char *add_param)
 {
 	if (!pbpctl_dev)
@@ -5318,7 +5318,7 @@ static int get_dev_idx(int ifindex)
 	return -1;
 }
 
-static bpctl_dev_t *get_dev_idx_p(int ifindex)
+static struct bpctl_dev *get_dev_idx_p(int ifindex)
 {
 	int idx_dev = 0;
 
@@ -5406,12 +5406,12 @@ static long device_ioctl(struct file *file,	/* see include/linux/fs.h */
 {
 	struct bpctl_cmd bpctl_cmd;
 	int dev_idx = 0;
-	bpctl_dev_t *pbpctl_dev_out;
+	struct bpctl_dev *pbpctl_dev_out;
 	void __user *argp = (void __user *)ioctl_param;
 	int ret = 0;
 	unsigned long flags;
 
-	static bpctl_dev_t *pbpctl_dev;
+	static struct bpctl_dev *pbpctl_dev;
 
 	/* lock_kernel(); */
 	lock_bpctl();
@@ -6627,7 +6627,7 @@ static bpmod_info_t tx_ctl_pci_tbl[] = {
 	{0,}
 };
 
-static void find_fw(bpctl_dev_t *dev)
+static void find_fw(struct bpctl_dev *dev)
 {
 	unsigned long mmio_start, mmio_len;
 	struct pci_dev *pdev1 = dev->pdev;
@@ -6657,7 +6657,7 @@ static void find_fw(bpctl_dev_t *dev)
 	printk("firmware version: 0x%x\n", dev->bp_fw_ver);
 }
 
-static int init_one(bpctl_dev_t *dev, bpmod_info_t *info, struct pci_dev *pdev1)
+static int init_one(struct bpctl_dev *dev, bpmod_info_t *info, struct pci_dev *pdev1)
 {
 	unsigned long mmio_start, mmio_len;
 
@@ -6748,7 +6748,7 @@ static int __init bypass_init_module(void)
 {
 	int ret_val, idx, idx_dev = 0;
 	struct pci_dev *pdev1 = NULL;
-	bpctl_dev_t *dev;
+	struct bpctl_dev *dev;
 
 	printk(BP_MOD_DESCR " v" BP_MOD_VER "\n");
 	ret_val = register_chrdev(major_num, DEVICE_NAME, &Fops);
@@ -6773,14 +6773,14 @@ static int __init bypass_init_module(void)
 		return -1;
 	}
 
-	bpctl_dev_arr = kmalloc((device_num) * sizeof(bpctl_dev_t), GFP_KERNEL);
+	bpctl_dev_arr = kmalloc((device_num) * sizeof(struct bpctl_dev), GFP_KERNEL);
 
 	if (!bpctl_dev_arr) {
 		printk("Allocation error\n");
 		unregister_chrdev(major_num, DEVICE_NAME);
 		return -1;
 	}
-	memset(bpctl_dev_arr, 0, ((device_num) * sizeof(bpctl_dev_t)));
+	memset(bpctl_dev_arr, 0, ((device_num) * sizeof(struct bpctl_dev)));
 
 	pdev1 = NULL;
 	dev = bpctl_dev_arr;
@@ -6801,7 +6801,7 @@ static int __init bypass_init_module(void)
 	spin_lock_init(&bpvm_lock);
 	{
 
-		bpctl_dev_t *pbpctl_dev_c = NULL;
+		struct bpctl_dev *pbpctl_dev_c = NULL;
 		for (idx_dev = 0, dev = bpctl_dev_arr;
 		     idx_dev < device_num && dev->pdev;
 		     idx_dev++, dev++) {
@@ -7173,7 +7173,7 @@ EXPORT_SYMBOL(get_bypass_caps_sd);
 
 int get_bypass_slave_sd(int ifindex)
 {
-	bpctl_dev_t *pbpctl_dev_out;
+	struct bpctl_dev *pbpctl_dev_out;
 	int ret = get_bypass_slave_fn(get_dev_idx_p(ifindex), &pbpctl_dev_out);
 	if (ret == 1)
 		return pbpctl_dev_out->ifindex;
@@ -7233,7 +7233,7 @@ int bp_proc_create(void)
 }
 
 static int procfs_add(char *proc_name, const struct file_operations *fops,
-		      bpctl_dev_t *dev)
+		      struct bpctl_dev *dev)
 {
 	struct bypass_pfs_sd *pfs = &dev->bypass_pfs_set;
 	if (!proc_create_data(proc_name, 0644, pfs->bypass_entry, fops, dev))
@@ -7268,7 +7268,7 @@ static const struct file_operations name##_ops = {		\
 
 static int show_bypass_info(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 
 	seq_printf(m, "Name\t\t\t%s\n", dev->name);
 	seq_printf(m, "Firmware version\t0x%x\n", dev->bp_fw_ver);
@@ -7278,8 +7278,8 @@ RO_FOPS(bypass_info)
 
 static int show_bypass_slave(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
-	bpctl_dev_t *slave = get_status_port_fn(dev);
+	struct bpctl_dev *dev = m->private;
+	struct bpctl_dev *slave = get_status_port_fn(dev);
 	if (!slave)
 		slave = dev;
 	if (!slave)
@@ -7292,7 +7292,7 @@ RO_FOPS(bypass_slave)
 
 static int show_bypass_caps(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_caps_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
@@ -7304,7 +7304,7 @@ RO_FOPS(bypass_caps)
 
 static int show_wd_set_caps(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_set_caps_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
@@ -7350,7 +7350,7 @@ static ssize_t bypass_write(struct file *file, const char __user *buffer,
 }
 static int show_bypass(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7374,7 +7374,7 @@ static ssize_t tap_write(struct file *file, const char __user *buffer,
 }
 static int show_tap(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7398,7 +7398,7 @@ static ssize_t disc_write(struct file *file, const char __user *buffer,
 }
 static int show_disc(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7412,7 +7412,7 @@ RW_FOPS(disc)
 
 static int show_bypass_change(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_change_fn(dev);
 	if (ret == 1)
 		seq_puts(m, "on\n");
@@ -7426,7 +7426,7 @@ RO_FOPS(bypass_change)
 
 static int show_tap_change(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_change_fn(dev);
 	if (ret == 1)
 		seq_puts(m, "on\n");
@@ -7440,7 +7440,7 @@ RO_FOPS(tap_change)
 
 static int show_disc_change(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_change_fn(dev);
 	if (ret == 1)
 		seq_puts(m, "on\n");
@@ -7455,7 +7455,7 @@ RO_FOPS(disc_change)
 static ssize_t bypass_wd_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
-	bpctl_dev_t *dev = PDE_DATA(file_inode(file));
+	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int timeout;
 	int ret = kstrtoint_from_user(buffer, count, 10, &timeout);
 	if (ret)
@@ -7465,7 +7465,7 @@ static ssize_t bypass_wd_write(struct file *file, const char __user *buffer,
 }
 static int show_bypass_wd(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = 0, timeout = 0;
 
 	ret = get_bypass_wd_fn(dev, &timeout);
@@ -7483,7 +7483,7 @@ RW_FOPS(bypass_wd)
 
 static int show_wd_expire_time(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = 0, timeout = 0;
 	ret = get_wd_expire_time_fn(dev, &timeout);
 	if (ret == BP_NOT_CAP)
@@ -7501,7 +7501,7 @@ RO_FOPS(wd_expire_time)
 static ssize_t tpl_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
-	bpctl_dev_t *dev = PDE_DATA(file_inode(file));
+	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
 	if (tpl_param < 0)
 		return -1;
@@ -7511,7 +7511,7 @@ static ssize_t tpl_write(struct file *file, const char __user *buffer,
 }
 static int show_tpl(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_tpl_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7527,7 +7527,7 @@ RW_FOPS(tpl)
 static ssize_t wait_at_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
-	bpctl_dev_t *dev = PDE_DATA(file_inode(file));
+	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
 	if (tpl_param < 0)
 		return -1;
@@ -7537,7 +7537,7 @@ static ssize_t wait_at_pwup_write(struct file *file, const char __user *buffer,
 }
 static int show_wait_at_pwup(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_wait_at_pwup_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7552,7 +7552,7 @@ RW_FOPS(wait_at_pwup)
 static ssize_t hw_reset_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
-	bpctl_dev_t *dev = PDE_DATA(file_inode(file));
+	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
 	if (tpl_param < 0)
 		return -1;
@@ -7562,7 +7562,7 @@ static ssize_t hw_reset_write(struct file *file, const char __user *buffer,
 }
 static int show_hw_reset(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_hw_reset_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7578,7 +7578,7 @@ RW_FOPS(hw_reset)
 
 static int show_reset_bypass_wd(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = reset_bypass_wd_timer_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7602,7 +7602,7 @@ static ssize_t dis_bypass_write(struct file *file, const char __user *buffer,
 }
 static int show_dis_bypass(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_bypass_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7626,7 +7626,7 @@ static ssize_t dis_tap_write(struct file *file, const char __user *buffer,
 }
 static int show_dis_tap(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_tap_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7650,7 +7650,7 @@ static ssize_t dis_disc_write(struct file *file, const char __user *buffer,
 }
 static int show_dis_disc(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_disc_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7674,7 +7674,7 @@ static ssize_t bypass_pwup_write(struct file *file, const char __user *buffer,
 }
 static int show_bypass_pwup(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwup_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7698,7 +7698,7 @@ static ssize_t bypass_pwoff_write(struct file *file, const char __user *buffer,
 }
 static int show_bypass_pwoff(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwoff_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7722,7 +7722,7 @@ static ssize_t tap_pwup_write(struct file *file, const char __user *buffer,
 }
 static int show_tap_pwup(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_pwup_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7746,7 +7746,7 @@ static ssize_t disc_pwup_write(struct file *file, const char __user *buffer,
 }
 static int show_disc_pwup(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_pwup_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7770,7 +7770,7 @@ static ssize_t std_nic_write(struct file *file, const char __user *buffer,
 }
 static int show_std_nic(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_std_nic_fn(dev);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7812,7 +7812,7 @@ static ssize_t wd_exp_mode_write(struct file *file, const char __user *buffer,
 }
 static int show_wd_exp_mode(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_exp_mode_fn(dev);
 	if (ret == 1)
 		seq_puts(m, "tap\n");
@@ -7838,7 +7838,7 @@ static ssize_t wd_autoreset_write(struct file *file, const char __user *buffer,
 }
 static int show_wd_autoreset(struct seq_file *m, void *v)
 {
-	bpctl_dev_t *dev = m->private;
+	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_autoreset_fn(dev);
 	if (ret >= 0)
 		seq_printf(m, "%d\n", ret);
@@ -7848,7 +7848,7 @@ static int show_wd_autoreset(struct seq_file *m, void *v)
 }
 RW_FOPS(wd_autoreset)
 
-int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block)
+int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block)
 {
 	struct bypass_pfs_sd *current_pfs = &(pbp_device_block->bypass_pfs_set);
 	static struct proc_dir_entry *procfs_dir;
@@ -7917,7 +7917,7 @@ int bypass_proc_create_dev_sd(bpctl_dev_t *pbp_device_block)
 	return ret;
 }
 
-int bypass_proc_remove_dev_sd(bpctl_dev_t *pbp_device_block)
+int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block)
 {
 
 	struct bypass_pfs_sd *current_pfs = &pbp_device_block->bypass_pfs_set;
-- 
1.8.1.4

