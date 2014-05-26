Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbaEZQHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:07:47 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46995 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaEZQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:07:43 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 18/24] staging: rtl8188eu: Use ODM_REG_IGI_A_11N and ODM_BIT_IGI_11N in odm_DIGInit()
Date: Mon, 26 May 2014 21:35:33 +0530
Message-Id: <1401120339-23667-18-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
References: <1401120339-23667-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ODM_REG(IGI_A, pDM_Odm) and ODM_BIT(IGI, pDM_Odm) macros produce
ODM_REG_IGI_A_11N and ODM_BIT_IGI_11N respectively after preprocessing.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/odm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8188eu/hal/odm.c b/drivers/staging/rtl8188eu/hal/odm.c
index 540527d..2bd68aa 100644
--- a/drivers/staging/rtl8188eu/hal/odm.c
+++ b/drivers/staging/rtl8188eu/hal/odm.c
@@ -531,7 +531,7 @@ void odm_DIGInit(struct odm_dm_struct *pDM_Odm)
 	struct adapter *adapter = pDM_Odm->Adapter;
 	struct rtw_dig *pDM_DigTable = &pDM_Odm->DM_DigTable;
 
-	pDM_DigTable->CurIGValue = (u8) PHY_QueryBBReg(adapter, ODM_REG(IGI_A, pDM_Odm), ODM_BIT(IGI, pDM_Odm));
+	pDM_DigTable->CurIGValue = (u8) PHY_QueryBBReg(adapter, ODM_REG_IGI_A_11N, ODM_BIT_IGI_11N);
 	pDM_DigTable->RssiLowThresh	= DM_DIG_THRESH_LOW;
 	pDM_DigTable->RssiHighThresh	= DM_DIG_THRESH_HIGH;
 	pDM_DigTable->FALowThresh	= DM_false_ALARM_THRESH_LOW;
-- 
1.7.10.4

