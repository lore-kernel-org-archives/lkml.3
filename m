Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaGJOzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 10:55:03 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:46874 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbaGJOzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 10:55:00 -0400
Date: Thu, 10 Jul 2014 10:54:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue fixes for v3.16-rc4
Message-ID: <20140710145454.GC6609@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

One patch to fix a typo in percpu section name.  Given how long the
bug has been there and that there hasn't been any report of brekage,
it's unlikely to cause actual issues.

Thanks.

The following changes since commit ebe06187bf2aec10d537ce4595e416035367d703:

  epoll: fix use-after-free in eventpoll_release_file (2014-06-16 17:21:59 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.16-fixes

for you to fetch changes up to 330d282216d6e4d845a21b72572dc4df4122e8fa:

  core: fix typo in percpu read_mostly section (2014-07-01 16:45:22 -0400)

----------------------------------------------------------------
Zhengyu He (1):
      core: fix typo in percpu read_mostly section

 include/asm-generic/vmlinux.lds.h | 2 +-
 include/linux/percpu-defs.h       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 471ba48..c1c0b0c 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -693,7 +693,7 @@
 	. = ALIGN(PAGE_SIZE);						\
 	*(.data..percpu..page_aligned)					\
 	. = ALIGN(cacheline);						\
-	*(.data..percpu..readmostly)					\
+	*(.data..percpu..read_mostly)					\
 	. = ALIGN(cacheline);						\
 	*(.data..percpu)						\
 	*(.data..percpu..shared_aligned)				\
diff --git a/include/linux/percpu-defs.h b/include/linux/percpu-defs.h
index a5fc7d0..dec01d6 100644
--- a/include/linux/percpu-defs.h
+++ b/include/linux/percpu-defs.h
@@ -146,10 +146,10 @@
  * Declaration/definition used for per-CPU variables that must be read mostly.
  */
 #define DECLARE_PER_CPU_READ_MOSTLY(type, name)			\
-	DECLARE_PER_CPU_SECTION(type, name, "..readmostly")
+	DECLARE_PER_CPU_SECTION(type, name, "..read_mostly")
 
 #define DEFINE_PER_CPU_READ_MOSTLY(type, name)				\
-	DEFINE_PER_CPU_SECTION(type, name, "..readmostly")
+	DEFINE_PER_CPU_SECTION(type, name, "..read_mostly")
 
 /*
  * Intermodule exports for per-CPU variables.  sparse forgets about
