Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483Ab3LITh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54950 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760431Ab3LIThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/21] perf kvm: Introduce option -v for perf kvm command.
Date: Mon,  9 Dec 2013 16:36:59 -0300
Message-Id: <1386617830-18926-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

As there is no -v option for perf kvm, the all debug message for perf
kvm will nerver be printed out to user.

Example:
	# perf kvm --guestmount /tmp/guestmount/ record -a
	Not enough memory for reading perf file header

It is confusing message for newbies such as me. With this patch applied,
we can use -v option to get the detail.

Example:
	# perf kvm --guestmount /tmp/guestmount/ record -a -v
	Can't access file /tmp/guestmount//15069/proc/kallsyms
	Not enough memory for reading perf file header

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1386609311-23889-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-kvm.txt | 7 +++++--
 tools/perf/builtin-kvm.c              | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 96a9a1dea727..52276a6d2b75 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -10,9 +10,9 @@ SYNOPSIS
 [verse]
 'perf kvm' [--host] [--guest] [--guestmount=<path>
 	[--guestkallsyms=<path> --guestmodules=<path> | --guestvmlinux=<path>]]
-	{top|record|report|diff|buildid-list}
+	{top|record|report|diff|buildid-list} [<options>]
 'perf kvm' [--host] [--guest] [--guestkallsyms=<path> --guestmodules=<path>
-	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list|stat}
+	| --guestvmlinux=<path>] {top|record|report|diff|buildid-list|stat} [<options>]
 'perf kvm stat [record|report|live] [<options>]
 
 DESCRIPTION
@@ -93,6 +93,9 @@ OPTIONS
 	kernel module information. Users copy it out from guest os.
 --guestvmlinux=<path>::
 	Guest os kernel vmlinux.
+-v::
+--verbose::
+	Be more verbose (show counter open errors, etc).
 
 STAT REPORT OPTIONS
 -------------------
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f8bf5f244d77..d9cc0e3f284f 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1690,6 +1690,8 @@ int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 			   "file", "file saving guest os /proc/kallsyms"),
 		OPT_STRING(0, "guestmodules", &symbol_conf.default_guest_modules,
 			   "file", "file saving guest os /proc/modules"),
+		OPT_INCR('v', "verbose", &verbose,
+			    "be more verbose (show counter open errors, etc)"),
 		OPT_END()
 	};
 
-- 
1.8.1.4

