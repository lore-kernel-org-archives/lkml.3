Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3LDJ6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:58:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755305Ab3LDJ6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:58:33 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9189163"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: dsahern@gmail.com, jolsa@redhat.com, acme@ghostprotocols.net,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/5] perf tools: Add more detail about buildid-list in Document of perf-kvm.
Date: Wed, 4 Dec 2013 17:56:42 -0500
Message-Id: <d605a805486340b53bc261aa64d7632ad0a8cf53.1386197481.git.yangds.fnst@cn.fujitsu.com>
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

As the buildid is read from /sys/kernel/notes, then if we use perf kvm buildid-list
with a perf data file captured by perf kvm record with --guestkallsyms and --guestmodules,
there is no result in output. This patch add a explanation about it and add a limit
of using perf kvm buildid-list.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/Documentation/perf-kvm.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 830613a..be1d263 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -44,7 +44,9 @@ There are a couple of variants of perf kvm:
 
   'perf kvm buildid-list' to  display the buildids found in a perf data file,
   so that other tools can be used to fetch packages with matching symbol tables
-  for use by perf report.
+  for use by perf report. As buildid is read from /sys/kernel/notes in os, then
+  if you want to list the buildid for guest, please make sure your perf data file
+  was captured with --guestmount in perf kvm record.
 
   'perf kvm stat <command>' to run a command and gather performance counter
   statistics.
-- 
1.8.2.1

