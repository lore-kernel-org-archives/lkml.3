Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751413AbaEYS7L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 14:59:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33002 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbaEYS7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 14:59:09 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, dan.carpenter@oracle.com, chad@dahc.us,
        michael.banken@mathe.stud.uni-erlangen.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Fixed a lot of checkpatch.pl warnings
Date: Sun, 25 May 2014 11:59:08 -0700
Message-Id: <1401044348-15627-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declarations in many places to fix the following warning issued by checkpatch.pl:

WARNING: Missing a blank line after declarations

Lets see if this works now, this patch is prepared against Greg's staging tree.

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/silicom/bpctl_mod.c        |   92 +++++++++++++++++++++++++++-
 drivers/staging/silicom/bypasslib/bypass.c |    2 +
 2 files changed, 91 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 6b9365b..b7f9893 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -749,6 +749,7 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 	uint32_t ctrl_ext = 0, ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_c = NULL;
 	unsigned long flags;
+
 	if (pbpctl_dev->bp_10g9) {
 		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
 		if (!pbpctl_dev_c)
@@ -924,6 +925,7 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 
 #ifdef BP_SYNC_FLAG
 	unsigned long flags;
+
 	spin_lock_irqsave(&pbpctl_dev->bypass_wr_lock, flags);
 #else
 	atomic_set(&pbpctl_dev->wdt_busy, 1);
@@ -1560,6 +1562,7 @@ int pulse_set_fn(struct bpctl_dev *pbpctl_dev, unsigned int counter)
 int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -1585,6 +1588,7 @@ int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 int pulse_get2_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -1600,6 +1604,7 @@ int pulse_get2_fn(struct bpctl_dev *pbpctl_dev)
 int pulse_get1_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -1663,6 +1668,7 @@ static struct bpctl_dev *lookup_port(struct bpctl_dev *dev)
 {
 	struct bpctl_dev *p;
 	int n;
+
 	for (n = 0, p = bpctl_dev_arr; n < device_num && p->pdev; n++) {
 		if (p->bus == dev->bus
 		    && p->slot == dev->slot
@@ -1840,6 +1846,7 @@ static int bypass_off(struct bpctl_dev *pbpctl_dev)
 static int tap_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
 	    && (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)) {
 		write_data(pbpctl_dev, TAP_OFF);
@@ -1853,6 +1860,7 @@ static int tap_off(struct bpctl_dev *pbpctl_dev)
 static int tap_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
 	    && (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)) {
 		write_data(pbpctl_dev, TAP_ON);
@@ -1866,6 +1874,7 @@ static int tap_on(struct bpctl_dev *pbpctl_dev)
 static int disc_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
 		write_data(pbpctl_dev, DISC_OFF);
 		msec_delay_bp(LATCH_DELAY);
@@ -1878,6 +1887,7 @@ static int disc_off(struct bpctl_dev *pbpctl_dev)
 static int disc_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
 		write_data(pbpctl_dev, /*DISC_ON */ 0x85);
 		msec_delay_bp(LATCH_DELAY);
@@ -2267,6 +2277,7 @@ static int set_tx(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
 	int ret = 0, ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_m;
+
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -2799,6 +2810,7 @@ int wdt_time_left(struct bpctl_dev *pbpctl_dev)
 static int wdt_timer(struct bpctl_dev *pbpctl_dev, int *time_left)
 {
 	int ret = 0;
+
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		{
 			if (pbpctl_dev->wdt_status == WDT_STATUS_UNKNOWN)
@@ -3011,6 +3023,7 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_m;
+
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -3192,6 +3205,7 @@ static int bypass_change_status(struct bpctl_dev *pbpctl_dev)
 static int bypass_status(struct bpctl_dev *pbpctl_dev)
 {
 	u32 ctrl_ext = 0;
+
 	if (pbpctl_dev->bp_caps & BP_CAP) {
 
 		struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -3320,6 +3334,7 @@ static int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
 static int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
 {
 	int ret = 0;
+
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
 			if ((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
@@ -3383,6 +3398,7 @@ static int tap_flag_status(struct bpctl_dev *pbpctl_dev)
 static int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
+
 	if (pbpctl_dev->bp_caps & TAP_STATUS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
 			status_reg = read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR);
@@ -3397,6 +3413,7 @@ static int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 static int tap_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
 		if (pbpctl_dev->bp_caps & TAP_CAP) {
 			if (pbpctl_dev->bp_caps & BP_CAP) {
@@ -3487,6 +3504,7 @@ static int disc_flag_status(struct bpctl_dev *pbpctl_dev)
 static int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
 			status_reg = read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR);
@@ -3501,6 +3519,7 @@ static int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 static int disc_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		ret = disc_flag_status(pbpctl_dev);
 		disc_flag_status_clear(pbpctl_dev);
@@ -3596,6 +3615,7 @@ static int disc_off_status(struct bpctl_dev *pbpctl_dev)
 static int disc_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ctrl = 0;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		ctrl = disc_off_status(pbpctl_dev);
 		if (ctrl < 0)
@@ -3741,6 +3761,7 @@ static void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 
 #ifdef BYPASS_DEBUG
 	int ret = 0;
+
 	if (!(INTEL_IF_SERIES(adapter->bp_device_block.subdevice))) {
 		ret = read_reg(pbpctl_dev, VER_REG_ADDR);
 		printk("VER_REG reg1=%x\n", ret);
@@ -4152,6 +4173,7 @@ static int get_bypass_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_bypass_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4179,6 +4201,7 @@ static int get_dis_bypass_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4206,6 +4229,7 @@ static int get_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4233,6 +4257,7 @@ static int get_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int timeout)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4279,8 +4304,8 @@ static int reset_bypass_wd_timer_fn(struct bpctl_dev *pbpctl_dev)
 static int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int bp_status = 0;
-
 	unsigned int step_value = TIMEOUT_MAX_STEP + 1, bit_cnt = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4303,6 +4328,7 @@ static int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 static int set_std_nic_fn(struct bpctl_dev *pbpctl_dev, int nic_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4355,6 +4381,7 @@ static int get_tap_fn(struct bpctl_dev *pbpctl_dev)
 static int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4373,6 +4400,7 @@ static int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4393,6 +4421,7 @@ static int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4435,6 +4464,7 @@ static int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4446,6 +4476,7 @@ static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4464,6 +4495,7 @@ static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4474,6 +4506,7 @@ static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4484,6 +4517,7 @@ static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4502,6 +4536,7 @@ static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 static int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4528,8 +4563,8 @@ static int set_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev, int param)
 
 static int set_tx_fn(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
-
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4607,6 +4642,7 @@ static int get_bypass_slave_fn(struct bpctl_dev *pbpctl_dev,
 			       struct bpctl_dev **pbpctl_dev_out)
 {
 	int idx_dev = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4650,6 +4686,7 @@ static int is_bypass(struct bpctl_dev *pbpctl_dev)
 static int get_tx_fn(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4733,6 +4770,7 @@ static void bp_tpl_timer_fn(unsigned long param)
 static void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return;
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
@@ -4781,8 +4819,8 @@ static int set_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev, unsigned int param)
 
 static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 {
-
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4812,6 +4850,7 @@ static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 static int get_tpl_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4846,6 +4885,7 @@ static int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4879,6 +4919,7 @@ static int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4906,6 +4947,7 @@ static int get_bypass_info_fn(struct bpctl_dev *pbpctl_dev, char *dev_name,
 static int get_dev_idx_bsf(int bus, int slot, int func)
 {
 	int idx_dev = 0;
+
 	for (idx_dev = 0;
 	     ((bpctl_dev_arr[idx_dev].pdev != NULL) && (idx_dev < device_num));
 	     idx_dev++) {
@@ -6427,6 +6469,7 @@ static int __init bypass_init_module(void)
 static void __exit bypass_cleanup_module(void)
 {
 	int i;
+
 	unregister_netdevice_notifier(&bp_notifier_block);
 
 	for (i = 0; i < device_num; i++) {
@@ -6738,6 +6781,7 @@ int get_bypass_slave_sd(int ifindex)
 {
 	struct bpctl_dev *pbpctl_dev_out;
 	int ret = get_bypass_slave_fn(get_dev_idx_p(ifindex), &pbpctl_dev_out);
+
 	if (ret == 1)
 		return pbpctl_dev_out->ifindex;
 	return -1;
@@ -6799,6 +6843,7 @@ static int procfs_add(char *proc_name, const struct file_operations *fops,
 		      struct bpctl_dev *dev)
 {
 	struct bypass_pfs_sd *pfs = &dev->bypass_pfs_set;
+
 	if (!proc_create_data(proc_name, 0644, pfs->bypass_entry, fops, dev))
 		return -1;
 	return 0;
@@ -6843,6 +6888,7 @@ static int show_bypass_slave(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	struct bpctl_dev *slave = get_status_port_fn(dev);
+
 	if (!slave)
 		slave = dev;
 	if (!slave)
@@ -6857,6 +6903,7 @@ static int show_bypass_caps(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_caps_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
 	else
@@ -6869,6 +6916,7 @@ static int show_wd_set_caps(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_set_caps_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
 	else
@@ -6905,6 +6953,7 @@ static ssize_t bypass_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -1;
 
@@ -6915,6 +6964,7 @@ static int show_bypass(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6929,6 +6979,7 @@ static ssize_t tap_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -1;
 
@@ -6939,6 +6990,7 @@ static int show_tap(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6953,6 +7005,7 @@ static ssize_t disc_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -1;
 
@@ -6963,6 +7016,7 @@ static int show_disc(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6977,6 +7031,7 @@ static int show_bypass_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -6991,6 +7046,7 @@ static int show_tap_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -7005,6 +7061,7 @@ static int show_disc_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -7021,6 +7078,7 @@ static ssize_t bypass_wd_write(struct file *file, const char __user *buffer,
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int timeout;
 	int ret = kstrtoint_from_user(buffer, count, 10, &timeout);
+
 	if (ret)
 		return ret;
 	set_bypass_wd_fn(dev, timeout);
@@ -7048,6 +7106,7 @@ static int show_wd_expire_time(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = 0, timeout = 0;
+
 	ret = get_wd_expire_time_fn(dev, &timeout);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7066,6 +7125,7 @@ static ssize_t tpl_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
 
@@ -7076,6 +7136,7 @@ static int show_tpl(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tpl_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7092,6 +7153,7 @@ static ssize_t wait_at_pwup_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
 
@@ -7102,6 +7164,7 @@ static int show_wait_at_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_wait_at_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7117,6 +7180,7 @@ static ssize_t hw_reset_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
 
@@ -7127,6 +7191,7 @@ static int show_hw_reset(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_hw_reset_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7143,6 +7208,7 @@ static int show_reset_bypass_wd(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = reset_bypass_wd_timer_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7157,6 +7223,7 @@ static ssize_t dis_bypass_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7167,6 +7234,7 @@ static int show_dis_bypass(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_bypass_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7181,6 +7249,7 @@ static ssize_t dis_tap_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7191,6 +7260,7 @@ static int show_dis_tap(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_tap_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7205,6 +7275,7 @@ static ssize_t dis_disc_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7215,6 +7286,7 @@ static int show_dis_disc(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_disc_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7229,6 +7301,7 @@ static ssize_t bypass_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7239,6 +7312,7 @@ static int show_bypass_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7253,6 +7327,7 @@ static ssize_t bypass_pwoff_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7263,6 +7338,7 @@ static int show_bypass_pwoff(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwoff_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7277,6 +7353,7 @@ static ssize_t tap_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7287,6 +7364,7 @@ static int show_tap_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7301,6 +7379,7 @@ static ssize_t disc_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7311,6 +7390,7 @@ static int show_disc_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7325,6 +7405,7 @@ static ssize_t std_nic_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7335,6 +7416,7 @@ static int show_std_nic(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_std_nic_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7377,6 +7459,7 @@ static int show_wd_exp_mode(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_exp_mode_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "tap\n");
 	else if (ret == 0)
@@ -7394,6 +7477,7 @@ static ssize_t wd_autoreset_write(struct file *file, const char __user *buffer,
 {
 	int timeout;
 	int ret = kstrtoint_from_user(buffer, count, 10, &timeout);
+
 	if (ret)
 		return ret;
 	set_wd_autoreset_fn(PDE_DATA(file_inode(file)), timeout);
@@ -7403,6 +7487,7 @@ static int show_wd_autoreset(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_autoreset_fn(dev);
+
 	if (ret >= 0)
 		seq_printf(m, "%d\n", ret);
 	else
@@ -7485,6 +7570,7 @@ static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block)
 {
 
 	struct bypass_pfs_sd *current_pfs = &pbp_device_block->bypass_pfs_set;
+
 	remove_proc_subtree(current_pfs->dir_name, bp_procfs_dir);
 	current_pfs->bypass_entry = NULL;
 	return 0;
diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index 09e00da..8f71e2d 100644
--- a/drivers/staging/silicom/bypasslib/bypass.c
+++ b/drivers/staging/silicom/bypasslib/bypass.c
@@ -135,6 +135,7 @@ static int doit(int cmd, int if_index, int *data)
 static int is_dev_sd(int if_index)
 {
 	int ret = 0;
+
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
 	return ret >= 0 ? 1 : 0;
 }
@@ -191,6 +192,7 @@ static int is_bypass_dev(int if_index)
 static int is_bypass(int if_index)
 {
 	int ret = 0;
+
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
 
 	if (ret < 0)
-- 
1.7.9.5

