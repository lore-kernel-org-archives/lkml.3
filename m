Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3BZX6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760313Ab3BZX6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 096/150] staging: vt6656: revert : 64 bit- Correctly address void structure.
Date: Tue, 26 Feb 2013 15:55:53 -0800
Message-Id: <20130226235534.029780812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit d61ac98a4bd86b3217f0c6e058bd0b3a3282899b upstream.

The patch is wrong and is partially reverted.

The NULL check of pTransmitKey->pvKeyTable is kept.

The problem was ultimately fixed by upstream commit.
1ee4c55fc9620451b2a825d793042a7e0775391b
staging: vt6656: Fix inconsistent structure packing

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/rxtx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -1454,7 +1454,7 @@ s_bPacketToWirelessUsb(
 
     pvRrvTime = pMICHDR = pvRTS = pvCTS = pvTxDataHd = NULL;
 	if (bNeedEncryption && pTransmitKey->pvKeyTable) {
-		if (((PSKeyTable)&pTransmitKey->pvKeyTable)->bSoftWEP == TRUE)
+		if (((PSKeyTable)pTransmitKey->pvKeyTable)->bSoftWEP == TRUE)
 			bSoftWEP = TRUE; /* WEP 256 */
 	}
 


