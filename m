Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3LKLGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:06:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60268 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3LKLGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:06:36 -0500
Date: Wed, 11 Dec 2013 03:04:58 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-100b907350c87aa1f3b5dbd95bac3ad5aad3e108@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <1386609311-23889-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1386609311-23889-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Introduce option -v for perf kvm command.
Git-Commit-ID: 100b907350c87aa1f3b5dbd95bac3ad5aad3e108
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:05:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  100b907350c87aa1f3b5dbd95bac3ad5aad3e108
Gitweb:     http://git.kernel.org/tip/100b907350c87aa1f3b5dbd95bac3ad5aad3e108
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 9 Dec 2013 12:15:11 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:19:11 -0300

perf kvm: Introduce option -v for perf kvm command.

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
 
