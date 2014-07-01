Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaGAFJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:09:41 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:50776 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbaGAFJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <20140701000913.5ea51f77@gandalf.local.home>
References: <20140701000913.5ea51f77@gandalf.local.home>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jun 2014 22:09:18 -0700
Message-ID: <CALCETrUJUvhGN3hrECf9A=vHkHSNqZ2KtMyDnmrhb-uTpgP6Nw@mail.gmail.com>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max = 13)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 9:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Testing the latest kernel (3.16-rc3) I hit this build bug:
>
>   VDSO2C  arch/x86/vdso/vdso-image-64.c
> Error: too many copied sections (max = 13)
> /arch/x86/vdso/Makefile:61: recipe for target 'arch/x86/vdso/vdso-image-64.c' failed
> make[3]: *** [arch/x86/vdso/vdso-image-64.c] Error 1
> /scripts/Makefile.build:404: recipe for target 'arch/x86/vdso' failed
> make[2]: *** [arch/x86/vdso] Error 2

I clearly need to improve that error message.  Sigh.

>
> I bisected it down to this commit:
>
> commit 0e3727a8839c988a3c56170bc8da76d55a16acad
> Author: Andy Lutomirski <luto@amacapital.net>
> Date:   Wed Jun 18 15:59:49 2014 -0700
>
>     x86/vdso: Remove some redundant in-memory section headers
>
> When I revert this commit, it compiles fine.

Weird.  Reverting that commit should be safe, but I'd like to
understand what's happening.

>
> I built my gcc and binutils from their sources unmodified:
>
> gcc 4.6.0
>
> binutils 2.21
>

I just successfully built your config, albeit with a different
toolchain.  Can you do:

for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done

after a failed build?

Let the game of section whack-a-mole begin.

Thanks,
Andy
