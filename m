Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaHRIWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:22:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51509 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHRIWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:22:40 -0400
Date: Mon, 18 Aug 2014 01:22:05 -0700
From: tip-bot for Elliott Hughes <tipbot@zytor.com>
Message-ID: <tip-c4d2df495c5bf05661772abf9b88f2696fd810c4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org, enh@google.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, enh@google.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20140814193920.A7D2D20572@enh.mtv.corp.google.com>
References: <20140814193920.A7D2D20572@enh.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add arm64 triplets
Git-Commit-ID: c4d2df495c5bf05661772abf9b88f2696fd810c4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4d2df495c5bf05661772abf9b88f2696fd810c4
Gitweb:     http://git.kernel.org/tip/c4d2df495c5bf05661772abf9b88f2696fd810c4
Author:     Elliott Hughes <enh@google.com>
AuthorDate: Thu, 14 Aug 2014 12:39:20 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 15 Aug 2014 10:40:11 -0300

perf tools: Add arm64 triplets

Adds the triplet used for arm64 by Android. Others will want to add
their own later.

Signed-off-by: Elliott Hughes <enh@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20140814193920.A7D2D20572@enh.mtv.corp.google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/common.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 42faf36..49776f1 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -12,6 +12,11 @@ const char *const arm_triplets[] = {
 	NULL
 };
 
+const char *const arm64_triplets[] = {
+	"aarch64-linux-android-",
+	NULL
+};
+
 const char *const powerpc_triplets[] = {
 	"powerpc-unknown-linux-gnu-",
 	"powerpc64-unknown-linux-gnu-",
@@ -105,6 +110,8 @@ static const char *normalize_arch(char *arch)
 		return "x86";
 	if (!strcmp(arch, "sun4u") || !strncmp(arch, "sparc", 5))
 		return "sparc";
+	if (!strcmp(arch, "aarch64") || !strcmp(arch, "arm64"))
+		return "arm64";
 	if (!strncmp(arch, "arm", 3) || !strcmp(arch, "sa110"))
 		return "arm";
 	if (!strncmp(arch, "s390", 4))
@@ -159,6 +166,8 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 
 	if (!strcmp(arch, "arm"))
 		path_list = arm_triplets;
+	else if (!strcmp(arch, "arm64"))
+		path_list = arm64_triplets;
 	else if (!strcmp(arch, "powerpc"))
 		path_list = powerpc_triplets;
 	else if (!strcmp(arch, "sh"))
