Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab3IJI75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:59:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43845 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3IJI7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:59:55 -0400
Date: Tue, 10 Sep 2013 09:59:50 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Sahara <keun-o.park@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: linux-next: manual merge of the arm-soc tree with the pm tree
Message-ID: <20130910085950.GB16716@e102568-lin.cambridge.arm.com>
References: <20130829180425.4aa3d164f01cc65b215187fe@canb.auug.org.au>
 <20130829175715.GH18542@quad.lixom.net>
 <20130902180900.GC11030@e102568-lin.cambridge.arm.com>
 <CAGa+x878Kz6mw9UduLtTBTJN3DSfKQeaCvG_-8WTW1QpVadSow@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAGa+x878Kz6mw9UduLtTBTJN3DSfKQeaCvG_-8WTW1QpVadSow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Sep 2013 08:59:51.0292 (UTC) FILETIME=[1BFBEBC0:01CEAE04]
X-MC-Unique: 113091009595303701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 09, 2013 at 06:22:16PM +0100, Kevin Hilman wrote:
> On Mon, Sep 2, 2013 at 11:09 AM, Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com> wrote:
> > On Thu, Aug 29, 2013 at 06:57:15PM +0100, Olof Johansson wrote:
> >> On Thu, Aug 29, 2013 at 06:04:25PM +1000, Stephen Rothwell wrote:
> >> > Hi all,
> >> >
> >> > Today's linux-next merge of the arm-soc tree got a conflict in
> >> > drivers/cpuidle/Makefile between commits b98e01ad4ed9 ("cpuidle: Add
> >> > Kconfig.arm and move calxeda, kirkwood and zynq") and d3f2950f2ade ("ARM:
> >> > ux500: cpuidle: Move ux500 cpuidle driver to drivers/cpuidle") from the
> >> > pm tree and commit 14d2c34cfa00 ("cpuidle: big.LITTLE: vexpress-TC2 CPU
> >> > idle driver") from the arm-soc tree.
> >> >
> >> > I fixed it up (see below) and can carry the fix as necessary (no action
> >> > is required).
> >> >
> >> > --
> >> > Cheers,
> >> > Stephen Rothwell                    sfr@canb.auug.org.au
> >> >
> >> > diff --cc drivers/cpuidle/Makefile
> >> > index 0b9d200,3b6445c..0000000
> >> > --- a/drivers/cpuidle/Makefile
> >> > +++ b/drivers/cpuidle/Makefile
> >> > @@@ -5,9 -5,7 +5,10 @@@
> >> >   obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
> >> >   obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
> >> >
> >> >  -obj-$(CONFIG_CPU_IDLE_CALXEDA) += cpuidle-calxeda.o
> >> >  -obj-$(CONFIG_ARCH_KIRKWOOD) += cpuidle-kirkwood.o
> >> >  -obj-$(CONFIG_CPU_IDLE_ZYNQ) += cpuidle-zynq.o
> >> >  -obj-$(CONFIG_CPU_IDLE_BIG_LITTLE) += cpuidle-big_little.o
> >> >  +##################################################################################
> >> >  +# ARM SoC drivers
> >> >  +obj-$(CONFIG_ARM_HIGHBANK_CPUIDLE)        += cpuidle-calxeda.o
> >> >  +obj-$(CONFIG_ARM_KIRKWOOD_CPUIDLE)        += cpuidle-kirkwood.o
> >> >  +obj-$(CONFIG_ARM_ZYNQ_CPUIDLE)            += cpuidle-zynq.o
> >> >  +obj-$(CONFIG_ARM_U8500_CPUIDLE)         += cpuidle-ux500.o
> >> > ++obj-$(CONFIG_CPU_IDLE_BIG_LITTLE)       += cpuidle-big_little.o
> >>
> >>
> >> Might want to sort u8500 before zynq, but otherwise looks fine.
> >
> > I noticed that owing to the merge, CONFIG_CPU_IDLE_BIG_LITTLE should be moved
> > to the newly introduced Kconfig.arm. How are we going to handle this ? It is
> > just a matter of renaming the config entry and moving it to Kconfig.arm.
> >
> 
> For the merge window, we'll merge it as is, but a rename
> cleanup/rename patch for v3.12-rc would be appreciated.

Agreed, thanks Kevin.

Lorenzo

