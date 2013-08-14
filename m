Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab3HNJtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:49:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:21602 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759451Ab3HNJtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:49:50 -0400
Date: Wed, 14 Aug 2013 12:49:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] efs: iget_locked() doesn't return an ERR_PTR()
Message-ID: <20130814094940.GF521@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The iget_locked() function returns NULL on error and never an ERR_PTR.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/efs/inode.c b/fs/efs/inode.c
index f3913eb..d15ccf2 100644
--- a/fs/efs/inode.c
+++ b/fs/efs/inode.c
@@ -57,7 +57,7 @@ struct inode *efs_iget(struct super_block *super, unsigned long ino)
 	struct inode *inode;
 
 	inode = iget_locked(super, ino);
-	if (IS_ERR(inode))
+	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
 		return inode;
