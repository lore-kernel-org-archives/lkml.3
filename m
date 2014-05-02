Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbaEBQ2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:28:48 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:52454 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbaEBQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:28:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Cc: devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] staging: lustre: Use %zd to format ssize_t
Date: Fri,  2 May 2014 18:28:34 +0200
Message-Id: <1399048115-19506-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399048115-19506-1-git-send-email-geert@linux-m68k.org>
References: <1399048115-19506-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/lustre/lustre/llite/rw26.c: In function 'll_direct_IO_26':
drivers/staging/lustre/lustre/llite/rw26.c:383:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'ssize_t' [-Wformat]
drivers/staging/lustre/lustre/llite/rw26.c:383:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 10 has type 'ssize_t' [-Wformat]

Join the quoted string split across lines to fix a checkpatch warning while
we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/staging/lustre/lustre/llite/rw26.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index c3fd544b78dc..af84c1aaa5f8 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -380,8 +380,8 @@ static ssize_t ll_direct_IO_26(int rw, struct kiocb *iocb,
 	if ((file_offset & ~CFS_PAGE_MASK) || (count & ~CFS_PAGE_MASK))
 		return -EINVAL;
 
-	CDEBUG(D_VFSTRACE, "VFS Op:inode=%lu/%u(%p), size=%lu (max %lu), "
-	       "offset=%lld=%llx, pages %lu (max %lu)\n",
+	CDEBUG(D_VFSTRACE,
+	       "VFS Op:inode=%lu/%u(%p), size=%zd (max %lu), offset=%lld=%llx, pages %zd (max %lu)\n",
 	       inode->i_ino, inode->i_generation, inode, count, MAX_DIO_SIZE,
 	       file_offset, file_offset, count >> PAGE_CACHE_SHIFT,
 	       MAX_DIO_SIZE >> PAGE_CACHE_SHIFT);
-- 
1.7.9.5

