Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160995Ab3BFWRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:17:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37536 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab3BFWRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:17:49 -0500
Date: Wed, 6 Feb 2013 14:17:27 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8pf64bsdywg1gl9m55ul77hg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Link with sysfs.o
Git-Commit-ID: 88fd2b6a76264e9e14463f532caae09d82a53207
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:17:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  88fd2b6a76264e9e14463f532caae09d82a53207
Gitweb:     http://git.kernel.org/tip/88fd2b6a76264e9e14463f532caae09d82a53207
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 6 Feb 2013 17:21:47 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:28 -0300

perf python: Link with sysfs.o

So that we fix this regression:

[root@sandy linux]# perf test -v 15
15: Try 'use perf' in python, checking link problems       :
--- start ---
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
ImportError: /home/acme/git/build/perf/python/perf.so: undefined symbol: sysfs_find_mountpoint
---- end ----
Try 'use perf' in python, checking link problems: FAILED!
[root@sandy linux]#

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8pf64bsdywg1gl9m55ul77hg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/python-ext-sources | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index c40c2d3..64536a9 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -18,4 +18,5 @@ util/cgroup.c
 util/debugfs.c
 util/rblist.c
 util/strlist.c
+util/sysfs.c
 ../../lib/rbtree.c
