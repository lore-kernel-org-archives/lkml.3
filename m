Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaEZQHl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:41 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:51062 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:37 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 17/24] staging: rtl8188eu: Use "ODM_REG_CCK_CCA_11N" in ODM_Write_CCK_CCA_Thres()
Date: Mon, 26 May 2014 21:35:32 +0530
Message-Id: <1401120339-23667-17-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "ODM_REG_CCK_CCA_11N" directly instead of using ODM_REG(CCK_CCA, pDM_Odm)
which produces same after preprocessing.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index a39eba9..540527d 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -842,7 +842,7 @@ void ODM_Write_CCK_CCA_Thres(struct odm_dm_struct *pDM_Odm, u8 CurCCK_CCAThres)
 	struct adapter *adapt = pDM_Odm->Adapter;
 
 	if (pDM_DigTable->CurCCK_CCAThres != CurCCK_CCAThres)		/* modify by Guo.Mingzhi 2012-01-03 */
-		rtw_write8(adapt, ODM_REG(CCK_CCA, pDM_Odm), CurCCK_CCAThres);
+		rtw_write8(adapt, ODM_REG_CCK_CCA_11N, CurCCK_CCAThres);
 	pDM_DigTable->PreCCK_CCAThres = pDM_DigTable->CurCCK_CCAThres;
 	pDM_DigTable->CurCCK_CCAThres = CurCCK_CCAThres;
 }
-- 
1.7.10.4

