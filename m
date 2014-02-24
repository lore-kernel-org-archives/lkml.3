Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaBXVsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 16:48:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaBXVse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 16:48:34 -0500
Date: Mon, 24 Feb 2014 13:48:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <sougata@tuxera.com>
Cc: Joe Perches <joe@perches.com>, Vyacheslav Dubeyko <slava@dubeyko.com>,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] hfsplus: fix longname handling
Message-Id: <20140224134832.d64b1e76e2d6d8fe5b25598d@linux-foundation.org>
In-Reply-To: <1393270107.27792.9.camel@ultrabook>
References: <1393270107.27792.9.camel@ultrabook>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 21:28:27 +0200 Sougata Santra <sougata@tuxera.com> wrote:

> 
> -ENAMETOOLONG returned from hfsplus_asc2uni was not propaged to iops. This
> allowed hfsplus to create files/directories with HFSPLUS_MAX_STRLEN and
> incorrect keys, leaving the FS in an inconsistent state. This patch fixes
> this issue.
> 
> ...
>
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -443,8 +443,10 @@ int hfsplus_cat_case_cmp_key(const hfsplus_btree_key *,
>  		const hfsplus_btree_key *);
>  int hfsplus_cat_bin_cmp_key(const hfsplus_btree_key *,
>  		const hfsplus_btree_key *);
> -void hfsplus_cat_build_key(struct super_block *sb,
> +int hfsplus_cat_build_key(struct super_block *sb,
>  		hfsplus_btree_key *, u32, struct qstr *);
> +void hfsplus_cat_build_key_with_cnid(struct super_block *sb,
> +		hfsplus_btree_key *, u32);
>  int hfsplus_find_cat(struct super_block *, u32, struct hfs_find_data *);
>  int hfsplus_create_cat(u32, struct inode *, struct qstr *, struct inode *);
>  int hfsplus_delete_cat(u32, struct inode *, struct qstr *);

grumble.  Omitting the argument names from declarations makes them
unreadable and generally useless.  I mean, a bare u32?

And including the names of some arguments but omitting others is
downright bizarre.

However this isn't a thing which can or should be addressed within this
patch.
