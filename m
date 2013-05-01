Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759867Ab3EAVnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 17:43:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36122 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757685Ab3EAVni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 17:43:38 -0400
Date: Wed, 1 May 2013 22:43:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: James Hogan <james.hogan@imgtec.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix
 handling
Message-ID: <20130501214335.GB11630@ZenIV.linux.org.uk>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 10:04:17PM +0100, James Hogan wrote:
> Al's commit e1b5bb6d1236d4ad2084c53aa83dde7cdf6f8eea ("consolidate
> cond_syscall and SYSCALL_ALIAS declarations") broke the build on
> blackfin and metag due to the following code:
> 
>   #ifndef SYMBOL_NAME
>   #ifdef CONFIG_SYMBOL_PREFIX
>   #define SYMBOL_NAME(x) CONFIG_SYMBOL_PREFIX ## x
>   #else
>   #define SYMBOL_NAME(x) x
>   #endif
>   #endif
>   #define __SYMBOL_NAME(x) __stringify(SYMBOL_NAME(x))
> 
> __stringify literally stringifies CONFIG_SYMBOL_PREFIX ##x, so you get
> lines like this in kernel/sys_ni.s:
> 
>   .weak CONFIG_SYMBOL_PREFIXsys_quotactl
>   .set CONFIG_SYMBOL_PREFIXsys_quotactl,CONFIG_SYMBOL_PREFIXsys_ni_syscall
> 
> The patches in Rusty's modules-next tree such as "CONFIG_SYMBOL_PREFIX:
> cleanup." clean up the whole mess around symbol prefixes, so this patch
> just attempts to fix the build in the mean time. The intermediate
> definition of SYMBOL_NAME above isn't used and is incorrect when
> CONFIG_SYMBOL_PREFIX is defined as CONFIG_SYMBOL_PREFIX is a quoted
> string literal, so define __SYMBOL_NAME directly depending on
> CONFIG_SYMBOL_PREFIX.

Oh, hell...  Guys, my deep apologies - what happened is that this thing
has been caught in -next, rebase done here (on top of Rusty's commit)
and *not* pushed to linux-next.  Unfortunately, folks had been too polite
and didn't keep kicking me - mistake, since the whole thing got forgotten ;-/
Sigh...
