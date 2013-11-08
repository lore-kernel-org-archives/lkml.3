Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab3KHS6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:58:24 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51574 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050Ab3KHS6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:58:22 -0500
X-Originating-IP: 173.246.103.110
Date: Fri, 8 Nov 2013 10:58:12 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the tip
 tree
Message-ID: <20131108185812.GB11311@jtriplet-mobl1>
References: <20131108184805.ec16e3b5cc08834cb5d4f812@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108184805.ec16e3b5cc08834cb5d4f812@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 06:48:05PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> kernel/Makefile between commits 60fc28746a7b ("locking: Move the spinlock
> code to kernel/locking/") and cd4d241d57c9 ("locking: Move the lglocks
> code to kernel/locking/") from the tip tree and commit f5639052d567
> ("lglock: map to spinlock when !CONFIG_SMP") from the akpm-current tree.
> 
> I fixed it up (dropping the kernel/Makefile section of the akpm-current
> commit and adding the below patch) and can carry the fix as necessary (no
> action is required).

Won't splitting the Makefile change into a separate commit break
bisection, in particular if you have the changes adding inlines but you
also compile in lglock.o?  Shouldn't this be squashed into the merge
itself, keeping the kernel/Makefile section of my original patch?

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 8 Nov 2013 18:45:25 +1100
> Subject: [PATCH] lglock: fixup for code movement
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  kernel/locking/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/locking/Makefile b/kernel/locking/Makefile
> index baab8e5e7f66..bb3c65930a20 100644
> --- a/kernel/locking/Makefile
> +++ b/kernel/locking/Makefile
> @@ -1,5 +1,5 @@
>  
> -obj-y += mutex.o semaphore.o rwsem.o lglock.o
> +obj-y += mutex.o semaphore.o rwsem.o
>  
>  ifdef CONFIG_FUNCTION_TRACER
>  CFLAGS_REMOVE_lockdep.o = -pg
> @@ -8,6 +8,7 @@ CFLAGS_REMOVE_mutex-debug.o = -pg
>  CFLAGS_REMOVE_rtmutex-debug.o = -pg
>  endif
>  
> +obj-$(CONFIG_SMP) += lglock.o
>  obj-$(CONFIG_DEBUG_MUTEXES) += mutex-debug.o
>  obj-$(CONFIG_LOCKDEP) += lockdep.o
>  ifeq ($(CONFIG_PROC_FS),y)
> -- 
> 1.8.4.2
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


