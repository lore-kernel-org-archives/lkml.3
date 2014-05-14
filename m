Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbaENKeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:34:07 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55819 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbaENKeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:34:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 00/25] Change time_t and clock_t to 64 bit
Date: Wed, 14 May 2014 12:33:51 +0200
Message-ID: <4803676.5b3DxkdLDT@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFiDJ5-No1Uw6gxSDXvsv60iyxH=dZKaVTckyZLVEWYUpR504w@mail.gmail.com>
References: <1399971456-3941-1-git-send-email-lftan@altera.com> <6202090.0OtAjefIFT@wuerfel> <CAFiDJ5-No1Uw6gxSDXvsv60iyxH=dZKaVTckyZLVEWYUpR504w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:heHS40TRFNRd64T8IwGFOk1SAUYDfYBG6NK82O7usoE
 N0fcrmu5fKlZlOBPfL5jDaEhxN6Eq2GsMLMIDkUV0RLRdpG8tS
 hyjUH7sbVSsqfh3PC8cVdF+hUVBXlwKm9Fqmy34+HGS3tKUDGw
 WAFAXhayNjjMnOmFj5AEtElB/2DqX0zTxMrtd1vFpsHpr3nFvr
 N7Z0csKYKbPRZU0xkEaBo7UK5i3mko6l4fcc+ihoVr11EkdXrc
 tlwKTFCnHoBUp2vuLx1u/aFpXJjLcmHdg7USu/m1QUQMsyvbdy
 lnRoIa09We498ggdy0yeupK/oPocbBJZum+gKfe+wTlaXHYBaR
 sanj4GzC2bi7SjHjxpOA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 18:13:41 Ley Foon Tan wrote:
> On Wed, May 14, 2014 at 2:10 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > I've just spent two days looking at stuff that uses time_t inside
> > of the kernel, to get a better idea of what we actually need to
> > do to get provide new user interfaces for the existing architectures.
> >
> > My impression so far is that we're better off fixing it for the
> > existing architectures first and then using the new interfaces
> > exclusively on new ones, rather than changing over the ABI for
> > all new architectures at this point, which would likely create
> > yet another variant to maintain in the long run.
> >
> > Using 64-bit time_t on x32 is fine, because it's fast to operate
> > in user space with 64-bit registers, and the kernel is 64-bit
> > anyway. Inside of the kernel, we may get into trouble using
> > a 64-bit time_t on 32-bit architectures because of the overhead
> > in 64-bit math, e.g. all the timekeeping code that is based on
> > timespec or some code paths in file systems and network code where
> > we actually require division of time_t values.
> > We clearly have to change that code in some for to deal with y2038,
> > but 64-bit time_t may not be the best option. A lot of the
> > in-kernel code can probably use ktime_t, which we can change
> > to a different representation (e.g. 34 bit seconds) if needed,
> > and all the code that is only interested in relative time
> > (e.g. nanosleep) doesn't have to change at all.
> 
> Hi Arnd,
> 
> From your comment above, can I assume we don't need this patchset any more?

I won't require it, but it's not just my decision to make.

Let's see what Peter Anvin and Thomas Gleixner think about it, as they
have argued strongly in favor of using 64-bit time_t for new architectures
in the past.

	Arnd
