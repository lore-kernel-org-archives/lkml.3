Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759278Ab3EBBtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 21:49:06 -0400
Received: from ozlabs.org ([203.10.76.45]:42983 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab3EBBtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 21:49:04 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: James Hogan <james.hogan@imgtec.com>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, James Hogan <james.hogan@imgtec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] linkage.h: fix build breakage due to symbol prefix handling
In-Reply-To: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
References: <1367442257-7897-1-git-send-email-james.hogan@imgtec.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 02 May 2013 09:58:08 +0930
Message-ID: <878v3yql7r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Hogan <james.hogan@imgtec.com> writes:
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

I just pushed my modules-next tree to Linus, so hopefully the nightmare
is over soon!

Cheers,
Rusty.
