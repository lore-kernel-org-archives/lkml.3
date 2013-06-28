Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3F1VpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:45:19 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48366 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3F1VpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:45:18 -0400
Date: Fri, 28 Jun 2013 22:45:12 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130628214512.GA11985@e102568-lin.cambridge.arm.com>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
 <20130628200333.GA2756@lukather>
 <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 28 Jun 2013 21:45:15.0571 (UTC) FILETIME=[C66B4830:01CE7448]
X-MC-Unique: 113062822451600201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 09:05:42PM +0100, Olof Johansson wrote:
> On Fri, Jun 28, 2013 at 1:03 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> >> On Fri, Jun 28, 2013 at 05:44:02PM +0100, Maxime Ripard wrote:
> >> > Hi Arnd, Olof,
> >> >
> >> > Sorry for steping in so late, but these two patches fixes a warning
> >> > introduced by the commit 1ba9bf0a (ARM: 7762/1: kernel: fix
> >> > arm_dt_init_cpu_maps() to skip non-cpu nodes) after 3.10-rc7.
> >> >
> >> > These two patches solve the situation for sunxi. The first one by
> >> > Lorenzo is to be applied for 3.10 if it's still possible, and the
> >> > second one on top of arm-soc/for-next. Tell me if you prefer a more
> >> > formal pull request for these patches
> >> >
> >> > Thanks!
> >> > Maxime
> >> >
> >> > Lorenzo Pieralisi (1):
> >> >   ARM: dts: sunxi: cpus/cpu nodes dts updates
> >>
> >> The patch above should already be queued in next/dt right ?
> >
> > Indeed.
> >
> > Then why the latest patch of your patchset got in 3.10, while the
> > patches actually fixing the DT it would have impacted were delayed to
> > 3.11?
> >
> > (And why was it merged so late in the development cycle?)
> 
> This. So now we have to scramble because some device trees will
> produce warnings at boot.
> 
> Russell, the alternative is to revert Lorenzo's patch for 3.10 (and
> re-introduce it for 3.11). Do you have a preference?

Ok, sorry about this guys. Technically speaking the DT bindings updates
(cpu/cpus nodes), dts updates and the ARM 7762/1 merged through Russell's
tree all are fixes, but probably we should not get them in as such.

ARM: 7762/1 was implemented to fix the warnings caused by new dts with
topology nodes (cpu-map node), and should go to stable kernels as well
since we want those kernels to boot with new DTs.

I should have prevented it from getting in as a fix, I really apologize.
I should also ask to drop the patch from the stable kernel queues, since this
would cause further issues (basically we should send all dts updates to
stable kernels as well, and unfortunately that's something we will have
to do anyway, when it has to be decided, if 7762/1 goes in 3.11 or later with
CC'ed stable we should send the dts updates to stable as well at the same
time).

I think the best solution is to revert ARM 7762/1 now and re-introduce it as
a fix after 3.11, when the dust has settled, I will drop it from stable
kernels queue as well if we all agree.

If we drop ARM 7762/1, 7764/1 needs rebasing since those patches order
unfortunately matters.

Again, my apologies, I am really sorry, please advise on the best way to do it.

Thanks,
Lorenzo

