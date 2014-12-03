Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaLCG2Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:28:24 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:58672 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaLCG2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:28:23 -0500
From: Fred Chou <fred.chou.nd@gmail.com>
X-Google-Original-From: Fred Chou
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, fred.chou.nd@gmail.com
Subject: [PATCH v2] staging: rt8192u: fix sparse warnings in r8192U_core.c
Date: Wed,  3 Dec 2014 14:30:29 +0800
Message-Id: <1417588229-9552-1-git-send-email-fred.chou.nd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fred Chou <fred.chou.nd@gmail.com>

v2: alignment to match open parenthesis

Fixed the following warnings in sparse:
drivers/staging/rtl8192u/r8192U_core.c:670:6: warning:
 	symbol 'dump_eprom' was not declared.
	Should it be static?
drivers/staging/rtl8192u/r8192U_core.c:1489:5: warning:
 	symbol 'ComputeTxTime' was not declared.
	Should it be static?
drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning:
	symbol 'txqueue2outpipe' was not declared.
	Should it be static?
drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning:
	symbol 'GetRxPacketShiftBytes819xUsb' was not declared.
	Should it be static?

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7640386..6b647ad 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -667,7 +667,7 @@ static void tx_timeout(struct net_device *dev)
 
 
 /* this is only for debug */
-void dump_eprom(struct net_device *dev)
+static void dump_eprom(struct net_device *dev)
 {
 	int i;
 	for (i = 0; i < 63; i++)
@@ -1486,7 +1486,7 @@ inline u8 rtl8192_IsWirelessBMode(u16 rate)
 
 u16 N_DBPSOfRate(u16 DataRate);
 
-u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
+static u16 ComputeTxTime(u16 FrameLength, u16 DataRate, u8 bManagementFrame,
 		  	  u8 bShortPreamble)
 {
 	u16	FrameTime;
@@ -1553,7 +1553,8 @@ u16 N_DBPSOfRate(u16 DataRate)
 	return N_DBPS;
 }
 
-unsigned int txqueue2outpipe(struct r8192_priv *priv, unsigned int tx_queue)
+static unsigned int txqueue2outpipe(struct r8192_priv *priv,
+				     unsigned int tx_queue)
 {
 	if (tx_queue >= 9) {
 		RT_TRACE(COMP_ERR, "%s():Unknown queue ID!!!\n", __func__);
@@ -4873,7 +4874,8 @@ static void query_rxdesc_status(struct sk_buff *skb,
 
 }
 
-u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status, bool bIsRxAggrSubframe)
+static u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status,
+					 bool bIsRxAggrSubframe)
 {
 #ifdef USB_RX_AGGREGATION_SUPPORT
 	if (bIsRxAggrSubframe)
-- 
1.9.1

