Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab3EGAHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:07:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759214Ab3EFW4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:56:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 05/63] powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()
Date: Mon,  6 May 2013 15:55:43 -0700
Message-Id: <20130506225316.209929280@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225314.802167948@linuxfoundation.org>
References: <20130506225314.802167948@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit 6747e83235caecd30b186d1282e4eba7679f81b7 upstream.

In commit 85fe402 (fs: do not assign default i_ino in new_inode), the
initialisation of i_ino was removed from new_inode() and pushed down
into the callers. However spufs_new_inode() was not updated.

This exhibits as no files appearing in /spu, because all our dirents
have a zero inode, which readdir() seems to dislike.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/cell/spufs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -99,6 +99,7 @@ spufs_new_inode(struct super_block *sb,
 	if (!inode)
 		goto out;
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();


