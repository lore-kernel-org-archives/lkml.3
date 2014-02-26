Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550AbaBZLOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:14:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaBZLOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:14:34 -0500
Date: Wed, 26 Feb 2014 12:14:32 +0100
From: Jan Kara <jack@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140226111432.GD6989@quack.suse.cz>
References: <20140226190436.53e6cf83e03ef4261577b94c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140226190436.53e6cf83e03ef4261577b94c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-02-14 19:04:36, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> fs/notify/fanotify/fanotify_user.c: In function 'SYSC_fanotify_init':
> fs/notify/fanotify/fanotify_user.c:707:8: error: 'struct fanotify_event_info' has no member named 'response'
>   oevent->response = 0;
>         ^
> 
> Caused by my bad conflict resolution.  I added the following merge fix
> patch (but I am not too sure of it).
  The fix below looks good for now. I'll push the fixes which are in
linux-next to Linus this week and after that send Andrew an updated version
of the cleanup rebased on top of fixes (ultimately the code added in the
fix wants to use new alloc_event() helper added by the cleanup).

								Honza

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 26 Feb 2014 19:01:03 +1100
> Subject: [PATCH] fanotify: fix for bad merge resolution
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  fs/notify/fanotify/fanotify_user.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 0edc47f7dfae..0d378a8cd279 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -704,7 +704,6 @@ SYSCALL_DEFINE2(fanotify_init, unsigned int, flags, unsigned int, event_f_flags)
>  
>  	group->fanotify_data.f_flags = event_f_flags;
>  #ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
> -	oevent->response = 0;
>  	spin_lock_init(&group->fanotify_data.access_lock);
>  	init_waitqueue_head(&group->fanotify_data.access_waitq);
>  	INIT_LIST_HEAD(&group->fanotify_data.access_list);
> -- 
> 1.9.0
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
