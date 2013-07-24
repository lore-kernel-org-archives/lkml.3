Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab3GXObF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:31:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45729 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751891Ab3GXOGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.341227510@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [18/85] ath9k: fill channel mode in caldata
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>

commit 77d848372875d2e4cbdbf07030f0e08cab5e7f4d upstream.

It is useful to have channel mode in caldata to find out
whether operaing channel is in HT40/20 when we are currently
on offchannel. It will be used by BTCOEX to enable/disable
concurrent tx mechanism later.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/calib.c | 1 +
 drivers/net/wireless/ath/ath9k/hw.h    | 1 +
 2 files changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -413,6 +413,7 @@ void ath9k_init_nfcal_hist_buffer(struct
 
 	ah->caldata->channel = chan->channel;
 	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
+	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -352,6 +352,7 @@ struct ath9k_rtt_hist {
 struct ath9k_hw_cal_data {
 	u16 channel;
 	u32 channelFlags;
+	u32 chanmode;
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;

