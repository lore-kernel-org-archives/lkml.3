Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3JOFlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:41:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab3JOF3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:12 -0400
Date: Mon, 14 Oct 2013 22:28:33 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ch4smqz8b5fmgrte7c5e4fuw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add 'trace' alias to 'perf trace'
Git-Commit-ID: b52bc23414124b0d37fd9933b5a894d9b4a9720d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:28:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b52bc23414124b0d37fd9933b5a894d9b4a9720d
Gitweb:     http://git.kernel.org/tip/b52bc23414124b0d37fd9933b5a894d9b4a9720d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 24 Sep 2013 11:56:36 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:10 -0300

perf trace: Add 'trace' alias to 'perf trace'

Make 'perf trace' more accessible by aliasing it to just 'trace':

  [root@zoo linux]# trace --duration 15 -a -e futex sleep 1
   110.092 (16.188 ms): libvirtd/1166 futex(uaddr: 0x185b344, op: WAIT|PRIV, val: 174293                    ) = 0
   110.101 (15.903 ms): libvirtd/1171 futex(uaddr: 0x185b3dc, op: WAIT|PRIV, val: 139265                    ) = 0
   111.594 (15.776 ms): libvirtd/1165 futex(uaddr: 0x185b344, op: WAIT|PRIV, val: 174295                    ) = 0
   111.610 (15.969 ms): libvirtd/1169 futex(uaddr: 0x185b3dc, op: WAIT|PRIV, val: 139267                    ) = 0
   113.556 (16.216 ms): libvirtd/1168 futex(uaddr: 0x185b3dc, op: WAIT|PRIV, val: 139269                    ) = 0
   291.265 (199.508 ms): chromium-brows/15830 futex(uaddr: 0x7fff2986bcb4, op: WAIT_BITSET|PRIV|CLKRT, val: 1, utime: 0x7fff2986bab0, val3: 4294967295) = -1 ETIMEDOUT Connection timed out
     360.354 (69.053 ms): chromium-brows/15830 futex(uaddr: 0x7fff2986bcb4, op: WAIT_BITSET|PRIV|CLKRT, val: 1, utime: 0x7fff2986bab0, val3: 4294967295) = -1 ETIMEDOUT Connection timed out
  [root@zoo linux]#

I.e. looking for futex calls that take at least 15ms, system wide, during a one
second window. Now to get callchains into 'trace' to figure out what are those
locks :-)

Requested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ch4smqz8b5fmgrte7c5e4fuw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf | 2 ++
 tools/perf/perf.c        | 9 ++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 1f13615..2badb08 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -78,6 +78,7 @@ CC = $(CROSS_COMPILE)gcc
 AR = $(CROSS_COMPILE)ar
 
 RM      = rm -f
+LN      = ln -f
 MKDIR   = mkdir
 FIND    = find
 INSTALL = install
@@ -809,6 +810,7 @@ install-gtk:
 install-bin: all install-gtk
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(bindir_SQ)'
 	$(INSTALL) $(OUTPUT)perf '$(DESTDIR_SQ)$(bindir_SQ)'
+	$(LN) '$(DESTDIR_SQ)$(bindir_SQ)/perf' '$(DESTDIR_SQ)$(bindir_SQ)/trace'
 	$(INSTALL) -d -m 755 '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 	$(INSTALL) $(OUTPUT)perf-archive -t '$(DESTDIR_SQ)$(perfexec_instdir_SQ)'
 ifndef NO_LIBPERL
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 6265778..8b38b4e 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -481,7 +481,14 @@ int main(int argc, const char **argv)
 		fprintf(stderr, "cannot handle %s internally", cmd);
 		goto out;
 	}
-
+#ifdef HAVE_LIBAUDIT_SUPPORT
+	if (!prefixcmp(cmd, "trace")) {
+		set_buildid_dir();
+		setup_path();
+		argv[0] = "trace";
+		return cmd_trace(argc, argv, NULL);
+	}
+#endif
 	/* Look for flags.. */
 	argv++;
 	argc--;
