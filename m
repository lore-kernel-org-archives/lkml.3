Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaEDOq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 10:46:57 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:33045 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaEDOqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 10:46:55 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Levente Kurusa <levex@linux.com>, linux-kernel@vger.kernel.org,
        Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH v2 2/2] staging/rtl8192e: userspace ptr deref + incorrect declarations
Date: Sun,  4 May 2014 16:46:27 +0200
Message-Id: <1399214787-15675-1-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. userspace pointer dereference ;

These issues have been fixed by a concurrent patch:
. missing inclusions of needed header files (fixed by concurrent patch);
. unrequired static function declaration (confusing another *.c file).

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
v1 : I submit this patch as a result for Task #16 of the Eudyptula Challenge.
v2 : Resubmitted because of a conflit with commit 5169af2309f42bb4cb0ebfefe6bf8bc888d4ce33 .
     Successfully tested against commit b5c8d48bf8f4273a9fe680bd834f991005c8ab59 .
     I resubmit only the 2/2 one, since the 1/2 as already been accepted.

     Levente, still agree with you about numeric values that should be changed into symbols.
     This will form another future patch.

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 498995d..d87cdfa 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -1131,11 +1131,18 @@ static int r8192_wx_set_PromiscuousMode(struct net_device *dev,
 	struct r8192_priv *priv = rtllib_priv(dev);
 	struct rtllib_device *ieee = priv->rtllib;
 
-	u32 *info_buf = (u32 *)(wrqu->data.pointer);
+	u32 info_buf[3];
 
-	u32 oid = info_buf[0];
-	u32 bPromiscuousOn = info_buf[1];
-	u32 bFilterSourceStationFrame = info_buf[2];
+	u32 oid;
+	u32 bPromiscuousOn;
+	u32 bFilterSourceStationFrame;
+
+	if (copy_from_user(info_buf, wrqu->data.pointer, sizeof(info_buf)))
+		return -EFAULT;
+
+	oid = info_buf[0];
+	bPromiscuousOn = info_buf[1];
+	bFilterSourceStationFrame = info_buf[2];
 
 	if (OID_RT_INTEL_PROMISCUOUS_MODE == oid) {
 		ieee->IntelPromiscuousModeInfo.bPromiscuousOn =
