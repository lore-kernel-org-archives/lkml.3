Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbbAGUco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 15:32:44 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56476 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbbAGUcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 15:32:42 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] next: sh: Fix compile error
Date: Wed,  7 Jan 2015 12:32:28 -0800
Message-Id: <1420662748-28129-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 2.1.0
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.54AD97FF.00F7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 2
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a91ed664749c ("kernel: tighten rules for ACCESS ONCE") results in a
compile failure for sh builds with CONFIG_X2TLB enabled.

arch/sh/mm/gup.c: In function 'gup_get_pte':
arch/sh/mm/gup.c:20:2: error: invalid initializer
make[1]: *** [arch/sh/mm/gup.o] Error 1

Replace ACCESS_ONCE with READ_ONCE to fix the problem.

Fixes: a91ed664749c ("kernel: tighten rules for ACCESS ONCE")
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Compile tested only.

 arch/sh/mm/gup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sh/mm/gup.c b/arch/sh/mm/gup.c
index 37458f3..e113bb4 100644
--- a/arch/sh/mm/gup.c
+++ b/arch/sh/mm/gup.c
@@ -17,7 +17,7 @@
 static inline pte_t gup_get_pte(pte_t *ptep)
 {
 #ifndef CONFIG_X2TLB
-	return ACCESS_ONCE(*ptep);
+	return READ_ONCE(*ptep);
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without
-- 
2.1.0

