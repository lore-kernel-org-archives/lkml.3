Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab3C1REu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:04:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36359 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784Ab3C1RC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:02:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Naohiro Aota <naota@elisp.net>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 33/36] perf python: Fix dependency for python/perf.so
Date: Thu, 28 Mar 2013 14:02:33 -0300
Message-Id: <1364490156-32064-34-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1364490156-32064-1-git-send-email-acme@infradead.org>
References: <1364490156-32064-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naohiro Aota <naota@elisp.net>

The python/perf.so binding lacks dependency for libtraceevent.a so that
it cause the following error building python/perf.so. This patch
introduce the dependency for it.

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
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/87wqswzznx.fsf@locke.i-did-not-set--mail-host-address--so-tickle-me
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 07feae7..8b4c952 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -272,7 +272,7 @@ export PYTHON_EXTBUILD_LIB PYTHON_EXTBUILD_TMP
 python-clean := rm -rf $(PYTHON_EXTBUILD) $(OUTPUT)python/perf.so
 
 PYTHON_EXT_SRCS := $(shell grep -v ^\# util/python-ext-sources)
-PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py
+PYTHON_EXT_DEPS := util/python-ext-sources util/setup.py $(LIBTRACEEVENT)
 
 $(OUTPUT)python/perf.so: $(PYTHON_EXT_SRCS) $(PYTHON_EXT_DEPS)
 	$(QUIET_GEN)CFLAGS='$(BASIC_CFLAGS)' $(PYTHON_WORD) util/setup.py \
-- 
1.7.1

