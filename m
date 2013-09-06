Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3IFMp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 08:45:58 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:42153 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3IFMp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 08:45:57 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: r8188eu: Fix uninitialized variable change_inx
Date: Fri,  6 Sep 2013 14:45:36 +0200
Message-Id: <1378471536-7169-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/rtl8188eu/core/rtw_wlan_util.c: In function ‘WMMOnAssocRsp’:
drivers/staging/rtl8188eu/core/rtw_wlan_util.c:634: warning: ‘change_inx’ may be used uninitialized in this function

And the compiler is right: change_inx should be initialized to false.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/rtl8188eu/core/rtw_wlan_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
index 013ea48..8018edd 100644
--- a/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
+++ b/drivers/staging/rtl8188eu/core/rtw_wlan_util.c
@@ -631,7 +631,7 @@ void WMMOnAssocRsp(struct adapter *padapter)
 	inx[0] = 0; inx[1] = 1; inx[2] = 2; inx[3] = 3;
 
 	if (pregpriv->wifi_spec == 1) {
-		u32	j, tmp, change_inx;
+		u32	j, tmp, change_inx = false;
 
 		/* entry indx: 0->vo, 1->vi, 2->be, 3->bk. */
 		for (i = 0; i < 4; i++) {
-- 
1.7.9.5

