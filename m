Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaFDVnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:43:52 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:39528 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaFDVnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:43:50 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Borislav Petkov <bp@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jiri Olsa <jolsa@kernel.org>, Vinson Lee <vlee@twitter.com>,
        Namhyung Kim <namhyung@kernel.org>, Xia Kaixu <xiakaixu@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: lib: api: fs: debugfs.c:  Cleaning up missing null-terminate after strncpy call
Date: Wed,  4 Jun 2014 23:44:44 +0200
Message-Id: <1401918284-3733-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/lib/api/fs/debugfs.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index a74fba6..5649b09 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -95,6 +95,7 @@ char *debugfs_mount(const char *mountpoint)
 	/* save the mountpoint */
 	debugfs_found = true;
 	strncpy(debugfs_mountpoint, mountpoint, sizeof(debugfs_mountpoint));
+	debugfs_mountpoint[sizeof(debugfs_mountpoint) - 1] = '\0';
 out:
 	return debugfs_mountpoint;
 }
-- 
1.7.10.4

