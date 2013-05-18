Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab3ERDIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:08:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab3ERDAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:24 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Tfx1VLZHzkwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=TJSSgSQ9lUMA:10 a=20KFwNOVAAAA:8 a=jUFqNg-nAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=KN7bHiih1CV89zf7EN4A:9 a=jEp0ucaQiEUA:10 a=ti9MVTvIaOAA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021655.743685399@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Jeffery <djeffery@redhat.com>, Ian Kent <raven@themaw.net>
Subject: [ 087/136 ] autofs - remove autofs dentry mount check
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0087-autofs-remove-autofs-dentry-mount-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: David Jeffery <djeffery@redhat.com>

[ Upstream commit ce8a5dbdf9e709bdaf4618d7ef8cceb91e8adc69 ]

When checking if an autofs mount point is busy it isn't sufficient to
only check if it's a mount point.

For example, if the mount of an offset mountpoint in a tree is denied
for this host by its export and the dentry becomes a process working
directory the check incorrectly returns the mount as not in use at
expire.

This can happen since the default when mounting within a tree is
nostrict, which means ingnore mount fails on mounts within the tree and
continue.  The nostrict option is meant to allow mounting in this case.

Signed-off-by: David Jeffery <djeffery@redhat.com>
Signed-off-by: Ian Kent <raven@themaw.net>
Cc: stable@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/autofs4/expire.c |    9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 842d000..c7ada0d 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -61,15 +61,6 @@ static int autofs4_mount_busy(struct vfsmount *mnt, struct dentry *dentry)
 		/* This is an autofs submount, we can't expire it */
 		if (autofs_type_indirect(sbi->type))
 			goto done;
-
-		/*
-		 * Otherwise it's an offset mount and we need to check
-		 * if we can umount its mount, if there is one.
-		 */
-		if (!d_mountpoint(path.dentry)) {
-			status = 0;
-			goto done;
-		}
 	}
 
 	/* Update the expiry counter if fs is busy */
-- 
1.7.10.4


