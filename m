Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab3JJVSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:18:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35693 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab3JJVQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:16:43 -0400
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Suman Anna <s-anna@ti.com>
Subject: [PATCHv3 0/8]  omap hwspinlock dt support
Date: Thu, 10 Oct 2013 16:15:27 -0500
Message-ID: <1381439735-52888-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an updated series addressing the review comments from the
v2 series. The hwmod patches have been dropped from the repost
as per Paul's request, they have already been queued.

The series is tested on top of v3.12-rc4 + Benoit's 3.13 DTS branch and
Tero's clock series, along with the queued hwmod patches.

Changes in v3:
- Removed the DT property hwlock-base-id and associated OF helper
- Added changes in core to support requesting a specific hwlock using
  phandle + args approach
- Revised both the common and OMAP DT bindings document
- OMAP AM335 support patches are unchanged from v2.
- OMAP DTS patches are unchanged from v2.

v2
- Added a new common DT binding documentation and OF helpers (Patch1),
  addressing the review comments from v1 [2]. The MSM support [1] needs
  to be reworked on top of this common patch.
- Revised OMAP DT parse support to use the new OF helper (Patch2)
- OMAP5 hwspinlock support including the hwmod entry and DT node (Patches 4, 5)
- Add AM335x support to OMAP hwspinlock driver, including a fix
  needed in driver given that AM335 spinlock module requires s/w wakeup
  (Patches 6, 7)
- AM335 DT node for spinlock, and a hwmod change to enable smart-idle
  for AM335 (Patches 8, 9). The sysc patch is not essential for AM335
  spinlock functionality, but is needed for smart-idling the IP when
  the module is enabled.
- OMAP4 DT node patch is unchanged (Patch 3)
http://marc.info/?l=linux-omap&m=137944644112727&w=2

v1:
- Add DT parse support to OMAP hwspinlock driver
- Add OMAP4 DT node and bindings information
http://marc.info/?l=linux-omap&m=137823082308009&w=2

[1] https://lkml.org/lkml/2013/8/14/528
[2] http://marc.info/?t=137823090300005&r=1&w=2

Suman Anna (8):
  hwspinlock/core: maintain a list of registered hwspinlock banks
  hwspinlock/core: add common dt bindings and OF helpers
  hwspinlock/omap: add support for dt nodes
  hwspinlock/omap: enable module before reading SYSSTATUS register
  hwspinlock/omap: support AM33xx
  ARM: dts: OMAP4: Add hwspinlock node
  ARM: dts: OMAP5: Add hwspinlock node
  ARM: dts: AM33XX: Add hwspinlock node

 .../devicetree/bindings/hwlock/hwlock.txt          |  49 ++++++++
 .../devicetree/bindings/hwlock/omap-hwspinlock.txt |  19 +++
 arch/arm/boot/dts/am33xx.dtsi                      |   6 +
 arch/arm/boot/dts/omap4.dtsi                       |   6 +
 arch/arm/boot/dts/omap5.dtsi                       |   6 +
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/hwspinlock.c                   |  60 ----------
 drivers/hwspinlock/Kconfig                         |   2 +-
 drivers/hwspinlock/hwspinlock_core.c               | 133 ++++++++++++++++++++-
 drivers/hwspinlock/hwspinlock_internal.h           |   2 +
 drivers/hwspinlock/omap_hwspinlock.c               |  38 ++++--
 include/linux/hwspinlock.h                         |  19 ++-
 12 files changed, 263 insertions(+), 80 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

-- 
1.8.4

