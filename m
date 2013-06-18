Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3FRDcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:32:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55307 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3FRDca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:32:30 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 1/4] Staging: silicom: remove unnecessary braces in bpctl_mod.c
Date: Mon, 17 Jun 2013 22:32:02 -0500
Message-Id: <1371526325-9821-2-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371526325-9821-1-git-send-email-chad@dahc.us>
References: <1371526325-9821-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary braces in bpctl_mod.c, resolving checkpatch.pl
warnings.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 58 +++++++++++++++----------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 4c8fb86..c09dc02 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -720,16 +720,15 @@ static int read_pulse(bpctl_dev_t *pbpctl_dev, unsigned int ctrl_ext,
 					 BP10G_MDIO_DATA_OUT));
 
 		}
-		if (pbpctl_dev->bp_10g9) {
-			ctrl_ext = BP10G_READ_REG(pbpctl_dev, I2CCTL);
 
-		} else if ((pbpctl_dev->bp_fiber5) || (pbpctl_dev->bp_i80)) {
+		if (pbpctl_dev->bp_10g9)
+			ctrl_ext = BP10G_READ_REG(pbpctl_dev, I2CCTL);
+		else if ((pbpctl_dev->bp_fiber5) || (pbpctl_dev->bp_i80))
 			ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL);
-		} else if (pbpctl_dev->bp_540) {
+		else if (pbpctl_dev->bp_540)
 			ctrl_ext = BP10G_READ_REG(pbpctl_dev, ESDP);
-		} else if (pbpctl_dev->bp_10gb)
+		else if (pbpctl_dev->bp_10gb)
 			ctrl_ext = BP10GB_READ_REG(pbpctl_dev, MISC_REG_SPIO);
-
 		else if (!pbpctl_dev->bp_10g)
 			ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
 		else
@@ -1920,13 +1919,10 @@ int disc_port_on(bpctl_dev_t *pbpctl_dev)
 		return BP_NOT_CAP;
 
 	if (pbpctl_dev_m->bp_caps_ex & DISC_PORT_CAP_EX) {
-		if (is_bypass_fn(pbpctl_dev) == 1) {
-
+		if (is_bypass_fn(pbpctl_dev) == 1)
 			write_data(pbpctl_dev_m, TX_DISA);
-		} else {
-
+		else
 			write_data(pbpctl_dev_m, TX_DISB);
-		}
 
 		msec_delay_bp(LATCH_DELAY);
 
@@ -2017,9 +2013,9 @@ int wdt_off(bpctl_dev_t *pbpctl_dev)
 	int ret = BP_NOT_CAP;
 
 	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
-		if (INTEL_IF_SERIES(pbpctl_dev->subdevice)) {
+		if (INTEL_IF_SERIES(pbpctl_dev->subdevice))
 			bypass_off(pbpctl_dev);
-		} else if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER)
+		else if (pbpctl_dev->bp_ext_ver >= PXG2BPI_VER)
 			write_data(pbpctl_dev, WDT_OFF);
 		else
 			data_pulse(pbpctl_dev, WDT_OFF);
@@ -2404,12 +2400,10 @@ static int set_tx(bpctl_dev_t *pbpctl_dev, int tx_state)
 			}
 
 		}
-		if (pbpctl_dev->bp_fiber5) {
+		if (pbpctl_dev->bp_fiber5)
 			ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
-
-		} else if (pbpctl_dev->bp_10gb)
+		else if (pbpctl_dev->bp_10gb)
 			ctrl = BP10GB_READ_REG(pbpctl_dev, MISC_REG_GPIO);
-
 		else if (!pbpctl_dev->bp_10g)
 			ctrl = BPCTL_READ_REG(pbpctl_dev, CTRL);
 		else
@@ -4054,9 +4048,8 @@ void bypass_caps_init(bpctl_dev_t *pbpctl_dev)
 			pbpctl_dev->bp_caps |=
 			    (TX_CTL_CAP | TX_STATUS_CAP | TPL_CAP);
 
