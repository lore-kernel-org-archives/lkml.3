Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaDXKDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:03:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbaDXKDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:03:02 -0400
Date: Thu, 24 Apr 2014 12:03:00 +0200
From: Jan Kara <jack@suse.cz>
To: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 1/1] fanotify: for FAN_MARK_FLUSH check flags
Message-ID: <20140424100300.GL17824@quack.suse.cz>
References: <1398290151-6502-1-git-send-email-xypron.glpk@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398290151-6502-1-git-send-email-xypron.glpk@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 23-04-14 23:55:51, Heinrich Schuchardt wrote:
> If fanotify_mark is called with illegal value of arguments flags and marks
> it usually returns EINVAL.
> 
> When fanotify_mark is called with FAN_MARK_FLUSH the argument flags is not
> checked for irrelevant flags like FAN_MARK_IGNORED_MASK.
> 
> The patch removes this inconsistency.
> 
> If an irrelevant flag is set error EINVAL is returned.
  OK, as Michael I think this shouldn't cause real userspace breakage and
it's better to have the flags checked. So feel free to add:
Acked-by: Jan Kara <jack@suse.cz>

							Honza

> 
> Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
> ---
>  fs/notify/fanotify/fanotify_user.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 287a22c..8bba549 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -819,7 +819,10 @@ SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
>  	case FAN_MARK_REMOVE:
>  		if (!mask)
>  			return -EINVAL;
> +		break;
>  	case FAN_MARK_FLUSH:
> +		if (flags & ~(FAN_MARK_MOUNT | FAN_MARK_FLUSH))
> +			return -EINVAL;
>  		break;
>  	default:
>  		return -EINVAL;
> -- 
> 1.9.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
