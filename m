Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaATSzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:55:13 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:62375 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbaATSzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:55:09 -0500
Date: Mon, 20 Jan 2014 13:55:07 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] arm64: advertise availability of CRC and crypto
 instructions
In-Reply-To: <CAKv+Gu8JEaVZDiOEegUeYfWbAMMH0ddgcWaTjFBpjXzoiKRoQg@mail.gmail.com>
Message-ID: <alpine.LFD.2.11.1401201351120.1652@knanqh.ubzr>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org> <20140120173838.GD29971@arm.com> <alpine.LFD.2.11.1401201242480.1652@knanqh.ubzr> <CAKv+Gu8jqctGFsyccg6_VGkZ6ogf8BD_kq1rsRQrc+cw7pk+qA@mail.gmail.com> <alpine.LFD.2.11.1401201307300.1652@knanqh.ubzr>
 <CAKv+Gu8JEaVZDiOEegUeYfWbAMMH0ddgcWaTjFBpjXzoiKRoQg@mail.gmail.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Ard Biesheuvel wrote:

> On 20 January 2014 19:17, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Mon, 20 Jan 2014, Ard Biesheuvel wrote:
> >> Calling getauxval(AT_HWCAP) on an outdated libc.so will give you the
> >> whole value, not just the bits whose meaning was known to glibc at the
> >> time.
> >> So if desired, a program can interpret AT_HWCAP itself.
> >>
> >> AT_HWCAP2 is completely new, so you won't be able to retrieve it using
> >> getauxval() on an older libc.
> >
> > I agree.  And I don't dispute the bit placement choice either.
> >
> > Still, an old glibc calling getauxval(AT_HWCAP) should already be
> > prepared to receive and rightfully ignore those bits it didn't know the
> > meaning of at the time.  So "preserving some future extensions in HWCAP
> > for older glibc" as a justification makes little sense to me... unless
> > I'm missing something?
> >
> > Even if applications interpret those bits themselves, supposing they
> > still need to be linked against an old glibc, then why would
> > yet-to-be-defined future extensions be more important to be signaled
> > using the lower 32 bits than the extensions you propose?  That is what I
> > don't get.
> >
> 
> In the general case, you are quite right.
> 
> In this particular case, the extensions for which I am adding the
> feature bits are not supported on any hardware currently known or
> supported by the ARM port. At this time, the only known CPUs
> supporting these extensions are ARMv8 CPUs executing in 32-bit
> compatibility mode (i.e., ARMv8 defines instructions for the 32-bit
> execution state using previously unallocated opcodes)

So?

> So the only reason (currently) for adding these feature bits to the
> ARM port is to align with the ARMv8 32-bit compat mode so that a
> 32-bit userland requires no knowledge about whether its 32-bit
> execution environment is hosted by an ARM or an arm64 kernel. In the
> future, ARMv8 32-bit only CPUs may well turn up that support these
> extensions as well.

I agree with all you've said so far.  But that doesn't answer my 
question.

And my unanswered question isn't that important either.


Nicolas
