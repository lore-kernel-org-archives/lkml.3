Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3LCOvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:51:42 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47482 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3LCOvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:51:38 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 6/9] staging/lustre/llite: fix used uninitialized warning
Date: Tue,  3 Dec 2013 22:42:05 +0800
Message-Id: <1386081729-9481-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
References: <1386081729-9481-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Got below warning when building with sparc:
drivers/staging/lustre/lustre/llite/file.c: In function 'll_file_aio_write':
drivers/staging/lustre/lustre/llite/file.c:1247:9: warning: 'count' may be used uninitialized in this function [-Wuninitialized]
drivers/staging/lustre/lustre/llite/file.c: In function 'll_file_aio_read':
drivers/staging/lustre/lustre/llite/file.c:1188:9: warning: 'count' may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index c126135..8f03eb0 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1185,7 +1185,7 @@ static ssize_t ll_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct lu_env      *env;
 	struct vvp_io_args *args;
-	size_t	      count;
+	size_t	      count = 0;
 	ssize_t	     result;
 	int		 refcheck;
 
@@ -1244,7 +1244,7 @@ static ssize_t ll_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 {
 	struct lu_env      *env;
 	struct vvp_io_args *args;
-	size_t	      count;
+	size_t	      count = 0;
 	ssize_t	     result;
 	int		 refcheck;
 
-- 
1.7.9.5

