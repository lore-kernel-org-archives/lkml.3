Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3B1DaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 22:30:08 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:65137 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab3B1DaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 22:30:03 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
Subject: [PATCH] perf kvm: fix segfault by initializing file_name to NULL
Date: Wed, 27 Feb 2013 20:29:57 -0700
Message-Id: <1362022197-38929-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dongsoo reported that perf-kvm was segfaulting. The bug was introduced by
commit 3786063 which moved file_name from struct perf_kvm which was
initialized on the stack to an uninitialized stack variable. Fix by
initializing.

Needs to be applied to 3.7 and 3.8 as well.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Dongsoo Nathaniel Kim <dongsoo.kim@gmail.com>
---
 tools/perf/builtin-kvm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index ca3f80e..e55701d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -973,7 +973,7 @@ __cmd_buildid_list(const char *file_name, int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	const char *file_name;
+	const char *file_name = NULL;
 
 	const struct option kvm_options[] = {
 		OPT_STRING('i', "input", &file_name, "file",
-- 
1.7.10.1

