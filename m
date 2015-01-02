Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbbABUAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:00:50 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43056 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbbABUAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:00:49 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Ohad Ben-Cohen <ohad@wizery.com>,
        Suman Anna <s-anna@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH 0/3] drivers: soc: ti: Introduce wkup_m3_ipc driver
Date: Fri, 2 Jan 2015 14:00:14 -0600
Message-ID: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series introduces a wkup_m3_ipc driver to handle communication
between the MPU and Cortex M3 present on TI AM335x SoCs. This is
required for much of the PM functionality for AM335x including suspend
support. This was split off from v4 of the am335x suspend series,
discussion that led to the implementation of this driver can be found
with the series here [1].  A previous RFC version of this series can be
found here [2]. The changes from that version are as follows:
 - Remove wake source reporting as it is unnecessary.
 - Use newly introduced rproc_get_by_phandle API to get rproc for
   booting [3].

This series depends on the patch "remoteproc: Introduce
rproc_get_by_phandle API" [3] and the wkup_m3_rproc series found
here [4]. A branch based on 3.19-rc1 containing this series and
all dependencies for the AM33xx suspend series can be found
here [5] for a high level view of what I am using this for.

A small API is exposed to allow the SoC PM code to execute the
specific tasks it needs to in order to enter and exit low power
modes. Communication works the same as it did in the past using the
IPC registers found within the control module, a mailbox module, and
an interrupt coming back from the CM3. All of that, including the
configurations needed for different low power tasks is encapsulated
within this driver.

Regards,
Dave

[1] http://www.spinics.net/lists/linux-omap/msg109331.html
[2] http://www.spinics.net/lists/linux-omap/msg113372.html
[3] http://marc.info/?l=linux-kernel&m=142022798923784&w=2
[4] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg795457.html
[5] https://github.com/dgerlach/linux-pm/tree/pm-am335x-v3.19-rc1

Dave Gerlach (3):
  Documentation: dt: add ti,am3353-wkup-m3-ipc bindings
  soc: ti: Add wkup_m3_ipc driver
  ARM: dts: am33xx: Add wkup_m3_ipc node

 .../devicetree/bindings/soc/ti/wkup_m3_ipc.txt     |  41 ++
 arch/arm/boot/dts/am33xx.dtsi                      |   9 +
 drivers/soc/ti/Kconfig                             |  11 +
 drivers/soc/ti/Makefile                            |   1 +
 drivers/soc/ti/wkup_m3_ipc.c                       | 451 +++++++++++++++++++++
 include/linux/wkup_m3_ipc.h                        |  33 ++
 6 files changed, 546 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/soc/ti/wkup_m3_ipc.txt
 create mode 100644 drivers/soc/ti/wkup_m3_ipc.c
 create mode 100644 include/linux/wkup_m3_ipc.h

-- 
2.1.0

