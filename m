Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbaEQRrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 13:47:17 -0400
Received: from v22013021537510585.yourvserver.net ([37.221.193.202]:39746 "EHLO
	finitebox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964885AbaEQRrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 13:47:14 -0400
From: Marcus Farkas <marcus.farkas@finitebox.com>
To: gregkh@linuxfoundation.org
Cc: Marcus Farkas <marcus.farkas@finitebox.com>, linux-kernel@vger.kernel.org,
        larry.finger@lwfinger.net, florian.c.schilhabel@googlemail.com
Subject: [PATCH 2/3] staging: rtl8712: fix unnecessary parentheses
Date: Sat, 17 May 2014 19:38:30 +0200
Message-Id: <005b83699a2cda8ac314a2bfa794fe44067a7702.1400347661.git.marcus.farkas@finitebox.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
References: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
In-Reply-To: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
References: <e16d58bee2dcc54f843c27e2269fd94202857858.1400347661.git.marcus.farkas@finitebox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes the following checkpatch warnings:

rtl8712/rtl871x_security.c
    - 1167: WARNING: Unnecessary parentheses - maybe == should be = ?
    - 1374: WARNING: Unnecessary parentheses - maybe == should be = ?

Signed-off-by: Marcus Farkas <marcus.farkas@finitebox.com>
---
 drivers/staging/rtl8712/rtl871x_security.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index b053a4d..1f2e197 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -1167,7 +1167,7 @@ u32 r8712_aes_encrypt(struct _adapter *padapter, u8 *pxmitframe)
 		return _FAIL;
 	pframe = ((struct xmit_frame *)pxmitframe)->buf_addr + TXDESC_OFFSET;
 	/* 4 start to encrypt each fragment */
-	if ((pattrib->encrypt == _AES_)) {
+	if (pattrib->encrypt == _AES_) {
 		if (pattrib->psta)
 			stainfo = pattrib->psta;
 		else
@@ -1374,7 +1374,7 @@ u32 r8712_aes_decrypt(struct _adapter *padapter, u8 *precvframe)
 	pframe = (unsigned char *)((union recv_frame *)precvframe)->
 		 u.hdr.rx_data;
 	/* 4 start to encrypt each fragment */
-	if ((prxattrib->encrypt == _AES_)) {
+	if (prxattrib->encrypt == _AES_) {
 		stainfo = r8712_get_stainfo(&padapter->stapriv,
 					    &prxattrib->ta[0]);
 		if (stainfo != NULL) {
-- 
1.9.2

