Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab3AYWtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:49:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64134 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3AYWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:45:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: [PATCH 08/19] lockdep: avoid warning about unused variables
Date: Fri, 25 Jan 2013 22:44:07 +0000
Message-Id: <1359153858-31992-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1359153858-31992-1-git-send-email-arnd@arndb.de>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:F65E/Z7RZJ8+lH8eCZhgd7CbbijzTjSQ9mWJmsfdpAg
 61ntjX/pqtf/8J1eS6jf0YlhQ9McZH1TEExWCOqcVzjTKsF81E
 1Kg+sn6q+kx7iyUOYfue02qxk/Cv/r71YrR7rk5OnbDQYUt558
 KosNOuyyCSnarOnQ+EkULSlSo+wjUZJCWKhnjCkAQ+DxT6Nrwj
 fnKbbj6AsW9Qxm3EnUr8cfKzVC8SJ5hrsXwg6n7bl3VQBRwOhB
 S6cDoqAY5qh1ER5sy2ntiri0x6HYzLljXczhmpRkQE2v5bLU7d
 Jj8Ld/yzDS6RVPwaknbhf1bV/t9a18aJo8+ZEB2hE8F/FGS6d5
 q4SzW8/K7NDWAiq5RvitNetBpUfAjIx3d9fWoHYKL
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

