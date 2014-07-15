Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaGOAtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:49:11 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47192 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752255AbaGOAtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:49:06 -0400
X-Sasl-enc: pcUWu248SM+XVb2AYOQbyituxlcyVXtyrXX6uWrk8vJp 1405385344
Date: Mon, 14 Jul 2014 17:53:36 -0700
From: Greg KH <greg@kroah.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [PATCH 3.15 2/2] f2fs: check bdi->dirty_exceeded when trying to
 skip data writes
Message-ID: <20140715005336.GC8745@kroah.com>
References: <1405349571-20058-1-git-send-email-jaegeuk@kernel.org>
 <1405349571-20058-2-git-send-email-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405349571-20058-2-git-send-email-jaegeuk@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 07:52:51AM -0700, Jaegeuk Kim wrote:
> commit dd6b9bf5883c3ca9c17bac80ccd8615fe5a452a3 upstream.

You mean 2743f865543c0c4a5e12fc13edb2bf89a6e9687c, right?

thanks,

greg k-h

> 
> If we don't check the current backing device status, balance_dirty_pages can
> fall into infinite pausing routine.
> 
> This can be occurred when a lot of directories make a small number of dirty
> dentry pages including files.
> 
> Reported-by: Brian Chadwick <brianchad@westnet.com.au>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  fs/f2fs/node.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index a9c0495..5696bde 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -42,6 +42,8 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
>  		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
>  		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
>  	} else if (type == DIRTY_DENTS) {
> +		if (sbi->sb->s_bdi->dirty_exceeded)
> +			return false;
>  		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
>  		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
>  	}
> -- 
> 2.0.1.472.g6f92e5f
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
