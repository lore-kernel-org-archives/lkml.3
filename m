Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3CXNiB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 09:38:01 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:54242 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3CXNh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 09:37:59 -0400
From: Naohiro Aota <naota@elisp.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] perf: Fix dependency for python/perf.so
Date: Sun, 24 Mar 2013 22:37:54 +0900
Message-ID: <87wqswzznx.fsf@locke.i-did-not-set--mail-host-address--so-tickle-me>
User-Agent: Gnus/5.130006 (Ma Gnus v0.6) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

python/perf.so lacks dependency for libtraceevent.a so that it cause
the following error building python/perf.so. This patch introduce the
dependency for it.

   $ make python/perf.so
       CHK -fstack-protector-all
       CHK -Wstack-protector
       CHK -Wvolatile-register-var
       CHK -D_FORTIFY_SOURCE=2
       CHK bionic
       CHK libelf
       CHK libdw
       CHK libunwind
       CHK -DLIBELF_MMAP
       CHK libaudit
       CHK libnewt
       CHK gtk2
       CHK -DHAVE_GTK_INFO_BAR
       CHK perl
       CHK python
       CHK python version
       CHK libbfd
       CHK -DHAVE_STRLCPY
       CHK -DHAVE_ON_EXIT
       CHK -DBACKTRACE_SUPPORT
       CHK libnuma
       GEN python/perf.so
   x86_64-pc-linux-gnu-gcc: error: ../lib/traceevent/libtraceevent.a: No such file or directory
   error: command 'x86_64-pc-linux-gnu-gcc' failed with exit status 1
   cp: cannot stat 'python_ext_build/lib/perf.so': No such file or directory
   make: *** [python/perf.so] Error 1

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bb74c79..d10ccda 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -262,7 +262,7 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
-PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT)
 
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
-- 
1.8.1.5

