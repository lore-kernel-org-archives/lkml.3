Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbaB0Uxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:53:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbaB0Uxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:53:50 -0500
Message-ID: <1393534420.24180.59.camel@flatline.rdu.redhat.com>
Subject: Re: [libseccomp-discuss] Making a universal list of syscalls?
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net,
        Steve Grubb <sgrubb@redhat.com>
Date: Thu, 27 Feb 2014 15:53:40 -0500
In-Reply-To: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com>
References: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 12:40 -0800, Andy Lutomirski wrote:
> Currently, dealing with Linux syscalls in an architecture-independent
> way is a mess.  Here are some issues:
> 
>  1. There's no clean way to map between syscall names and numbers on
> different architectures.  The kernel contains a number of tables (that
> work differently for different architectures).  strace has some arcane
> mechanism.  libseccomp has another.

userspace audit a 3rd.

> I'd like to see a master list in the kernel that lists, for every
> syscall, the name, the number for each architecture that implements it
> (using the AUDIT_ARCH semantics, probably), and the signature.  The
> build process could parse this table to replace the current per-arch
> mess.

I know for audit it would be huge if userspace didn't try to organically
grow this knowledge on their own!  So +1 from me!

> 
> Issues here: some syscalls have different signatures on different
> architectures.  Maybe we could require that a canonical syscall name
> would have the same signature everywhere, but architectures could
> specify alternate names.  So, for things like clone (?), there could
> actually be a few syscalls that all have alternate names of "clone".
> 
> More importantly, we could add a library in tools that exposes this
> information to userspace.  Useful operations:
> 
>  - For a given (arch, nr), indicate, for each logical argument, which
> physical argument slot is used or, if the argument is split into a
> high and low part, which pair of slots is used.
> 
>  - For a given (nr, logical args), issue the syscall for the
> architecture that build the library.
> 
>  - For a given (arch, nr, logical args), issue the syscall if
> possible.  An x86_32 build could issue x86_64 syscalls with some
> effort, and an x86_64 build could easily issue 32-bit syscalls.
> 
>  - For a given arch, map between name and nr, and give access to the signature.
> 
> If this happened, presumably all architectures that supported it would
> have to have valid AUDIT_ARCH support.  That means that someone would
> have to fix ARM OABI (sigh).
> 
> Thoughts?

