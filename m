Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947251Ab3BHWMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:12:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947095Ab3BHWMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:12:47 -0500
Date: Fri, 8 Feb 2013 17:12:01 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
Message-ID: <20130208221201.GI31684@hansolo.jdub.homelinux.org>
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
 <20130207141502.04625ea0.akpm@linux-foundation.org>
 <20130208003501.GC31684@hansolo.jdub.homelinux.org>
 <20130208181949.GD31684@hansolo.jdub.homelinux.org>
 <87k3qiwomi.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k3qiwomi.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:13:09PM -0800, Eric W. Biederman wrote:

For posterity's sake

> From: "Eric W. Biederman" <ebiederm@xmission.com>
> Date: Fri, 8 Feb 2013 12:05:54 -0800
> Subject: [PATCH] pid: unlock_irq when alloc_pid fails because init has
>  exited.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Tested-by: Josh Boyer <jwboyer@redhat.com>

> ---
>  kernel/pid.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/pid.c b/kernel/pid.c
> index de9af60..f2c6a68 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -331,7 +331,7 @@ out:
>  	return pid;
>  
>  out_unlock:
> -	spin_unlock(&pidmap_lock);
> +	spin_unlock_irq(&pidmap_lock);
>  out_free:
>  	while (++i <= ns->level)
>  		free_pidmap(pid->numbers + i);
> -- 
> 1.7.5.4
