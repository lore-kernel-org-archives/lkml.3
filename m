Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016Ab3EBTUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:20:15 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31125 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761972Ab3EBTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:20:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX187OQddR/WpMjnArYskalcGrKE3MNlGBXU=
Date: Thu, 2 May 2013 15:19:34 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: dove: prepare and move to orion irqchip driver
Message-ID: <20130502191934.GH31290@titan.lakedaemon.net>
References: <1367519140-19716-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367519140-19716-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 08:25:37PM +0200, Sebastian Hesselbarth wrote:
> This patch set moves Dove to the recently introduced irqchip driver
> for Marvell Orion SoCs. First, init code for timer and mv643xx_eth
> is added to prepare legacy non-DT drivers for virtual irqs provided by
> irqchip drivers. Then DT enabled boards for Dove are moved to the
> orion irqchip driver.
> 
> Note: This patch set depends on irqchip driver for Orion SoCs patch.
> 
> Sebastian Hesselbarth (3):
>   ARM: dove: add DT parsing for legacy mv643xx_eth
>   ARM: dove: add DT parsing for legacy timer
>   ARM: dove: move DT boards to orion irqchip driver
> 
>  arch/arm/boot/dts/dove.dtsi   |   18 ++++++++-

In the next version, please send the dtsi changes as separate patches.
This will reduce merge conflicts on our end.

Also, and I'll note this on the other thread as well, please put the
drivers/irqchip patch in the same series as this so the dependency is
clear.

In it's current state, your driver patch can only conflict with other
work in drivers/irqchip/{Makefile,Kconfig}.  This easy for us.  So we
should try to get an Ack from the irqchip folks to keep that patch with
this series and prevent a cross-tree dependency.

thx,

Jason.

>  arch/arm/mach-dove/Kconfig    |    1 +
>  arch/arm/mach-dove/Makefile   |    4 +-
>  arch/arm/mach-dove/board-dt.c |   77 ++++++++++++++++++++++++++++++++++++-----
>  4 files changed, 87 insertions(+), 13 deletions(-)
> ---
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> Cc: Jean-Francois Moine <moinejf@free.fr>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> -- 
> 1.7.2.5
> 
