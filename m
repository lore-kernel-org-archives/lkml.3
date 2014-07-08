Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbaGHTaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:30:17 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:39556 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383AbaGHTaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:30:07 -0400
Date: Tue, 8 Jul 2014 12:30:03 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nick Krause <xerofoify@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Compile issues with se7206_defconfig
Message-ID: <20140708193003.GA30984@roeck-us.net>
References: <CAPDOMVid3nbw0-3n_5d8QF_c5uOosWyYRPtqW29ZUB9Ziz7F+Q@mail.gmail.com>
 <53BB6D8F.70900@roeck-us.net>
 <CAMuHMdVS79CpOiNkB60Vdrbe_ba=C=ONTFbsXbkcjJacSLaZYw@mail.gmail.com>
 <20140708164525.GB12935@roeck-us.net>
 <CAMuHMdVpWMboV1JGnOY7BtB1Qcm2=70Q079NPSGfut4Kjz34dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVpWMboV1JGnOY7BtB1Qcm2=70Q079NPSGfut4Kjz34dQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 09:24:49PM +0200, Geert Uytterhoeven wrote:
> On Tue, Jul 8, 2014 at 6:45 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >> > net/built-in.o: In function `__sk_run_filter':
> >> > filter.c:(.text+0x3156c): undefined reference to `__fpscr_values'
> >> > filter.c:(.text+0x31760): undefined reference to `__fpscr_values'
> >> > filter.c:(.text+0x31c8c): undefined reference to `__fpscr_values'
> >> > filter.c:(.text+0x31f00): undefined reference to `__fpscr_values'
> >> > filter.c:(.text+0x323b0): undefined reference to `__fpscr_values'
> >>
> >> Toolchain issue: the compiler doesn't recognize the option to disable
> >> the FPU, so it isn't passed, cfr.
> >> www.spinics.net/lists/netdev/msg278300.html
> >
> > Seems that similar problems were fixed earlier without requiring a toolchain
> > change. What is different this time (besides the apparent difficulty to build a
> > new toolchain) ? Or am I missing something ?
> 
> sh4-linux-gcc doesn't recognize -m2a-nofpu, so that is not passed.
> It does recognize -m4a-nofpu, but when that's passed, it complains
> about opcode not valid for this cpu variant in inline asm/
> 
> Ah, it also recognizes -m4-nofpu. If I add that, se7206_defconfig builds.
> I assume a proper sh2a-linux toolchain will not recognize the -m4-nofpu,
> so it won't be passed due to $(call cc-option).
> 
> Does this sound like an acceptable solution? If yes, I'll send a patch.
> 
Sounds good to me.

Guenter
