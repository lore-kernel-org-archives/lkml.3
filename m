Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab3EIMIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 08:08:38 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:53467 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab3EIMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 08:08:37 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chris Zankel <chris@zankel.net>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] xtensa simdisk: Fix proc_create_data() conversion fallout
Date: Thu,  9 May 2013 14:08:31 +0200
Message-Id: <1368101311-18573-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/xtensa/platforms/iss/simdisk.c: In function 'proc_read_simdisk':
arch/xtensa/platforms/iss/simdisk.c:220:12: warning: initialization discards 'const' qualifier from pointer target type [enabled by default]
arch/xtensa/platforms/iss/simdisk.c: In function 'proc_write_simdisk':
arch/xtensa/platforms/iss/simdisk.c:241:38: error: 'buffer' undeclared (first use in this function)
arch/xtensa/platforms/iss/simdisk.c:241:38: note: each undeclared identifier is reported only once for each function it appears in

Introduced by commit a69755b187749e7cc020e17127a54f395aea4eaa ("xtensa
simdisk: switch to proc_create_data()")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/8716354/

 arch/xtensa/platforms/iss/simdisk.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 0345f43..fc3c91f 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -217,7 +217,7 @@ static ssize_t proc_read_simdisk(struct file *file, char __user *buf,
 			size_t size, loff_t *ppos)
 {
 	struct simdisk *dev = PDE_DATA(file_inode(file));
-	char *s = dev->filename;
+	const char *s = dev->filename;
 	if (s) {
 		ssize_t n = simple_read_from_buffer(buf, size, ppos,
 							s, strlen(s));
@@ -238,7 +238,7 @@ static ssize_t proc_write_simdisk(struct file *file, const char __user *buf,
 
 	if (tmp == NULL)
 		return -ENOMEM;
-	if (copy_from_user(tmp, buffer, count)) {
+	if (copy_from_user(tmp, buf, count)) {
 		err = -EFAULT;
 		goto out_free;
 	}
-- 
1.7.0.4

