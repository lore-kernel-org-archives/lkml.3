Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab3GKOhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:37:53 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43161 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab3GKO0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:26:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 69/98] ath9k: fill channel mode in caldata
Date: Thu, 11 Jul 2013 15:24:39 +0100
Message-Id: <1373552708-15235-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 77d848372875d2e4cbdbf07030f0e08cab5e7f4d upstream.

It is useful to have channel mode in caldata to find out
whether operaing channel is in HT40/20 when we are currently
on offchannel. It will be used by BTCOEX to enable/disable
concurrent tx mechanism later.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 1 +
 drivers/net/wireless/ath/ath9k/hw.h    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index bbd249d..1e85085 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -411,6 +411,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 
 	ah->caldata->channel = chan->channel;
 	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
+	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index ec2835b..88295a1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -355,6 +355,7 @@ enum ath9k_int {
 struct ath9k_hw_cal_data {
 	u16 channel;
 	u32 channelFlags;
+	u32 chanmode;
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;
-- 
1.8.1.2

