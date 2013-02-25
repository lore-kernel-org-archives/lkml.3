Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759181Ab3BYJxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 04:53:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759073Ab3BYJxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 04:53:17 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 3/5] perf tests: Make attr script test event cpu
Date: Mon, 25 Feb 2013 10:52:50 +0100
Message-Id: <1361785972-7431-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
References: <1361785972-7431-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make attr script to check for 'cpu' when testing
event properties. This will allow us to check the
'-C X' option for both record and stat commands.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
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
-- 
1.7.11.7

