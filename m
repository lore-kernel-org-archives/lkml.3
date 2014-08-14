Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaHNTjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 15:39:22 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:46559 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaHNTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 15:39:21 -0400
Date: Thu, 14 Aug 2014 12:39:20 -0700
To: linux-kernel@vger.kernel.org, acme@kernel.org, mingo@redhat.com,
        paulus@samba.org, a.p.zijlstra@chello.nl, enh@google.com
Subject: [PATCH] Add arm64 triples to perf.
User-Agent: Heirloom mailx 12.5 6/20/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20140814193920.A7D2D20572@enh.mtv.corp.google.com>
From: enh@google.com (Elliott Hughes)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adds the triple used for arm64 by Android. Others will want to add
their own later.

Signed-off-by: Elliott Hughes <enh@google.com>
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
-- 
2.1.0.rc2.206.gedb03e5
