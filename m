Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab3KGJBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 04:01:17 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:62656 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3KGJBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 04:01:04 -0500
Date: Thu, 7 Nov 2013 10:01:00 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 3.12 released .. and no merge window yet .. and 4.0 plans?
Message-ID: <20131107090100.GA403@gmail.com>
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com>
 <20131104062540.GA12149@gmail.com>
 <20131107044052.GA11459@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107044052.GA11459@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@linuxfoundation.org> wrote:

> > Thirdly, _users_ interested in stability can already go to the -stable 
> > kernel, will will suck up 1 cycle worth of bugfixes out of the main 
> > flow of changes. So users already have a stability choice of v-latest 
> > and 'v-latest - 1' - plus the 'long term' stable kernels as well.
> 
> I think (but I'm probably biased here), that the -stable releases are 
> doing this pretty well. [...]

I do think it's pretty healthy. (I just have no idea how you manage the 
firehose of patches! :-)

The biggest weak spot I see is the lack of unbiased kernel stability 
metrics. bugzillas are self-selecting and suffer from the squeakiest whell 
problem. Distros are conservative and under-staffed, so there's 
significant lag there.

What would help a lot would be the revival of kerneloops.org.

Would people object to a mainline kernel opt-in kernel crash reporting 
feature that would send a single UDP packet to a special port on 
kernel.org on a kernel crash, sending a crash signature, a backtrace, a 
kernel version string or so, a /dev/random generated system UUID, etc.?

A _lot_ of useful information can be squeezed into a 1.4k packet, and the 
format would obviously be human readable but space-optimized.

The upstream kernel crash reporting feature is off by default but distros 
could turn it on and would allow users to opt-in via a nice GUI question 
on install or first-bootup. (It would also be a fundamentally distro 
neutral reporting facility, with immediate, very quick feedback to kernel 
developers.)

[ This crash reporting facility would utilize the netconsole
  infrastructure to be able to send the crash-report packet from deep 
  inside just about any kernel context, and and would thus work better 
  than current oops gathering methods that all rely on user-space still 
  functioning when the crash happens. Users could query the crashes 
  reported for their UUIDs on kernel.org and could provide further 
  feedback if they want to. ]

> > Maybe ask first-hop maintainers to be extra super diligent about new 
> > features in v4.0 by imposing an internal merge window deadline 2 weeks 
> > before the real merge window [a fair chunk of patches hit maintainer 
> > trees in the last 2 weeks of the development window, and those cause 
> > much of the regressions], maybe even reject a few pulls during the 
> > merge window that blatantly violate these pre-freeze rules, but don't 
> > hold up the low-latency flow of steady improvements - much of which is 
> > driver work, platform enablement work, small improvements, etc., which 
> > isn't really a big source of real regressions for the existing 
> > installed base.
> 
> A 2 week merge window deadline would help out a lot with a number of 
> some of the bugs we get during the -rc cycle, but there's always going 
> to be issues found with wider testing, so I'm not quite sure that will 
> help out all that much in the end.

I think we already had such a change in the recent past: Linus started 
enforcing "no development during the merge window!" in ernest.

That step, combined with linux-next testing, made the merge window a _lot_ 
less painful over the last 1-2 years, eliminating much of the risk that 
comes with pushing well intentioned but barely tested bits upstream.

So you are probably right that extending that by 1-2 weeks would probably 
bring diminishing returns, because the "no development during the merge 
window" policy already eliminates the worst offenders.

Thanks,

	Ingo
