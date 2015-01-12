Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698AbbALJ6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:58:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbbALJ6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:58:40 -0500
Date: Mon, 12 Jan 2015 10:58:34 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/1 linux-next] udf: destroy sbi mutex in put_super
Message-ID: <20150112095834.GB4468@quack.suse.cz>
References: <1420913612-8844-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420913612-8844-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10-01-15 19:13:32, Fabian Frederick wrote:
> Call mutex_destroy() on superblock mutex in udf_put_super()
> otherwise mutex debugging code isn't able to detect that
> mutex is used after being freed.
> (thanks to Jan Kara for complete definition).
  Applied, thanks.

							Honza

> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  fs/udf/super.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 3ccb2f1..3d35a75 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -2300,6 +2300,7 @@ static void udf_put_super(struct super_block *sb)
>  		udf_close_lvid(sb);
>  	brelse(sbi->s_lvid_bh);
>  	udf_sb_free_partitions(sb);
> +	mutex_destroy(&sbi->s_alloc_mutex);
>  	kfree(sb->s_fs_info);
>  	sb->s_fs_info = NULL;
>  }
> -- 
> 2.1.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
