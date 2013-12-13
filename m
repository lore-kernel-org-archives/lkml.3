Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3LMPMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 10:12:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45166 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3LMPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 10:12:12 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/20] perf completion: Complete 'perf kvm'
Date: Fri, 13 Dec 2013 12:11:54 -0300
Message-Id: <1386947526-7118-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386947526-7118-1-git-send-email-acme@infradead.org>
References: <1386947526-7118-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Currently, there is no way to enumerate the subcommands under 'perf
kvm', so hardcode them.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/1386758056-24618-2-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-completion.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index 49494882d9bb..496e2abb5482 100644
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
1.8.1.4

