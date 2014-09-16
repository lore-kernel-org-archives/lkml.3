Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaIPW21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:28:27 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59804 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaIPW20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:28:26 -0400
From: Kieron Browne <kieron.browne@gmail.com>
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Kieron Browne <kieron.browne@gmail.com>
Subject: [PATCH 1/1] staging: rtl8723au: fix sparse incorrect type assignment warnings
Date: Tue, 16 Sep 2014 23:28:09 +0100
Message-Id: <1410906489-26671-1-git-send-email-kieron.browne@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use cpu_to_le16 to cast int for assignment to __le16 members

Signed-off-by: Kieron Browne <kieron.browne@gmail.com>
---
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
index efe4af8..f2615dc 100644
--- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
@@ -3169,13 +3169,13 @@ static void rtw_cfg80211_init_ht_capab(struct ieee80211_sta_ht_cap *ht_cap,
 		ht_cap->mcs.rx_mask[1] = 0x00;
 		ht_cap->mcs.rx_mask[4] = 0x01;
 
-		ht_cap->mcs.rx_highest = MAX_BIT_RATE_40MHZ_MCS7;
+		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS7);
 	} else if ((rf_type == RF_1T2R) || (rf_type == RF_2T2R)) {
 		ht_cap->mcs.rx_mask[0] = 0xFF;
 		ht_cap->mcs.rx_mask[1] = 0xFF;
 		ht_cap->mcs.rx_mask[4] = 0x01;
 
-		ht_cap->mcs.rx_highest = MAX_BIT_RATE_40MHZ_MCS15;
+		ht_cap->mcs.rx_highest = cpu_to_le16(MAX_BIT_RATE_40MHZ_MCS15);
 	} else {
 		DBG_8723A("%s, error rf_type =%d\n", __func__, rf_type);
 	}
-- 
1.9.1

