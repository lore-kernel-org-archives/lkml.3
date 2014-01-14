Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaANAUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:20:01 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33804 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbaANAT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:19:59 -0500
From: Suman Anna <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Suman Anna <s-anna@ti.com>
Subject: [PATCHv4 0/7] omap hwspinlock dt support
Date: Mon, 13 Jan 2014 18:19:17 -0600
Message-ID: <1389658764-39199-1-git-send-email-s-anna@ti.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an updated series mainly addressing Mark Rutland's comments
about hwlock specifier being always one-cell. The series adds the
support for #hwlock-cells property and adds a simple default OF
translate function.

The DTS patches from previous series have already been merged, and
needs this property to be added. This is handled in a separate series
that only deals with OMAP hwspinlock DTS patches.

The series, along with the DTS patches, is tested on top of v3.13-rc8
plus Tero's v13 clock DT series and Tony's 3.14 staged branches. The
validation on OMAP5, DRA7, AM437 requires Tero's series with couple of
additional base patches for AM43xx. AM43xx functionality needs a hwmod
fix [1] for creating the associated omap_device as well.

The validation logs on all the applicable OMAP SoCs are at:
  OMAP4 - http://paste2.org/YJ7ZwG80
  OMAP5 - http://paste2.org/c6vO96b9
  DRA7  - http://paste2.org/tHvxN439
  AM33x - http://paste2.org/AjCv0U4t
  AM43x - http://paste2.org/2AKIPa55

The kernel with the test patches plus the various pulled in branches
is here for reference (not for merging)
https://github.com/sumananna/omap-kernel/commits/hwspinlock/3.13-rc8-v4-test

[1] http://marc.info/?l=linux-omap&m=138939747524820&w=2

Changes new in v4:
- The DT bindings are split into separate patches, and updated to
  add comments about #hwlock-cells (Patches 1 & 2)
- Fixed a registration issue with repeated module installation and
  removal. (Patch 3)
- Added a new OF helper to support #hwlock-cells in addition to the
  previous OF functions (Patch 4). The OMAP adaptation patch is
  updated to use the default translate function (Patch 5)
- Updated hwspinlock documentation to adjust for the structure
  changes and the new api additions. (Patches 3, 4)
- Added build support for AM335x, AM43xx and DRA7xx (Patch 7)
- The AM335/AM43x fix patch is unchanged (Patch 6)

v3:
- Removed the DT property hwlock-base-id and associated OF helper
- Added changes in core to support requesting a specific hwlock using
  phandle + args approach
- Revised both the common and OMAP DT bindings document
http://marc.info/?l=linux-omap&m=138143992932197&w=2

v2:
- Added a new common DT binding documentation and OF helpers.
- Revised OMAP DT parse support to use the new OF helper (Patch2)
- OMAP5 hwspinlock support including the hwmod entry and DT node
- Add AM335x support to OMAP hwspinlock driver, including a fix
  needed in driver given that AM335 spinlock module requires s/w wakeup
- AM335 DT node for spinlock, and a hwmod change to enable smart-idle
  for AM335.
- OMAP4 DT node patch is unchanged
http://marc.info/?l=linux-omap&m=137944644112727&w=2

v1:
- Add DT parse support to OMAP hwspinlock driver
- Add OMAP4 DT node and bindings information
http://marc.info/?l=linux-omap&m=137823082308009&w=2

Suman Anna (7):
  Documentation: dt: add common bindings for hwspinlock
  Documentation: dt: add the omap hwspinlock bindings document
  hwspinlock/core: maintain a list of registered hwspinlock banks
  hwspinlock/core: add common OF helpers
  hwspinlock/omap: add support for dt nodes
  hwspinlock/omap: enable module before reading SYSSTATUS register
  hwspinlock/omap: enable build for AM33xx, AM43xx & DRA7xx

 .../devicetree/bindings/hwlock/hwlock.txt          |  52 +++++++
 .../devicetree/bindings/hwlock/omap-hwspinlock.txt |  24 ++++
 Documentation/hwspinlock.txt                       |  36 ++++-
 MAINTAINERS                                        |   1 -
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/hwspinlock.c                   |  60 --------
 drivers/hwspinlock/Kconfig                         |   2 +-
 drivers/hwspinlock/hwspinlock_core.c               | 159 ++++++++++++++++++++-
 drivers/hwspinlock/hwspinlock_internal.h           |   6 +
 drivers/hwspinlock/omap_hwspinlock.c               |  39 +++--
 include/linux/hwspinlock.h                         |  20 ++-
 11 files changed, 321 insertions(+), 81 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/hwlock/hwlock.txt
 create mode 100644 Documentation/devicetree/bindings/hwlock/omap-hwspinlock.txt
 delete mode 100644 arch/arm/mach-omap2/hwspinlock.c

-- 
1.8.4.3

