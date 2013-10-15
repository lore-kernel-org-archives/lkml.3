Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab3JOFYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:24:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32878 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3JOFXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:23:14 -0400
Date: Mon, 14 Oct 2013 22:22:07 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-myqozw43hk8z2r5hsupzdk82@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Don't print zeroed args
Git-Commit-ID: 22ae5cf1c9b4e27a3efe96d8fa6d038560a2cf23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:22:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22ae5cf1c9b4e27a3efe96d8fa6d038560a2cf23
Gitweb:     http://git.kernel.org/tip/22ae5cf1c9b4e27a3efe96d8fa6d038560a2cf23
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 12 Sep 2013 11:27:34 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:11:06 -0300

perf trace: Don't print zeroed args

This way we make the output more compact.

If somebody complain (and provide a sane reason why we would like to see
zeroes) we can make it an optional, ~/.perfconfig configurable knob.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-myqozw43hk8z2r5hsupzdk82@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 903416c..516f6b3 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -818,6 +818,9 @@ static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
 			if (arg.mask & bit)
 				continue;
 
+			if (args[arg.idx] == 0)
+				continue;
+
 			printed += scnprintf(bf + printed, size - printed,
 					     "%s%s: ", printed ? ", " : "", field->name);
 			if (sc->arg_scnprintf && sc->arg_scnprintf[arg.idx]) {
