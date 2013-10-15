Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab3JOFrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:47:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab3JOFXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:23:05 -0400
Date: Mon, 14 Oct 2013 22:21:59 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-770480592084d2c114adedfbe6740e345aaf2279@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1378319865-55695-2-git-send-email-dsahern@gmail.com>
References: <1378319865-55695-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Remove duplicate mmap entry in syscall_fmts array
Git-Commit-ID: 770480592084d2c114adedfbe6740e345aaf2279
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:22:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  770480592084d2c114adedfbe6740e345aaf2279
Gitweb:     http://git.kernel.org/tip/770480592084d2c114adedfbe6740e345aaf2279
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 4 Sep 2013 12:37:44 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:10:56 -0300

perf trace: Remove duplicate mmap entry in syscall_fmts array

Entries in syscall_fmts need to be in alphabetical order, and the
duplicate entry breaks bsearch on new entries around this duplicate
entry.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1378319865-55695-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index bc21140..903416c 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -461,7 +461,6 @@ static struct syscall_fmt {
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
 	{ .name	    = "brk",	    .hexret = true,
 	  .arg_scnprintf = { [0] = SCA_HEX, /* brk */ }, },
-	{ .name	    = "mmap",	    .hexret = true, },
 	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "fcntl",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_STRARRAY, /* cmd */ },
