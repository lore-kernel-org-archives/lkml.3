Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbbABTwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 14:52:38 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49307 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbbABTwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 14:52:36 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH 0/3] remoteproc: Introduce wkup_m3_rproc driver
Date: Fri, 2 Jan 2015 13:51:56 -0600
Message-ID: <1420228319-41085-1-git-send-email-d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This patch series adds a wkup_m3_rproc driver for TI AM335x SoCs.
This family of SoCs contains an ARM Cortex M3 coprocessor that is
responsible for low-level power tasks that cannot be handled by
the main ARM Cortex A8 so firmware running from the CM3 can be
used instead. This driver handles loading of the firmware and
reset of the CM3 once it is booted.

This patch was split off from v4 of the am335x suspend series,
found here [1]. I have pushed a branch based on v3.19-rc1
containing all dependencies here [2] for am33xx suspend
for a higher level view of the entire series of patch sets. This
series is required for a coming series "drivers: soc: ti:
Introduce wkup_m3_ipc driver" that boots this rproc driver and
handles the communication layer between the SoC and this remote
processor.

This patch set depends on series "couple of generic remoteproc
enhancements" by Suman Anna found here [3]. The driver expects to
load firmware am335x-pm-firmware.elf from /lib/firmware which is
found here [4].

Regards,
Dave

[1] http://www.spinics.net/lists/linux-omap/msg109331.html
[2] https://github.com/dgerlach/linux-pm/tree/pm-am335x-v3.19-rc1
[3] http://www.spinics.net/lists/arm-kernel/msg362961.html
[4] https://git.ti.com/ti-cm3-pm-firmware/amx3-cm3/commits/next


Dave Gerlach (3):
  ARM: OMAP2+: Use pdata-quirks for wkup_m3 deassert_hardreset
  Documentation: dt: add ti,am3353-wkup-m3 bindings
  remoteproc: wkup_m3: Add wkup_m3 remote proc driver

 .../bindings/remoteproc/wkup_m3_rproc.txt          |  32 ++++
 arch/arm/mach-omap2/pdata-quirks.c                 |  13 ++
 drivers/remoteproc/Kconfig                         |  12 ++
 drivers/remoteproc/Makefile                        |   1 +
 drivers/remoteproc/wkup_m3_rproc.c                 | 175 +++++++++++++++++++++
 include/linux/platform_data/wkup_m3.h              |  23 +++
 6 files changed, 256 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/remoteproc/wkup_m3_rproc.txt
 create mode 100644 drivers/remoteproc/wkup_m3_rproc.c
 create mode 100644 include/linux/platform_data/wkup_m3.h

-- 
2.1.0

