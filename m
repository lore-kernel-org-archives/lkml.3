Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaLGOhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 09:37:37 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64321 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaLGOhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 09:37:34 -0500
From: Emil Renner Berthing <kernel@esmil.dk>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Emil Renner Berthing <kernel@esmil.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: staging: rtl8723au: get rid of unneeded memset/memcpy
Date: Sun,  7 Dec 2014 15:37:20 +0100
Message-Id: <1417963040-9014-1-git-send-email-kernel@esmil.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This also fixes a sparse warning.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
index 7b56411..d8c4c8b 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
@@ -124,14 +124,15 @@ int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
 
 int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
 {
-	u8 buf[5];
+	struct {
+		__le32 mask;
+		u8 arg;
+	} __packed buf;
 
-	memset(buf, 0, 5);
-	mask = cpu_to_le32(mask);
-	memcpy(buf, &mask, 4);
-	buf[4]  = arg;
+	buf.mask = cpu_to_le32(mask);
+	buf.arg = arg;
 
-	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, buf);
+	FillH2CCmd(padapter, MACID_CONFIG_EID, 5, (u8 *)&buf);
 
 	return _SUCCESS;
 }
-- 
2.1.3

