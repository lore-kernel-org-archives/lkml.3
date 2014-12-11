Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbaLKCc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 21:32:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42913 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933176AbaLKCc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 21:32:56 -0500
Date: Thu, 11 Dec 2014 02:32:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the vfs tree
Message-ID: <20141211023253.GW22149@ZenIV.linux.org.uk>
References: <20141210184537.4b0d98dd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210184537.4b0d98dd@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 06:45:37PM +1100, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> allnoconfig) failed like this:

> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 0791d086804d..7d98db03c2ce 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -3,6 +3,8 @@
>  #include <linux/fs.h>
>  #include <linux/proc_ns.h>
>  #include <linux/magic.h>
> +#include <linux/ktime.h>
> +#include <linux/timekeeping.h>

Umm...  Either it's time.h + timekeeping.h or ktime.h alone - ktime.h
pulls timekeeping.h and time.h.  For now I went with the latter variant.
However, I wonder if longer term it would be better to provide a variant
of new_inode_pseudo() that would set the timestamps that way - only two
callers (new_inode() and sock_alloc()) do not do exactly that.  Oh, well -
that can wait...

For now, fixed and force-pushed
