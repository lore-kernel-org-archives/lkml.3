Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab3LDUQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:16:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59331 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab3LDUHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/38] perf kvm: Add more detail about buildid-list in man page
Date: Wed,  4 Dec 2013 17:06:32 -0300
Message-Id: <1386187622-2928-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

As the buildid is read from /sys/kernel/notes, then if we use perf kvm
buildid-list with a perf data file captured by perf kvm record with
--guestkallsyms and --guestmodules, there is no result in output.

This patch add a explanation about it and add a limit of using perf kvm
buildid-list.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/d605a805486340b53bc261aa64d7632ad0a8cf53.1386197481.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-kvm.txt | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 6a06cefe9642..f52f94d9f66b 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -37,7 +37,9 @@ There are a couple of variants of perf kvm:
 
   'perf kvm buildid-list' to  display the buildids found in a perf data file,
   so that other tools can be used to fetch packages with matching symbol tables
-  for use by perf report.
+  for use by perf report. As buildid is read from /sys/kernel/notes in os, then
+  if you want to list the buildid for guest, please make sure your perf data file
+  was captured with --guestmount in perf kvm record.
 
   'perf kvm stat <command>' to run a command and gather performance counter
   statistics.
-- 
1.8.1.4

