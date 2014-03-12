Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaCLVt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:49:29 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51095 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaCLVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzC1Xy1VNF46Mj8V8CEc0tyVA76+631xZiF6nk3Gyvc-Q@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>
 <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
 <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
 <CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>
 <531F365B.4060000@linux.intel.com> <CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>
 <531F3D02.30706@linux.intel.com> <CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>
 <CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>
 <CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>
 <1394613046.995.51.camel@wall-e.seibold.net> <CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
 <CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com>
 <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
 <5320D3AB.5060002@linux.intel.com> <CA+55aFzC1Xy1VNF46Mj8V8CEc0tyVA76+631xZiF6nk3Gyvc-Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 14:49:06 -0700
Message-ID: <CALCETrUGc5+CS8=sYvtkK967ZR833zu98rzRkEw_DX++1hL-BA@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
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

On Wed, Mar 12, 2014 at 2:46 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 12, 2014 at 2:37 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>> How would that deal with the legacy vsyscall case for x86-64?  Just rely
>> on the "legacy vsyscall emulation" (which seems to have its own class of
>> problems...)?
>
> It does?
>
> We *default* to emulation, and have for over two years now (since
> v3.4).  If there are problems with it, we need to fix those.

Even in the non-default "vsyscall=native" case, the vsyscall pages
just contains syscalls.  It does not need to access the vvar page, the
hpet, or anything else that the vdso uses.

>
>            Linus



-- 
Andy Lutomirski
AMA Capital Management, LLC
