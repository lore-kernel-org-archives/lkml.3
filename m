Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935504Ab3BOIn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 03:43:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10187 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab3BOIn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 03:43:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 15 Feb 2013 00:43:18 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <linux-tegra@vger.kernel.org>
CC: <pdeschrijver@nvidia.com>, <pgaikwad@nvidia.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [v3 0/6] ARM: tegra: convert device tree files to use CLK defines
Date: Fri, 15 Feb 2013 10:43:11 +0200
Message-ID: <1360917814-27236-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With new dtc+cpp feature, we could get rid of magic numbers in dts*
files. This patch replaces CLK IDs.

We also plan to share those DT header files with kernel source
later[1].

This series depends on:
  [PATCH 0/9] ARM: tegra: use new dtc+cpp feature
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149613.html

[5/6] and [6/6] depend on:
  [PATCH v6 00/10] Tegra114 clockframework
  http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/148895.html

v2:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149816.html

v1:
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149672.html

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-February/149804.html


Hiroshi Doyu (6):
  ARM: tegra20: create a DT header defining CLK IDs
  ARM: tegra20: convert device tree files to use CLK defines
  ARM: tegra30: create a DT header defining CLK IDs
  ARM: tegra30: convert device tree files to use CLK defines
  ARM: tegra114: create a DT header defining CLK IDs
  ARM: tegra114: convert device tree files to use CLK defines

 .../bindings/clock/nvidia,tegra114-car.txt         |  261 +------------------
 .../bindings/clock/nvidia,tegra20-car.txt          |  150 +----------
 .../bindings/clock/nvidia,tegra30-car.txt          |  207 +--------------
 arch/arm/boot/dts/tegra114-car.h                   |  272 ++++++++++++++++++++
 arch/arm/boot/dts/tegra114.dtsip                   |   13 +-
 arch/arm/boot/dts/tegra20-car.h                    |  158 ++++++++++++
 arch/arm/boot/dts/tegra20-paz00.dtsp               |    2 +-
 arch/arm/boot/dts/tegra20.dtsip                    |   85 +++---
 arch/arm/boot/dts/tegra30-car.h                    |  218 ++++++++++++++++
 arch/arm/boot/dts/tegra30.dtsip                    |   87 +++----
 10 files changed, 746 insertions(+), 707 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra114-car.h
 create mode 100644 arch/arm/boot/dts/tegra20-car.h
 create mode 100644 arch/arm/boot/dts/tegra30-car.h

-- 
1.7.9.5

