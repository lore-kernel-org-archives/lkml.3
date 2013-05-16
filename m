Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3EPHwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 03:52:03 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19590 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3EPHwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 03:52:00 -0400
Date: Thu, 16 May 2013 10:51:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] minix: bug widening a binary "not" operation
Message-ID: <20130516075148.GA7494@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"chunk_size" is an unsigned int and "pos" is an unsigned long.  The
"& ~(chunk_size-1)" operation clears the high 32 bits unintentionally.

The ALIGN() macro does the correct thing.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/minix/dir.c b/fs/minix/dir.c
index a9ed6f3..09b0c96 100644
--- a/fs/minix/dir.c
+++ b/fs/minix/dir.c
@@ -95,7 +95,7 @@ static int minix_readdir(struct file * filp, void * dirent, filldir_t filldir)
 	char *name;
 	__u32 inumber;
 
-	pos = (pos + chunk_size-1) & ~(chunk_size-1);
+	pos = ALIGN(pos, chunk_size);
 	if (pos >= inode->i_size)
 		goto done;
 
