Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3HFMb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:31:29 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62895 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756194Ab3HFMb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:31:28 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <tao.peng@emc.com>,
        Kent Overstreet <koverstreet@google.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] staging/lustre: kiocb->ki_left is removed
Date: Tue,  6 Aug 2013 20:31:01 +0800
Message-Id: <1375792261-2674-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peng Tao <tao.peng@emc.com>

We also missed ki_nbytes...

Cc: Kent Overstreet <koverstreet@google.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Peng Tao <tao.peng@emc.com>
---
This fixes Lustre build in linux-next and needs to go through
the aio tree as Kent's AIO patch is not in upstream kernel. 

 drivers/staging/lustre/lustre/llite/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 253f026..bc534db 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1009,7 +1009,7 @@ static ssize_t ll_file_read(struct file *file, char *buf, size_t count,
 	local_iov->iov_len = count;
 	init_sync_kiocb(kiocb, file);
 	kiocb->ki_pos = *ppos;
-	kiocb->ki_left = count;
+	kiocb->ki_nbytes = count;
 
 	result = ll_file_aio_read(kiocb, local_iov, 1, kiocb->ki_pos);
 	*ppos = kiocb->ki_pos;
@@ -1068,7 +1068,7 @@ static ssize_t ll_file_write(struct file *file, const char *buf, size_t count,
 	local_iov->iov_len = count;
 	init_sync_kiocb(kiocb, file);
 	kiocb->ki_pos = *ppos;
-	kiocb->ki_left = count;
+	kiocb->ki_nbytes = count;
 
 	result = ll_file_aio_write(kiocb, local_iov, 1, kiocb->ki_pos);
 	*ppos = kiocb->ki_pos;
-- 
1.7.9.5

