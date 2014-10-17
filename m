Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaJQPZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 11:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41234 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaJQPZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 11:25:11 -0400
Date: Fri, 17 Oct 2014 17:21:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the
	sub_infostructure
Message-ID: <20141017152156.GA6519@redhat.com>
References: <20141016160042.7f898871@mschwide> <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp> <20141016174209.GB18318@redhat.com> <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp> <20141016215834.GA28864@redhat.com> <20141017093653.6fa60dff@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017093653.6fa60dff@mschwide>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Martin Schwidefsky wrote:
>
> On Thu, 16 Oct 2014 23:58:34 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > I also agree that the changelog could mention exec_mmap. Plus a comment
> > about UMH_NO_WAIT && sub_info->complete == NULL. So yes, perhaps v2 makes
> > sense if Martin agrees.
>
> Version 2 of the patch.

Thanks!

> All change requests have gone in except for the
> mention of exec_mmap. I don't quite get the relevance of it, do_execve
> can fail for the various reasons.

Yes. But if it fails before exec_mmap() (which in particular calls
mm_release()->complete_vfork_done()) we are safe; sub_info can't go away
because the parent sleeps in sys_wait4() if UMH_WAIT_PROC, or it sleeps
in wait_for_vfork_done() otherwise.

But this is minor, and this only relates to the changelog. So still/again

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

