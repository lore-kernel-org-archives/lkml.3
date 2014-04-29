Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbaD2QTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:19:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213AbaD2QTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:19:37 -0400
Date: Tue, 29 Apr 2014 18:19:36 +0200
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, jack <jack@suse.cz>,
        hch <hch@infradead.org>, Viro <viro@zeniv.linux.org.uk>,
        tytso <tytso@mit.edu>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH V3 2/2] fs/ext4/fsync.c: generic_file_fsync call based on
 barrier flag
Message-ID: <20140429161936.GB29634@quack.suse.cz>
References: <20140428231508.a101532b3154e7742489abf2@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140428231508.a101532b3154e7742489abf2@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 28-04-14 23:15:08, Fabian Frederick wrote:
> generic_file_fsync has been updated to issue a flush for
> older filesystems.
> 
> This patch tests for barrier flag in ext4 mount flags
> and calls the right function.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
  The patch looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/ext4/fsync.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index a8bc47f..fa82c0a 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -108,6 +108,10 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  
>  	if (!journal) {
>  		ret = generic_file_fsync(file, start, end, datasync);
> +		if (test_opt(inode->i_sb, BARRIER))
> +			ret = generic_file_fsync(file, start, end, datasync);
> +		else
> +			ret = __generic_file_fsync(file, start, end, datasync);
>  		if (!ret && !hlist_empty(&inode->i_dentry))
>  			ret = ext4_sync_parent(inode);
>  		goto out;
> -- 
> 1.8.4.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
