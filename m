Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaG1THF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:07:05 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48494 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaG1THA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:07:00 -0400
Date: Mon, 28 Jul 2014 21:06:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andreas Schwab <schwab@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
Message-ID: <20140728190652.GB366@ravnborg.org>
References: <CAKv+Gu_9HRwAxkJjT3KRvDbupp0yzstyq1dXsXkTu9M6swdCKQ@mail.gmail.com>
 <mvmr41aj2ob.fsf@hawking.suse.de>
 <CAKv+Gu_z4VTssLDhiQxi8DRJNEUgzrM5bFzje8NXEmBiA2vqeg@mail.gmail.com>
 <CAKv+Gu-B9_sgGgw9obrBGNUFSS1JcskN34s1X4PU8F5bauHT1Q@mail.gmail.com>
 <20140724161225.GA11204@ravnborg.org>
 <CAKv+Gu8ikMGNVHeuujSf4eaK+LOFKMWxKF8i76VthnKYgvOcYQ@mail.gmail.com>
 <20140724204526.GA11754@ravnborg.org>
 <CAKv+Gu9S8vVALGFR1qL+sFfnUuYR9pkkwy0t6NuJHrs9bVxdBw@mail.gmail.com>
 <20140727184010.GA26029@ravnborg.org>
 <CAKv+Gu_1FXj8fOckrFbxEz7figdKmcvN+gnpvBC8g8QArpO+3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_1FXj8fOckrFbxEz7figdKmcvN+gnpvBC8g8QArpO+3Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:00:17PM +0200, Ard Biesheuvel wrote:
> On 27 July 2014 20:40, Sam Ravnborg <sam@ravnborg.org> wrote:
> >>
> >> > Btw. the current solution is already faulty - even with the fix.
> >> > There are no support for make C=2 arch/.../crypto/
> >> >
> >>
> >> So can you elaborate on how it is faulty?
> >
> > When you run "make C=2 arch/.../crypto/" then sparse shall be run
> > for all .c files also if they are already built.
> > But due to the re-implementation of some parts of the kbuild logic
> > in the makefile this does not happen with the -glue file.
> >
> > A minor detail - but this may not be the only wreckage we see over time.
> >
> 
> I agree. Any suggestions for a generic way to solve this?
Yes - two small .c file that each include the same glue file.
Anything else is over-engineering.

> BTW, while looking into this issue, I noticed something else that is strange:
> after touch'ing sha1-ce-glue.c in arch/arm64/crypto and re-executing
> 'make V=2', this is what I get
> 
> make[1]: Entering directory `/home/ard/linux-arm64-build'
>   CHK     include/config/kernel.release
>   Using /home/ard/linux-2.6 as source for kernel
>   GEN     ./Makefile
>   CHK     include/generated/uapi/linux/version.h
>   CHK     include/generated/utsrelease.h
>   CALL    /home/ard/linux-2.6/scripts/checksyscalls.sh - due to target missing
>   CHK     include/generated/compile.h
>   CC      arch/arm64/crypto/sha1-ce-glue.o - due to:
> /home/ard/linux-2.6/arch/arm64/crypto/sha1-ce-glue.c
>   LD      arch/arm64/crypto/sha1-ce.o - due to: arch/arm64/crypto/sha1-ce-glue.o
>   LD      arch/arm64/crypto/sha2-ce.o - due to: arch/arm64/crypto/sha1-ce-glue.o
>   LD      arch/arm64/crypto/ghash-ce.o - due to:
> arch/arm64/crypto/sha1-ce-glue.o
>   LD      arch/arm64/crypto/aes-ce-ccm.o - due to:
> arch/arm64/crypto/sha1-ce-glue.o
>   LD      arch/arm64/crypto/built-in.o - due to:
> arch/arm64/crypto/sha1-ce.o arch/arm64/crypto/sha2-ce.o
> arch/arm64/crypto/ghash-ce.o arch/arm64/crypto/aes-ce-ccm.o
>   CHK     kernel/config_data.h
>   LINK    vmlinux - due to: arch/arm64/crypto/built-in.o

Just from inspecting the above I have no idea.
And I have no arm64 toolchain installed to test myself.

So for now no clue - sorry.

	Sam
