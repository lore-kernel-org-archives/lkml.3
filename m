Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbaA2ILe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:11:34 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53672 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaA2ILc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:11:32 -0500
Date: Wed, 29 Jan 2014 09:11:28 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140129081128.GA31489@gmail.com>
References: <20140128062806.GA20750@gmail.com>
 <52E76997.40303@nod.at>
 <52E7D2E5.8090208@linux.intel.com>
 <52E7D9FF.1080506@nod.at>
 <52E7DB15.3090808@zytor.com>
 <CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
 <20140128170507.GA16279@gmail.com>
 <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
 <20140128194823.GA18702@gmail.com>
 <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Jan 28, 2014 at 11:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > I really meant it when I said I build without debuginfo! :)
> 
> Ok, but so what?
> 
> As mentioned, nobody sane should build with DEBUG_INFO. But a normal 
> vmlinux file has the symbol information even without it.

So, your mail sure read to me as a rant directed at me, so I thought 
I'd defend myself or something :)

I now realize that the whole episode was caused by me calling the 
vmlinux 'symbol-less':

> > > > AFAICS this won't work in a symbol-less vmlinux. Is there some 
> > > > trick to do it with gdb?

while I should have said 'debuginfo-less'. Mea culpa.

> > So, when I build a kernel, such as with a regular 'make defconfig',
> > the following happens in gdb:
> >
> >   Reading symbols from /home/mingo/tip/vmlinux...(no debugging symbols found)...done.
> >   (gdb) list schedule+0x45
> >   No symbol table is loaded.  Use the "file" command.
> >
> > Is there a way to resolve schedule+0x45 in a regular vmlinux? It 
> > was an honest question.
> 
> That seems to be just a gdb bug (or "UI feature"), in that gdb likes 
> to give misleading error messages and requires odd syntax for some 
> things.

Yeah. Almost as if they worked hard to make annoying users go away or 
something. (LLVM is IMO a blessing because, despite its somewhat 
broken licensing, it cured a similar attitude of the GCC folks. In a 
way competition is more important than licensing details!)

> But you can see that the symbol is perfectly fine:
> 
>   (gdb) list *(schedule+0x45)

Oh, cool. Thanks for that trick - this will save me quite some time in 
the future.

So we can strip absolute addresses just fine from oopses - cool.

I'd even argue to strip the hex on non-randomized kernels as long as 
there's kallsyms around, and only print hex if we don't have any 
symbols.

> So my point is that the hex address doesn't give you *anything* that 
> the symbolic address doesn't give you. [...]

Yeah, and with your trick that's now the case for my debugging as 
well, which is a nice touch.

> [...] Unless you do truly crazy things like actively strip the 
> kernel.

Being crazy is something I try to avoid. (Beyond being a maintainer
of a software project as busy and stressful as the Linux kernel that is.)

Thanks,

	Ingo
