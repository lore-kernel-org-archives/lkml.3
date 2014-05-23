Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaEWVrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:47:23 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39740 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEWVrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:47:22 -0400
From: Chaitanya Hazarey <c@24.io>
To: gregkh@linuxfoundation.org, chad@dahc.us,
        michael.banken@mathe.stud.uni-erlangen.de, lorenz@badgers.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Chaitanya Hazarey <c@24.io>
Subject: [PATCH] Staging: Silicom: bpctl_mod.c: Fixed a lot of checkpatch.pl warnings
Date: Fri, 23 May 2014 14:47:10 -0700
Message-Id: <1400881630-23997-1-git-send-email-c@24.io>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a blank line after declarations in many places to fix the following warning issued by checkpatch.pl:

WARNING: Missing a blank line after declarations
---
 drivers/staging/silicom/bpctl_mod.c |   90 ++++++++++++++++++++++++++++++++++-
 1 file changed, 88 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 7f3d884..f0c6831 100644
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
@@ -2270,6 +2279,7 @@ static int set_tx(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
 	int ret = 0, ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_m;
+
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -2802,6 +2812,7 @@ int wdt_time_left(struct bpctl_dev *pbpctl_dev)
 static int wdt_timer(struct bpctl_dev *pbpctl_dev, int *time_left)
 {
 	int ret = 0;
+
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		{
 			if (pbpctl_dev->wdt_status == WDT_STATUS_UNKNOWN)
@@ -3014,6 +3025,7 @@ static int tx_status(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t ctrl = 0;
 	struct bpctl_dev *pbpctl_dev_m;
+
 	if ((is_bypass_fn(pbpctl_dev)) == 1)
 		pbpctl_dev_m = pbpctl_dev;
 	else
@@ -3195,6 +3207,7 @@ static int bypass_change_status(struct bpctl_dev *pbpctl_dev)
 static int bypass_status(struct bpctl_dev *pbpctl_dev)
 {
 	u32 ctrl_ext = 0;
+
 	if (pbpctl_dev->bp_caps & BP_CAP) {
 		struct bpctl_dev *pbpctl_dev_b = NULL;
@@ -3323,6 +3336,7 @@ static int dis_bypass_cap_status(struct bpctl_dev *pbpctl_dev)
 static int wdt_programmed(struct bpctl_dev *pbpctl_dev, int *timeout)
 {
 	int ret = 0;
+
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER) {
 			if ((read_reg(pbpctl_dev, STATUS_REG_ADDR)) &
@@ -3386,6 +3400,7 @@ static int tap_flag_status(struct bpctl_dev *pbpctl_dev)
 static int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
+
 	if (pbpctl_dev->bp_caps & TAP_STATUS_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
 			status_reg = read_reg(pbpctl_dev, STATUS_TAP_REG_ADDR);
@@ -3400,6 +3415,7 @@ static int tap_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 static int tap_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (pbpctl_dev->bp_ext_ver >= PXG2TBPI_VER) {
 		if (pbpctl_dev->bp_caps & TAP_CAP) {
 			if (pbpctl_dev->bp_caps & BP_CAP) {
@@ -3490,6 +3506,7 @@ static int disc_flag_status(struct bpctl_dev *pbpctl_dev)
 static int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 {
 	uint32_t status_reg = 0;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
 			status_reg = read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR);
@@ -3504,6 +3521,7 @@ static int disc_flag_status_clear(struct bpctl_dev *pbpctl_dev)
 static int disc_change_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		ret = disc_flag_status(pbpctl_dev);
 		disc_flag_status_clear(pbpctl_dev);
@@ -3599,6 +3617,7 @@ static int disc_off_status(struct bpctl_dev *pbpctl_dev)
 static int disc_status(struct bpctl_dev *pbpctl_dev)
 {
 	int ctrl = 0;
+
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
 		ctrl = disc_off_status(pbpctl_dev);
 		if (ctrl < 0)
@@ -3744,6 +3763,7 @@ static void bypass_caps_init(struct bpctl_dev *pbpctl_dev)
 #ifdef BYPASS_DEBUG
 	int ret = 0;
+
 	if (!(INTEL_IF_SERIES(adapter->bp_device_block.subdevice))) {
 		ret = read_reg(pbpctl_dev, VER_REG_ADDR);
 		printk("VER_REG reg1=%x\n", ret);
@@ -4155,6 +4175,7 @@ static int get_bypass_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_bypass_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4182,6 +4203,7 @@ static int get_dis_bypass_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4209,6 +4231,7 @@ static int get_bypass_pwoff_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev, int bypass_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4236,6 +4259,7 @@ static int get_bypass_pwup_fn(struct bpctl_dev *pbpctl_dev)
 static int set_bypass_wd_fn(struct bpctl_dev *pbpctl_dev, int timeout)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4282,8 +4306,8 @@ static int reset_bypass_wd_timer_fn(struct bpctl_dev *pbpctl_dev)
 static int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int bp_status = 0;
-
 	unsigned int step_value = TIMEOUT_MAX_STEP + 1, bit_cnt = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4306,6 +4330,7 @@ static int get_wd_set_caps_fn(struct bpctl_dev *pbpctl_dev)
 static int set_std_nic_fn(struct bpctl_dev *pbpctl_dev, int nic_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4358,6 +4383,7 @@ static int get_tap_fn(struct bpctl_dev *pbpctl_dev)
 static int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4376,6 +4402,7 @@ static int set_tap_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_tap_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4396,6 +4423,7 @@ static int get_tap_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_tap_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4438,6 +4466,7 @@ static int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4449,6 +4478,7 @@ static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4467,6 +4497,7 @@ static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4477,6 +4508,7 @@ static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4487,6 +4519,7 @@ static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4505,6 +4538,7 @@ static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 static int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4533,6 +4567,7 @@ static int set_tx_fn(struct bpctl_dev *pbpctl_dev, int tx_state)
 {
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
@@ -4736,6 +4773,7 @@ static void bp_tpl_timer_fn(unsigned long param)
 static void remove_bypass_tpl_auto(struct bpctl_dev *pbpctl_dev)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return;
 	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
@@ -4786,6 +4824,7 @@ static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 {
 	struct bpctl_dev *pbpctl_dev_b = NULL;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4815,6 +4854,7 @@ static int set_tpl_fn(struct bpctl_dev *pbpctl_dev, int tpl_mode)
 static int get_tpl_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = BP_NOT_CAP;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4849,6 +4889,7 @@ static int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4882,6 +4923,7 @@ static int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 static int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
 {
 	int ret = 0;
+
 	if (!pbpctl_dev)
 		return -1;
@@ -4909,6 +4951,7 @@ static int get_bypass_info_fn(struct bpctl_dev *pbpctl_dev, char *dev_name,
 static int get_dev_idx_bsf(int bus, int slot, int func)
 {
 	int idx_dev = 0;
+
 	for (idx_dev = 0;
 	     ((bpctl_dev_arr[idx_dev].pdev != NULL) && (idx_dev < device_num));
 	     idx_dev++) {
@@ -6411,6 +6454,7 @@ static int __init bypass_init_module(void)
 static void __exit bypass_cleanup_module(void)
 {
 	int i;
+
 	unregister_netdevice_notifier(&bp_notifier_block);
 	for (i = 0; i < device_num; i++) {
@@ -6715,6 +6759,7 @@ int get_bypass_slave_sd(int ifindex)
 {
 	struct bpctl_dev *pbpctl_dev_out;
 	int ret = get_bypass_slave_fn(get_dev_idx_p(ifindex), &pbpctl_dev_out);
+
 	if (ret == 1)
 		return pbpctl_dev_out->ifindex;
 	return -1;
@@ -6764,6 +6809,7 @@ static int procfs_add(char *proc_name, const struct file_operations *fops,
 		      struct bpctl_dev *dev)
 {
 	struct bypass_pfs_sd *pfs = &dev->bypass_pfs_set;
+
 	if (!proc_create_data(proc_name, 0644, pfs->bypass_entry, fops, dev))
 		return -1;
 	return 0;
@@ -6808,6 +6854,7 @@ static int show_bypass_slave(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	struct bpctl_dev *slave = get_status_port_fn(dev);
+
 	if (!slave)
 		slave = dev;
 	if (!slave)
@@ -6822,6 +6869,7 @@ static int show_bypass_caps(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_caps_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
 	else
@@ -6834,6 +6882,7 @@ static int show_wd_set_caps(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_set_caps_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "-1\n");
 	else
@@ -6870,6 +6919,7 @@ static ssize_t bypass_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -1;
@@ -6880,6 +6930,7 @@ static int show_bypass(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6894,6 +6945,7 @@ static ssize_t tap_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -1;
@@ -6904,6 +6956,7 @@ static int show_tap(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6918,6 +6971,7 @@ static ssize_t disc_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -1;
@@ -6928,6 +6982,7 @@ static int show_disc(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -6942,6 +6997,7 @@ static int show_bypass_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -6956,6 +7012,7 @@ static int show_tap_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -6970,6 +7027,7 @@ static int show_disc_change(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_change_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "on\n");
 	else if (ret == 0)
@@ -6986,6 +7044,7 @@ static ssize_t bypass_wd_write(struct file *file, const char __user *buffer,
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int timeout;
 	int ret = kstrtoint_from_user(buffer, count, 10, &timeout);
+
 	if (ret)
 		return ret;
 	set_bypass_wd_fn(dev, timeout);
@@ -7013,6 +7072,7 @@ static int show_wd_expire_time(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = 0, timeout = 0;
+
 	ret = get_wd_expire_time_fn(dev, &timeout);
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
@@ -7031,6 +7091,7 @@ static ssize_t tpl_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
@@ -7041,6 +7102,7 @@ static int show_tpl(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tpl_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7057,6 +7119,7 @@ static ssize_t wait_at_pwup_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
@@ -7067,6 +7130,7 @@ static int show_wait_at_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_wait_at_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7082,6 +7146,7 @@ static ssize_t hw_reset_write(struct file *file, const char __user *buffer,
 {
 	struct bpctl_dev *dev = PDE_DATA(file_inode(file));
 	int tpl_param = user_on_off(buffer, count);
+
 	if (tpl_param < 0)
 		return -1;
@@ -7092,6 +7157,7 @@ static int show_hw_reset(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bp_hw_reset_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 1)
@@ -7108,6 +7174,7 @@ static int show_reset_bypass_wd(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = reset_bypass_wd_timer_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7122,6 +7189,7 @@ static ssize_t dis_bypass_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
@@ -7132,6 +7200,7 @@ static int show_dis_bypass(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_bypass_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7146,6 +7215,7 @@ static ssize_t dis_tap_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
@@ -7156,6 +7226,7 @@ static int show_dis_tap(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_tap_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7170,6 +7241,7 @@ static ssize_t dis_disc_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
@@ -7180,6 +7252,7 @@ static int show_dis_disc(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_dis_disc_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7194,6 +7267,7 @@ static ssize_t bypass_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
@@ -7204,6 +7278,7 @@ static int show_bypass_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7218,6 +7293,7 @@ static ssize_t bypass_pwoff_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
@@ -7228,6 +7304,7 @@ static int show_bypass_pwoff(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_bypass_pwoff_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7242,6 +7319,7 @@ static ssize_t tap_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
@@ -7252,6 +7330,7 @@ static int show_tap_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_tap_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7266,6 +7345,7 @@ static ssize_t disc_pwup_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int tap_param = user_on_off(buffer, count);
+
 	if (tap_param < 0)
 		return -EINVAL;
@@ -7276,6 +7356,7 @@ static int show_disc_pwup(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_disc_pwup_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7290,6 +7371,7 @@ static ssize_t std_nic_write(struct file *file, const char __user *buffer,
 				  size_t count, loff_t *pos)
 {
 	int bypass_param = user_on_off(buffer, count);
+
 	if (bypass_param < 0)
 		return -EINVAL;
@@ -7300,6 +7382,7 @@ static int show_std_nic(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_std_nic_fn(dev);
+
 	if (ret == BP_NOT_CAP)
 		seq_puts(m, "fail\n");
 	else if (ret == 0)
@@ -7342,6 +7425,7 @@ static int show_wd_exp_mode(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_exp_mode_fn(dev);
+
 	if (ret == 1)
 		seq_puts(m, "tap\n");
 	else if (ret == 0)
@@ -7359,6 +7443,7 @@ static ssize_t wd_autoreset_write(struct file *file, const char __user *buffer,
 {
 	int timeout;
 	int ret = kstrtoint_from_user(buffer, count, 10, &timeout);
+
 	if (ret)
 		return ret;
 	set_wd_autoreset_fn(PDE_DATA(file_inode(file)), timeout);
@@ -7368,6 +7453,7 @@ static int show_wd_autoreset(struct seq_file *m, void *v)
 {
 	struct bpctl_dev *dev = m->private;
 	int ret = get_wd_autoreset_fn(dev);
+
 	if (ret >= 0)
 		seq_printf(m, "%d\n", ret);
 	else
@@ -7448,8 +7534,8 @@ static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block)
 static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block)
 {
-
 	struct bypass_pfs_sd *current_pfs = &pbp_device_block->bypass_pfs_set;
+
 	remove_proc_subtree(current_pfs->dir_name, bp_procfs_dir);
 	current_pfs->bypass_entry = NULL;
 	return 0;
--
1.7.9.5

