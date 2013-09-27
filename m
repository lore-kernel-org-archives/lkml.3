Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979Ab3I0IEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:04:15 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:54800 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab3I0IEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:04:01 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tony Luck <tony.luck@intel.com>, Waiman Long <waiman.long@hp.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/3] lockref: use cpu_relax_simple()
Date: Fri, 27 Sep 2013 10:03:53 +0200
Message-Id: <1380269034-38521-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1380269034-38521-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1380269034-38521-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092708-0342-0000-0000-000006660F3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of cpu_relax_simple() so architectures can override the default
cpu_relax() semantics.
This is especially useful for s390, where cpu_relax() means that the we
yield() the current (virtual) cpu and therefore is very expensive.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 lib/lockref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index 677d036..1a00c33 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -19,7 +19,7 @@
 		if (likely(old.lock_count == prev.lock_count)) {		\
 			SUCCESS;						\
 		}								\
-		cpu_relax();							\
+		cpu_relax_simple();						\
 	}									\
 } while (0)
 
-- 
1.8.3.4

