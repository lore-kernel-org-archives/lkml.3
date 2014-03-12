Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaCLVhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:37:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:57632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbaCLVhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:37:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,641,1389772800"; 
   d="scan'208";a="490797078"
Message-ID: <5320D3AB.5060002@linux.intel.com>
Date: Wed, 12 Mar 2014 14:37:47 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefani Seibold <stefani@seibold.net>
CC: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>	<CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com>	<CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>	<CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>	<CA+55aFzB9jjOjxT=m=5t04L3JONe5HhEhuHUXtqDYREmEjQrgQ@mail.gmail.com>	<531F365B.4060000@linux.intel.com>	<CA+55aFxmkBnwDfKhX7h1qoJ3emD=+ugc3OLNDH79a1kGu7He1Q@mail.gmail.com>	<531F3D02.30706@linux.intel.com>	<CALCETrXt5=N7U-f1i+oCkbF5xqc0Qn8U_C9B47grcuEagAhDEA@mail.gmail.com>	<CALCETrWCXY-hwZh2U4QPp0YeeGuPXFUrUuCn7h-5H+TvdXEq5Q@mail.gmail.com>	<CA+55aFz+OfvtXLxg4CA4C6GPGh8F_aDuG6nnFFCCBpjTPLP1zA@mail.gmail.com>	<1394613046.995.51.camel@wall-e.seibold.net>	<CA+55aFyTCoipjhbAVCuhCgqb8JeSjGcmOU3xE6EFrjNpfspfqg@mail.gmail.com>	<CA+55aFxc8Qp-4_+n=upd-ghzkxpjCyRpesm3P7xtWjDyBe9MCw@mail.gmail.com> <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
In-Reply-To: <CA+55aFyhS5jCWcxuK4bXKEPh+8HWbPE+gy1m4N9B-2HyT48+QA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 12:41 PM, Linus Torvalds wrote:
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

How would that deal with the legacy vsyscall case for x86-64?  Just rely
on the "legacy vsyscall emulation" (which seems to have its own class of
problems...)?

	-hpa


