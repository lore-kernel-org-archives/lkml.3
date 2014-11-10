Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbaKJUIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:08:11 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:59227 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaKJUIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:08:09 -0500
From: Chris Ruffin <cmruffin@gmail.com>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, Jes Sorensen <Jes.Sorensen@redhat.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Ruffin <cmruffin@gmail.com>
Subject: [PATCH] staging: rtl8723au: change typecast to match type returned by htons()
Date: Mon, 10 Nov 2014 15:07:05 -0500
Message-Id: <1415650025-16403-1-git-send-email-cmruffin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a u16 pointer typecast for a result from htons() results in the following warning from sparse:

drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36: warning: incorrect type in assignment (different base types)
drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36:    expected unsigned short [unsigned] [short] [usertype] <noident>
drivers/staging/rtl8723au/core/rtw_xmit.c:1279:36:    got restricted __be16 [usertype] <noident>

This patch fixes the issue by using an endian-specific typecast
that will always match the type returned by htons().

Signed-off-by: Chris Ruffin <cmruffin@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_xmit.c b/drivers/staging/rtl8723au/core/rtw_xmit.c
index a0f7e27..44ef55c 100644
--- a/drivers/staging/rtl8723au/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723au/core/rtw_xmit.c
@@ -1276,7 +1276,7 @@ s32 rtw_put_snap23a(u8 *data, u16 h_proto)
 	snap->oui[0] = oui[0];
 	snap->oui[1] = oui[1];
 	snap->oui[2] = oui[2];
-	*(u16 *)(data + SNAP_SIZE) = htons(h_proto);
+	*(__be16 *)(data + SNAP_SIZE) = htons(h_proto);
 	return SNAP_SIZE + sizeof(u16);
 }
 
-- 
1.7.10.4

