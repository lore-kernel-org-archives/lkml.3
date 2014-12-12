Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370AbaLLV1b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 16:27:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaLLV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 16:27:30 -0500
Date: Fri, 12 Dec 2014 22:27:27 +0100
From: Jan Kara <jack@suse.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, All Versions <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] reiserfs: destroy allocated commit workqueue
Message-ID: <20141212212727.GB18669@quack.suse.cz>
References: <1418398169-19820-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418398169-19820-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 12-12-14 16:29:29, Jiri Slaby wrote:
> When resirefs is trying to mount a partition, it creates a commit
> workqueue (sbi->commit_wq). But when mount fails later, the workqueue
> is not freed.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: auxsvr@gmail.com
> Reported-by: Benoît Monin <benoit.monin@gmx.fr>
> Cc: Jan Kara <jack@suse.cz>
> Cc: All Versions <stable@vger.kernel.org>
> Cc: reiserfs-devel@vger.kernel.org
  Thanks, I've added the patch to my tree and will send it to Linus soon.

								Honza
> ---
>  fs/reiserfs/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index ea63ab13ef92..71fbbe3e2dab 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -2172,6 +2172,9 @@ error_unlocked:
>  		reiserfs_write_unlock(s);
>  	}
>  
> +	if (sbi->commit_wq)
> +		destroy_workqueue(sbi->commit_wq);
> +
>  	cancel_delayed_work_sync(&REISERFS_SB(s)->old_work);
>  
>  	reiserfs_free_bitmap_cache(s);
> -- 
> 2.2.0
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
