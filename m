Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3FRDcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:32:39 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:43403 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab3FRDcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:32:36 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 3/4] Staging: silicom: move assignments out of if conditions
Date: Mon, 17 Jun 2013 22:32:04 -0500
Message-Id: <1371526325-9821-4-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371526325-9821-1-git-send-email-chad@dahc.us>
References: <1371526325-9821-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a bunch of assignments from if-statement conditions in
bpctl_mod.c, resolving checkpatch.pl errors. (This isn't all of
them, but the patch is getting rather long...)

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 54 +++++++++++++++++++++++--------------
 1 file changed, 34 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index 893737a..19a9239 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -306,7 +306,8 @@ static void write_pulse(bpctl_dev_t *pbpctl_dev,
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
 
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_c)
 			return;
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 	}
@@ -606,7 +607,8 @@ static int read_pulse(bpctl_dev_t *pbpctl_dev, unsigned int ctrl_ext,
 	if (pbpctl_dev->bp_540)
 		ctrl = BP10G_READ_REG(pbpctl_dev, ESDP);
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_c)
 			return -1;
 		ctrl = BP10G_READ_REG(pbpctl_dev_c, ESDP);
 	}
@@ -774,7 +776,8 @@ static void write_reg(bpctl_dev_t *pbpctl_dev, unsigned char value,
 	bpctl_dev_t *pbpctl_dev_c = NULL;
 	unsigned long flags;
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_c)
 			return;
 	}
 	if ((pbpctl_dev->wdt_status == WDT_STATUS_EN) &&
@@ -952,7 +955,8 @@ static int read_reg(bpctl_dev_t *pbpctl_dev, unsigned char addr)
 	atomic_set(&pbpctl_dev->wdt_busy, 1);
 #endif
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_c)
 			return -1;
 	}
 
@@ -1223,7 +1227,8 @@ static int wdt_pulse(bpctl_dev_t *pbpctl_dev)
 		return -1;
 #endif
 	if (pbpctl_dev->bp_10g9) {
-		if (!(pbpctl_dev_c = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_c = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_c)
 			return -1;
 	}
 
@@ -1743,7 +1748,8 @@ static int write_data_int(bpctl_dev_t *pbpctl_dev, unsigned char value)
 {
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+	if (!pbpctl_dev_b)
 		return -1;
 	atomic_set(&pbpctl_dev->wdt_busy, 1);
 	write_data_port_int(pbpctl_dev, value & 0x3);
@@ -1961,7 +1967,8 @@ int tpl_hw_on(bpctl_dev_t *pbpctl_dev)
 	int ret = 0, ctrl = 0;
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+	if (!pbpctl_dev_b)
 		return BP_NOT_CAP;
 
 	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
@@ -1988,7 +1995,8 @@ int tpl_hw_off(bpctl_dev_t *pbpctl_dev)
 	int ret = 0, ctrl = 0;
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+	if (!pbpctl_dev_b)
 		return BP_NOT_CAP;
 	if (pbpctl_dev->bp_caps_ex & TPL2_CAP_EX) {
 		cmnd_on(pbpctl_dev);
@@ -3231,8 +3239,10 @@ int bypass_from_last_read(bpctl_dev_t *pbpctl_dev)
 	uint32_t ctrl_ext = 0;
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if ((pbpctl_dev->bp_caps & SW_CTL_CAP)
-	    && (pbpctl_dev_b = get_status_port_fn(pbpctl_dev))) {
+	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_b)
+			return BP_NOT_CAP;
 		ctrl_ext = BPCTL_READ_REG(pbpctl_dev_b, CTRL_EXT);
 		BPCTL_BP_WRITE_REG(pbpctl_dev_b, CTRL_EXT,
 				   (ctrl_ext & ~BPCTLI_CTRL_EXT_SDP7_DIR));
@@ -3248,9 +3258,10 @@ int bypass_status_clear(bpctl_dev_t *pbpctl_dev)
 {
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if ((pbpctl_dev->bp_caps & SW_CTL_CAP)
-	    && (pbpctl_dev_b = get_status_port_fn(pbpctl_dev))) {
-
+	if (pbpctl_dev->bp_caps & SW_CTL_CAP) {
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_b)
+			return BP_NOT_CAP;
 		send_bypass_clear_pulse(pbpctl_dev_b, 1);
 		return 0;
 	} else
@@ -3323,7 +3334,8 @@ static int bypass_status(bpctl_dev_t *pbpctl_dev)
 
 		bpctl_dev_t *pbpctl_dev_b = NULL;
 
-		if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_b)
 			return BP_NOT_CAP;
 
 		if (INTEL_IF_SERIES(pbpctl_dev->subdevice)) {
@@ -3611,7 +3623,8 @@ int tap_status(bpctl_dev_t *pbpctl_dev)
 	if (pbpctl_dev->bp_caps & TAP_CAP) {
 		bpctl_dev_t *pbpctl_dev_b = NULL;
 
-		if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_b)
 			return BP_NOT_CAP;
 
 		if (pbpctl_dev->bp_ext_ver >= 0x8) {
@@ -3707,7 +3720,8 @@ int disc_off_status(bpctl_dev_t *pbpctl_dev)
 	u32 ctrl_ext = 0;
 
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
-		if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+		pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+		if (!pbpctl_dev_b)
 			return BP_NOT_CAP;
 		if (DISCF_IF_SERIES(pbpctl_dev->subdevice))
 			return ((((read_reg(pbpctl_dev, STATUS_DISC_REG_ADDR)) &
@@ -3788,11 +3802,10 @@ static int disc_status(bpctl_dev_t *pbpctl_dev)
 {
 	int ctrl = 0;
 	if (pbpctl_dev->bp_caps & DISC_CAP) {
-
-		if ((ctrl = disc_off_status(pbpctl_dev)) < 0)
+		ctrl = disc_off_status(pbpctl_dev);
+		if (ctrl < 0)
 			return ctrl;
 		return ((ctrl == 0) ? 1 : 0);
-
 	}
 	return BP_NOT_CAP;
 }
@@ -3905,7 +3918,8 @@ int tpl_hw_status(bpctl_dev_t *pbpctl_dev)
 {
 	bpctl_dev_t *pbpctl_dev_b = NULL;
 
-	if (!(pbpctl_dev_b = get_status_port_fn(pbpctl_dev)))
+	pbpctl_dev_b = get_status_port_fn(pbpctl_dev);
+	if (!pbpctl_dev_b)
 		return BP_NOT_CAP;
 
 	if (TPL_IF_SERIES(pbpctl_dev->subdevice))
-- 
1.8.1.4

