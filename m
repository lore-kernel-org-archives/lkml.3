Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869Ab3HPWkB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:40:01 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60337 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756776Ab3HPWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:39:54 -0400
Date: Fri, 16 Aug 2013 15:39:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [ 00/17] 3.4.58-stable review
Message-ID: <20130816223950.GA9152@roeck-us.net>
References: <20130813201936.GA18358@roeck-us.net>
 <20130815063158.GB25754@kroah.com>
 <520C86BD.2020903@roeck-us.net>
 <CAMuHMdU+EOC_etihOzUC6N0cqc2qHaGm3_L+gyTRxESCGhOzEg@mail.gmail.com>
 <520DB045.7000309@roeck-us.net>
 <20130816051041.GA23784@kroah.com>
 <520DE21D.8000905@roeck-us.net>
 <20130816124140.GD24550@kroah.com>
 <20130816202702.GD4568@roeck-us.net>
 <CAMuHMdW6Ji7ibMeQj5FBQsJS3B-WWx=Lbhmjx4CCFEGg_uobHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdW6Ji7ibMeQj5FBQsJS3B-WWx=Lbhmjx4CCFEGg_uobHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:55:02PM +0200, Geert Uytterhoeven wrote:
> On Fri, Aug 16, 2013 at 10:27 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > Still failing:
> >         sparc64:allmodconfig
> > /opt/buildbot/slave/stable-queue-3_4/build/usr/include/linux/types.h:27:1: error: unknown type name ‘__u16’
> 
> According to my log collection, this same error message was fixed in v3.3-rc2,
> but I couldn't easily find a matching commit.
> But this is v3.4-stable, which is after v3.3-rc2, so it got reintroduced?
> 
It was fixed recently with

commit cbf1ef6b3345d2cc7e62407eec6a6f72a8b1346f
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sun Mar 31 07:01:47 2013 +0000

    sparc: use asm-generic version of types.h

and

commit a2d34dd41212032c03e77bc30c2023725def841a
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Sat Mar 30 11:44:22 2013 +0000

    sparc: use generic headers

I tried to apply those patches, but it failed miserably due to the
userspace/kernel header separation. Given that, I figured that
it would be too invasive to fix, at least for me.

> >         xtensa:defconfig
> > dev.c:(.text.unlikely+0x3): dangerous relocation: l32r: literal placed after use: .literal.unlikely
> 
> Fixed in v3.7-rc1:
> 
> commit f6a03a12ecdbe0dd80a55f6df3b7206c5a403a49
> Author: Max Filippov <jcmvbkbc@gmail.com>
> Date:   Mon Sep 17 05:44:31 2012 +0400
> 
>     xtensa: fix linker script transformation for .text.unlikely
> 
Yes, that fixes this problem, except now we get another known error:

kernel/built-in.o:(.text+0x8c8): undefined reference to `_sdata'

which you had fixed with

commit 5e7b6ed8e9bf3c8e3bb579fd0aec64f6526f8c81
Author: Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed Jun 20 12:52:58 2012 -0700

    xtensa: replace xtensa-specific _f{data,text} by _s{data,text}

After applying both patches to the 3.4-stable queue, xtensa:defconfig builds
successfully.

Thanks,
Guenter
