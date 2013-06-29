Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3F2TDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 15:03:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:40669 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3F2TDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 15:03:16 -0400
Date: Sat, 29 Jun 2013 20:03:06 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130629190306.GA7533@e102568-lin.cambridge.arm.com>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com>
 <20130628171532.GD30603@e102568-lin.cambridge.arm.com>
 <20130628200333.GA2756@lukather>
 <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com>
 <20130628214512.GA11985@e102568-lin.cambridge.arm.com>
 <20130629180730.GI2593@lukather>
MIME-Version: 1.0
In-Reply-To: <20130629180730.GI2593@lukather>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Jun 2013 19:03:10.0862 (UTC) FILETIME=[4C7432E0:01CE74FB]
X-MC-Unique: 113062920031300201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 07:07:30PM +0100, Maxime Ripard wrote:
> On Fri, Jun 28, 2013 at 10:45:12PM +0100, Lorenzo Pieralisi wrote:
> > On Fri, Jun 28, 2013 at 09:05:42PM +0100, Olof Johansson wrote:
> > > On Fri, Jun 28, 2013 at 1:03 PM, Maxime Ripard
> > > <maxime.ripard@free-electrons.com> wrote:
> > > > On Fri, Jun 28, 2013 at 06:15:32PM +0100, Lorenzo Pieralisi wrote:
> > > >> On Fri, Jun 28, 2013 at 05:44:02PM +0100, Maxime Ripard wrote:
> > > >> > Hi Arnd, Olof,
> > > >> >
> > > >> > Sorry for steping in so late, but these two patches fixes a warning
> > > >> > introduced by the commit 1ba9bf0a (ARM: 7762/1: kernel: fix
> > > >> > arm_dt_init_cpu_maps() to skip non-cpu nodes) after 3.10-rc7.
> > > >> >
> > > >> > These two patches solve the situation for sunxi. The first one by
> > > >> > Lorenzo is to be applied for 3.10 if it's still possible, and the
> > > >> > second one on top of arm-soc/for-next. Tell me if you prefer a more
> > > >> > formal pull request for these patches
> > > >> >
> > > >> > Thanks!
> > > >> > Maxime
> > > >> >
> > > >> > Lorenzo Pieralisi (1):
> > > >> >   ARM: dts: sunxi: cpus/cpu nodes dts updates
> > > >>
> > > >> The patch above should already be queued in next/dt right ?
> > > >
> > > > Indeed.
> > > >
> > > > Then why the latest patch of your patchset got in 3.10, while the
> > > > patches actually fixing the DT it would have impacted were delayed to
> > > > 3.11?
> > > >
> > > > (And why was it merged so late in the development cycle?)
> > > 
> > > This. So now we have to scramble because some device trees will
> > > produce warnings at boot.
> > > 
> > > Russell, the alternative is to revert Lorenzo's patch for 3.10 (and
> > > re-introduce it for 3.11). Do you have a preference?
> > 
> > Ok, sorry about this guys. Technically speaking the DT bindings updates
> > (cpu/cpus nodes), dts updates and the ARM 7762/1 merged through Russell's
> > tree all are fixes, but probably we should not get them in as such.
> > 
> > ARM: 7762/1 was implemented to fix the warnings caused by new dts with
> > topology nodes (cpu-map node), and should go to stable kernels as well
> > since we want those kernels to boot with new DTs.
> > 
> > I should have prevented it from getting in as a fix, I really apologize.
> > I should also ask to drop the patch from the stable kernel queues, since this
> > would cause further issues (basically we should send all dts updates to
> > stable kernels as well, and unfortunately that's something we will have
> > to do anyway, when it has to be decided, if 7762/1 goes in 3.11 or later with
> > CC'ed stable we should send the dts updates to stable as well at the same
> > time).
> > 
> > I think the best solution is to revert ARM 7762/1 now and re-introduce it as
> > a fix after 3.11, when the dust has settled, I will drop it from stable
> > kernels queue as well if we all agree.
> > 
> > If we drop ARM 7762/1, 7764/1 needs rebasing since those patches order
> > unfortunately matters.
> 
> Ok, so you're saying we need to revert 1ba9bf0a and 7764/1. I couldn't
> find a commit corresponding to this one, however there is a commit
> labelled 7763/1 from you that touch the same area (18d7f152). Are these
> the commits that need to be reverted (and then reapplied for 3.11) ?

7764/1 is in Russell's patch system and has not been applied yet.
7763/1 can stay in since it is a fix that cleans-up cpu_logical_map
initialization.

1ba9bf0a (7762/1) is the patch that should be reverted (or we merge all
dts updates, since as I said, after all dts updates are fixes as well,
the warning is caused by the check for /cpu device_type to be == "cpu".
Those dts in the kernel are non-compliant, and have never been).

If 7762/1 is reverted, 7764/1 in Russell's patch system does not apply
cleanly anymore. Hence, if 7762/1 is reverted, we also have to drop 7764/1
from the patch system and I have to update it.

I asked to remove 7762/1 from stable kernels queues, the question is
still open if we want to backport all dts updates to stable kernels or
not. I would say no for now, hence 7762/1 can just be dropped (it was
meant to deal with the cpus node having children that are != /cpu. This
can happen with the new topology bindings, but let me say we will cross
that bridge when we come to it, 7762/1 has already caused too much
trouble for what it is worth).

On top of that there are bindings updates that I asked Grant to get them
merged for 3.11.

I am really really sorry for taking your time for this, but it has not been
easy to clean all dts up and define a proper standard, it is a necessary
evil.

Thanks a lot guys, please let me know how I can help, apologies.
Lorenzo

