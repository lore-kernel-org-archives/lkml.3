Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3CRQds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:33:48 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49398
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796Ab3CRQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/54] perf tests: Make attr script test event cpu
Date: Mon, 18 Mar 2013 13:24:52 -0300
Message-Id: <1363623939-10748-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
 tools/perf/tests/attr.py          |    1 +
 tools/perf/tests/attr/base-record |    1 +
 tools/perf/tests/attr/base-stat   |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

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
1.7.1

