Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaGaF51 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 01:57:27 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:49930 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaGaF5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 01:57:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140730221127.GF10213@pd.tnic>
References: <20140730164701.GA19604@pd.tnic>
	<20140730211937.GA14864@jig.fritz.box>
	<20140730212814.GA15010@jig.fritz.box>
	<20140730221127.GF10213@pd.tnic>
Date: Thu, 31 Jul 2014 07:57:22 +0200
Message-ID: <CA+rthh-Hi+1iqAQigcQ9WBkmUYDjpUEEHnaKHkECwtVjJgO4vw@mail.gmail.com>
Subject: Re: [PATCH] x86, crypto: Check if gas supports CRC32
From: Mathias Krause <minipli@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 July 2014 00:11, Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, Jul 30, 2014 at 11:28:14PM +0200, Mathias Krause wrote:
> > Gah, CONFIG_AS_CRC32 gets defined as a preprocessor symbol only so
> > cannot be used in makefiles. So crc32c-pcl-intel-asm_64.S needs a
> > "#ifdef CONFIG_AS_CRC32" guard and still be compiled for CONFIG_64BIT,
> > as it is now. It'll be an empty object for older binutils versions not
> > supporting the crc32 instruction.
>
> Yeah, that makes it all even simpler, thanks!
>
> We're still b0rked though:
>
> arch/x86/crypto/crct10dif-pcl-asm_64.S: Assembler messages:
> arch/x86/crypto/crct10dif-pcl-asm_64.S:147: Error: no such instruction: `pclmulqdq $0x0,%xmm10,%xmm0'
> arch/x86/crypto/crct10dif-pcl-asm_64.S:148: Error: no such instruction: `pclmulqdq $0x11,%xmm10,%xmm8'
> arch/x86/crypto/crct10dif-pcl-asm_64.S:149: Error: no such instruction: `pclmulqdq $0x0,%xmm10,%xmm1'
> ...
>
> and need checking for more instructions. I'll play with this more
> tomorrow.
>

You probably can reuse the AVX test for this -- either the
CONFIG_AS_AVX preprocessor one or the $(avx_supported) make one, local
to arch/x86/crypto/Makefile.
Even though the CLMUL feature has not much to with AVX (it has a
dedicated CPUID feature bit), support for it in binutils was added
together with AVX support, see
https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=c0f3af977b0f28a0dc5a620110b8dcf9d8286f84

Regards,
Mathias

> Good night :-)
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
