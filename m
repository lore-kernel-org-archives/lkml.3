Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbaCLIbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 04:31:06 -0400
Received: from www84.your-server.de ([213.133.104.84]:48078 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbaCLIbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 04:31:03 -0400
Message-ID: <1394613046.995.51.camel@wall-e.seibold.net>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
From: Stefani Seibold <stefani@seibold.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 12 Mar 2014 09:30:46 +0100
In-Reply-To: <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
	 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
	 <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
	 <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
	 <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
	 <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
	 <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
	 <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
	 <531F365B.4060000@linux.intel.com>
	 <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
	 <531F3D02.30706@linux.intel.com>
	 <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>
	 <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
	 <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 11.03.2014, 10:09 -0700 schrieb Linus Torvalds:
> On Tue, Mar 11, 2014 at 9:50 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > Looking forward, would it be reasonable to have an extensible set of
> > flags that live in the ELF interpreter's headers somewhere
> 
> No. Not reasonable. The whole "32-bit x86" and "looking forward"
> combination makes absolutely zero sense.
> 
> I can pretty much guarantee that even *phones* will be 64-bit if/when
> x86 ever gets there. They'll need it just for ARM emulation, I bet.
> 
> So 32-bit x86 is dead, dead, dead. There's absolutely no future to it.
> We're not adding new stuff to "future-proof" it.
> 

Quite frankly this sounds like the mad scientist in an old marvell
comic: "dead, dead, dead".

Is it possible to calm down and get a more technical discussion rather
than blaming and treats not to accepting patches?

Can we also stop this hard words like "WTF". I don't like this style and
other developers too, especially women.

32-bit is not dead. I think 98 percent of all computers running linux
are embedded devices and a lot of them are not capable for 64 bit
support. So its your opinion, but there a also developers not sharing
this.

For me i still work with old Celeron Pentium III devices. And the life
time of this device will end in 7 years.

A lot of peoples (also main kernel hackers) ask me to do this patch
because the time functions in 32 bit kernel mode are so slow compared to
a 64 bit linux. And as i can see most of the involved kernel developers
are not opposite against this patch.

The other side is that many embedded developers use hand crafted time
functions using TSC or similar to get a fast time functions, but did not
know the pitfalls (C- and P-States) to handle this in a right way. So a
reliable way is to use the kernel functions, because the kernel knows
the state of the CPU and always returns the correct time. But this will
result in a slow down of the application, which generates latency.

We use this kind of patch for a long time and it decreased the latency
of our applications notable.

The current solution is quite clean, but there was a issue with the size
of the vDSO which not fits into one page by some kernel configurations. 

There is a solution for this to #undef CONFIG_OPTIMIZE_INLINING and
CONFIG_X86_PPRO_FENCE in arch/x86/vdso/vdso32/vclock_gettime.c. 

To prevent issues which future kernel releases, we have now two ideas to
solve this:

One ist Andy's kick ouf of the compat VDSO. For this there is already a
patch there.

And the other one is (thanks to Andys archeology investigations) to
increase the size of the vDSO fixmap space which has according to Andy
no side effect. This can be done in a very clean and easy way. The code
is still there, since the fixmap area is not fix:

Lguest, XEN, OPLC and the reservetop will move the fixmap during boot,
so we can easily get additional space by fixing __FIXADDR_TOP.

I will write a patch for the later one.

- Stefani


