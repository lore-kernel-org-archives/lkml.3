Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660AbaB0VQr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:16:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18136 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaB0VQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:16:45 -0500
From: Paul Moore <pmoore@redhat.com>
To: libseccomp-discuss@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [libseccomp-discuss] Making a universal list of syscalls?
Date: Thu, 27 Feb 2014 16:16:29 -0500
Message-ID: <3314313.Fyy7jKNWkG@sifl>
Organization: Red Hat
User-Agent: KMail/4.12.2 (Linux/3.12.9-gentoo; KDE/4.12.2; x86_64; ; )
In-Reply-To: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com>
References: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 27, 2014 12:40:32 PM Andy Lutomirski wrote:
> Currently, dealing with Linux syscalls in an architecture-independent
> way is a mess.  Here are some issues:
> 
>  1. There's no clean way to map between syscall names and numbers on
> different architectures.  The kernel contains a number of tables (that
> work differently for different architectures).  strace has some arcane
> mechanism.  libseccomp has another.

This is a major pain point for libseccomp, what we have now is passable, and 
it works, but I cringe each time I look at it because I worry about 
maintaining it.  I would be very happy if the kernel had some 
header/file/whatever that could be used by userspace applications to map 
syscall names/numbers for each architecture.

>  2. There's no clean way to map between syscall argument registers and
> logical syscall arguments.  Each architecture knows how to do it, as
> do strace and glibc, but I suspect that *everyone* else gets it wrong.
>  Especially on ARM.

I remember looking into this with libseccomp, around the ARM time frame with 
Andy, and I believe I managed to reassure myself - not well, mind you - that 
we were *ok* with seccomp/libseccomp.  However, having a argument mapping 
document/header/etc. would go a long way here.

>  3. Determining which architectures have which syscalls is a mess.
> Recent kernel builds love to warn me that finit_module is missing on
> x86_64.  This is simply not true.  I have no idea why.

Closely related to item #1.  Also a major pain for libseccomp for the same 
reasons.

>  5. Decoding ucontext from SIGSYS is a mess.  I have prototype code
> for libseccomp that can do it, but it gets the arguments wrong due to
> ABI issues.  See (2).

I've actually been sitting on some of Andy's libseccomp code for this for a 
while now because the solution is very fiddly.  Improvements here could make 
life much easier for us and remove a lot of my hesitation in merging Andy's 
code.

-- 
paul moore
security and virtualization @ redhat

