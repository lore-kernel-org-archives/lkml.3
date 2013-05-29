Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966126Ab3E2TCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:02:55 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:51088 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3E2TCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:02:50 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20130529190204.6058.85682@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH 00/10] clk: mvebu: restructure SoC clock drivers
Date: Wed, 29 May 2013 12:02:04 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-05-10 18:08:00)
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

Sebastian,

Sorry for the tardy response.  This cleanup looks really good.  If it's
not too late:

Acked-by: Mike Turquette <mturquette@linaro.org>

If the branch is already pulled into arm-soc don't worry about the Ack.

Regards,
Mike

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
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> -- 
> 1.7.10.4
