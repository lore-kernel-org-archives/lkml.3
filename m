Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbaITLJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 07:09:17 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:62644 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183AbaITLJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 07:09:15 -0400
From: Grzegorz Swirski <grzegorz@swirski.name>
To: gregkh@linuxfoundation.org
Cc: josh@joshtriplett.org, stankus.modestas@gmail.com, vitaly.osipov@gmail.com,
        Johannes.Stadlinger@fau.de, himangi774@gmail.com,
        grzegorz@swirski.name, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: remove unused 'result' var
Date: Sat, 20 Sep 2014 12:09:11 +0100
Message-Id: <1411211351-4207-1-git-send-email-grzegorz@swirski.name>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grzegorz Swirski <grzegorz@swirski.name>
---
 drivers/staging/wlan-ng/prism2mib.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
index f471708..0163e06 100644
--- a/drivers/staging/wlan-ng/prism2mib.c
+++ b/drivers/staging/wlan-ng/prism2mib.c
@@ -717,8 +717,6 @@ static int prism2mib_priv(struct mibrec *mib,
 {
 	p80211pstrd_t *pstr = (p80211pstrd_t *) data;
 
-	int result;
-
 	switch (mib->did) {
 	case DIDmib_lnx_lnxConfigTable_lnxRSNAIE:{
 			hfa384x_WPAData_t wpa;
@@ -734,11 +732,10 @@ static int prism2mib_priv(struct mibrec *mib,
 				wpa.datalen = cpu_to_le16(pstr->len);
 				memcpy(wpa.data, pstr->data, pstr->len);
 
-				result =
-				    hfa384x_drvr_setconfig(hw,
-						   HFA384x_RID_CNFWPADATA,
-						   (u8 *) &wpa,
-						   sizeof(wpa));
+				hfa384x_drvr_setconfig(hw,
+						       HFA384x_RID_CNFWPADATA,
+						       (u8 *) &wpa,
+						       sizeof(wpa));
 			}
 			break;
 		}
-- 
1.9.1

