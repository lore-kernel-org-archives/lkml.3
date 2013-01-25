Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab3AYOPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 09:15:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:51165 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932348Ab3AYOPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 09:15:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@list.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: [PATCH 08/19] lockdep: avoid warning about unused variables
Date: Fri, 25 Jan 2013 14:14:25 +0000
Message-Id: <1359123276-15833-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359123276-15833-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/Hob6oHYoRPdnBCYy7R4yJ+YVMHa9RNZPzmAURAMFqD
 tC8o1cdK7qfewWQ3pCGEbWYKENA0eU4LJ0aLbcTwRrCjXuVp4I
 JrfhSuxVvcyqHLdOfhDuuDsznkhk+3/hmMDu/vxeqFe+QfCELu
 Uk/PO+Y19bP1pUMsbOIeGbGGC0WnORXNpxFAt336ivfqWaqJ69
 HtbXaxS04BwI7xlBRPi4UNxqpcvejseCRO4puNun+jehG6OngI
 1lygJOIvGJ7gme+rPdF49exKhhX8YuPy8bZrxs+aCeHt8ZGe5W
 MkCSUeP6iE3LjdrWeid3vYrDdl3zLxwrDclzS6+x/cyVLHlb51
 /rbGf9q6S680m7RrwQ1QjBWDHe73NSbUiDew98DtF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When lockdep is disabled, a call to lockdep_assert_held
does not use its argument, which results in a compiler
warning if nothing else in the same function uses
that variable. An instance of this was introduced
by c9a49628819 "nfsd: make client_lock per net".

Without this patch, building ARM cerfcube_defconfig results in:

fs/nfsd/nfs4state.c: In function 'free_client':
fs/nfsd/nfs4state.c:1047:19: error: unused variable 'nn' [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 include/linux/lockdep.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 2bca44b..f05631e 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -410,7 +410,7 @@ struct lock_class_key { };
 
 #define lockdep_depth(tsk)	(0)
 
-#define lockdep_assert_held(l)			do { } while (0)
+#define lockdep_assert_held(l)			do { (void)(l); } while (0)
 
 #define lockdep_recursing(tsk)			(0)
 
-- 
1.8.0

