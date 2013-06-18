Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab3FRDcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:32:43 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:49817 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3FRDcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:32:41 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 4/4] Staging: silicom: move more assignments out of if conditions
Date: Mon, 17 Jun 2013 22:32:05 -0500
Message-Id: <1371526325-9821-5-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371526325-9821-1-git-send-email-chad@dahc.us>
References: <1371526325-9821-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove more assignments from if-statement conditions in bpctl_mod.c,
resolving checkpatch.pl errors. Those that remain need more attention
than I'm presently prepared to give them.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 53 ++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 19a9239..91a6afd 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -4222,9 +4222,8 @@ void bypass_caps_init(bpctl_dev_t *pbpctl_dev)
 
 int bypass_off_init(bpctl_dev_t *pbpctl_dev)
 {
-	int ret = 0;
-
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	int ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	if (INTEL_IF_SERIES(pbpctl_dev->subdevice))
 		return dis_bypass_cap(pbpctl_dev);
@@ -4409,7 +4408,8 @@ int set_bypass_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 
 	if (!(pbpctl_dev->bp_caps & BP_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	if (!bypass_mode)
 		ret = bypass_off(pbpctl_dev);
@@ -4441,7 +4441,8 @@ int set_dis_bypass_fn(bpctl_dev_t *pbpctl_dev, int dis_param)
 
 	if (!(pbpctl_dev->bp_caps & BP_DIS_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	if (dis_param)
 		ret = dis_bypass_cap(pbpctl_dev);
@@ -4467,7 +4468,8 @@ int set_bypass_pwoff_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 
 	if (!(pbpctl_dev->bp_caps & BP_PWOFF_CTL_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	if (bypass_mode)
 		ret = bypass_state_pwroff(pbpctl_dev);
@@ -4493,7 +4495,8 @@ int set_bypass_pwup_fn(bpctl_dev_t *pbpctl_dev, int bypass_mode)
 
 	if (!(pbpctl_dev->bp_caps & BP_PWUP_CTL_CAP))
 		return BP_NOT_CAP;
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	if (bypass_mode)
 		ret = bypass_state_pwron(pbpctl_dev);
@@ -4520,7 +4523,8 @@ int set_bypass_wd_fn(bpctl_dev_t *pbpctl_dev, int timeout)
 	if (!(pbpctl_dev->bp_caps & WD_CTL_CAP))
 		return BP_NOT_CAP;
 
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	if (!timeout)
 		ret = wdt_off(pbpctl_dev);
@@ -4589,7 +4593,8 @@ int set_std_nic_fn(bpctl_dev_t *pbpctl_dev, int nic_mode)
 	if (!(pbpctl_dev->bp_caps & STD_NIC_CAP))
 		return BP_NOT_CAP;
 
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	if (nic_mode)
 		ret = std_nic_on(pbpctl_dev);
@@ -4655,7 +4660,8 @@ int get_tap_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	if ((ret = default_pwron_tap_status(pbpctl_dev)) < 0)
+	ret = default_pwron_tap_status(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	return ((ret == 0) ? 1 : 0);
 }
@@ -4830,7 +4836,8 @@ int get_disc_port_pwup_fn(bpctl_dev_t *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	if ((ret = default_pwron_disc_port_status(pbpctl_dev)) < 0)
+	ret = default_pwron_disc_port_status(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	return ((ret == 0) ? 1 : 0);
 }
@@ -4857,7 +4864,8 @@ int reset_cont_fn(bpctl_dev_t *pbpctl_dev)
 	if (!pbpctl_dev)
 		return -1;
 
-	if ((ret = cmnd_on(pbpctl_dev)) < 0)
+	ret = cmnd_on(pbpctl_dev);
+	if (ret < 0)
 		return ret;
 	return reset_cont(pbpctl_dev);
 }
@@ -4873,8 +4881,10 @@ int set_tx_fn(bpctl_dev_t *pbpctl_dev, int tx_state)
 	    (pbpctl_dev->bp_caps & SW_CTL_CAP)) {
 		if ((pbpctl_dev->bp_tpl_flag))
 			return BP_NOT_CAP;
-	} else if ((pbpctl_dev_b = get_master_port_fn(pbpctl_dev))) {
-		if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
+	} else {
+		pbpctl_dev_b = get_master_port_fn(pbpctl_dev);
+		if (pbpctl_dev_b &&
+		    (pbpctl_dev_b->bp_caps & TPL_CAP) &&
 		    (pbpctl_dev_b->bp_tpl_flag))
 			return BP_NOT_CAP;
 	}
@@ -4990,8 +5000,10 @@ int get_tx_fn(bpctl_dev_t *pbpctl_dev)
 	    (pbpctl_dev->bp_caps & SW_CTL_CAP)) {
 		if ((pbpctl_dev->bp_tpl_flag))
 			return BP_NOT_CAP;
-	} else if ((pbpctl_dev_b = get_master_port_fn(pbpctl_dev))) {
-		if ((pbpctl_dev_b->bp_caps & TPL_CAP) &&
+	} else {
+		pbpctl_dev_b = get_master_port_fn(pbpctl_dev);
+		if (pbpctl_dev_b &&
+		    (pbpctl_dev_b->bp_caps & TPL_CAP) &&
 		    (pbpctl_dev_b->bp_tpl_flag))
 			return BP_NOT_CAP;
 	}
@@ -5030,7 +5042,8 @@ static void bp_tpl_timer_fn(unsigned long param)
 	uint32_t link1, link2;
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+	if (!pbpctl_dev_b)
 		return;
 
 	if (!pbpctl_dev->bp_tpl_flag) {
@@ -5130,7 +5143,8 @@ int set_tpl_fn(bpctl_dev_t *pbpctl_dev, int tpl_mode)
 
 	if (pbpctl_dev->bp_caps & TPL_CAP) {
 		if (tpl_mode) {
-			if ((pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+			pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+			if (pbpctl_dev_b)
 				set_tx(pbpctl_dev_b, 1);
 			set_tx(pbpctl_dev, 1);
 		}
@@ -6710,7 +6724,8 @@ static int init_one(bpctl_dev_t *dev, bpmod_info_t *info, struct pci_dev *pdev1)
 			reset_cont(dev);
 	}
 #ifdef BP_SELF_TEST
-	if ((dev->bp_tx_data = kzalloc(BPTEST_DATA_LEN, GFP_KERNEL))) {
+	dev->bp_tx_data = kzalloc(BPTEST_DATA_LEN, GFP_KERNEL);
+	if (dev->bp_tx_data) {
 		memset(dev->bp_tx_data, 0xff, 6);
 		memset(dev->bp_tx_data + 6, 0x0, 1);
 		memset(dev->bp_tx_data + 7, 0xaa, 5);
-- 
1.8.1.4

