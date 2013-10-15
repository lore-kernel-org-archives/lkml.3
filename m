Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab3JOFW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:22:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32797 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758519Ab3JOFWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:22:23 -0400
Date: Mon, 14 Oct 2013 22:21:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-8xuaupgmy82v7sha3l09oaux@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify socket 'family' arg
Git-Commit-ID: e10bce815d5c0e7eb793231e4334839b2cd0d81f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:21:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e10bce815d5c0e7eb793231e4334839b2cd0d81f
Gitweb:     http://git.kernel.org/tip/e10bce815d5c0e7eb793231e4334839b2cd0d81f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 4 Sep 2013 10:27:41 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:20 -0300

perf trace: Beautify socket 'family' arg

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8xuaupgmy82v7sha3l09oaux@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index eb0bbff..6280166 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -255,6 +255,16 @@ static DEFINE_STRARRAY(fcntl_cmds);
 static const char *sighow[] = { "BLOCK", "UNBLOCK", "SETMASK", };
 static DEFINE_STRARRAY(sighow);
 
+static const char *socket_families[] = {
+	"UNSPEC", "LOCAL", "INET", "AX25", "IPX", "APPLETALK", "NETROM",
+	"BRIDGE", "ATMPVC", "X25", "INET6", "ROSE", "DECnet", "NETBEUI",
+	"SECURITY", "KEY", "NETLINK", "PACKET", "ASH", "ECONET", "ATMSVC",
+	"RDS", "SNA", "IRDA", "PPPOX", "WANPIPE", "LLC", "IB", "CAN", "TIPC",
+	"BLUETOOTH", "IUCV", "RXRPC", "ISDN", "PHONET", "IEEE802154", "CAIF",
+	"ALG", "NFC", "VSOCK",
+};
+static DEFINE_STRARRAY(socket_families);
+
 static size_t syscall_arg__scnprintf_open_flags(char *bf, size_t size,
 					       struct syscall_arg *arg)
 {
@@ -429,7 +439,9 @@ static struct syscall_fmt {
 	{ .name	    = "setitimer",  .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* which */ },
 	  .arg_parm	 = { [0] = &strarray__itimers, /* which */ }, },
-	{ .name	    = "socket",	    .errmsg = true, },
+	{ .name	    = "socket",	    .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_STRARRAY, /* family */ },
+	  .arg_parm	 = { [0] = &strarray__socket_families, /* family */ }, },
 	{ .name	    = "stat",	    .errmsg = true, .alias = "newstat", },
 	{ .name	    = "tgkill",	    .errmsg = true,
 	  .arg_scnprintf = { [2] = SCA_SIGNUM, /* sig */ }, },
