Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaG1P0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:26:41 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:39737 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544AbaG1P0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:26:40 -0400
Date: Mon, 28 Jul 2014 20:56:32 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ocfs2: delete double assignment
Message-ID: <20140728152632.GA2926@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete successive assignments to the same location. The two assignments are
simply identical.

A simplified version of Coccinelle semantic match that finds this problem is as
follows:

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
---
Should the fist assignment be initializing the pv_minor field?
 fs/ocfs2/stack_user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 13a8537..4bcbb9b 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -591,7 +591,6 @@ static int ocfs2_control_release(struct inode *inode, struct file *file)
 		 */
 		ocfs2_control_this_node = -1;
 		running_proto.pv_major = 0;
-		running_proto.pv_major = 0;
 	}
 
 out:
-- 
1.9.1

