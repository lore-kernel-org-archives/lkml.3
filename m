Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3IZPCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 11:02:43 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:11784 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3IZPCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 11:02:38 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199D+gTT7lxKkakIMZBoliXCqYmmUjLhL0=
Date: Thu, 26 Sep 2013 11:02:28 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Frank Li <lznuaa@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Kevin Hilman <khilman@linaro.org>, Stephen Warren <swarren@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PCI host merge strategy and maintainers
Message-ID: <20130926150228.GL11119@titan.lakedaemon.net>
References: <CAErSpo7UX6dt0CPZp3kEQrXXbMeArpu1iFfp=-FX46LVgq0iMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7UX6dt0CPZp3kEQrXXbMeArpu1iFfp=-FX46LVgq0iMw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 05:28:28PM -0600, Bjorn Helgaas wrote:
> There are patches for exynos, imx6, mvebu, and tegra on the PCI list,
> and I want to sort out how people expect them to be merged.
> 
> My current assumption is the following:
...
>   drivers/pci/host/pci-mvebu.c  ?? unclear; Jason Cooper has merged
> some, I've merged some

hmm, my current branch I'm about to send a pull for, mvebu/msi_mvebu has
the following diffstat:

 .../devicetree/bindings/arm/armada-370-xp-mpic.txt |   3 +
 .../devicetree/bindings/pci/mvebu-pci.txt          |   3 +
 arch/arm/boot/dts/armada-370-xp.dtsi               |   1 +
 arch/arm/boot/dts/armada-370.dtsi                  |   1 +
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |   1 +
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |   1 +
 arch/arm/boot/dts/armada-xp-mv78460.dtsi           |   1 +
 drivers/irqchip/irq-armada-370-xp.c                | 202 ++++++++++++++++++++-
 drivers/pci/host/pci-mvebu.c                       |  26 +++
 9 files changed, 234 insertions(+), 5 deletions(-)

The problematic piece is the build dep on the irqchip changes.  It was
ok for me to take them through my tree last time, I assume that's the
case this time.

One thing you didn't mention are the dove changes which (of course)
depend on Thomas' mvebu changes above.  They are currently in
mvebu/dove_pcie-mbus-dt and has the following diffstat:

 .../devicetree/bindings/pci/mvebu-pci.txt          |    7 +
 arch/arm/boot/dts/Makefile                         |    1 +
 arch/arm/boot/dts/dove-cm-a510.dts                 |    2 +-
 arch/arm/boot/dts/dove-cubox.dts                   |    2 +-
 arch/arm/boot/dts/dove-d2plug.dts                  |    2 +-
 arch/arm/boot/dts/dove-d3plug.dts                  |  103 ++
 arch/arm/boot/dts/dove-dove-db.dts                 |    2 +-
 arch/arm/boot/dts/dove.dtsi                        | 1009 +++++++++++---------
 arch/arm/mach-dove/board-dt.c                      |   39 +-
 drivers/pci/host/Kconfig                           |    2 +-
 drivers/pci/host/pci-mvebu.c                       |   99 +-
 11 files changed, 719 insertions(+), 549 deletions(-)

Both series were intended for the last merge window, but didn't make it.
So they've had plenty of time in -next.  I've not seen any merge
conflicts either, but I haven't followed how early everyone else starts
posting to -next.

> Please correct anything that's wrong above, and please give me some
> guidance on mvebu.  I'm happy to go either way; I just need to know
> whether to pay attention to them :)

Well, there's nothing new here, so if you're ok with me taking them,
I'll continue on that path for these two series.

thx,

Jason.
