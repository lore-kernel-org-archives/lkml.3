Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3EJTfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 15:35:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab3EJTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 15:35:13 -0400
Date: Fri, 10 May 2013 12:35:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: SyS symbol munging.
Message-Id: <20130510123510.78c066f177a7a8e5dd9ec7e4@linux-foundation.org>
In-Reply-To: <20130510192417.GA4915@redhat.com>
References: <20130510192417.GA4915@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 May 2013 15:24:17 -0400 Dave Jones <davej@redhat.com> wrote:

> On Fri, May 10, 2013 at 12:14:54PM -0700, Andrew Morton wrote:
> 
>  > [  163.953629] Call Trace:
>  > [  163.957706]  [<ffffffff812be322>] ipcget+0x182/0x380
>  > [  163.962123]  [<ffffffff810b99a5>] ?trace_hardirqs_on_caller+0x115/0x1e0
>  > [  163.966752]  [<ffffffff812c559a>] SyS_shmget+0x5a/0x60
>  > [  163.971163]  [<ffffffff812c47e0>] ? shm_close+0x140/0x140
>  > [  163.975590]  [<ffffffff812c3e60>] ? shm_release+0x50/0x50
>  > [  163.979991]  [<ffffffff812c3df0>] ? shm_get_unmapped_area+0x20/0x20
>  > [  163.984499]  [<ffffffff816caa14>] tracesys+0xdd/0xe2
>  
> This has been bugging me for a while.
> What's changing sys_shmget to SyS_shmget in that trace ? And why ?
> 

nm vmlinux | grep SyS

That's the actual name of the function definition which the C compiler
sees.  It's emitted by SYSCALL_DEFINE, cooked up by all the macro goop
in include/linux/syscalls.h.

I forget who did this initially and peeling back those layers with git
is tiresome.
