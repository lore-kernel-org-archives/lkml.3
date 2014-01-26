Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaAZKQd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 05:16:33 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:49455 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbaAZKQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 05:16:31 -0500
MIME-Version: 1.0
In-Reply-To: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
References: <201401201647.s0KGlZdh004167@tazenda.hos.anvin.org>
Date: Sun, 26 Jan 2014 11:16:30 +0100
Message-ID: <CAFLxGvxO1MPDDjEh3FU5Gv2-eb6zBJxYtTnKdABDTTpbMxxYAw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Richard Weinberger <richard.weinberger@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Cong Ding <dinggnu@gmail.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 5:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hi Linus,
>
> This enables kernel address space randomization for x86.
>
> The following changes since commit d0e639c9e06d44e713170031fe05fb60ebe680af:
>
>   Linux 3.12-rc4 (2013-10-06 14:00:20 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-kaslr-for-linus
>
> The head of this tree is da2b6fb990cf782b18952f534ec7323453bc4fc9.
>
>   x86, kaslr: Clarify RANDOMIZE_BASE_MAX_OFFSET (2014-01-14 10:45:56 -0800)
>
> ----------------------------------------------------------------
> H. Peter Anvin (2):
>       x86, boot: Rename get_flags() and check_flags() to *_cpuflags()
>       x86, kaslr: Add a circular multiply for better bit diffusion
>
> Kees Cook (10):
>       x86, boot: Move CPU flags out of cpucheck
>       x86, kaslr: Return location from decompress_kernel
>       x86, kaslr: Provide randomness functions
>       x86, kaslr: Select random position from e820 maps
>       x86, kaslr: Report kernel offset on panic
>       x86, kaslr: Raise the maximum virtual address to -1 GiB on x86_64
>       x86/relocs: Add percpu fixup for GNU ld 2.23
>       x86, kaslr: Mix entropy sources together as needed
>       x86, kaslr: Use char array to gain sizeof sanity
>       x86, kaslr: Clarify RANDOMIZE_BASE_MAX_OFFSET
>
> Michael Davidson (1):
>       x86, relocs: Add more per-cpu gold special cases
>
> Wei Yongjun (1):
>       x86, kaslr: Remove unused including <linux/version.h>

Currently we print the kernel offset only upon a panic() using the
panic notifier list.
This way it does not show up if the kernel hits a BUG() in process
context or something less critical.
Wouldn't make more sense to report the offset in every dump_stack() or
show_regs() call?
Or at least add a hint that the kernel was built with kaslr enabled.

I'm a heavy user of addr2line -e vmlinux <booboo-happened-here>, so I
want to make sure that I don't waste
too much time with finding out that the addresses are useless. :-)

-- 
Thanks,
//richard
