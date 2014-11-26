Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805AbaKZV17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:27:59 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36052 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbaKZV15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:27:57 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kevin Hilman <khilman@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Dave Gerlach <d-gerlach@ti.com>
Subject: [RFC PATCH 0/3] remoteproc: Introduce wkup_m3_rproc driver
Date: Wed, 26 Nov 2014 15:27:09 -0600
Message-ID: <cover.1417029919.git.d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
This patch series adds a wkup_m3_rproc driver for TI AM335x SoCs.
This family of SoCs contains an ARM Cortex M3 coprocessor that is
responsible for low-level power tasks that cannot be handled by the
main ARM Cortex A8 so firmware running from the CM3 can be used instead.
This driver handles loading of the firmware and reset of the CM3
once it is booted.

This patch was split off from v4 of the am335x suspend series, found
here [1]. Because of this it is a dependency for v5 of that series. I have
pushed a branch based on v3.18-rc6 containing all dependencies here [2] for
am33xx suspend for a higher level view of the entire series of patch sets.

This patch set depends on series "couple of generic remoteproc enhancements"
by Suman Anna found here [3] (Included already in previously mentioned branch)

Regards,
Dave

[1] http://www.spinics.net/lists/linux-omap/msg109331.html
[2] https://github.com/dgerlach/linux-pm/tree/rfc-pm-am335x-v3.18-rc6
[3] http://www.spinics.net/lists/arm-kernel/msg362961.html

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

