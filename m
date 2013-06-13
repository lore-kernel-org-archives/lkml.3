Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab3FMANw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 20:13:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:9567 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833Ab3FMANv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 20:13:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,855,1363158000"; 
   d="scan'208";a="352562110"
Date: Thu, 13 Jun 2013 02:13:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v3 0/2] drivers: mfd: Versatile Express SPC support
Message-ID: <20130613001311.GC4567@zurbaran>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
 <20130611090545.GC8164@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130611090545.GC8164@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lorenzo,

On Tue, Jun 11, 2013 at 10:05:45AM +0100, Lorenzo Pieralisi wrote:
> Hi Samuel,
> 
> if nobody has objections I think this set is ready to get merged. As
> Nico mentioned in:
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173541.html
> 
> since we would like to get it merged through the ARM SoC tree owing to
> dependencies between this code and ARM power management back-ends, your ack
> would be appreciated, if you think it is worth it of course.
I'm fine with it going through the arm-soc tree, but please prepare a
branch for me to pull from.
AFAIR, we got a merge conflict during the last merge window with the
vexpress driver, I want to avoid that for the next one.

Now, about the driver itself, besides the really odd code design, the
static variables all over the place, the nasty init hacks and the
unneeded long function names, someone should refresh my memory and explain
to me why is this guy under mfd. I can see it somehow supports IP blocks
providing different functions, but the design is not sharing anything with
most of the rest of the mfd drivers.
Not only that, but the whole vexpress-config code design is not the
nicest piece of code I've ever seen. And I'm usually not picky. e.g. the
whole vexpress-config ad-hoc API is awkward and I wonder if it could be
implemented as a bus instead.

FWIW I take the blame here for not reviewing the initial driver
submission that Arnd kindly sent to me...But now that I'm looking at it,
I think it really is on the edge of being staging material. Any thought
on that ?

Cheers,
Samuel.

> Thank you very much indeed,
> Lorenzo
> 
> On Thu, Jun 06, 2013 at 10:59:21AM +0100, Lorenzo Pieralisi wrote:
> > This patch is v3 of a previous posting:
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173464.html
> > 
> > v3 changes:
> > 
> > - added __refdata to spc_check_loaded pointer
> > - removed some exported symbols
> > - added node pointer check in vexpress_spc_init()
> > 
> > v2 changes:
> > 
> > - Dropped timeout interface patch
> > - Converted interfaces to non-timeout ones, integrated and retested
> > - Removed mutex used at init
> > - Refactored code to work around init sections warning
> > - Fixed two minor bugs
> > 
> > This patch series introduces support for the Versatile Express Serial
> > Power Controller (SPC) present in ARM Versatile Express TC2 core tiles.
> > SPC driver is a fundamental component of TC2 power management and allows
> > to carry out C-state management and DVFS for A15 and A7 clusters.
> > 
> > First patch provides changes required by SPC to comply with the
> > Versatile Express config API, second patch is the SPC driver implementation.
> > 
> > Code extensively exercised through CPUidle and CPUfreq power states and
> > operating point transitions.
> > 
> > Lorenzo Pieralisi (1):
> >   drivers: mfd: vexpress: add Serial Power Controller (SPC) support
> > 
> > Pawel Moll (1):
> >   drivers: mfd: refactor the vexpress config bridge API
> > 
> >  Documentation/devicetree/bindings/mfd/vexpress-spc.txt |  35 +
> >  drivers/mfd/Kconfig                                    |   7 +
> >  drivers/mfd/Makefile                                   |   1 +
> >  drivers/mfd/vexpress-config.c                          |  61 +-
> >  drivers/mfd/vexpress-spc.c                             | 633 ++++++++++
> >  drivers/mfd/vexpress-sysreg.c                          |   2 +-
> >  include/linux/vexpress.h                               |  59 +-
> >  7 files changed, 770 insertions(+), 28 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/vexpress-spc.txt
> >  create mode 100644 drivers/mfd/vexpress-spc.c
> > 
> > -- 
> > 1.8.2.2
> > 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
