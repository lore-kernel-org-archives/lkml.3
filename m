Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3K3Myn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:54:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59830 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3K3Myk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:54:40 -0500
Date: Sat, 30 Nov 2013 04:54:05 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-26286141a43251bed548349efbf60b61f1c433e8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <20131126125412.GJ1267@krava.brq.redhat.com>
References: <20131126125412.GJ1267@krava.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix tags/TAGS targets rebuilding
Git-Commit-ID: 26286141a43251bed548349efbf60b61f1c433e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:54:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  26286141a43251bed548349efbf60b61f1c433e8
Gitweb:     http://git.kernel.org/tip/26286141a43251bed548349efbf60b61f1c433e8
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 26 Nov 2013 13:54:12 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 16:47:14 -0300

perf tools: Fix tags/TAGS targets rebuilding

Once the tags/TAGS file is generated it's never rebuilt until it's
removed by hand.

The reason is that the Makefile does not treat tags/TAGS as targets but
as files and thus won't rebuilt them once they are in place.

Adding PHONY tags/TAGS targets into Makefile.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/20131126125412.GJ1267@krava.brq.redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 4835618..eefb9fb 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -60,8 +60,11 @@ endef
 
 #
 # Needed if no target specified:
+# (Except for tags and TAGS targets. The reason is that the
+# Makefile does not treat tags/TAGS as targets but as files
+# and thus won't rebuilt them once they are in place.)
 #
-all:
+all tags TAGS:
 	$(print_msg)
 	$(make)
 
@@ -77,3 +80,5 @@ clean:
 %:
 	$(print_msg)
 	$(make)
+
+.PHONY: tags TAGS
