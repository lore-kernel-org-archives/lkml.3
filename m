Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaCLQSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:18:13 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40869 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbaCLQSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:18:11 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyyeMaKRvk+SQ_nVgaZQhmFQgi3dGGtut7JBgZ9fGMpXw@mail.gmail.com>
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
	<CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>
	<CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com>
	<CA+55aFyyeMaKRvk+SQ_nVgaZQhmFQgi3dGGtut7JBgZ9fGMpXw@mail.gmail.com>
Date: Wed, 12 Mar 2014 12:18:10 -0400
Message-ID: <CAMzpN2j1-Pa0JrVBnpFJHV++-Kw7FjSvf1gEYy1+HZNJHt-CUQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
From: Brian Gerst <brgerst@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefani Seibold <stefani@seibold.net>,
        Andy Lutomirski <luto@amacapital.net>,
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

On Wed, Mar 12, 2014 at 12:04 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Mar 12, 2014 at 8:46 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> But I think that "x86, vdso: Add 32 bit VDSO time support for 32 bit
>> kernel" patch needs to die. And the helper patches building up to it
>> (just because that patch used [io_]remap_pfn_range()) should die too.
>> Why weren't those pages in the vdso*_pages[] array anyway?
>
> Sorry, confused. FIXMAP, not vdso_pages.
>
> Anyway, that's what x86-64 does. Why not 32?

A 32-bit process running on a 64-bit kernel cannot access the high
fixmap mappings.  The VVAR/HPET pages have to be mapped below 4GB.

--
Brian Gerst
