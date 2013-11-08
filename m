Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128Ab3KHS6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:58:51 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37414 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab3KHS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:58:47 -0500
X-Originating-IP: 173.246.103.110
Date: Fri, 8 Nov 2013 10:58:41 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the vfs
 tree
Message-ID: <20131108185841.GC11311@jtriplet-mobl1>
References: <20131108183806.809acb8b1608c42457d64e5a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108183806.809acb8b1608c42457d64e5a@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 06:38:06PM +1100, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm-current tree got a conflict in
> include/linux/lglock.h between commit 4314ff760e8b ("no need to keep
> brlock macros anymore...") from the vfs tree and commit f5639052d567
> ("lglock: map to spinlock when !CONFIG_SMP") from the akpm-current tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

This looks like the right fix.

> diff --cc include/linux/lglock.h
> index 96549abe8842,6561b1c0fa63..000000000000
> --- a/include/linux/lglock.h
> +++ b/include/linux/lglock.h
> @@@ -25,6 -25,18 +25,8 @@@
>   #include <linux/cpu.h>
>   #include <linux/notifier.h>
>   
>  -/* can make br locks by using local lock for read side, global lock for write */
>  -#define br_lock_init(name)	lg_lock_init(name, #name)
>  -#define br_read_lock(name)	lg_local_lock(name)
>  -#define br_read_unlock(name)	lg_local_unlock(name)
>  -#define br_write_lock(name)	lg_global_lock(name)
>  -#define br_write_unlock(name)	lg_global_unlock(name)
>  -
>  -#define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
>  -#define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
>  -
> + #ifdef CONFIG_SMP
> + 
>   #ifdef CONFIG_DEBUG_LOCK_ALLOC
>   #define LOCKDEP_INIT_MAP lockdep_init_map
>   #else


