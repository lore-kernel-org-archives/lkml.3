Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965476AbaDJEQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:16:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41057 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934703AbaDJDWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 040/134] ath9k: fill channel mode in caldata
Date: Wed,  9 Apr 2014 20:22:36 -0700
Message-Id: <20140410032305.164870422@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/calib.c |    1 +
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -410,6 +410,7 @@ void ath9k_init_nfcal_hist_buffer(struct
 
 	ah->caldata->channel = chan->channel;
 	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
+	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -361,6 +361,7 @@ struct ath9k_rtt_hist {
 struct ath9k_hw_cal_data {
 	u16 channel;
 	u32 channelFlags;
+	u32 chanmode;
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;


