Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbaGHQpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 12:45:31 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:48541 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbaGHQp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 12:45:29 -0400
Date: Tue, 8 Jul 2014 09:45:25 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Compile issues with se7206_defconfig
Message-ID: <20140708164525.GB12935@roeck-us.net>
References: <CAPDOMVid3nbw0-3n_5d8QF_c5uOosWyYRPtqW29ZUB9Ziz7F+Q@mail.gmail.com>
 <53BB6D8F.70900@roeck-us.net>
 <CAMuHMdVS79CpOiNkB60Vdrbe_ba=C=ONTFbsXbkcjJacSLaZYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVS79CpOiNkB60Vdrbe_ba=C=ONTFbsXbkcjJacSLaZYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 10:08:46AM +0200, Geert Uytterhoeven wrote:
> On Tue, Jul 8, 2014 at 6:03 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 07/07/2014 07:56 PM, Nick Krause wrote:
> >> There seems to me a build issue with this config. I will paste my logs
> >> for this build below this message.
> >> Cheers Nick
> >> scripts/mod/empty.c:1:0: error: cannot use atomic model soft-imask in user
> >> mode
> >>   /* empty file to figure out endianness / word size */
> >>   ^
> >> make[2]: *** [scripts/mod/empty.o] Error 1
> >> make[2]: *** Waiting for unfinished jobs....
> >> make[1]: *** [scripts/mod] Error 2
> >> make[1]: *** Waiting for unfinished jobs....
> >>    CHK     include/generated/utsrelease.h
> >>    UPD     include/generated/utsrelease.h
> >>    Generating include/generated/machtypes.h
> >>    CC      kernel/bounds.s
> >> kernel/bounds.c:1:0: error: cannot use atomic model soft-imask in user
> >> mode
> >>   /*
> >>   ^
> >> make[1]: *** [kernel/bounds.s] Error 1
> >> make: *** [prepare0] Error 2
> >> make: *** Waiting for unfinished jobs....
> >> make: *** [scripts] Error 2
> >
> > What kernel version ? I see a build failure in mainline, but it is
> > different.
> 
> Indeed.
> 
> > net/built-in.o: In function `__sk_run_filter':
> > filter.c:(.text+0x3156c): undefined reference to `__fpscr_values'
> > filter.c:(.text+0x31760): undefined reference to `__fpscr_values'
> > filter.c:(.text+0x31c8c): undefined reference to `__fpscr_values'
> > filter.c:(.text+0x31f00): undefined reference to `__fpscr_values'
> > filter.c:(.text+0x323b0): undefined reference to `__fpscr_values'
> 
> Toolchain issue: the compiler doesn't recognize the option to disable
> the FPU, so it isn't passed, cfr.
> www.spinics.net/lists/netdev/msg278300.html
> 

Seems that similar problems were fixed earlier without requiring a toolchain
change. What is different this time (besides the apparent difficulty to build a
new toolchain) ? Or am I missing something ?

Thanks,
Guenter
