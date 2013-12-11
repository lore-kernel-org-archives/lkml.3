Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab3LKKfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 05:35:30 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:40302 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3LKKfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 05:35:25 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf completion: complete 'perf kvm'
Date: Wed, 11 Dec 2013 16:04:15 +0530
Message-Id: <1386758056-24618-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.5.g70ebc73.dirty
In-Reply-To: <1386758056-24618-1-git-send-email-artagnon@gmail.com>
References: <1386758056-24618-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, there is no way to enumerate the subcommands under 'perf
kvm', so hardcode them.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/perf-completion.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 4949488..496e2ab 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -121,6 +121,10 @@ __perf_main ()
 	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		__perfcomp_colon "$evts" "$cur"
+	# List subcommands for 'perf kvm'
+	elif [[ $prev == "kvm" ]]; then
+		subcmds="top record report diff buildid-list stat"
+		__perfcomp_colon "$subcmds" "$cur"
 	# List long option names
 	elif [[ $cur == --* ]];  then
 		subcmd=${words[1]}
-- 
1.8.5.rc0.5.g70ebc73.dirty

