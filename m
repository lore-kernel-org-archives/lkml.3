Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbaCUOIA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:08:00 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:61603 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbaCUOH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:07:58 -0400
From: Matei Oprea <eu@opreamatei.ro>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Matei Oprea <eu@opreamatei.ro>,
        ROSEdu Kernel Community <firefly@lists.rosedu.org>
Subject: [PATCH] staging: rtl8192u: r8192U_wx: Fix sparse warnings
Date: Fri, 21 Mar 2014 16:07:49 +0200
Message-Id: <1395410869-19362-1-git-send-email-eu@opreamatei.ro>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse "should be static" warnings. Those structures are
only referenced in file scope so they can be marked as static.

Signed-off-by: Matei Oprea <eu@opreamatei.ro>
Cc: ROSEdu Kernel Community <firefly@lists.rosedu.org>
---
 drivers/staging/rtl8192u/r8192U_wx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index c70af01..1a3e80d 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -24,7 +24,7 @@
 #include "dot11d.h"
 
 #define RATE_COUNT 12
-u32 rtl8180_rates[] = {1000000,2000000,5500000,11000000,
+static u32 rtl8180_rates[] = {1000000,2000000,5500000,11000000,
 	6000000,9000000,12000000,18000000,24000000,36000000,48000000,54000000};
 
 
@@ -979,7 +979,7 @@ static iw_handler r8192_private_handler[] = {
 };
 
 //#if WIRELESS_EXT >= 17
-struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
+static struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 {
        struct r8192_priv *priv = ieee80211_priv(dev);
 	struct ieee80211_device *ieee = priv->ieee80211;
@@ -1010,7 +1010,7 @@ struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev)
 //#endif
 
 
-struct iw_handler_def  r8192_wx_handlers_def={
+static struct iw_handler_def  r8192_wx_handlers_def={
 	.standard = r8192_wx_handlers,
 	.num_standard = ARRAY_SIZE(r8192_wx_handlers),
 	.private = r8192_private_handler,
-- 
1.7.9.5

