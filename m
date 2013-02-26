Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933830Ab3B0A4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:56:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42089 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab3BZX6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [ 097/150] staging: vt6656: Revert: 64bit fixes: dpc.c incorrect addressing of void structure.
Date: Tue, 26 Feb 2013 15:55:54 -0800
Message-Id: <20130226235534.134163248@linuxfoundation.org>
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

commit 392c6ff87f568d573239b763855160d1f06114de upstream.

The patch was totally wrong and is reverted.

The problem was ultimately fixed by upstream commit.
1ee4c55fc9620451b2a825d793042a7e0775391b
staging: vt6656: Fix inconsistent structure packing

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/dpc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6656/dpc.c
+++ b/drivers/staging/vt6656/dpc.c
@@ -1190,7 +1190,7 @@ static BOOL s_bHandleRxEncryption (
     if (byDecMode == KEY_CTL_WEP) {
         // handle WEP
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-		(((PSKeyTable)(&pKey->pvKeyTable))->bSoftWEP == TRUE)) {
+		(((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE)) {
             // Software WEP
             // 1. 3253A
             // 2. WEP 256
@@ -1299,7 +1299,7 @@ static BOOL s_bHostWepRxEncryption (
         // handle WEP
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO"byDecMode == KEY_CTL_WEP\n");
         if ((pDevice->byLocalID <= REV_ID_VT3253_A1) ||
-		(((PSKeyTable)(&pKey->pvKeyTable))->bSoftWEP == TRUE) ||
+		(((PSKeyTable)(pKey->pvKeyTable))->bSoftWEP == TRUE) ||
             (bOnFly == FALSE)) {
             // Software WEP
             // 1. 3253A


