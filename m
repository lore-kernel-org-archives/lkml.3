Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbaLCWad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:30:33 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:55892 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaLCWa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:30:28 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 4/9] x86/gup: Replace ACCESS_ONCE with READ_ONCE
Date: Wed,  3 Dec 2014 23:30:16 +0100
Message-Id: <1417645821-54731-5-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120322-0041-0000-0000-0000025A6393
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
(https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the gup code to replace ACCESS_ONCE with READ_ONCE.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/x86/mm/gup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 207d9aef..d754782 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -15,7 +15,7 @@
 static inline pte_t gup_get_pte(pte_t *ptep)
 {
 #ifndef CONFIG_X86_PAE
-	return ACCESS_ONCE(*ptep);
+	return READ_ONCE(*ptep);
 #else
 	/*
 	 * With get_user_pages_fast, we walk down the pagetables without taking
-- 
1.9.3

