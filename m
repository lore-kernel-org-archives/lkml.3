Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaLUK62 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 05:58:28 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:35881 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaLUK6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 05:58:25 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Drysdale <drysdale@google.com>, Shuah Khan <shuahkh@osg.samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] selftests/exec: Use %zu to format size_t
Date: Sun, 21 Dec 2014 11:58:16 +0100
Message-Id: <1419159496-11558-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32-bit:

execveat.c: In function 'check_execveat_pathmax':
execveat.c:183: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'size_t'
execveat.c:187: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'size_t'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 tools/testing/selftests/exec/execveat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
index 33a5c06d95caa038..d273624c93a64254 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -179,11 +179,11 @@ static int check_execveat_pathmax(int dot_dfd, const char *src, int is_script)
 	 */
 	fd = open(longpath, O_RDONLY);
 	if (fd > 0) {
-		printf("Invoke copy of '%s' via filename of length %lu:\n",
+		printf("Invoke copy of '%s' via filename of length %zu:\n",
 			src, strlen(longpath));
 		fail += check_execveat(fd, "", AT_EMPTY_PATH);
 	} else {
-		printf("Failed to open length %lu filename, errno=%d (%s)\n",
+		printf("Failed to open length %zu filename, errno=%d (%s)\n",
 			strlen(longpath), errno, strerror(errno));
 		fail++;
 	}
-- 
1.9.1

