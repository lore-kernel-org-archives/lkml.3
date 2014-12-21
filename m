Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaLUN5G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 08:57:06 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51413 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaLUN5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 08:57:02 -0500
From: Mike Krinkin <krinkin.m.u@gmail.com>
To: gregkh@linuxfoundation.org, forest@alittletooquiet.net, tvboxspy@gmail.com,
        gclement@baobob.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mike Krinkin <krinkin.m.u@gmail.com>
Subject: [PATCH] staging: vt6655: fix sparse warnings: incorrect argument type
Date: Sun, 21 Dec 2014 16:56:47 +0300
Message-Id: <1419170207-2585-1-git-send-email-krinkin.m.u@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes following sparse warnings:

drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1503:25: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/device_main.c:1503:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1503:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *
drivers/staging/vt6655/device_main.c:1505:25: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/vt6655/device_main.c:1505:25:    expected void [noderef] <asn:2>*<noident>
drivers/staging/vt6655/device_main.c:1505:25:    got struct vnt_private *

Signed-off-by: Mike Krinkin <krinkin.m.u@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 83e4162..ce616f9 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1500,9 +1500,11 @@ static void vnt_bss_info_changed(struct ieee80211_hw *hw,
 		if (conf->enable_beacon) {
 			vnt_beacon_enable(priv, vif, conf);
 
-			MACvRegBitsOn(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+			MACvRegBitsOn(priv->PortOffset, MAC_REG_TCR,
+				      TCR_AUTOBCNTX);
 		} else {
-			MACvRegBitsOff(priv, MAC_REG_TCR, TCR_AUTOBCNTX);
+			MACvRegBitsOff(priv->PortOffset, MAC_REG_TCR,
+				       TCR_AUTOBCNTX);
 		}
 	}
 
-- 
1.9.1

