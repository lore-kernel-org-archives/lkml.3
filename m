Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3LPP14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:27:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47636 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3LPP1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:27:54 -0500
Date: Mon, 16 Dec 2013 07:27:43 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-8f2f5ada719560954174da30ce0a67261c616e39@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1386758056-24618-2-git-send-email-artagnon@gmail.com>
References: <1386758056-24618-2-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Complete 'perf kvm'
Git-Commit-ID: 8f2f5ada719560954174da30ce0a67261c616e39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 16 Dec 2013 07:27:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f2f5ada719560954174da30ce0a67261c616e39
Gitweb:     http://git.kernel.org/tip/8f2f5ada719560954174da30ce0a67261c616e39
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Wed, 11 Dec 2013 16:04:15 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 13 Dec 2013 10:30:21 -0300

perf completion: Complete 'perf kvm'

Currently, there is no way to enumerate the subcommands under 'perf
kvm', so hardcode them.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/1386758056-24618-2-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
