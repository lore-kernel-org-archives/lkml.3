Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3LJJeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:34:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3LJJRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:17:08 -0500
Date: Tue, 10 Dec 2013 01:16:45 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-ed086d5b8a793955981f0726d8d66a03d801279b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <d605a805486340b53bc261aa64d7632ad0a8cf53.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <d605a805486340b53bc261aa64d7632ad0a8cf53.1386197481.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Add more detail about buildid-list in man page
Git-Commit-ID: ed086d5b8a793955981f0726d8d66a03d801279b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:16:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed086d5b8a793955981f0726d8d66a03d801279b
Gitweb:     http://git.kernel.org/tip/ed086d5b8a793955981f0726d8d66a03d801279b
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Wed, 4 Dec 2013 17:56:42 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:02:47 -0300

perf kvm: Add more detail about buildid-list in man page

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
index 6a06cef..f52f94d 100644
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
