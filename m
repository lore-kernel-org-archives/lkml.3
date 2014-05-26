Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaEZQ6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 12:58:09 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:60006 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130AbaEZQ6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 12:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <1401110850-3552-3-git-send-email-tixxdz@opendz.org>
References: <1401110850-3552-1-git-send-email-tixxdz@opendz.org> <1401110850-3552-3-git-send-email-tixxdz@opendz.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 26 May 2014 09:57:44 -0700
Message-ID: <CALCETrVyPRf2K6kCVfy-=WsgXD66ONz=sNzp2TWt3+cREmNRmQ@mail.gmail.com>
Subject: Re: [PATCH 2/9] procfs: add pid_entry_access() for proper checks on /proc/<pid>/*
To: Djalal Harouni <tixxdz@opendz.org>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 6:27 AM, Djalal Harouni <tixxdz@opendz.org> wrote:
> Add the helper pid_entry_access() to unify the permission checks during
> ->open()
>
> This is a preparation patch.
>
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/proc/generic.c  | 22 ++++++++++++++++++++++
>  fs/proc/internal.h |  2 ++
>  2 files changed, 24 insertions(+)
>
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index b7f268e..98ed927 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -23,6 +23,7 @@
>  #include <linux/bitops.h>
>  #include <linux/spinlock.h>
>  #include <linux/completion.h>
> +#include <linux/ptrace.h>
>  #include <asm/uaccess.h>
>
>  #include "internal.h"
> @@ -596,3 +597,24 @@ void *PDE_DATA(const struct inode *inode)
>         return __PDE_DATA(inode);
>  }
>  EXPORT_SYMBOL(PDE_DATA);
> +
> +int pid_entry_access(struct file *filp, unsigned int mode)

pid_entry_may_ptrace, perhaps?

--Andy
