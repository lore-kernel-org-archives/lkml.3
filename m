Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3ILQj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:39:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596Ab3ILQj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:39:56 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 1/4] perf tools: Fix 'make install prefix=...' build rule
Date: Thu, 12 Sep 2013 18:39:33 +0200
Message-Id: <1379003976-5839-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
References: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we fail for following make command:

  $ sudo make install prefix=/opt/perf
  ...
      GEN python/perf.so
  install -d -m 755 '/opt/perf/bin'
  install perf '/opt/perf/bin'
  install perf-archive -t '/opt/perf/libexec/perf-core'
  install: accessing `/opt/perf/libexec/perf-core': No such file or directory
  make: *** [install-bin] Error 1

Fixing this by properly creating '/opt/perf/libexec/perf-core'
directory.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index c5dc1ad..229964a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -769,6 +769,7 @@ check: $(OUTPUT)common-cmds.h
 install-bin: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
-- 
1.7.11.7

