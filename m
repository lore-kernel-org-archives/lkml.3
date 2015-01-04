Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbbADHYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 02:24:07 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:41480 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbADHYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 02:24:03 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH v2] staging: rtl8192e: Fix duplicated conditional branch
Date: Sun,  4 Jan 2015 13:23:50 +0600
Message-Id: <1420356230-6446-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.202.g44ae4ee.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_dm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
index 885315c..b8891c6 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_dm.c
@@ -1661,8 +1661,8 @@ void dm_change_dynamic_initgain_thresh(struct net_device *dev,
 		dm_digtable.rssi_low_thresh = dm_value;
 	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
 		dm_digtable.rssi_high_power_highthresh = dm_value;
-	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_HIGH) {
-		dm_digtable.rssi_high_power_highthresh = dm_value;
+	} else if (dm_type == DIG_TYPE_THRESH_HIGHPWR_LOW) {
+		dm_digtable.rssi_high_power_lowthresh = dm_value;
 	} else if (dm_type == DIG_TYPE_ENABLE) {
 		dm_digtable.dig_state		= DM_STA_DIG_MAX;
 		dm_digtable.dig_enable_flag	= true;
-- 
2.2.1.202.g44ae4ee.dirty

