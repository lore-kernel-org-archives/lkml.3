Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab3LDJ7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:59:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab3LDJ6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:58:31 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9189160"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: dsahern@gmail.com, jolsa@redhat.com, acme@ghostprotocols.net,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 3/5] perf tools: Update the Document for perf kvm record for new behavior.
Date: Wed, 4 Dec 2013 17:56:41 -0500
Message-Id: <3a3a9c1e05acb5a274d1d8369db5a4c6467d6276.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:21,
	Serialize complete at 2013/12/04 17:58:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we have changed the default behavior of perf kvm to --guest enabled,
the document about perf kvm record is outdated. This patch update it to
show the correct output with --host/--guest/neither/both of them.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-kvm.txt | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 6a06cef..830613a 100644
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
1.8.2.1

