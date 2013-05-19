Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3ESUNm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 16:13:42 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:33007 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754089Ab3ESUNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 16:13:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19qLXCm5F0hw0NHZN36SipgHvW0WAQNBqE=
Date: Sun, 19 May 2013 16:13:12 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Message-ID: <20130519201312.GJ11137@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian,

On Sat, May 11, 2013 at 03:08:00AM +0200, Sebastian Hesselbarth wrote:
> Marvell EBU SoCs share some common clock functions that register core
> clocks or clock gates from SoC specific data. These clock drivers are
> organized by function and over time the drivers filled up with #ifdefs
> to separate different SoC specific code.
> 
> This patch set first adds a new element to clock gate descriptors to
> allow to pass clk flags per clock gate. (Patch 1)
> 
> Then it restructures MVEBU clock drivers into common clock setup and
> SoC specific files and Kconfig options. The driver's init functions
> are also registered to get called with of_clk_init. (Patches 2, 3-6)
> 
> It then switches Dove, Kirkwood, and Armada 370/XP to make use of
> of_clk_init instead of mvebu_clocks_init. (Patches 7-9)
> 
> Finally, all obsolete files and Kconfig options are removed. (Patch 10)
> 
> It has been tested on CuBox (Dove) and Dockstar (Kirkwood) by me.
> Armada 370 and XP are compile tested only and should get their Tested-by
> from Thomas and Gregory, respectively.
> 
> @Mike: As this only touches MVEBU related code, I suggest to take it
> all through the corresponding ARM branch.
> 
> Sebastian Hesselbarth (10):
>   clk: mvebu: introduce per-clock-gate flags
>   clk: mvebu: add common clock functions for core clk and clk gating
>   clk: mvebu: add Dove SoC-centric clock init
>   clk: mvebu: add Kirkwood SoC-centric clock init
>   clk: mvebu: add Armada 370 SoC-centric clock init
>   clk: mvebu: add Armada XP SoC-centric clock init
>   ARM: dove: move DT boards to SoC-centric clock init
>   ARM: kirkwood: move DT boards to SoC-centric clock init
>   ARM: mvebu: move DT boards to SoC-centric clock init
>   clk: mvebu: desintegrate obsolete file
> 
>  arch/arm/mach-dove/Kconfig          |    3 +-
>  arch/arm/mach-dove/board-dt.c       |    3 +-
>  arch/arm/mach-dove/common.c         |    1 -
>  arch/arm/mach-kirkwood/Kconfig      |    3 +-
>  arch/arm/mach-kirkwood/board-dt.c   |    3 +-
>  arch/arm/mach-mvebu/Kconfig         |    5 +-
>  arch/arm/mach-mvebu/armada-370-xp.c |    4 +-
>  drivers/clk/mvebu/Kconfig           |   25 +-
>  drivers/clk/mvebu/Makefile          |    8 +-
>  drivers/clk/mvebu/armada-370.c      |  176 +++++++++
>  drivers/clk/mvebu/armada-xp.c       |  204 +++++++++++
>  drivers/clk/mvebu/clk-core.c        |  675 -----------------------------------
>  drivers/clk/mvebu/clk-core.h        |   18 -
>  drivers/clk/mvebu/clk-gating-ctrl.c |  250 -------------
>  drivers/clk/mvebu/clk-gating-ctrl.h |   22 --
>  drivers/clk/mvebu/clk.c             |   23 --
>  drivers/clk/mvebu/common.c          |  163 +++++++++
>  drivers/clk/mvebu/common.h          |   48 +++
>  drivers/clk/mvebu/dove.c            |  194 ++++++++++
>  drivers/clk/mvebu/kirkwood.c        |  247 +++++++++++++
>  include/linux/clk/mvebu.h           |   22 --
>  21 files changed, 1066 insertions(+), 1031 deletions(-)
>  create mode 100644 drivers/clk/mvebu/armada-370.c
>  create mode 100644 drivers/clk/mvebu/armada-xp.c
>  delete mode 100644 drivers/clk/mvebu/clk-core.c
>  delete mode 100644 drivers/clk/mvebu/clk-core.h
>  delete mode 100644 drivers/clk/mvebu/clk-gating-ctrl.c
>  delete mode 100644 drivers/clk/mvebu/clk-gating-ctrl.h
>  delete mode 100644 drivers/clk/mvebu/clk.c
>  create mode 100644 drivers/clk/mvebu/common.c
>  create mode 100644 drivers/clk/mvebu/common.h
>  create mode 100644 drivers/clk/mvebu/dove.c
>  create mode 100644 drivers/clk/mvebu/kirkwood.c
>  delete mode 100644 include/linux/clk/mvebu.h
> ---

I've tentatively applied the whole series to mvebu/seb_clk and merged it
into for-next.  This will get it a few rounds of testing in linux-next
until Mike has a chance to review it.

thx,

Jason.
