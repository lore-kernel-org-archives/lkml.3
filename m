Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806Ab3ERC2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:28:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756092Ab3ERCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:48 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=FhdGuyMz6jkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=efzMK_dpO7oA:10 a=VwQbUJbxAAAA:8 a=wMNdZWldAAAA:8 a=_t_JsXkQ9BBgKRCOETkA:9 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021642.920184311@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:04 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 007/136 ] powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0007-powerpc-spufs-Initialise-inode-i_ino-in-spufs_new_in.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

[ Upstream commit 6747e83235caecd30b186d1282e4eba7679f81b7 ]

In commit 85fe402 (fs: do not assign default i_ino in new_inode), the
initialisation of i_ino was removed from new_inode() and pushed down
into the callers. However spufs_new_inode() was not updated.

This exhibits as no files appearing in /spu, because all our dirents
have a zero inode, which readdir() seems to dislike.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index dba1ce2..506dc9f 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -99,6 +99,7 @@ spufs_new_inode(struct super_block *sb, umode_t mode)
 	if (!inode)
 		goto out;
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();
-- 
1.7.10.4


