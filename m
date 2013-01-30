Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3A3TxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:53:05 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:52387 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753177Ab3A3TxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:53:04 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18pyPFcn5IIUeFeOLp5F7OReod1jA7GQHg=
Date: Wed, 30 Jan 2013 14:52:36 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Lunn <andrew@lunn.ch>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Nadav Haklai <nadavh@marvell.com>, David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Jon Masters <jcm@redhat.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v2 0/5] arm: mvebu: add support for local timer for
 Armada 370/XP
Message-ID: <20130130195236.GS7717@titan.lakedaemon.net>
References: <1359135165-32108-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359135165-32108-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner, John Stultz,

I'm getting close to pulling this series in through arm-soc.  Would you
prefer to take the clocksource patches through your tree, or provide an
Acked-by and I can take them through mvebu/arm-soc?

I'm comfortable with either, if you decide to take them, please let me
know which tree and branch you put them in so I can properly depend on
them.

thx,

Jason.

On Fri, Jan 25, 2013 at 06:32:40PM +0100, Gregory CLEMENT wrote:
> Hello,
> 
> The Armada XP SoCs comes with private timers. This allows us to use
> local timers through CONFIG_LOCAL_TIMERS and as stated in the kconfig
> help, it prevents a "thundering herd" at every timer tick.
> 
> Armada 370 also have these private timers, and even if it comes only
> with a single CPU, the feature is also enabled for this SoC to keep
> the code generic.
> 
> In order to be able to use the local timer, I also had to add the
> support for the per-CPU interrupts.
> 
> There are not many changes since the first version (see the changelog
> below), I hope it means that everybody is happy with this patch
> set. If it is, so please could you give your acked-by. I especially
> expect the acked-by from John Stultz then I will feel more comfortable
> to ask Jason to pull it.
> 
> This patch set is based on 3.8-rc4 and is obviously 3.9 material. The
> git branch called local_timer is available at:
> https://github.com/MISL-EBU-System-SW/mainline-public.git.
> 
> Thanks,
> 
> Changelog:
> V1->V2:
>  - Fixed unneeded empty line and wrong indentation.
>  - Made percpu_armada_370_xp_evt a static variable
>  - Removed the patch "arm: kconfig: don't select TWD with local timer
>    for Armada 370/XP" from the series. There is still some improvement
>    possible in this area, but this patch set not depends on it.
> 
> Gregory CLEMENT (5):
>   arm: mvebu: Add support for local interrupt
>   clocksource: time-armada-370-xp: add local timer support
>   arm: mvebu: update defconfig with local timer support
>   arm: mvebu: update DT to support local timers
>   clocksource: update and move armada-370-xp-timer documentation to
>     timer directory
> 
>  .../bindings/arm/armada-370-xp-timer.txt           |   12 --
>  .../bindings/timer/marvell,armada-370-xp-timer.txt |   15 ++
>  arch/arm/boot/dts/armada-370-xp.dtsi               |    5 +-
>  arch/arm/configs/mvebu_defconfig                   |    1 -
>  arch/arm/mach-mvebu/irq-armada-370-xp.c            |   15 +-
>  drivers/clocksource/time-armada-370-xp.c           |  150 +++++++++++++++-----
>  6 files changed, 141 insertions(+), 57 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/arm/armada-370-xp-timer.txt
>  create mode 100644 Documentation/devicetree/bindings/timer/marvell,armada-370-xp-timer.txt
> 
> -- 
> 1.7.9.5
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
