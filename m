Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3JOF27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:28:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33355 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3JOF24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:28:56 -0400
Date: Mon, 14 Oct 2013 22:28:16 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-gd68zmnwbbofsv5m6w18intw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify mlock & friends 'addr' arg
Git-Commit-ID: 3d903aa74a98da2836249bce86aaf557781239c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:28:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d903aa74a98da2836249bce86aaf557781239c9
Gitweb:     http://git.kernel.org/tip/3d903aa74a98da2836249bce86aaf557781239c9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 24 Sep 2013 00:09:38 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 17:42:54 -0300

perf trace: Beautify mlock & friends 'addr' arg

Printing it as an hex number.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-gd68zmnwbbofsv5m6w18intw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 3ca6a85..12a275d 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -635,6 +635,10 @@ static struct syscall_fmt {
 	{ .name     = "madvise",    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	 /* start */
 			     [2] = SCA_MADV_BHV, /* behavior */ }, },
+	{ .name	    = "mlock",	    .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
+	{ .name	    = "mlockall",   .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "mmap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
 			     [2] = SCA_MMAP_PROT, /* prot */
@@ -645,6 +649,8 @@ static struct syscall_fmt {
 	{ .name	    = "mremap",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */
 			     [4] = SCA_HEX, /* new_addr */ }, },
+	{ .name	    = "munlock",    .errmsg = true,
+	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "munmap",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* addr */ }, },
 	{ .name	    = "open",	    .errmsg = true,
