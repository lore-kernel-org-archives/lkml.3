Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbbAEKNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:13:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46246 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbbAEKNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:13:37 -0500
Date: Mon, 5 Jan 2015 11:13:31 +0100
From: Jan Kara <jack@suse.cz>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] ext3: destroy sbi mutexes in put_super
Message-ID: <20150105101331.GE7056@quack.suse.cz>
References: <1419692482-17658-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419692482-17658-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 27-12-14 16:01:22, Fabian Frederick wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
  Thanks, I have merged the patch with somewhat updated changelog to
describe what are the visible effects of this.

								Honza
> ---
> This is untested.
> 
>  fs/ext3/super.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 9b4e7d7..d4dbf3c 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -466,6 +466,8 @@ static void ext3_put_super (struct super_block * sb)
>  	}
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
> +	mutex_destroy(&sbi->s_orphan_lock);
> +	mutex_destroy(&sbi->s_resize_lock);
>  	kfree(sbi);
>  }
>  
> -- 
> 2.1.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
