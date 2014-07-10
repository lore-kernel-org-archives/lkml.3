Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751037AbaGJFzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:55:53 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:65496 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGJFzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:55:51 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/2] staging: rtl8723au: core: rtw_ap.c - removed NULL pointer check before kfree()
Date: Thu, 10 Jul 2014 11:25:36 +0530
Message-Id: <1404971737-9737-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- as kfree() internally check for NULL, additional check it not
  required.

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/rtl8723au/core/rtw_ap.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
index c8700b3..8714ae3 100644
--- a/drivers/staging/rtl8723au/core/rtw_ap.c
+++ b/drivers/staging/rtl8723au/core/rtw_ap.c
@@ -1270,8 +1270,7 @@ static void update_bcn_wps_ie(struct rtw_adapter *padapter)
 		pnetwork->IELength = wps_offset + (wps_ielen+2) + remainder_ielen;
 	}
 
-	if (pbackup_remainder_ie)
-		kfree(pbackup_remainder_ie);
+	kfree(pbackup_remainder_ie);
 }
 
 static void update_bcn_p2p_ie(struct rtw_adapter *padapter)
-- 
1.9.1

