Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaCLUxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:53:13 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:41670 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaCLUxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:53:09 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
 <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
 <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
 <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
 <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
 <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
 <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
 <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
 <531F3D02.30706@linux.intel.com> <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>
 <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
 <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
 <1394613046.995.51.camel@wall-e.seibold.net> <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
 <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com> <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 13:52:48 -0700
Message-ID: <CALCETrX58yfPHrZnKwgFY=6bihxcjiGn6wNKB+iVOb2QD0f5=w@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 12:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 12, 2014 at 8:46 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>>  - do *not* add the HPET/VVAR page games to the legacy case. Get rid
>> of the remap_pfn_pages() games entirely.
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

I think this is approximately what I was suggesting as a long-term solution :)

>
> Together with Andy's "remove legacy 32-bit fixmap vdso", I'd feel that
> this is actually an _improvement_ to the current situation.
>
> Would something like that be more acceptable to everybody?

I like it.

This has the added benefit that the vvar symbols can be ordinary
symbols as far as the compiler is concerned.  Unfortunately, I don't
know how to get the linker to play along without hardcoding the
offsets of all the variables into the linker script.  I'll play around
a bit.

--Andy

It would be nice to get rid of the vvar declaration stuff, too

>
>              Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
