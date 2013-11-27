Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3K0Ryw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 12:54:52 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:38965 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab3K0Ryt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 12:54:49 -0500
Date: Wed, 27 Nov 2013 18:54:42 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Olof Johansson <olofj@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] use -fstack-protector-strong
Message-ID: <20131127175442.GA28088@gmail.com>
References: <20131126203727.GA352@www.outflux.net>
 <20131127112731.GA10435@gmail.com>
 <CAGXu5jLY+AzaB4f92OLA6Orm=Mr9C+G+-mgOmSf-yju+YCmaUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLY+AzaB4f92OLA6Orm=Mr9C+G+-mgOmSf-yju+YCmaUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> On Wed, Nov 27, 2013 at 3:27 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Kees Cook <keescook@chromium.org> wrote:
> >
> >> On a defconfig x86_64 build (with CONFIG_CC_STACKPROTECTOR enabled), the
> >> delta in size is just under 9% larger:
> >>
> >>  -rwxrwxr-x 1 kees kees  22134340 Nov 26 10:28 vmlinux.gcc-4.8
> >>  -rwxrwxr-x 1 kees kees  22123870 Nov 26 10:40 vmlinux.gcc-4.9
> >>  -rwxrwxr-x 1 kees kees  24225118 Nov 26 10:42 vmlinux.gcc-4.9+strong
> >
> > Please run it through 'size' so that we know the real text size
> > increases.
> 
>    text    data     bss     dec     hex filename
> 11407474        1453792 1191936 14053202         d66f52 vmlinux.gcc-4.8
> 11458837        1457504 1191936 14108277         d74675 vmlinux.gcc-4.9
> 11682929        1457504 1191936 14332369         dab1d1 vmlinux.gcc-4.9+strong
> 
> Looks to be 2% for defconfig. That's way better. Shall I send a v3?

Well, it's better than 9%, but still almost an order of magnitude 
higher than the cost is today, and a lot of distros have 
CONFIG_CC_STACKPROTECTOR=y.

So it would be nice to measure how much the instruction count goes up 
in some realistic system-bound test. How much does something like 
kernel/built-in.o increase, as per 'size' output?

Thanks,

	Ingo
