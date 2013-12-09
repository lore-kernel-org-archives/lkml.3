Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760476Ab3LIERC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 23:17:02 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:44939 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755614Ab3LIERA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 23:17:00 -0500
X-IronPort-AV: E=Sophos;i="4.93,855,1378828800"; 
   d="scan'208";a="9219432"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf kvm: Introduce option -v for perf kvm command.
Date: Mon, 9 Dec 2013 12:15:11 -0500
Message-Id: <1386609311-23889-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 12:16:43,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 12:16:44,
	Serialize complete at 2013/12/09 12:16:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there is no -v option for perf kvm, the all debug message for perf kvm
will nerver be printed out to user.

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
---
 tools/perf/Documentation/perf-kvm.txt | 7 +++++--
 tools/perf/builtin-kvm.c              | 2 ++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index 96a9a1d..52276a6 100644
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
index f8bf5f2..d9cc0e3 100644
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
1.8.2.1

