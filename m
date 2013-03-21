Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3CUK44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 06:56:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56057 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab3CUK4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 06:56:55 -0400
Date: Thu, 21 Mar 2013 03:55:12 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-c21d0030cfe17d87f8ad80a4205c8203bdb3949b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, oleg@redhat.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1361785972-7431-4-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Make attr script test event cpu
Git-Commit-ID: c21d0030cfe17d87f8ad80a4205c8203bdb3949b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 03:55:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c21d0030cfe17d87f8ad80a4205c8203bdb3949b
Gitweb:     http://git.kernel.org/tip/c21d0030cfe17d87f8ad80a4205c8203bdb3949b
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Mon, 25 Feb 2013 10:52:50 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Mar 2013 13:06:00 -0300

perf tests: Make attr script test event cpu

Make attr script to check for 'cpu' when testing event properties. This
will allow us to check the '-C X' option for both record and stat
commands.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1361785972-7431-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.py          | 1 +
 tools/perf/tests/attr/base-record | 1 +
 tools/perf/tests/attr/base-stat   | 1 +
 3 files changed, 3 insertions(+)

diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index e0ea513..c9b4b62 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -24,6 +24,7 @@ class Unsup(Exception):
 
 class Event(dict):
     terms = [
+        'cpu',
         'flags',
         'type',
         'size',
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index 5bc3880..b4fc835 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -2,6 +2,7 @@
 fd=1
 group_fd=-1
 flags=0
+cpu=*
 type=0|1
 size=96
 config=0
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 4bd79a8..748ee94 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -2,6 +2,7 @@
 fd=1
 group_fd=-1
 flags=0
+cpu=*
 type=0
 size=96
 config=0
