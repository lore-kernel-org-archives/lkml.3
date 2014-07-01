Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaGAMeK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:34:10 -0400
Received: from smtpdg2.aruba.it ([62.149.158.232]:46900 "EHLO smtpdg6.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752717AbaGAMeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:34:08 -0400
From: Davide Gianforte <davide@gengisdave.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 2/2] staging: silicom: function return fixes
Date: Tue, 01 Jul 2014 14:33:43 +0200
Message-ID: <1488578.ritUTSl26I@mayhem>
User-Agent: KMail/4.13.2 (Linux/3.15.3; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1972083.WZLDx2N35Z@mayhem>
References: <1972083.WZLDx2N35Z@mayhem>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function return fixes

Some functions don't need a temporary variable to store return value.

Where functions always return 0, changed into void functions.

Signed-off-by: Davide Gianforte <davide@gengisdave.org>
--

 drivers/staging/silicom/bpctl_mod.c | 62 ++++++++++---------------------------
 1 file changed, 16 insertions(+), 46 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 1322437..c9a4c40 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -117,7 +117,7 @@ static struct bpctl_dev *get_status_port_fn(struct bpctl_dev *pbpctl_dev);
 static void if_scan_init(void);
 
 static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
-static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
+static void bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
 
 static int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
 static int get_dev_idx_bsf(int bus, int slot, int func);
@@ -1458,9 +1458,8 @@ static int send_wdt_pulse(struct bpctl_dev *pbpctl_dev)
 static void send_bypass_clear_pulse(struct bpctl_dev *pbpctl_dev,
 				    unsigned int value)
 {
-	uint32_t ctrl_ext = 0;
+	uint32_t ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |	/* 0 */
 						   BPCTLI_CTRL_EXT_SDP6_DIR) &
 						  ~BPCTLI_CTRL_EXT_SDP6_DATA));
@@ -1566,48 +1565,40 @@ int pulse_get1_fn(struct bpctl_dev *pbpctl_dev)
 	return ctrl_value;
 }
 
-int gpio6_set_fn(struct bpctl_dev *pbpctl_dev)
+void gpio6_set_fn(struct bpctl_dev *pbpctl_dev)
 {
-	uint32_t ctrl_ext = 0;
+	uint32_t ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ctrl_ext |
 			   BPCTLI_CTRL_EXT_SDP6_DIR |
 			   BPCTLI_CTRL_EXT_SDP6_DATA);
-	return 0;
 }
 
-int gpio7_set_fn(struct bpctl_dev *pbpctl_dev)
+void gpio7_set_fn(struct bpctl_dev *pbpctl_dev)
 {
-	uint32_t ctrl_ext = 0;
+	uint32_t ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ctrl_ext |
 			   BPCTLI_CTRL_EXT_SDP7_DIR |
 			   BPCTLI_CTRL_EXT_SDP7_DATA);
-	return 0;
 }
 
-int gpio7_clear_fn(struct bpctl_dev *pbpctl_dev)
+void gpio7_clear_fn(struct bpctl_dev *pbpctl_dev)
 {
-	uint32_t ctrl_ext = 0;
+	uint32_t ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
 						   BPCTLI_CTRL_EXT_SDP7_DIR) &
 						  ~BPCTLI_CTRL_EXT_SDP7_DATA));
-	return 0;
 }
 
-int gpio6_clear_fn(struct bpctl_dev *pbpctl_dev)
+void gpio6_clear_fn(struct bpctl_dev *pbpctl_dev)
 {
-	uint32_t ctrl_ext = 0;
+	uint32_t ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 
-	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 	BPCTL_BP_WRITE_REG(pbpctl_dev, CTRL_EXT, ((ctrl_ext |
 						   BPCTLI_CTRL_EXT_SDP6_DIR) &
 						  ~BPCTLI_CTRL_EXT_SDP6_DATA));
-	return 0;
 }
 #endif				/*BYPASS_DEBUG */
 
@@ -4428,14 +4419,10 @@ static int set_disc_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
 
 static int get_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
-	int ret = 0;
-
 	if (!pbpctl_dev)
 		return -1;
 
-	ret = disc_status(pbpctl_dev);
-
-	return ret;
+	return disc_status(pbpctl_dev);
 }
 
 static int set_disc_pwup_fn(struct bpctl_dev *pbpctl_dev, int disc_mode)
@@ -4470,13 +4457,10 @@ static int get_disc_pwup_fn(struct bpctl_dev *pbpctl_dev)
 
 static int get_disc_change_fn(struct bpctl_dev *pbpctl_dev)
 {
-	int ret = 0;
-
 	if (!pbpctl_dev)
 		return -1;
 
-	ret = disc_change_status(pbpctl_dev);
-	return ret;
+	return disc_change_status(pbpctl_dev);
 }
 
 static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
@@ -4500,14 +4484,10 @@ static int set_dis_disc_fn(struct bpctl_dev *pbpctl_dev, int dis_param)
 
 static int get_dis_disc_fn(struct bpctl_dev *pbpctl_dev)
 {
-	int ret = 0;
-
 	if (!pbpctl_dev)
 		return -1;
 
-	ret = dis_disc_cap_status(pbpctl_dev);
-
-	return ret;
+	return dis_disc_cap_status(pbpctl_dev);
 }
 
 static int get_wd_exp_mode_fn(struct bpctl_dev *pbpctl_dev)
@@ -4846,16 +4826,12 @@ static int set_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 
 static int get_bp_wait_at_pwup_fn(struct bpctl_dev *pbpctl_dev)
 {
-	int ret = 0;
-
 	if (!pbpctl_dev)
 		return -1;
 
 	/* bp_lock(pbp_device_block); */
-	ret = bp_wait_at_pwup_status(pbpctl_dev);
+	return bp_wait_at_pwup_status(pbpctl_dev);
 	/* bp_unlock(pbp_device_block); */
-
-	return ret;
 }
 
 static int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
@@ -4880,20 +4856,15 @@ static int set_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev, int tap_mode)
 
 static int get_bp_hw_reset_fn(struct bpctl_dev *pbpctl_dev)
 {
-	int ret = 0;
-
 	if (!pbpctl_dev)
 		return -1;
 
 	/* bp_lock(pbp_device_block); */
-	ret = bp_hw_reset_status(pbpctl_dev);
+	return bp_hw_reset_status(pbpctl_dev);
 
 	/* bp_unlock(pbp_device_block); */
-
-	return ret;
 }
 
-
 static int get_bypass_info_fn(struct bpctl_dev *pbpctl_dev, char *dev_name,
 		       char *add_param)
 {
@@ -7486,11 +7457,10 @@ static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block)
 	return ret;
 }
 
-static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block)
+static void bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block)
 {
 	struct bypass_pfs_sd *current_pfs = &pbp_device_block->bypass_pfs_set;
 
 	remove_proc_subtree(current_pfs->dir_name, bp_procfs_dir);
 	current_pfs->bypass_entry = NULL;
-	return 0;
 }
