Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3JHKl4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 06:41:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37615 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756451Ab3JHKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 06:41:49 -0400
Date: Tue, 8 Oct 2013 03:41:00 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-z7ryi3r1b9dn9smbfnab0fdc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix installation of libexec components
Git-Commit-ID: 027a7e86a17fb2d172f4eb17cd6b0e9f139224fd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 08 Oct 2013 03:41:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  027a7e86a17fb2d172f4eb17cd6b0e9f139224fd
Gitweb:     http://git.kernel.org/tip/027a7e86a17fb2d172f4eb17cd6b0e9f139224fd
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 4 Oct 2013 10:24:17 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 4 Oct 2013 15:16:05 -0300

perf tools: Fix installation of libexec components

Doing a fresh install on a user home directory needs to first make sure
that the ~/libexec/perf-core/ directory is present so that
'perf-archive' like scripts, 'perf test' attr config files and 'perf
script' scripts can be installed.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-z7ryi3r1b9dn9smbfnab0fdc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 3a0ff7f..64c043b 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -770,6 +770,7 @@ check: $(OUTPUT)common-cmds.h
 install-bin: all
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)/scripts/perl/Perf-Trace-Util/lib/Perf/Trace'
