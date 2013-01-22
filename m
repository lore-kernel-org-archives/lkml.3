Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3AVPeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:34:02 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986Ab3AVPeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:34:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] making HAVE_SYSCALL_WRAPPERS universal (Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit)
Date: Tue, 22 Jan 2013 15:33:50 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org, Tony Luck <tony.luck@intel.com>
References: <50F3D2F2.3080200@6wind.com> <20130121023010.GR4939@ZenIV.linux.org.uk> <20130121225517.GV4939@ZenIV.linux.org.uk>
In-Reply-To: <20130121225517.GV4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301221533.50965.arnd@arndb.de>
X-Provags-ID: V02:K0:NBmFFaZ45VwTfdqE+rj8gyQL5fZMiY5dRQRGhfz3lcB
 hW8ARFqAY+5tKzypFB8h6j7lH5FVYvc8+mfTVVgDacF+bjj+NA
 k5uuBfedZ+1CFEvaQ/z3ASIf/mJ43h5seRa/8C8eJkFpCp0dQ8
 kRWvAKg6Tr0anQvzaEG3Y7Dh4spaHZcno0iZeHeY80QAAekz+y
 Hwi8PEgFEQrpoLDag/rfPqIR25gOXF+XjCeQpDQqYOBjGiu17i
 RSweLWHsdonbz5Lc36HeUaRWJntjeyjG4QdHW9f3kvVhxmDv60
 C7SHA+Wg9wppFAoVl/wAwuyruj0izkU0H7U7scubw9MXipn/D3
 NbK+55MXYEsybk24LzUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Al Viro wrote:
>         1) alpha, mips
> .weak foo
> foo = sys_ni_syscall
>         2) itanic, ppc
> asmlinkage long x (void) __attribute__((weak,alias("sys_ni_syscall")))
>         3) very common - most of the architectures
> .weak foo
> .set foo sys_ni_syscall
>         3a) blackfin, h8300 - same as (3), except that asm symbols get
> underscore prepended.
> .weak _foo
> .set _foo _sys_ni_syscall

One question here: Is there still a reason why we can't use method 2 on
all architectures now? The comment in a lot of architectures says

 * What we want is __attribute__((weak,alias("sys_ni_syscall")))
 * but it doesn't work on all toolchains, so we just do it by hand

and my guess is that all toolchains we support at this point actually
do allow it, and turn it into the appropriate assembler syntax.

	Arnd
