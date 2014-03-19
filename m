Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbaCSNIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:08:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34258 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbaCSNIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:08:34 -0400
Date: Wed, 19 Mar 2014 06:08:20 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-a33f6efc43cb71795bbdaf0251544ff3edbfdb2f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1395169842-1399-1-git-send-email-artagnon@gmail.com>
References: <1395169842-1399-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Update function names in debug messages
Git-Commit-ID: a33f6efc43cb71795bbdaf0251544ff3edbfdb2f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a33f6efc43cb71795bbdaf0251544ff3edbfdb2f
Gitweb:     http://git.kernel.org/tip/a33f6efc43cb71795bbdaf0251544ff3edbfdb2f
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Tue, 18 Mar 2014 15:10:42 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:17:05 -0300

perf evsel: Update function names in debug messages

perf_event_open() was renamed to sys_perf_event_open(); update the debug
messages to reflect this.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395169842-1399-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 26b67b1..5c28d82 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1023,7 +1023,7 @@ retry_sample_id:
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 retry_open:
-			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
+			pr_debug2("sys_perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
 				  pid, cpus->map[cpu], group_fd, flags);
 
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
@@ -1032,7 +1032,7 @@ retry_open:
 								     group_fd, flags);
 			if (FD(evsel, cpu, thread) < 0) {
 				err = -errno;
-				pr_debug2("perf_event_open failed, error %d\n",
+				pr_debug2("sys_perf_event_open failed, error %d\n",
 					  err);
 				goto try_fallback;
 			}
