Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751685AbaEZE6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:58:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62806 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaEZE6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:58:43 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, chad@dahc.us,
        michael.banken@mathe.stud.uni-erlangen.de, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, c@24.io
Subject: [PATCH] Staging: Silicom: bpctl_mod.c & bypass.c: Adding blank lines
Date: Sun, 25 May 2014 21:58:43 -0700
Message-Id: <1401080323-11767-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declarations in many places to fix
the following warning issued by checkpatch.pl:

WARNING: Missing a blank line after declarations

Signed-off-by: Chaitanya Hazarey <c@24.io>
---
 drivers/staging/silicom/bpctl_mod.c        |   88 +++++++++++++++++++++++++++-
 drivers/staging/silicom/bypasslib/bypass.c |    2 +
 2 files changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index e361cde..22bf4bf 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -752,6 +752,7 @@ static void write_reg(struct bpctl_dev *pbpctl_dev, unsigned char value,
 	uint32_t ctrl_ext = 0, ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_c = NULL;
 	unsigned long flags;
+
 	if (pbpctl_dev->bp_10g9) {
 		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
 		if (!pbpctl_dev_c)
@@ -927,6 +928,7 @@ static int read_reg(struct bpctl_dev *pbpctl_dev, unsigned char addr)
 
 #ifdef BP_SYNC_FLAG
 	unsigned long flags;
+
 	spin_lock_irqsave(&pbpctl_dev->bypass_wr_lock, flags);
 #else
 	atomic_set(&pbpctl_dev->wdt_busy, 1);
@@ -1563,6 +1565,7 @@ int pulse_set_fn(struct bpctl_dev *pbpctl_dev, unsigned int counter)
 int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -1588,6 +1591,7 @@ int zero_set_fn(struct bpctl_dev *pbpctl_dev)
 int pulse_get2_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -1603,6 +1607,7 @@ int pulse_get2_fn(struct bpctl_dev *pbpctl_dev)
 int pulse_get1_fn(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl_ext = 0, ctrl_value = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -1666,6 +1671,7 @@ static struct bpctl_dev *lookup_port(struct bpctl_dev *dev)
 {
 	struct bpctl_dev *p;
 	int n;
+
 	for (n = 0, p = bpctl_dev_arr; n < device_num && p->pdev; n++) {
 		if (p->bus == dev->bus
 		    && p->slot == dev->slot
@@ -1843,6 +1849,7 @@ static int bypass_off(struct bpctl_dev *pbpctl_dev)
 static int tap_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
 	    && (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)) {
 		write_data(pbpctl_dev, TAP_OFF);
@@ -1856,6 +1863,7 @@ static int tap_off(struct bpctl_dev *pbpctl_dev)
 static int tap_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if ((pbpctl_dev->bp_caps & TAP_CAP)
 	    && (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER)) {
 		write_data(pbpctl_dev, TAP_ON);
@@ -1869,6 +1877,7 @@ static int tap_on(struct bpctl_dev *pbpctl_dev)
 static int disc_off(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
 		write_data(pbpctl_dev, DISC_OFF);
 		msec_delay_bp(LATCH_DELAY);
@@ -1881,6 +1890,7 @@ static int disc_off(struct bpctl_dev *pbpctl_dev)
 static int disc_on(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if ((pbpctl_dev->bp_caps & DISC_CAP) && (pbpctl_dev->bp_ext_ver >= 0x8)) {
 		write_data(pbpctl_dev, /*DISC_ON */ 0x85);
 		msec_delay_bp(LATCH_DELAY);
@@ -2270,6 +2280,7 @@ static int set_tx(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
 	int ret = 0, ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_m;
+
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -2802,6 +2813,7 @@ int wdt_time_left(struct bpctl_dev *pbpctl_dev)
 static int wdt_timer(struct bpctl_dev *pbpctl_dev, int *time_left)
 {
 	int ret = 0;
+
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		{
 			if (pbpctl_dev->wdt_status == WDT_STATUS_UNKNOWN)
@@ -3014,6 +3026,7 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_m;
+
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -3195,6 +3208,7 @@ static int bypass_change_status(struct bpctl_dev *pbpctl_dev)
 static int bypass_status(struct bpctl_dev *pbpctl_dev)
 {
 	u32 ctrl_ext = 0;
+
 	if (pbpctl_dev->bp_caps & BP_CAP) {
 
 		struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -3323,6 +3337,7 @@ static int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
 static int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
 {
 	int ret = 0;
+
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
 			if ((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
@@ -3386,6 +3401,7 @@ static int tap_flag_status(struct bpctl_dev *pbpctl_dev)
 static int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
+
 	if (pbpctl_dev->bp_caps & TAP_STATUS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
 			status_reg = read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR);
@@ -3400,6 +3416,7 @@ static int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 static int tap_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
 		if (pbpctl_dev->bp_caps & TAP_CAP) {
 			if (pbpctl_dev->bp_caps & BP_CAP) {
@@ -3490,6 +3507,7 @@ static int disc_flag_status(struct bpctl_dev *pbpctl_dev)
 static int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
 			status_reg = read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR);
@@ -3504,6 +3522,7 @@ static int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 static int disc_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		ret = disc_flag_status(pbpctl_dev);
 		disc_flag_status_clear(pbpctl_dev);
@@ -3599,6 +3618,7 @@ static int disc_off_status(struct bpctl_dev *pbpctl_dev)
 static int disc_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ctrl = 0;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		ctrl = disc_off_status(pbpctl_dev);
 		if (ctrl < 0)
@@ -3744,6 +3764,7 @@ static void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 
 #ifdef BYPASS_DEBUG
 	int ret = 0;
+
 	if (!(INTEL_IF_SERIES(adapter->bp_device_block.subdevice))) {
 		ret = read_reg(pbpctl_dev, VER_REG_ADDR);
 		printk("VER_REG reg1=%x\n", ret);
@@ -4155,6 +4176,7 @@ static int get_bypass_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_bypass_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4182,6 +4204,7 @@ static int get_dis_bypass_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4209,6 +4232,7 @@ static int get_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4236,6 +4260,7 @@ static int get_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int timeout)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4282,8 +4307,8 @@ static int reset_bypass_wd_timer_fn(struct bpctl_dev *pbpctl_dev)
 static int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int bp_status = 0;
-
 	unsigned int step_value = TIMEOUT_MAX_STEP + 1, bit_cnt = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4306,6 +4331,7 @@ static int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 static int set_std_nic_fn(struct bpctl_dev *pbpctl_dev, int nic_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4358,6 +4384,7 @@ static int get_tap_fn(struct bpctl_dev *pbpctl_dev)
 static int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4376,6 +4403,7 @@ static int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4396,6 +4424,7 @@ static int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4438,6 +4467,7 @@ static int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4449,6 +4479,7 @@ static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4467,6 +4498,7 @@ static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4477,6 +4509,7 @@ static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4487,6 +4520,7 @@ static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4505,6 +4539,7 @@ static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 static int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4531,8 +4566,8 @@ static int set_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev, int param)
 
 static int set_tx_fn(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
-
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4610,6 +4645,7 @@ static int get_bypass_slave_fn(struct bpctl_dev *pbpctl_dev,
 			       struct bpctl_dev **pbpctl_dev_out)
 {
 	int idx_dev = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4653,6 +4689,7 @@ static int is_bypass(struct bpctl_dev *pbpctl_dev)
 static int get_tx_fn(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4812,6 +4849,7 @@ static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 static int get_tpl_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4846,6 +4884,7 @@ static int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4879,6 +4918,7 @@ static int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
 
@@ -4906,6 +4946,7 @@ static int get_bypass_info_fn(struct bpctl_dev *pbpctl_dev, char *dev_name,
 static int get_dev_idx_bsf(int bus, int slot, int func)
 {
 	int idx_dev = 0;
+
 	for (idx_dev = 0;
 	     ((bpctl_dev_arr[idx_dev].pdev != NULL) && (idx_dev < device_num));
 	     idx_dev++) {
@@ -6401,6 +6442,7 @@ static int __init bypass_init_module(void)
 static void __exit bypass_cleanup_module(void)
 {
 	int i;
+
 	unregister_netdevice_notifier(&bp_notifier_block);
 
 	for (i = 0; i < device_num; i++) {
@@ -6705,6 +6747,7 @@ int get_bypass_slave_sd(int ifindex)
 {
 	struct bpctl_dev *pbpctl_dev_out;
 	int ret = get_bypass_slave_fn(get_dev_idx_p(ifindex), &pbpctl_dev_out);
+
 	if (ret == 1)
 		return pbpctl_dev_out->ifindex;
 	return -1;
@@ -6754,6 +6797,7 @@ static int procfs_add(char *proc_name, const struct file_operations *fops,
 		      struct bpctl_dev *dev)
 {
 	struct bypass_pfs_sd *pfs = &dev->bypass_pfs_set;
+
 	if (!proc_create_data(proc_name, 0644, pfs->bypass_entry, fops, dev))
 		return -1;
 	return 0;
@@ -6798,6 +6842,7 @@ static int show_bypass_slave(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	struct bpctl_dev *slave = get_status_port_fn(dev);
+
 	if (!slave)
 		slave = dev;
 	if (!slave)
@@ -6812,6 +6857,7 @@ static int show_bypass_caps(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_caps_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
 	else
@@ -6824,6 +6870,7 @@ static int show_wd_set_caps(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_set_caps_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
 	else
@@ -6860,6 +6907,7 @@ static ssize_t bypass_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -1;
 
@@ -6870,6 +6918,7 @@ static int show_bypass(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6884,6 +6933,7 @@ static ssize_t tap_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -1;
 
@@ -6894,6 +6944,7 @@ static int show_tap(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6908,6 +6959,7 @@ static ssize_t disc_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -1;
 
@@ -6918,6 +6970,7 @@ static int show_disc(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6932,6 +6985,7 @@ static int show_bypass_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -6946,6 +7000,7 @@ static int show_tap_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -6960,6 +7015,7 @@ static int show_disc_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -6976,6 +7032,7 @@ static ssize_t bypass_wd_write(struct file *file, const char __user *buffer,
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int timeout;
 	int ret = kstrtoint_from_user(buffer, count, 10, &timeout);
+
 	if (ret)
 		return ret;
 	set_bypass_wd_fn(dev, timeout);
@@ -7003,6 +7060,7 @@ static int show_wd_expire_time(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = 0, timeout = 0;
+
 	ret = get_wd_expire_time_fn(dev, &timeout);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7021,6 +7079,7 @@ static ssize_t tpl_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
 
@@ -7031,6 +7090,7 @@ static int show_tpl(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tpl_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7047,6 +7107,7 @@ static ssize_t wait_at_pwup_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
 
@@ -7057,6 +7118,7 @@ static int show_wait_at_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_wait_at_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7072,6 +7134,7 @@ static ssize_t hw_reset_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
 
@@ -7082,6 +7145,7 @@ static int show_hw_reset(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_hw_reset_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7098,6 +7162,7 @@ static int show_reset_bypass_wd(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = reset_bypass_wd_timer_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7112,6 +7177,7 @@ static ssize_t dis_bypass_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7122,6 +7188,7 @@ static int show_dis_bypass(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_bypass_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7136,6 +7203,7 @@ static ssize_t dis_tap_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7146,6 +7214,7 @@ static int show_dis_tap(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_tap_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7160,6 +7229,7 @@ static ssize_t dis_disc_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7170,6 +7240,7 @@ static int show_dis_disc(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_disc_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7184,6 +7255,7 @@ static ssize_t bypass_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7194,6 +7266,7 @@ static int show_bypass_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7208,6 +7281,7 @@ static ssize_t bypass_pwoff_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7218,6 +7292,7 @@ static int show_bypass_pwoff(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwoff_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7232,6 +7307,7 @@ static ssize_t tap_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7242,6 +7318,7 @@ static int show_tap_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7256,6 +7333,7 @@ static ssize_t disc_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
 
@@ -7266,6 +7344,7 @@ static int show_disc_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7280,6 +7359,7 @@ static ssize_t std_nic_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
 
@@ -7290,6 +7370,7 @@ static int show_std_nic(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_std_nic_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7332,6 +7413,7 @@ static int show_wd_exp_mode(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_exp_mode_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "tap\n");
 	else if (ret == 0)
@@ -7349,6 +7431,7 @@ static ssize_t wd_autoreset_write(struct file *file, const char __user *buffer,
 {
 	int timeout;
 	int ret = kstrtoint_from_user(buffer, count, 10, &timeout);
+
 	if (ret)
 		return ret;
 	set_wd_autoreset_fn(PDE_DATA(file_inode(file)), timeout);
@@ -7358,6 +7441,7 @@ static int show_wd_autoreset(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_autoreset_fn(dev);
+
 	if (ret >= 0)
 		seq_printf(m, "%d\n", ret);
 	else
diff --git a/drivers/staging/silicom/bypasslib/bypass.c b/drivers/staging/silicom/bypasslib/bypass.c
index a58251f..8e714a8 100644
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
@@ -186,6 +187,7 @@ static int is_bypass_dev(int if_index)
 static int is_bypass(int if_index)
 {
 	int ret = 0;
+
 	SET_BPLIB_INT_FN(is_bypass, int, if_index, ret);
 
 	if (ret < 0)
-- 
1.7.9.5

