Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3LDJ6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 04:58:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:9980 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab3LDJ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 04:58:30 -0500
X-IronPort-AV: E=Sophos;i="4.93,823,1378828800"; 
   d="scan'208";a="9189158"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: dsahern@gmail.com, jolsa@redhat.com, acme@ghostprotocols.net,
        mingo@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 1/5] perf tools: Remove condition in machine__get_kernel_start_addr.
Date: Wed, 4 Dec 2013 17:56:39 -0500
Message-Id: <0a81645dd0b384a12cb4f962cf193ef8c3ce2010.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1386197481.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/04 17:58:20,
	Serialize complete at 2013/12/04 17:58:20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In machine__get_kernel_start_addr, the code, which is
using machine->root_dir to build filename, works for both
host and guests initialized from guestmount. So this patch
remove the branch for machine__is_host.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
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
-- 
1.8.2.1

