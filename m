Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027AbaLKOHN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:07:13 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:59048 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934058AbaLKOF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:05:28 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, George Spelvin <linux@horizon.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 5/8] mips/gup: Replace ACCESS_ONCE with READ_ONCE
Date: Thu, 11 Dec 2014 15:05:08 +0100
Message-Id: <1418306712-17245-6-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
References: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121114-0025-0000-0000-000002D5B2A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Change the gup code to replace ACCESS_ONCE with READ_ONCE.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/mips/mm/gup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/mm/gup.c b/arch/mips/mm/gup.c
index 06ce17c..8aa50e3 100644
--- a/arch/mips/mm/gup.c
+++ b/arch/mips/mm/gup.c
@@ -30,7 +30,7 @@ retry:
 
 	return pte;
 #else
-	return ACCESS_ONCE(*ptep);
+	return READ_ONCE(*ptep);
 #endif
 }
 
-- 
1.9.3

