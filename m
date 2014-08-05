Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaHESmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:42:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaHESO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:14:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 3.14 13/39] staging: vt6655: Fix disassociated messages every 10 seconds
Date: Tue,  5 Aug 2014 11:13:50 -0700
Message-Id: <20140805181336.447709382@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181336.030349158@linuxfoundation.org>
References: <20140805181336.030349158@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 4aa0abed3a2a11b7d71ad560c1a3e7631c5a31cd upstream.

byReAssocCount is incremented every second resulting in
disassociated message being send every 10 seconds whether
connection or not.

byReAssocCount should only advance while eCommandState
is in WLAN_ASSOCIATE_WAIT

Change existing scope to if condition.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6655/bssdb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -983,7 +983,7 @@ start:
 		pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
 	}
 
-	{
+	if (pDevice->eCommandState == WLAN_ASSOCIATE_WAIT) {
 		pDevice->byReAssocCount++;
 		/* 10 sec timeout */
 		if ((pDevice->byReAssocCount > 10) && (!pDevice->bLinkPass)) {


