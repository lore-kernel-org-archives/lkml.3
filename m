Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbbAZVsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:48:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464AbbAZVsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:48:05 -0500
Date: Mon, 26 Jan 2015 13:48:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] compat: Declare compat_sys_sigpending and
 compat_sys_sigprocmask prototypes
Message-Id: <20150126134803.99158a48850283da3d67d6cf@linux-foundation.org>
In-Reply-To: <1420819048-3515-2-git-send-email-catalin.marinas@arm.com>
References: <1420819048-3515-1-git-send-email-catalin.marinas@arm.com>
	<1420819048-3515-2-git-send-email-catalin.marinas@arm.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Jan 2015 15:57:24 +0000 Catalin Marinas <catalin.marinas@arm.com> wrote:

> __ARCH_WANT_SYS_SIGPENDING or __ARCH_WANT_SYS_SIGPROGMASK may be defined
> for compat support but the corresponding prototypes are missing from
> linux/compat.h.
> 
> ...
>
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -689,6 +689,15 @@ asmlinkage long compat_sys_sendfile64(int out_fd, int in_fd,
>  asmlinkage long compat_sys_sigaltstack(const compat_stack_t __user *uss_ptr,
>  				       compat_stack_t __user *uoss_ptr);
>  
> +#ifdef __ARCH_WANT_SYS_SIGPENDING
> +asmlinkage long compat_sys_sigpending(compat_old_sigset_t __user *set);
> +#endif
> +
> +#ifdef __ARCH_WANT_SYS_SIGPROCMASK
> +asmlinkage long compat_sys_sigprocmask(int how, compat_old_sigset_t __user *nset,
> +				       compat_old_sigset_t __user *oset);
> +#endif
> +

ack, please merge and submit.
