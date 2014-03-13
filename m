Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaCMQX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 12:23:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:52244 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbaCMQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 12:23:23 -0400
Date: Thu, 13 Mar 2014 17:23:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
In-Reply-To: <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1403131555590.18573@ionos.tec.linutronix.de>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net> <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com> <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
 <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com> <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com> <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
 <531F3D02.30706@linux.intel.com> <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com> <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com> <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
 <1394613046.995.51.camel@wall-e.seibold.net> <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com> <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com> <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Linus Torvalds wrote:
> On Wed, Mar 12, 2014 at 8:46 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >  - do *not* add the HPET/VVAR page games to the legacy case. Get rid
> > of the remap_pfn_pages() games entirely.
> 
> .. actually, another approach would be to do the HPET/VVAR page games,
> but make them non-legacy.
> 
> The reason I hate seeing those remap_pfn_range() things is because
> it's nasty code for a legacy case that I think shouldn't have new code
> written for it, especially when it won't get testing by developers.
> 
> So my reaction was "don't do that".
> 
> But people pointing out that we can't do what x86-64 does made me
> think: we could avoid the whole "nasty code for a legacy case" by
> making it the *non*-legacy case. We could get rid of the fixmap
> HPET/VVAR entirely - on x86-64 (which can use those addresses) a
> PC-relative addressing is probably actually better anyway, so mapping
> them together with the vdso code shouldn't hurt.
> 
> That would remove my objections to doing all this stuff for a case
> that developers won't see and use (the whole "It's dead, Jim"
> objection) . And it would unify the 32-bit and 64-bit cases.
>
> Together with Andy's "remove legacy 32-bit fixmap vdso", I'd feel that
> this is actually an _improvement_ to the current situation.
> 
> Would something like that be more acceptable to everybody?

Definitely yes.

Thanks,

	tglx