-		if (TPL_IF_SERIES(pbpctl_dev->subdevice)) {
+		if (TPL_IF_SERIES(pbpctl_dev->subdevice))
 			pbpctl_dev->bp_caps |= TPL_CAP;
-		}
 
 		if (INTEL_IF_SERIES(pbpctl_dev->subdevice)) {
 			pbpctl_dev->bp_caps |=
@@ -4196,9 +4189,9 @@ void bypass_caps_init(bpctl_dev_t *pbpctl_dev)
 	if (PEG5_IF_SERIES(pbpctl_dev->subdevice))
 		pbpctl_dev->bp_caps |= (TX_CTL_CAP | TX_STATUS_CAP);
 
-	if (BP10GB_IF_SERIES(pbpctl_dev->subdevice)) {
+	if (BP10GB_IF_SERIES(pbpctl_dev->subdevice))
 		pbpctl_dev->bp_caps &= ~(TX_CTL_CAP | TX_STATUS_CAP);
-	}
+
 	pbpctl_dev_m = get_master_port_fn(pbpctl_dev);
 	if (pbpctl_dev_m != NULL) {
 		int cap_reg = 0;
@@ -4327,10 +4320,9 @@ int set_bypass_wd_auto(bpctl_dev_t *pbpctl_dev, unsigned int param)
 
 int get_bypass_wd_auto(bpctl_dev_t *pbpctl_dev)
 {
-
-	if (pbpctl_dev->bp_caps & WD_CTL_CAP) {
+	if (pbpctl_dev->bp_caps & WD_CTL_CAP)
 		return pbpctl_dev->reset_time;
-	}
+
 	return BP_NOT_CAP;
 }
 
@@ -5036,23 +5028,19 @@ static void bp_tpl_timer_fn(unsigned long param)
 
 	link2 = get_bypass_link_status(pbpctl_dev_b);
 	if ((link1) && (tx_status(pbpctl_dev))) {
-		if ((!link2) && (tx_status(pbpctl_dev_b))) {
+		if ((!link2) && (tx_status(pbpctl_dev_b)))
 			set_tx(pbpctl_dev, 0);
-		} else if (!tx_status(pbpctl_dev_b)) {
+		else if (!tx_status(pbpctl_dev_b))
 			set_tx(pbpctl_dev_b, 1);
-		}
 	} else if ((!link1) && (tx_status(pbpctl_dev))) {
-		if ((link2) && (tx_status(pbpctl_dev_b))) {
+		if ((link2) && (tx_status(pbpctl_dev_b)))
 			set_tx(pbpctl_dev_b, 0);
-		}
 	} else if ((link1) && (!tx_status(pbpctl_dev))) {
-		if ((link2) && (tx_status(pbpctl_dev_b))) {
+		if ((link2) && (tx_status(pbpctl_dev_b)))
 			set_tx(pbpctl_dev, 1);
-		}
 	} else if ((!link1) && (!tx_status(pbpctl_dev))) {
-		if ((link2) && (tx_status(pbpctl_dev_b))) {
+		if ((link2) && (tx_status(pbpctl_dev_b)))
 			set_tx(pbpctl_dev, 1);
-		}
 	}
 
 	mod_timer(&pbpctl_dev->bp_tpl_timer, jiffies + BP_LINK_MON_DELAY * HZ);
@@ -5111,9 +5099,9 @@ int get_bypass_tpl_auto(bpctl_dev_t *pbpctl_dev)
 {
 	if (!pbpctl_dev)
 		return -1;
-	if (pbpctl_dev->bp_caps & TPL_CAP) {
+	if (pbpctl_dev->bp_caps & TPL_CAP)
 		return pbpctl_dev->bp_tpl_flag;
-	}
+
 	return BP_NOT_CAP;
 }
 
-- 
1.8.1.4

