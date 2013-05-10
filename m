Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3EJOc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:32:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57195 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755491Ab3EJOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Michael Ellerman" <michael@ellerman.id.au>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.545180391@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [053/118] powerpc/spufs: Initialise inode->i_ino in spufs_new_inode()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/platforms/cell/spufs/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -100,6 +100,7 @@ spufs_new_inode(struct super_block *sb,
 	if (!inode)
 		goto out;
 
+	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_uid = current_fsuid();
 	inode->i_gid = current_fsgid();

