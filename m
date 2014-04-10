Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880AbaDJRrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:47:01 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:53876 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaDJRrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:47:00 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: r8723au: Add missing initialization of change_inx in sort algorithm
Date: Thu, 10 Apr 2014 19:46:56 +0200
Message-Id: <1397152016-31005-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/rtl8723au/core/rtw_wlan_util.c: In function ‘WMMOnAssocRsp23a’:
drivers/staging/rtl8723au/core/rtw_wlan_util.c:684: warning: ‘change_inx’ may be used uninitialized in this function

Depending on the uninitialized data on the stack, the array may not be
sorted correctly.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/rtl8723au/core/rtw_wlan_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
index 0dfcfbce3b52..a4361bb93865 100644
--- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
@@ -681,7 +681,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
 	inx[0] = 0; inx[1] = 1; inx[2] = 2; inx[3] = 3;
 
 	if (pregpriv->wifi_spec == 1) {
-		u32	j, tmp, change_inx;
+		u32	j, tmp, change_inx = false;
 
 		/* entry indx: 0->vo, 1->vi, 2->be, 3->bk. */
 		for (i = 0; i < 4; i++) {
-- 
1.7.9.5

