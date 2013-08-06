Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab3HFRGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:06:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18572 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3HFRGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:06:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wElgYUrBh5toKtpUvVDTgz4brIHaVPMk=
Date: Tue, 6 Aug 2013 13:06:12 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] ARM: dove: switch to DT MBus
Message-ID: <20130806170612.GW19280@titan.lakedaemon.net>
References: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375101114-28858-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 02:31:49PM +0200, Sebastian Hesselbarth wrote:
> This patch set converts DT based Dove boards to DT probed MBus to be
> introduced with v3.12.
> 
> The first two patches prepare Dove DT nodes for MBus ID remapping by using
> preprocessor includes and adding the MBUS_ID macro. The third patch adds a
> MBus DT node to Dove SoC dtsi with required ranges for internal MBus and
> AXI registers, and PCIe mem and I/O apertures. The forth patch relocates
> the nodes for the internal devices to the new MBus node. Also, internal-regs
> ranges are updated to allow proper translation of MBus children's reg
> properties. Finally, legacy MBus init is replaced by DT based MBus init
> for DT based Dove.
> 
> The patch set depends on the MBus device tree patches that should appear
> in v3.12. Currently, it is based on v3.11-rc2 with Dove DT cleanup patches
> and MBus patch set v8 applied.

Grrr.  It also depends on the mv643xx_eth and irqchip/clocksource
changes.  I caught it, so no big deal.  In the future, please try to
make each series stand alone unless absolutely necessary.

> The patch set is _not_ sent to devicetree mainling list, because the MBus
> binding will be discussed there on the MBus patches itself.
> 
> Sebastian Hesselbarth (5):
>   ARM: dove: use preprocessor on device tree files
>   ARM: dove: add MBUS_ID macro to Dove DT
>   ARM: dove: add MBus DT node
>   ARM: dove: relocate internal registers device nodes
>   ARM: dove: switch to DT probed mbus address windows
> 
>  arch/arm/boot/dts/dove-cm-a510.dts |    2 +-
>  arch/arm/boot/dts/dove-cubox.dts   |    2 +-
>  arch/arm/boot/dts/dove-d2plug.dts  |    2 +-
>  arch/arm/boot/dts/dove-dove-db.dts |    2 +-
>  arch/arm/boot/dts/dove.dtsi        |  958 ++++++++++++++++++------------------
>  arch/arm/mach-dove/board-dt.c      |   10 +-
>  6 files changed, 491 insertions(+), 485 deletions(-)

whole series applied to mvebu/dove_mbus with dependencies on
mvebu/dove_dt, mvebu/mbus_dt, and mvebu/boards.  I may redo this to
merge mvebu/dove_dt back into mvebu/boards.  I haven't decided yet.

thx,

Jason.
