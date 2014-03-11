Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaCKRRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:17:15 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:55377 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaCKRRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:17:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
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
 <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com> <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Mar 2014 10:16:53 -0700
Message-ID: <CALCETrUHOe3yP2nyijU8HwUpE6CmSHJWgEGwgEJvdu3BhO+B1A@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefani Seibold <stefani@seibold.net>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 10:09 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Mar 11, 2014 at 9:50 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Looking forward, would it be reasonable to have an extensible set of
>> flags that live in the ELF interpreter's headers somewhere
>
> No. Not reasonable. The whole "32-bit x86" and "looking forward"
> combination makes absolutely zero sense.
>
> I can pretty much guarantee that even *phones* will be 64-bit if/when
> x86 ever gets there. They'll need it just for ARM emulation, I bet.
>
> So 32-bit x86 is dead, dead, dead. There's absolutely no future to it.
> We're not adding new stuff to "future-proof" it.

One of those flags is for 64-bit code, though -- it would be nice if
the tasks that don't use the legacy vsyscall page could tell the
kernel, which would allow them to opt into full ASLR.  (There are lots
of legacy programs around that need vsyscall emulation, so there's no
practical way to turn it off with a config option for a very long
time, but vsyscall emulation would be trivial to turn on and off
per-process.)

--Andy
