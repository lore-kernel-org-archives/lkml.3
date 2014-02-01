Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaBAVGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 16:06:16 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49854 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbaBAVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 16:06:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140201202320.GA1313@p100.box>
References: <20140201202320.GA1313@p100.box>
Date: Sat, 1 Feb 2014 22:06:14 +0100
Message-ID: <CAFLxGvy7vbKmQzyNvTbk35DX5cFGS99CE=nYE_Q0c=LVuD1x9A@mail.gmail.com>
Subject: Re: [GIT PULL] parisc updates for v3.14
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Helge Deller <deller@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-parisc@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 1, 2014 at 9:23 PM, Helge Deller <deller@gmx.de> wrote:
> Hi Linus,
>
> please pull the latest updates for the parisc architecture from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/deller/parisc-linux.git parisc-for-3.14
>
> The three major changes in this patchset is a implementation for flexible
> userspace memory maps, cache-flushing fixes (again), and a long-discussed ABI
> change to make EWOULDBLOCK the same value as EAGAIN.
>
> parisc has been the only platform where we had EWOULDBLOCK != EAGAIN to keep
> HP-UX compatibility.  Since we will probably never implement full HP-UX
> support, we prefer to drop this compatibility to make it easier for us with
> Linux userspace programs which mostly never checked for both values.  We don't
> expect major fall-outs because of this change, and if we face some, we will
> simply rebuild the necessary applications in the debian archives.
>
> The change to fs/exec.c only touches code which affects parisc since it's
> inside a #ifdef CONFIG_STACK_GROWSUP section (and parisc is the only platform
> where the stack grows upwards).

What about metag?

> Thanks,
> Helge
>
> ----------------------------------------------------------------
> Guy Martin (1):
>       parisc: Make EWOULDBLOCK be equal to EAGAIN on parisc
>
> Helge Deller (5):
>       parisc/sti_console: prefer Linux fonts over built-in ROM fonts
>       parisc: fix cache-flushing
>       parisc: add flexible mmap memory layout support
>       parisc: wire up sched_setattr and sched_getattr
>       parisc: convert uapi/asm/stat.h to use native types only
>
>  arch/parisc/include/asm/cacheflush.h  |   2 -
>  arch/parisc/include/asm/elf.h         |   7 +
>  arch/parisc/include/asm/page.h        |   3 +-
>  arch/parisc/include/asm/pgtable.h     |   1 +
>  arch/parisc/include/asm/processor.h   |   2 +
>  arch/parisc/include/asm/thread_info.h |  10 ++
>  arch/parisc/include/uapi/asm/errno.h  |   2 +-
>  arch/parisc/include/uapi/asm/stat.h   |  40 +++---
>  arch/parisc/include/uapi/asm/unistd.h |   4 +-
>  arch/parisc/kernel/cache.c            |  14 ++
>  arch/parisc/kernel/process.c          |  21 ++-
>  arch/parisc/kernel/sys_parisc.c       | 238 ++++++++++++++++++++++++++++------
>  arch/parisc/kernel/syscall_table.S    |   2 +
>  drivers/video/console/sticore.c       |   2 +-
>  fs/exec.c                             |   3 +
>  lib/fonts/Kconfig                     |   6 +-
>  16 files changed, 284 insertions(+), 73 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
