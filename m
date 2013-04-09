Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936077Ab3DIJGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:06:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:44035 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936012Ab3DIJG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:06:29 -0400
Date: Tue, 9 Apr 2013 11:06:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Clean up kernel/timer.c
In-Reply-To: <20130409182604.15039dc0e35097628f241294@canb.auug.org.au>
Message-ID: <alpine.LFD.2.02.1304091105470.21884@ionos>
References: <20130408115325.1e4b35359271383b9c459ef9@canb.auug.org.au> <20130408144341.7738da3c31074f7098898029@canb.auug.org.au> <20130408145616.fc074f04c4c813fd2eac96a1@canb.auug.org.au> <20130408143554.3d23a6d96bd880d46c201e8a@linux-foundation.org>
 <20130409182604.15039dc0e35097628f241294@canb.auug.org.au>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Apr 2013, Stephen Rothwell wrote:

> Andrew Morton noted:
> 
> 	akpm3:/usr/src/25> grep SYSCALL kernel/timer.c
> 	SYSCALL_DEFINE1(alarm, unsigned int, seconds)
> 	SYSCALL_DEFINE0(getpid)
> 	SYSCALL_DEFINE0(getppid)
> 	SYSCALL_DEFINE0(getuid)
> 	SYSCALL_DEFINE0(geteuid)
> 	SYSCALL_DEFINE0(getgid)
> 	SYSCALL_DEFINE0(getegid)
> 	SYSCALL_DEFINE0(gettid)
> 	SYSCALL_DEFINE1(sysinfo, struct sysinfo __user *, info)
> 	COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
> 
> 	Only one of those should be in kernel/timer.c.  Who wrote this thing?

Hehe :)
 
> Move some non timer related syscalls to kernel/sys.c
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
