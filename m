Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab3EHN6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:58:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab3EHN63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:58:29 -0400
Date: Wed, 8 May 2013 15:58:25 +0200
From: Jan Kara <jack@suse.cz>
To: Maarten ter Huurne <maarten@treewalker.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext4: Fixed corruption when online resizing a fs with 1K
 block size
Message-ID: <20130508135825.GA3810@quack.suse.cz>
References: <1367856367-15924-1-git-send-email-maarten@treewalker.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367856367-15924-1-git-send-email-maarten@treewalker.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 06-05-13 18:06:07, Maarten ter Huurne wrote:
> Subtracting the number of the first data block places the superblock
> backups one block too early, corrupting the file system. When the block
> size is larger than 1K, the first data block is 0, so the subtraction
> has no effect and no corruption occurs.
  Looking where mke2fs places backup super blocks you are right. You can
add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> 
> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
> ---
>  fs/ext4/resize.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index c169477..116c80d 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -1654,12 +1654,10 @@ errout:
>  		err = err2;
>  
>  	if (!err) {
> -		ext4_fsblk_t first_block;
> -		first_block = ext4_group_first_block_no(sb, 0);
>  		if (test_opt(sb, DEBUG))
>  			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
>  			       "blocks\n", ext4_blocks_count(es));
> -		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr - first_block,
> +		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
>  			       (char *)es, sizeof(struct ext4_super_block), 0);
>  	}
>  	return err;
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
