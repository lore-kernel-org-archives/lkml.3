Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaBEXNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 18:13:24 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:51657 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222AbaBEXNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:13:23 -0500
Message-ID: <52F2C56F.5030309@oracle.com>
Date: Wed, 05 Feb 2014 18:12:47 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [GIT PULL] liblockdep fixes for v3.14
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 65370bdf881e20907e7a53abab9b8c0bc5f60a6b:

   Merge branch 'linus' into core/locking (2014-02-02 09:43:20 +0100)

are available in the git repository at:


   https://github.com/sashalevin/liblockdep.git liblockdep-fixes

for you to fetch changes up to a521b55af18ac72c969c1ba41b660d77dae37357:

   liblockdep: add a stub for new rcu_is_watching (2014-02-05 18:03:54 -0500)

----------------------------------------------------------------
Ira W. Snyder (3):
       tools: lockdep: fix initialization code path
       tools: lockdep: fix include of asm/hash.h
       tools: lockdep: add include directory to allow tests to compile

Sasha Levin (2):
       liblockdep: mark runtests.sh as executable
       liblockdep: add a stub for new rcu_is_watching

  tools/lib/lockdep/Makefile             | 2 +-
  tools/lib/lockdep/preload.c            | 2 +-
  tools/lib/lockdep/run_tests.sh         | 0
  tools/lib/lockdep/uinclude/asm/hash.h  | 6 ++++++
  tools/lib/lockdep/uinclude/linux/rcu.h | 5 +++++
  5 files changed, 13 insertions(+), 2 deletions(-)
  mode change 100644 => 100755 tools/lib/lockdep/run_tests.sh
  create mode 100644 tools/lib/lockdep/uinclude/asm/hash.h

diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
index da8b7aa..e8dd749 100644
--- a/tools/lib/lockdep/Makefile
+++ b/tools/lib/lockdep/Makefile
@@ -112,7 +112,7 @@ export Q VERBOSE

  LIBLOCKDEP_VERSION = $(LL_VERSION).$(LL_PATCHLEVEL).$(LL_EXTRAVERSION)

-INCLUDES = -I. -I/usr/local/include -I./uinclude $(CONFIG_INCLUDES)
+INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include $(CONFIG_INCLUDES)

  # Set compile option CFLAGS if not set elsewhere
  CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING 
-DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
diff --git a/tools/lib/lockdep/preload.c b/tools/lib/lockdep/preload.c
index f8465a8..23bd69c 100644
--- a/tools/lib/lockdep/preload.c
+++ b/tools/lib/lockdep/preload.c
@@ -418,7 +418,7 @@ int pthread_rwlock_unlock(pthread_rwlock_t *rwlock)

  __attribute__((constructor)) static void init_preload(void)
  {
-	if (__init_state != done)
+	if (__init_state == done)
  		return;

  #ifndef __GLIBC__
diff --git a/tools/lib/lockdep/run_tests.sh b/tools/lib/lockdep/run_tests.sh
old mode 100644
new mode 100755
diff --git a/tools/lib/lockdep/uinclude/asm/hash.h b/tools/lib/lockdep/uinclude/asm/hash.h
new file mode 100644
index 0000000..d82b170b
--- /dev/null
+++ b/tools/lib/lockdep/uinclude/asm/hash.h
@@ -0,0 +1,6 @@
+#ifndef __ASM_GENERIC_HASH_H
+#define __ASM_GENERIC_HASH_H
+
+/* Stub */
+
+#endif /* __ASM_GENERIC_HASH_H */
diff --git a/tools/lib/lockdep/uinclude/linux/rcu.h b/tools/lib/lockdep/uinclude/linux/rcu.h
index 4c99fcb..042ee8e 100644
--- a/tools/lib/lockdep/uinclude/linux/rcu.h
+++ b/tools/lib/lockdep/uinclude/linux/rcu.h
@@ -13,4 +13,9 @@ static inline int rcu_is_cpu_idle(void)
  	return 1;
  }

+static inline bool rcu_is_watching(void)
+{
+	return false;
+}
+
  #endif
