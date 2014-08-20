Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaHTLoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:44:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58867 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 011/104] staging: vt6655: Fix disassociated messages every 10 seconds
Date: Wed, 20 Aug 2014 13:42:34 +0200
Message-Id: <0a5d8d71f528efeeffa3415fb61846e6f18541ae.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4aa0abed3a2a11b7d71ad560c1a3e7631c5a31cd upstream.

byReAssocCount is incremented every second resulting in
disassociated message being send every 10 seconds whether
connection or not.

byReAssocCount should only advance while eCommandState
is in WLAN_ASSOCIATE_WAIT

Change existing scope to if condition.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/vt6655/bssdb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/bssdb.c b/drivers/staging/vt6655/bssdb.c
index f983915168b7..3496a77612ba 100644
--- a/drivers/staging/vt6655/bssdb.c
+++ b/drivers/staging/vt6655/bssdb.c
@@ -1026,7 +1026,7 @@ start:
 		pDevice->byERPFlag &= ~(WLAN_SET_ERP_USE_PROTECTION(1));
 	}
 
-	{
+	if (pDevice->eCommandState == WLAN_ASSOCIATE_WAIT) {
 		pDevice->byReAssocCount++;
 		if ((pDevice->byReAssocCount > 10) && (pDevice->bLinkPass != true)) {  //10 sec timeout
 			printk("Re-association timeout!!!\n");
-- 
2.0.4

