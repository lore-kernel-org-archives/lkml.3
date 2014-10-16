Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbaJPUTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:19:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752620AbaJPUTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:19:37 -0400
Date: Thu, 16 Oct 2014 22:16:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the sub_info
	structure
Message-ID: <20141016201620.GA25225@redhat.com>
References: <20141016160042.7f898871@mschwide> <20141016173733.GA18318@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016173733.GA18318@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Oleg Nesterov wrote:
>
> OK... I am wondering if __call_usermodehelper() still needs CLONE_VFORK
> with this patch.

Yes, looks like it doesn't, but this needs another patch.

> > @@ -588,7 +580,7 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
> >  		goto out;
> >  	}
> >
> > -	sub_info->complete = &done;
> > +	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;
>
> This probably needs a comment, and the comment in umh_complete() should
> be updated,
>
> 	- we own sub_info, the UMH_KILLABLE caller has gone away.
> 	+ we own sub_info, the UMH_KILLABLE caller has gone away
> 	+ or the caller used UMH_NO_WAIT.
>
> The patch looks correct at first glance. I'll try to re-read it later
> once again.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

