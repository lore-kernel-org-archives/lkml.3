Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaEOMWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:22:35 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:39113 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaEOMWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:22:34 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <1397211951-20549-14-git-send-email-miklos@szeredi.hu>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-14-git-send-email-miklos@szeredi.hu>
Date: Thu, 15 May 2014 14:22:33 +0200
Message-ID: <CAJfpegsAUQZ0mxpqOeVj2SERT41Caw77irBHSTPMc0CaQp=uYA@mail.gmail.com>
Subject: Re: [PATCH 13/15] sparc: add renameat2 syscall
From: Miklos Szeredi <miklos@szeredi.hu>
To: "David S. Miller" <davem@davemloft.net>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 12:25 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: David S. Miller <davem@davemloft.net>

David,

I'll be sending a batch of patches with arch support for the renameat2
syscall to Linus next week.  If you'd like me to send this as well,
could you please ACK it?

Thanks,
Miklos

> ---
>  arch/sparc/include/uapi/asm/unistd.h | 3 ++-
>  arch/sparc/kernel/systbls_32.S       | 1 +
>  arch/sparc/kernel/systbls_64.S       | 2 ++
>  3 files changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/arch/sparc/include/uapi/asm/unistd.h b/arch/sparc/include/uapi/asm/unistd.h
> index b73274fb961a..42f2bca1d338 100644
> --- a/arch/sparc/include/uapi/asm/unistd.h
> +++ b/arch/sparc/include/uapi/asm/unistd.h
> @@ -410,8 +410,9 @@
>  #define __NR_finit_module      342
>  #define __NR_sched_setattr     343
>  #define __NR_sched_getattr     344
> +#define __NR_renameat2         345
>
> -#define NR_syscalls            345
> +#define NR_syscalls            346
>
>  /* Bitmask values returned from kern_features system call.  */
>  #define KERN_FEATURE_MIXED_MODE_STACK  0x00000001
> diff --git a/arch/sparc/kernel/systbls_32.S b/arch/sparc/kernel/systbls_32.S
> index 151ace8766cc..85fe9b1087cd 100644
> --- a/arch/sparc/kernel/systbls_32.S
> +++ b/arch/sparc/kernel/systbls_32.S
> @@ -86,3 +86,4 @@ sys_call_table:
>  /*330*/        .long sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
>  /*335*/        .long sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
>  /*340*/        .long sys_ni_syscall, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
> +/*345*/        .long sys_renameat2
> diff --git a/arch/sparc/kernel/systbls_64.S b/arch/sparc/kernel/systbls_64.S
> index 4bd4e2bb26cf..814beaeda4dc 100644
> --- a/arch/sparc/kernel/systbls_64.S
> +++ b/arch/sparc/kernel/systbls_64.S
> @@ -87,6 +87,7 @@ sys_call_table32:
>  /*330*/        .word compat_sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, compat_sys_open_by_handle_at, compat_sys_clock_adjtime
>         .word sys_syncfs, compat_sys_sendmmsg, sys_setns, compat_sys_process_vm_readv, compat_sys_process_vm_writev
>  /*340*/        .word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
> +       .word sys_renameat2
>
>  #endif /* CONFIG_COMPAT */
>
> @@ -165,3 +166,4 @@ sys_call_table:
>  /*330*/        .word sys_fanotify_mark, sys_prlimit64, sys_name_to_handle_at, sys_open_by_handle_at, sys_clock_adjtime
>         .word sys_syncfs, sys_sendmmsg, sys_setns, sys_process_vm_readv, sys_process_vm_writev
>  /*340*/        .word sys_kern_features, sys_kcmp, sys_finit_module, sys_sched_setattr, sys_sched_getattr
> +       .word sys_renameat2
> --
> 1.8.1.4
>
