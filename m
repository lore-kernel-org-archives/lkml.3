Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889Ab3BVK0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:26:53 -0500
Received: from mx.anti-virus.by ([93.125.111.29]:52691 "EHLO tux.vba.com.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610Ab3BVK0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:26:39 -0500
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2013 05:26:39 EST
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sergei Trofimovich <slyfox@gentoo.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] tools/perf/Makefile: drop _FORTIFY_SOURCE right before redefinition
Date: Fri, 22 Feb 2013 13:17:54 +0300
Message-Id: <1361528274-27126-1-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

Gentoo's toolchain sets _FORTIFY_SOURCE by default
which leads to very obscure error:

perf # make clean && make
Makefile:455: No libdw.h found or old libdw.h found or elfutils is older than 0.138, disables dwarf support. Please install new elfutils-devel/libdw-dev
Makefile:470: *** No gnu/libc-version.h found, please install glibc-dev[el]/glibc-static.  Stop

Patch explicitely undefines _FORTIFY_SOURCE. Thanks!

CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 tools/perf/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 891bc77..60f083d 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -94,7 +94,7 @@ ifeq ("$(origin DEBUG)", "command line")
   PERF_DEBUG = $(DEBUG)
 endif
 ifndef PERF_DEBUG
-  CFLAGS_OPTIMIZE = -O6 -D_FORTIFY_SOURCE=2
+  CFLAGS_OPTIMIZE = -O6 -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
 endif
 
 ifdef PARSER_DEBUG
-- 
1.8.0

