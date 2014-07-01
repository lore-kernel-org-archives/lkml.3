Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaGAVrf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:47:35 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:32880 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbaGAVre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:47:34 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrXy3ft8AipAm=_u9OJb-t+FF=AfvXBke4pTh5a25nTcFA@mail.gmail.com>
References: <CALCETrXy3ft8AipAm=_u9OJb-t+FF=AfvXBke4pTh5a25nTcFA@mail.gmail.com>
Date: Tue, 1 Jul 2014 14:47:33 -0700
X-Google-Sender-Auth: 6bi9xYHtLHAHSCh2-w2rAOg7eR0
Message-ID: <CAGXu5jJAdr8mJttE_7XrV0Dj2UEQ-LgyEwNs5txA_mC66Qgm6Q@mail.gmail.com>
Subject: Re: Seccomp performance vs. asm complexity
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 1:18 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This is a question about tradeoffs.  I'm playing with a couple of
> approaches for an x86 seccomp fast path.
>
> It looks like populating struct seccomp_data in the syscall entry asm
> code saves 4-5ns (83ns vs 87.7ns or so for getpid with seccomp
> enabled).  Presumably this is because it avoids a branch and replaces
> seven two-instruction memory copies with 6 register pushes and one
> memory push.  It also keeps the code shorter, with corresponding
> icache benefits.
>
> OTOH, populating struct seccomp_data in C keeps the asm code shorter
> and simpler.  In fast, it ends up being a net deletion of asm code.
>
> Thoughts?  What's a line of assembly code worth?  Keep in mind that
> someone will probably want to port this to the x86_32 and compat
> entries.

My feeling is that keeping it maintainable/readable should probably
take precedence over 5ns. The syscall entry points are already
complex, and already very security-sensitive, so my
(security-conservative) instincts are for robustness over speed.

> To keep this in perspective, this is down from >200ns in 3.16-rc3.
>
> My current code is here:
>
> https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/seccomp-fastpath
>
> I think it's in pretty good shape, but I still want to play with it a
> bit before sending it out.  This version uses the C approach.

This looks really great!

-Kees

-- 
Kees Cook
Chrome OS Security
