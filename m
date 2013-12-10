Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LJJRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:17:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3LJJR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:17:27 -0500
Date: Tue, 10 Dec 2013 01:17:05 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-8df0b4ad58081773647dd2e0fddd45e8c0022c67@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <3a3a9c1e05acb5a274d1d8369db5a4c6467d6276.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <3a3a9c1e05acb5a274d1d8369db5a4c6467d6276.1386197481.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Update the 'record'
  man page entry for new --guest/--host behavior
Git-Commit-ID: 8df0b4ad58081773647dd2e0fddd45e8c0022c67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:17:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8df0b4ad58081773647dd2e0fddd45e8c0022c67
Gitweb:     http://git.kernel.org/tip/8df0b4ad58081773647dd2e0fddd45e8c0022c67
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Wed, 4 Dec 2013 17:56:41 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:06:08 -0300

perf kvm: Update the 'record' man page entry for new --guest/--host behavior

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
index 7953227..96a9a1d 100644
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
