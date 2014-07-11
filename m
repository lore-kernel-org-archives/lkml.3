Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaGKKiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:38:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaGKKiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:38:18 -0400
Date: Fri, 11 Jul 2014 12:35:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Silesh C V <svellattu@mvista.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH] coredump: Fix the setting of PF_DUMPCORE
Message-ID: <20140711103510.GA2252@redhat.com>
References: <1405072839-4137-1-git-send-email-svellattu@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405072839-4137-1-git-send-email-svellattu@mvista.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OOPS. Thanks a lot Silesh.

Hopefully Andrew can take this patch. And it probably needs
Cc: stable@vger.kernel.org # v3.10+

On 07/11, Silesh C V wrote:
>
> commit 079148b91 (coredump: factor out the setting of PF_DUMPCORE)
> cleaned up the setting of PF_DUMPCORE by removing it from all the
> linux_binfmt->core_dump() and moving it to zap_threads().But this
> ended up clearing all the previously set flags. This causes issues
> during core generation when tsk->flags is checked again
> (eg. for PF_USED_MATH to dump floating point registers). Fix this.
> 
> Signed-off-by: Silesh C V <svellattu@mvista.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Mandeep Singh Baines <msb@chromium.org>
> 
> ---
>  fs/coredump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 0b2528f..a93f7e6 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -306,7 +306,7 @@ static int zap_threads(struct task_struct *tsk, struct mm_struct *mm,
>  	if (unlikely(nr < 0))
>  		return nr;
>  
> -	tsk->flags = PF_DUMPCORE;
> +	tsk->flags |= PF_DUMPCORE;
>  	if (atomic_read(&mm->mm_users) == nr + 1)
>  		goto done;
>  	/*
> -- 
> 1.8.1.2
> 

