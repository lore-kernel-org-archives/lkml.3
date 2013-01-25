Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab3AYLPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:15:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41431 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3AYLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:15:00 -0500
Date: Fri, 25 Jan 2013 03:14:20 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-qo2jevp1bdcnh8khzdazs17s@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, xiaoguangrong@linux.vnet.ibm.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Initialize file_name var to fix segfault
Git-Commit-ID: 20914ce5b9e1ef4a35f1f09a2c9c8fb8eb1c4d86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:14:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20914ce5b9e1ef4a35f1f09a2c9c8fb8eb1c4d86
Gitweb:     http://git.kernel.org/tip/20914ce5b9e1ef4a35f1f09a2c9c8fb8eb1c4d86
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 19 Dec 2012 10:59:29 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:13 -0300

perf kvm: Initialize file_name var to fix segfault

The 3786063 commit:

    perf kvm: Rename perf_kvm to perf_kvm_stat

Moved the file_name from inside a local struct var that initialized some
of its members, thus zero initializing the not explicitely initialized
variables, one of which was 'file_name', to a standalone local variable,
but forgot to initialize it explicitely to NULL, so it then got some
undefined value, causing a segfault in strdup when it wasn't, by luck,
zero.

Fix it by explicitely initializing it to NULL.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-qo2jevp1bdcnh8khzdazs17s@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index ca3f80e..37a769d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -973,8 +973,7 @@ __cmd_buildid_list(const char *file_name, int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	const char *file_name;
-
+	const char *file_name = NULL;
 	const struct option kvm_options[] = {
 		OPT_STRING('i', "input", &file_name, "file",
 			   "Input file name"),
