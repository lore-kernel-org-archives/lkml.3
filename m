Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbaIZPJK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:09:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbaIZPJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:09:09 -0400
Message-ID: <1411744121.3402.28.camel@localhost>
Subject: Re: linux-next: New build failures in Sep 25 tree
From: Eric Paris <eparis@redhat.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>, linux <linux@openrisc.net>,
        rgb@redhat.com
Date: Fri, 26 Sep 2014 11:08:41 -0400
In-Reply-To: <54256AF1.6030800@roeck-us.net>
References: <20140925202559.GA1750@roeck-us.net>
	 <CAMuHMdXE4aU1qZ9iGBT48QfMv5v7gsBZSjL_1_D8p=JBJfeN6A@mail.gmail.com>
	 <20140926075859.GA21697@chokladfabriken.org>
	 <54256AF1.6030800@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-26 at 06:32 -0700, Guenter Roeck wrote:
> On 09/26/2014 12:59 AM, Stefan Kristiansson wrote:
> > On Fri, Sep 26, 2014 at 08:30:57AM +0200, Geert Uytterhoeven wrote:
> >> Hi Günther,
> >>
> >> [cc openrisc]
> >>
> >> On Thu, Sep 25, 2014 at 10:25 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> >>> New build failures:
> >>
> >>> openrisc-defconfig
> >>>
> >>> In file included from arch/openrisc/kernel/signal.c:31:0:
> >>> ./arch/openrisc/include/asm/syscall.h: In function 'syscall_get_arch':
> >>> ./arch/openrisc/include/asm/syscall.h:77:9: error: 'EM_OPENRISC' undeclared
> >>
> >> That's not a new one. It's been failing for half or year or so.
> >>
> >> If you only see it now, that means something else got fixed ;-)
> >>
> >
> >>From what I can see, it's caused by
> > ce5d112827e5 ("ARCH: AUDIT: implement syscall_get_arch for all arches")
> > that got (re?)introduced two days ago.
> >
> > To me it seems that the problem is that EM_OPENRISC is
> > missing in include/uapi/linux/elf-em.h, but if that's the case,
> > I think microblaze have the same problem with that patch applied.
> >
> 
> Microblaze builds for some reason. But, yes, that commit is from March.
> Maybe that is where I remember it from.
> 
> You are right, it builds if I add the define. I'll submit a patch to fix
> the problem if the resulting image builds.
> 
> Guenter

I had no idea you were having build problems for so long!!  I'm so
sorry!  The tree got pulled from -next for a while because we ran into
some arm problems and I was going on vacation.  So I pulled from -next.
It just went back into -next (after I dealt with arm).  And so you saw
build failure again on the 25th.

I guess the choices are moving EM_OPENRISC public like the other ones
(which I believe you sent a patch for) or maybe you can include
arch/openrisc/include/uapi/asm/elf.h inside
arch/openrisc/include/asm/syscall.h so you still get to keep that
definition 'private'.  I have no idea if such an include would give you
a circular mess.  That happens all to often at the arch level.

