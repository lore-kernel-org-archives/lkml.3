Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbaAFJ3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 04:29:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54374 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaAFJ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 04:29:51 -0500
Date: Mon, 6 Jan 2014 10:29:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCHv5 6/7] perf: introduce a flag to enable close-on-exec in
 perf_event_open()
Message-ID: <20140106092929.GA31570@twins.programming.kicks-ass.net>
References: <cover.1388952061.git.ydroneaud@opteya.com>
 <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c03f54e1598b1727c19706f3af03f98685d9fe6.1388952061.git.ydroneaud@opteya.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 09:36:33PM +0100, Yann Droneaud wrote:
> Unlike recent modern userspace API such as
>   epoll_create1 (EPOLL_CLOEXEC), eventfd (EFD_CLOEXEC),
>   fanotify_init (FAN_CLOEXEC), inotify_init1 (IN_CLOEXEC),
>   signalfd (SFD_CLOEXEC), timerfd_create (TFD_CLOEXEC),
>   or the venerable general purpose open (O_CLOEXEC),
> perf_event_open() syscall lack a flag to atomically set FD_CLOEXEC
> (eg. close-on-exec) flag on file descriptor it returns to userspace.
> 
> The present patch adds a PERF_FLAG_FD_CLOEXEC flag to allow
> perf_event_open() syscall to atomically set close-on-exec.
> 
> Having this flag will enable userspace to remove the file descriptor
> from the list of file descriptors being inherited across exec,
> without the need to call fcntl(fd, F_SETFD, FD_CLOEXEC) and the
> associated race condition between the current thread and another
> thread calling fork(2) then execve(2).
> 
> Links:
> 
>  - Secure File Descriptor Handling (Ulrich Drepper, 2008)
>    http://udrepper.livejournal.com/20407.html
> 
>  - Excuse me son, but your code is leaking !!! (Dan Walsh, March 2012)
>    http://danwalsh.livejournal.com/53603.html
> 
>  - Notes in DMA buffer sharing: leak and security hole
>    http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/dma-buf-sharing.txt?id=v3.13-rc3#n428
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>

Seems sane enough.

Thanks!
