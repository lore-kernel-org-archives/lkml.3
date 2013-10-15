Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab3JOFiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:38:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33646 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab3JOFcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:32:22 -0400
Date: Mon, 14 Oct 2013 22:31:35 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-afajwap3mr60dfl4qpdl1pxn@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Initial beautifier for ioctl's 'cmd'
  arg
Git-Commit-ID: 78645cf3ed32860a3e83b8e35aa469f5b844a4ba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:31:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78645cf3ed32860a3e83b8e35aa469f5b844a4ba
Gitweb:     http://git.kernel.org/tip/78645cf3ed32860a3e83b8e35aa469f5b844a4ba
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 8 Oct 2013 17:43:20 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:18:02 -0300

perf trace: Initial beautifier for ioctl's 'cmd' arg

 [root@zoo linux]# trace -e ioctl | grep -v "cmd: 0x" | head -10
      0.386 ( 0.001 ms): trace/1602 ioctl(fd: 1<pipe:[127057]>, cmd: TCGETS, arg: 0x7fff59fcb4d0          ) = -1 ENOTTY Inappropriate ioctl for device
   1459.368 ( 0.002 ms): inotify_reader/10352 ioctl(fd: 18<anon_inode:inotify>, cmd: FIONREAD, arg: 0x7fb835228bcc  ) = 0
   1463.586 ( 0.002 ms): inotify_reader/10352 ioctl(fd: 18<anon_inode:inotify>, cmd: FIONREAD, arg: 0x7fb835228bcc  ) = 0
   1463.611 ( 0.002 ms): inotify_reader/10352 ioctl(fd: 18<anon_inode:inotify>, cmd: FIONREAD, arg: 0x7fb835228bcc  ) = 0
   3740.526 ( 0.002 ms): awk/1612 ioctl(fd: 1<pipe:[128265]>, cmd: TCGETS, arg: 0x7fff4d166b90          ) = -1 ENOTTY Inappropriate ioctl for device
   3740.704 ( 0.001 ms): awk/1612 ioctl(fd: 3</proc/meminfo>, cmd: TCGETS, arg: 0x7fff4d1669a0          ) = -1 ENOTTY Inappropriate ioctl for device
   3742.550 ( 0.002 ms): ps/1614 ioctl(fd: 1<pipe:[128266]>, cmd: TIOCGWINSZ, arg: 0x7fff591762b0      ) = -1 ENOTTY Inappropriate ioctl for device
   3742.555 ( 0.003 ms): ps/1614 ioctl(fd: 2<socket:[19550]>, cmd: TIOCGWINSZ, arg: 0x7fff591762b0     ) = -1 ENOTTY Inappropriate ioctl for device
   3742.558 ( 0.002 ms): ps/1614 ioctl(cmd: TIOCGWINSZ, arg: 0x7fff591762b0                            ) = -1 ENOTTY Inappropriate ioctl for device
   3742.572 ( 0.002 ms): ps/1614 ioctl(fd: 1<pipe:[128266]>, cmd: TCGETS, arg: 0x7fff59176220          ) = -1 ENOTTY Inappropriate ioctl for device
 [root@zoo linux]#

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-afajwap3mr60dfl4qpdl1pxn@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0d4af1d..19ddcab 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -81,6 +81,14 @@ static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
 
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
+static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
+						 struct syscall_arg *arg)
+{
+	return __syscall_arg__scnprintf_strarray(bf, size, "%#x", arg);
+}
+
+#define SCA_STRHEXARRAY syscall_arg__scnprintf_strhexarray
+
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 					struct syscall_arg *arg);
 
@@ -633,6 +641,28 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+#define TCGETS		0x5401
+
+static const char *tioctls[] = {
+	"TCGETS", "TCSETS", "TCSETSW", "TCSETSF", "TCGETA", "TCSETA", "TCSETAW",
+	"TCSETAF", "TCSBRK", "TCXONC", "TCFLSH", "TIOCEXCL", "TIOCNXCL",
+	"TIOCSCTTY", "TIOCGPGRP", "TIOCSPGRP", "TIOCOUTQ", "TIOCSTI",
+	"TIOCGWINSZ", "TIOCSWINSZ", "TIOCMGET", "TIOCMBIS", "TIOCMBIC",
+	"TIOCMSET", "TIOCGSOFTCAR", "TIOCSSOFTCAR", "FIONREAD", "TIOCLINUX",
+	"TIOCCONS", "TIOCGSERIAL", "TIOCSSERIAL", "TIOCPKT", "FIONBIO",
+	"TIOCNOTTY", "TIOCSETD", "TIOCGETD", "TCSBRKP", [0x27] = "TIOCSBRK",
+	"TIOCCBRK", "TIOCGSID", "TCGETS2", "TCSETS2", "TCSETSW2", "TCSETSF2",
+	"TIOCGRS485", "TIOCSRS485", "TIOCGPTN", "TIOCSPTLCK",
+	"TIOCGDEV||TCGETX", "TCSETX", "TCSETXF", "TCSETXW", "TIOCSIG",
+	"TIOCVHANGUP", "TIOCGPKT", "TIOCGPTLCK", "TIOCGEXCL",
+	[0x50] = "FIONCLEX", "FIOCLEX", "FIOASYNC", "TIOCSERCONFIG",
+	"TIOCSERGWILD", "TIOCSERSWILD", "TIOCGLCKTRMIOS", "TIOCSLCKTRMIOS",
+	"TIOCSERGSTRUCT", "TIOCSERGETLSR", "TIOCSERGETMULTI", "TIOCSERSETMULTI",
+	"TIOCMIWAIT", "TIOCGICOUNT", [0x60] = "FIOQSIZE",
+};
+
+static DEFINE_STRARRAY_OFFSET(tioctls, 0x5401);
+
 #define STRARRAY(arg, name, array) \
 	  .arg_scnprintf = { [arg] = SCA_STRARRAY, }, \
 	  .arg_parm	 = { [arg] = &strarray__##array, }
@@ -713,7 +743,9 @@ static struct syscall_fmt {
 	{ .name	    = "getrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ 
-			     [2] = SCA_HEX, /* arg */ }, },
+			     [1] = SCA_STRHEXARRAY, /* cmd */
+			     [2] = SCA_HEX, /* arg */ },
+	  .arg_parm	 = { [1] = &strarray__tioctls, /* cmd */ }, },
 	{ .name	    = "kill",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "linkat",	    .errmsg = true,
