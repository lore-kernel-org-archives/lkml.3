Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715AbaGXUpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:45:46 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:48591 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:45:45 -0400
Date: Thu, 24 Jul 2014 22:45:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andreas Schwab <schwab@suse.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64/crypto: fix makefile rule for aes-glue-%.o
Message-ID: <20140724204526.GA11754@ravnborg.org>
References: <mvm4my7j5xh.fsf@hawking.suse.de>
 <CAKv+Gu-6rUxUnF+dRuroDJqy2K2B5F0r7_bm0X-vyiuQ-83W5w@mail.gmail.com>
 <CAKv+Gu96k7GOVR85EXtro3Lt0jjiJqxyvT9cwJZ1qc6uzq97bw@mail.gmail.com>
 <mvmvbqmj3b2.fsf@hawking.suse.de>
 <CAKv+Gu_9HRwAxkJjT3KRvDbupp0yzstyq1dXsXkTu9M6swdCKQ@mail.gmail.com>
 <mvmr41aj2ob.fsf@hawking.suse.de>
 <CAKv+Gu_z4VTssLDhiQxi8DRJNEUgzrM5bFzje8NXEmBiA2vqeg@mail.gmail.com>
 <CAKv+Gu-B9_sgGgw9obrBGNUFSS1JcskN34s1X4PU8F5bauHT1Q@mail.gmail.com>
 <20140724161225.GA11204@ravnborg.org>
 <CAKv+Gu8ikMGNVHeuujSf4eaK+LOFKMWxKF8i76VthnKYgvOcYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8ikMGNVHeuujSf4eaK+LOFKMWxKF8i76VthnKYgvOcYQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 09:25:13PM +0200, Ard Biesheuvel wrote:
> On 24 July 2014 18:12, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Thu, Jul 24, 2014 at 04:24:48PM +0200, Ard Biesheuvel wrote:
> >> On 24 July 2014 16:18, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> >> > On 24 July 2014 15:40, Andreas Schwab <schwab@suse.de> wrote:
> >> >> Ard Biesheuvel <ard.biesheuvel@linaro.org> writes:
> >> >>
> >> >>> On 24 July 2014 15:26, Andreas Schwab <schwab@suse.de> wrote:
> >> >>>> You are not using CONFIG_MODVERSIONS.
> >> >>>>
> >> >>>
> >> >>> I am
> >> >>
> >> >> No, you aren't, since you say that your .cmd contains a command to
> >> >> create aes-glue-ce.o, which with CONFIG_MODVERSIONS it doesn't.
> >> >>
> >> >
> >> > OK, you're right, it contains a command to create .tmp_aes-glue-ce.o.
> >> > But I am still not seeing the error you are seeing, strangely enough.
> >>
> >> OK, now I am seeing it.
> >>
> >> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > Jumping in the end of the thread here - sorry for that.
> >
> 
> No worries
> 
> > Another way to solve this would be to create two
> > small wrapper files:
> > aes-glue-neon.c - which include aes-glue.c
> > aes-glue-ce.c that include aes-glue.c
> >
> > Then you could use standard kbuild support for building your module.
> > And we will not potentially break it when we change cc_o_c in the near future.
> >
> 
> I see how that would fix this issue, but frankly, if we need to add .c
> files that only #include other .c files to support building multiple
> objects from a single .c file, I think the flaw is in the build
> system, and I would rather fix the build system instead.
The kbuild syntax could be extended to allow building multiple .o files from
a single .c file. But the need for this feature is so seldom that
people would not recognize the syntax most likely.

Btw. the current solution is already faulty - even with the fix.
There are no support for make C=2 arch/.../crypto/

Therefore - for now the correct fix is to use two wrapper .c files,
and accept this. It will not have the C=2 problem above.

	Sam
