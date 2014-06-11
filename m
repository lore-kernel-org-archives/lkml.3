Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbaFKRBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:01:04 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:55862 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaFKRBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:01:02 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] staging: lustre: Use %ld to format long
Date: Wed, 11 Jun 2014 19:00:54 +0200
Message-Id: <1402506054-7696-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/lustre/lustre/llite/rw26.c: In function ‘ll_direct_IO_26’:
drivers/staging/lustre/lustre/llite/rw26.c:388: warning: format ‘%zd’ expects type ‘signed size_t’, but argument 6 has type ‘long int’
drivers/staging/lustre/lustre/llite/rw26.c:388: warning: format ‘%zd’ expects type ‘signed size_t’, but argument 10 has type ‘long int’

Introduced by commit b41a1fe067c34b40736860458b9d62b2139471d5 ("staging:
lustre: Use %zd to format ssize_t"), which was part of a series to fix
issues in -next. However, the commits introducing the issues never made it
to mainline.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/lustre/lustre/llite/rw26.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 55ca8d3c3e46..5b944d3fb80c 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -386,7 +386,7 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 		return -EINVAL;
 
 	CDEBUG(D_VFSTRACE,
-	       "VFS Op:inode=%lu/%u(%p), size=%zd (max %lu), offset=%lld=%llx, pages %zd (max %lu)\n",
+	       "VFS Op:inode=%lu/%u(%p), size=%ld (max %lu), offset=%lld=%llx, pages %ld (max %lu)\n",
 	       inode->i_ino, inode->i_generation, inode, count, MAX_DIO_SIZE,
 	       file_offset, file_offset, count >> PAGE_CACHE_SHIFT,
 	       MAX_DIO_SIZE >> PAGE_CACHE_SHIFT);
-- 
1.9.1

