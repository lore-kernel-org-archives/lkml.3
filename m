Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbaHFIvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:51:33 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:39128 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbaHFIvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:51:31 -0400
From: A Raghavendra Rao <raghav3276@gmail.com>
X-Google-Original-From: A Raghavendra Rao <arrao@cdac.in>
To: gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com, c@24.io
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        A Raghavendra Rao <arrao@cdac.in>
Subject: [PATCH] staging: rtl8192u: fix sparse warnings in r8192U_core.c
Date: Wed,  6 Aug 2014 14:14:16 +0530
Message-Id: <1407314656-24471-1-git-send-email-arrao@cdac.in>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings:
drivers/staging/rtl8192u/r8192U_core.c:670:6: warning: symbol 'dump_eprom'
was not declared. Should it be static?
drivers/staging/rtl8192u/r8192U_core.c:1556:14: warning: symbol
'txqueue2outpipe' was not declared. Should it be static?
drivers/staging/rtl8192u/r8192U_core.c:4876:5: warning: symbol
'GetRxPacketShiftBytes819xUsb' was not declared. Should it be static?

Signed-off-by: A Raghavendra Rao <arrao@cdac.in>
---
 drivers/staging/rtl8192u/r8192U_core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 7640386..b41b21a 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -667,7 +667,7 @@ static void tx_timeout(struct net_device *dev)
 
 
 /* this is only for debug */
-void dump_eprom(struct net_device *dev)
+static void dump_eprom(struct net_device *dev)
 {
 	int i;
 	for (i = 0; i < 63; i++)
@@ -1553,7 +1553,8 @@ u16 N_DBPSOfRate(u16 DataRate)
 	return N_DBPS;
 }
 
-unsigned int txqueue2outpipe(struct r8192_priv *priv, unsigned int tx_queue)
+static unsigned int txqueue2outpipe(struct r8192_priv *priv,
+					unsigned int tx_queue)
 {
 	if (tx_queue >= 9) {
 		RT_TRACE(COMP_ERR, "%s():Unknown queue ID!!!\n", __func__);
@@ -4873,7 +4874,8 @@ static void query_rxdesc_status(struct sk_buff *skb,
 
 }
 
-u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status, bool bIsRxAggrSubframe)
+static u32 GetRxPacketShiftBytes819xUsb(struct ieee80211_rx_stats  *Status,
+					bool bIsRxAggrSubframe)
 {
 #ifdef USB_RX_AGGREGATION_SUPPORT
 	if (bIsRxAggrSubframe)
-- 
1.7.9.5

