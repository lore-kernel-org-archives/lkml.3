Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761580Ab3BNS74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 13:59:56 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10021 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758544Ab3BNS7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 13:59:55 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 14 Feb 2013 10:59:15 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v2 0/4] ARM: tegra: convert device tree files to use CLK defines
Date: Thu, 14 Feb 2013 20:59:14 +0200
Message-ID: <1360868369-20093-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With new dtc+cpp feature, we can get rid of magic numbers in dts*
files. To get rid of Tegra clock magic number, the following patches
were created with a script run as below. This can be applied for
Tegra114 clock as well.

for x in 20 30; do
    cat drivers/clk/tegra/clk-tegra$x.c | enum2define.py \
    	> arch/arm/boot/dts/tegra$x-car.h 2>/tmp/tegra$x-car.sed
    sed -i -f /tmp/tegra$x-car.sed \
    	Documentation/devicetree/bindings/clock/nvidia\,tegra$x-car.txt \
	arch/arm/boot/dts/*
done

We plan to share those DT header files with kernel source later[1].

This series depends on:

  [PATCH 0/9] ARM: tegra: use new dtc+cpp feature
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149613.html

v1:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149672.html

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149804.html

Hiroshi Doyu (4):
  ARM: tegra20: create a DT header defining CLK IDs
  ARM: tegra20: convert device tree files to use CLK defines
  ARM: tegra30: create a DT header defining CLK IDs
  ARM: tegra30: convert device tree files to use CLK defines

 .../bindings/clock/nvidia,tegra20-car.txt          |    2 +-
 .../bindings/clock/nvidia,tegra30-car.txt          |    2 +-
 arch/arm/boot/dts/tegra20-car.h                    |  114 +++++++++++++
 arch/arm/boot/dts/tegra20-paz00.dtsp               |    2 +-
 arch/arm/boot/dts/tegra20.dtsip                    |   85 +++++-----
 arch/arm/boot/dts/tegra30-car.h                    |  171 ++++++++++++++++++++
 arch/arm/boot/dts/tegra30.dtsip                    |   87 +++++-----
 7 files changed, 375 insertions(+), 88 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra20-car.h
 create mode 100644 arch/arm/boot/dts/tegra30-car.h

--
1.7.9.5

