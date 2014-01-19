Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaASEbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 23:31:34 -0500
Received: from smtp-69.nebula.fi ([83.145.220.69]:55314 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751860AbaASEbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 23:31:31 -0500
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Subject: [PATCH] exec: remove redundant check in search_binary_handler()
Date: Sun, 19 Jan 2014 06:30:23 +0200
Message-Id: <1390105823-20844-1-git-send-email-stefan.kristiansson@saunalahti.fi>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

retval >= 0 is implied by retval != -ENOEXEC

Signed-off-by: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
---
 fs/exec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7ea097f..aafafea 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1390,8 +1390,8 @@ int search_binary_handler(struct linux_binprm *bprm)
 		bprm->recursion_depth++;
 		retval = fmt->load_binary(bprm);
 		bprm->recursion_depth--;
-		if (retval >= 0 || retval != -ENOEXEC ||
-		    bprm->mm == NULL || bprm->file == NULL) {
+		if (retval != -ENOEXEC || bprm->mm == NULL ||
+		    bprm->file == NULL) {
 			put_binfmt(fmt);
 			return retval;
 		}
-- 
1.8.3.2

