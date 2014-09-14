Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaINQB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:01:27 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:38349 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaINQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:01:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peng Tao <bergwolf@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: libcfs: debug.c:  Cleaning up unnecessary use of memset in conjunction with strncpy
Date: Sun, 14 Sep 2014 18:03:16 +0200
Message-Id: <1410710597-14520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using memset before strncpy just to ensure a trailing null
character is an unnecessary double writing of a string

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/lustre/lustre/libcfs/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/libcfs/debug.c b/drivers/staging/lustre/lustre/libcfs/debug.c
index 6b58469..98c7c3a 100644
--- a/drivers/staging/lustre/lustre/libcfs/debug.c
+++ b/drivers/staging/lustre/lustre/libcfs/debug.c
@@ -402,9 +402,9 @@ int libcfs_debug_init(unsigned long bufsize)
 	}
 
 	if (libcfs_debug_file_path != NULL) {
-		memset(libcfs_debug_file_path_arr, 0, PATH_MAX);
 		strncpy(libcfs_debug_file_path_arr,
 			libcfs_debug_file_path, PATH_MAX-1);
+		libcfs_debug_file_path_arr[PATH_MAX - 1] = '\0';
 	}
 
 	/* If libcfs_debug_mb is set to an invalid value or uninitialized
-- 
1.7.10.4

