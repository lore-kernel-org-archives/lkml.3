Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbaIHRBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:01:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37099 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754598AbaIHRA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:00:59 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
Subject: [GIT PULL 2/2] ARM: OMAP4+: PRM fixes, DRA7 suspend-to-ram support
Date: Mon, 8 Sep 2014 12:00:20 -0500
Message-ID: <1410195620-6347-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1410195620-6347-1-git-send-email-nm@ti.com>
References: <1410195620-6347-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
Please pull the following changes.

part 2: "ARM: OMAP3+: PRM: fix up prm_handling"
http://marc.info/?l=linux-kernel&m=140871580806186&w=2
Status: Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

part 3: "ARM: OMAP5+: pdata quirks for pinctrl"
http://marc.info/?l=linux-kernel&m=140871598306262&w=2
Status: Sending pull based on http://marc.info/?l=linux-kernel&m=140871666506706&w=2 (Acked by Tony, Pulled by Linus W)

part 5: "ARM: OMAP5 / DRA7: Add framework for suspend and cpuidle"
http://marc.info/?l=linux-kernel&m=140871637106555&w=2
Status: picked up kevin's tested and reviewed-by, dropped cpuidle for this pull

These could go into your tree for the branch  omap-for-v3.18/soc

The following changes since commit 7d1311b93e58ed55f3a31cc8f94c4b8fe988a2b9:

  Linux 3.17-rc1 (2014-08-16 10:40:26 -0600)

are available in the git repository at:

  https://github.com/nmenon/linux-2.6-playground.git pull/v3.18/for-omap-soc

for you to fetch changes up to 628ed4717000789bff827c5799d1aac4c1008541:

  ARM: OMAP5: Add hook in SoC initcalls to enable pm initialization (2014-09-08 11:38:43 -0500)

----------------------------------------------------------------
Keerthy (1):
      ARM: AM437x: use pdata quirks for pinctrl information

Nishanth Menon (8):
      ARM: OMAP4+: prminst: provide function to find prm_dev instance offset
      ARM: OMAP4: PRM: use the generic prm_inst to allow logic to be abstracted
      ARM: OMAP4+: PRM: register interrupt information from DT
      ARM: OMAP4+: PRM: remove "wkup" event
      ARM: OMAP4+: PRM: Enable wakeup capability for OMAP5, DRA7
      ARM: OMAP3+: PRM: register interrupt information from DT
      ARM: OMAP5: use pdata quirks for pinctrl information
      ARM: DRA7: use pdata quirks for pinctrl information

Rajendra Nayak (2):
      ARM: OMAP5 / DRA7: PM: Avoid all SAR saves
      ARM: OMAP5 / DRA7: Enable CPU RET on suspend

Santosh Shilimkar (6):
      ARM: OMAP5 / DRA7: PM: Update CPU context register offset
      ARM: OMAP5 / DRA7: PM: Set MPUSS-EMIF clock-domain static dependency
      ARM: OMAP5 / DRA7: PM / wakeupgen: Enables ES2 PM mode by default
      ARM: OMAP5 / DRA7: PM: Enable Mercury retention mode on CPUx powerdomains
      ARM: OMAP5 / DRA7: PM: Provide a dummy startup function for CPU hotplug
      ARM: OMAP5: Add hook in SoC initcalls to enable pm initialization

 arch/arm/mach-omap2/common.h              |    2 +-
 arch/arm/mach-omap2/io.c                  |    3 +
 arch/arm/mach-omap2/omap-mpuss-lowpower.c |  102 ++++++++++++++++++++---------
 arch/arm/mach-omap2/omap-secure.h         |    1 +
 arch/arm/mach-omap2/omap-wakeupgen.c      |   20 +++++-
 arch/arm/mach-omap2/omap-wakeupgen.h      |    1 +
 arch/arm/mach-omap2/pdata-quirks.c        |   10 +++
 arch/arm/mach-omap2/pm.h                  |    1 +
 arch/arm/mach-omap2/pm44xx.c              |   48 ++++++++++++--
 arch/arm/mach-omap2/prm3xxx.c             |   18 +++++
 arch/arm/mach-omap2/prm44xx.c             |   90 +++++++++++++++++++++----
 arch/arm/mach-omap2/prminst44xx.c         |   40 ++++++-----
 arch/arm/mach-omap2/prminst44xx.h         |    3 +
 13 files changed, 275 insertions(+), 64 deletions(-)

Regards,
Nishanth Menon
