Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936335Ab3DHVf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 17:35:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50663 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935997Ab3DHVf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 17:35:56 -0400
Date: Mon, 8 Apr 2013 14:35:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Guenter Roeck <linux@roeck-us.net>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Convert compat_sys_sysinfo to COMPAT_SYSCALL_DEFINE
Message-Id: <20130408143554.3d23a6d96bd880d46c201e8a@linux-foundation.org>
In-Reply-To: <20130408145616.fc074f04c4c813fd2eac96a1@canb.auug.org.au>
References: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au>
	<20130408144341.7738da3c31074f7098898029@canb.auug.org.au>
	<20130408145616.fc074f04c4c813fd2eac96a1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013 14:56:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> --- a/kernel/timer.c
> +++ b/kernel/timer.c
> @@ -1661,8 +1661,7 @@ struct compat_sysinfo {
>  	char _f[20-2*sizeof(u32)-sizeof(int)];
>  };
>  
> -asmlinkage long
> -compat_sys_sysinfo(struct compat_sysinfo __user *info)
> +COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)

wtflol.

akpm3:/usr/src/25> grep SYSCALL kernel/timer.c 
SYSCALL_DEFINE1(alarm, unsigned int, seconds)
SYSCALL_DEFINE0(getpid)
SYSCALL_DEFINE0(getppid)
SYSCALL_DEFINE0(getuid)
SYSCALL_DEFINE0(geteuid)
SYSCALL_DEFINE0(getgid)
SYSCALL_DEFINE0(getegid)
SYSCALL_DEFINE0(gettid)
SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)

Only one of those should be in kernel/timer.c.  Who wrote this thing?
