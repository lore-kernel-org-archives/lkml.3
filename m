Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab3KEXiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:38:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab3KEXiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:38:15 -0500
Date: Tue, 5 Nov 2013 15:38:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH] hfs: remove duplicate includes
Message-Id: <20131105153814.c9786e731b937dd3316d5e93@linux-foundation.org>
In-Reply-To: <1382342497-3132-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382342497-3132-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Oct 2013 10:01:37 +0200 Michael Opdenacker <michael.opdenacker@free-electrons.com> wrote:

> This patch removes duplicate includes from fs/hfs/btree.h
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  fs/hfs/btree.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/fs/hfs/btree.h b/fs/hfs/btree.h
> index 2a1d712..f6bd266 100644
> --- a/fs/hfs/btree.h
> +++ b/fs/hfs/btree.h
> @@ -153,11 +153,6 @@ struct hfs_btree_header_rec {
>  	u32 reserved3[16];
>  } __packed;
>  
> -#define HFS_NODE_INDEX	0x00	/* An internal (index) node */
> -#define HFS_NODE_HEADER	0x01	/* The tree header node (node 0) */
> -#define HFS_NODE_MAP		0x02	/* Holds part of the bitmap of used nodes */
> -#define HFS_NODE_LEAF		0xFF	/* A leaf (ndNHeight==1) node */
> -
>  #define BTREE_ATTR_BADCLOSE	0x00000001	/* b-tree not closed properly. not
>  						   used by hfsplus. */
>  #define HFS_TREE_BIGKEYS	0x00000002	/* key length is u16 instead of u8.

But we lost the nice comments...

From: Andrew Morton <akpm@linux-foundation.org>
Subject: fs-hfs-btreeh-remove-duplicate-defines-fix

retain the comments

Cc: Christoph Hellwig <hch@lst.de>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfsplus/hfsplus_raw.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/hfs/btree.h~fs-hfs-btreeh-remove-duplicate-defines-fix fs/hfs/btree.h
diff -puN fs/hfsplus/hfsplus_raw.h~fs-hfs-btreeh-remove-duplicate-defines-fix fs/hfsplus/hfsplus_raw.h
--- a/fs/hfsplus/hfsplus_raw.h~fs-hfs-btreeh-remove-duplicate-defines-fix
+++ a/fs/hfsplus/hfsplus_raw.h
@@ -156,10 +156,10 @@ struct hfs_bnode_desc {
 } __packed;
 
 /* HFS+ BTree node types */
-#define HFS_NODE_INDEX	0x00
-#define HFS_NODE_HEADER	0x01
-#define HFS_NODE_MAP	0x02
-#define HFS_NODE_LEAF	0xFF
+#define HFS_NODE_INDEX	0x00	/* An internal (index) node */
+#define HFS_NODE_HEADER	0x01	/* The tree header node (node 0) */
+#define HFS_NODE_MAP	0x02	/* Holds part of the bitmap of used nodes */
+#define HFS_NODE_LEAF	0xFF	/* A leaf (ndNHeight==1) node */
 
 /* HFS+ BTree header */
 struct hfs_btree_header_rec {
_

