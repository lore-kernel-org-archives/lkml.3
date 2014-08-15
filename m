Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaHOQub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:50:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:44657 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976AbaHOQu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:50:27 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Elliott Hughes <enh@google.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/18] perf tools: Add arm64 triplets
Date: Fri, 15 Aug 2014 13:49:48 -0300
Message-Id: <1408121403-11919-4-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121403-11919-1-git-send-email-acme@kernel.org>
References: <1408121403-11919-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Elliott Hughes <enh@google.com>

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
index 42faf369211c..49776f190abf 100644
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
-- 
1.9.3

