Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab3DBKCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:02:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51225 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760620Ab3DBKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:02:51 -0400
Date: Tue, 2 Apr 2013 03:01:55 -0700
From: tip-bot for Naohiro Aota <tipbot@zytor.com>
Message-ID: <tip-707ef2e69a53f2dc60cfa2ff5cb4bf5474206f33@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, naota@elisp.net, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        naota@elisp.net, tglx@linutronix.de
In-Reply-To: <87wqswzznx.fsf@locke.i-did-not-set--mail-host-address--so-tickle-me>
References: <87wqswzznx.fsf@locke.i-did-not-set--mail-host-address--so-tickle-me>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Fix dependency for python/perf.so
Git-Commit-ID: 707ef2e69a53f2dc60cfa2ff5cb4bf5474206f33
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 03:02:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  707ef2e69a53f2dc60cfa2ff5cb4bf5474206f33
Gitweb:     http://git.kernel.org/tip/707ef2e69a53f2dc60cfa2ff5cb4bf5474206f33
Author:     Naohiro Aota <naota@elisp.net>
AuthorDate: Sun, 24 Mar 2013 22:37:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Apr 2013 12:23:01 -0300

perf python: Fix dependency for python/perf.so

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
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
