Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663AbaCLOl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 10:41:29 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:58599 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbaCLOl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 10:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <1394613046.995.51.camel@wall-e.seibold.net>
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
	<1394613046.995.51.camel@wall-e.seibold.net>
Date: Wed, 12 Mar 2014 07:41:26 -0700
X-Google-Sender-Auth: eXu2VxJ7RcOim61Y0-vtdC1I9Oo
Message-ID: <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 1:30 AM, Stefani Seibold <stefani@seibold.net> wrote:
>
> Is it possible to calm down and get a more technical discussion rather
> than blaming and treats not to accepting patches?

I'm just asking for an upside to the changes, and fighting changing
things "just because".

32-bit is not dead in the sense that it doesn't exist any more, but it
*is* dead in the sense that there is absolutely zero point in treating
it as a developing platform. That was very clearly also the context in
which I said "dead, dead, dead", I was objecting to trying to
future-proof things that are not worth future-proofing.

The VDSO code has worked for us for a long time, and I'm upset and
annoyed that people want to do "improvements" to it that are not
improvements at all. They are ugly (just look at that
remap_pfn_range() call in you patch - why?), and they cause problems,
and instead of people saying "ok, fix the source of the problem",
people are running around like headless chicken and saying "ok, let's
work around all these problems".

WHY?

Nobody has even explained why we want this at all, and why we want
this headache. Nobody has explained why the solution is not to "just
don't do that then". Instead, people are piling up *more* complexity
because the patch had a problem.

That's a technical issue, Stefani. And the threat to not apply patches
is a technical solution, and I'm getting more and more convinced is
the *right* technical solution.

And when Fengguang's automatic bug tester found the problem, YOU
STARTED ARGUING WITH HIM.  Christ, well *excuuse* me for being fed up
with this pointless discussion.

                  Linus
