Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab3LDUNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:13:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59329 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933239Ab3LDUHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:18 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/38] perf kvm: Update the 'record' man page entry for new --guest/--host behavior
Date: Wed,  4 Dec 2013 17:06:34 -0300
Message-Id: <1386187622-2928-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

As we have changed the default behavior of 'perf kvm' to --guest
enabled, the parts of the man page that covers the 'record' subcommand
are outdated.

This patch updates it to show the correct output with
--host/--guest/neither/both of them.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/3a3a9c1e05acb5a274d1d8369db5a4c6467d6276.1386197481.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-kvm.txt | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 795322733c56..96a9a1dea727 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -24,10 +24,17 @@ There are a couple of variants of perf kvm:
   of an arbitrary workload.
 
   'perf kvm record <command>' to record the performance counter profile
-  of an arbitrary workload and save it into a perf data file. If both
-  --host and --guest are input, the perf data file name is perf.data.kvm.
-  If there is  no --host but --guest, the file name is perf.data.guest.
-  If there is no --guest but --host, the file name is perf.data.host.
+  of an arbitrary workload and save it into a perf data file. We set the
+  default behavior of perf kvm as --guest, so if neither --host nor --guest
+  is input, the perf data file name is perf.data.guest. If --host is input,
+  the perf data file name is perf.data.kvm. If you want to record data into
+  perf.data.host, please input --host --no-guest. The behaviors are shown as
+  following:
+    Default('')         ->  perf.data.guest
+    --host              ->  perf.data.kvm
+    --guest             ->  perf.data.guest
+    --host --guest      ->  perf.data.kvm
+    --host --no-guest   ->  perf.data.host
 
   'perf kvm report' to display the performance counter profile information
   recorded via perf kvm record.
-- 
1.8.1.4

