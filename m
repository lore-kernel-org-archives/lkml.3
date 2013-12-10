Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3LJJRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:17:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44087 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3LJJRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:17:03 -0500
Date: Tue, 10 Dec 2013 01:16:26 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-2f37573507643407d0a8f38c676ed2e90b795db3@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <0a81645dd0b384a12cb4f962cf193ef8c3ce2010.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <0a81645dd0b384a12cb4f962cf193ef8c3ce2010.1386197481.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove condition in machine__get_kernel_start_addr.
Git-Commit-ID: 2f37573507643407d0a8f38c676ed2e90b795db3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:16:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2f37573507643407d0a8f38c676ed2e90b795db3
Gitweb:     http://git.kernel.org/tip/2f37573507643407d0a8f38c676ed2e90b795db3
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Wed, 4 Dec 2013 17:56:39 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 13:46:36 -0300

perf tools: Remove condition in machine__get_kernel_start_addr.

In machine__get_kernel_start_addr, the code, which is using
machine->root_dir to build filename, works for both host and guests
initialized from guestmount, as root_dir is set to "" for the host
machine in the machine__init() function.

So this patch remove the branch for machine__is_host.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/0a81645dd0b384a12cb4f962cf193ef8c3ce2010.1386197481.git.yangds.fnst@cn.fujitsu.com
[ Clarified changeset mentioning root_dir setup in machine__init() ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 84cdb07..bac817a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -502,15 +502,11 @@ static u64 machine__get_kernel_start_addr(struct machine *machine)
 	char path[PATH_MAX];
 	struct process_args args;
 
-	if (machine__is_host(machine)) {
-		filename = "/proc/kallsyms";
-	} else {
-		if (machine__is_default_guest(machine))
-			filename = (char *)symbol_conf.default_guest_kallsyms;
-		else {
-			sprintf(path, "%s/proc/kallsyms", machine->root_dir);
-			filename = path;
-		}
+	if (machine__is_default_guest(machine))
+		filename = (char *)symbol_conf.default_guest_kallsyms;
+	else {
+		sprintf(path, "%s/proc/kallsyms", machine->root_dir);
+		filename = path;
 	}
 
 	if (symbol__restricted_filename(filename, "/proc/kallsyms"))
