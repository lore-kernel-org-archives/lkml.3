Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbaESJYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:24:18 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:5134 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaESJYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:24:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 May 2014 02:19:24 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/5] drm/nouveau: platform devices and GK20A probing
Date: Mon, 19 May 2014 18:24:05 +0900
Message-ID: <1400491450-19223-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is the final (?) step towards the initial support of GK20A,
allowing it to be probed and used (currently at a very slow speed, and for
offscreen rendering only) on the Jetson TK1 and Venice 2 boards.

The main piece if the first patch which adds platform devices probing support
to Nouveau. There are probably lots of things that need to be discussed about
it, e.g.:

* The way the DRM device is created, especially with respect to the ongoing
  changes to the DRM framework,
* The fact that the same drm_driver instance is used for the PCI and platform
  drivers,
* Whether we should have only one platform driver capable of probing all
  platform devices, or one driver per GPU (in this case, where should all these
  drivers reside?)

So there are still some rough edges, but we are getting there. :)

The first patch should go through the Nouveau tree, while the 4 others are
rather intended for Tegra.

Alexandre Courbot (3):
  drm/nouveau: support for probing platform devices
  ARM: tegra: of: add GK20A device tree binding
  ARM: tegra: jetson-tk1: enable GK20A GPU

Thierry Reding (2):
  ARM: tegra: add GK20A GPU to Tegra124 DT
  ARM: tegra: venice2: enable GK20A GPU

 .../devicetree/bindings/gpu/nvidia,gk20a.txt       |  45 +++++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   8 +-
 arch/arm/boot/dts/tegra124-venice2.dts             |   8 +-
 arch/arm/boot/dts/tegra124.dtsi                    |  15 ++
 drivers/gpu/drm/nouveau/Kconfig                    |   8 +
 drivers/gpu/drm/nouveau/Makefile                   |   3 +
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  33 ++--
 drivers/gpu/drm/nouveau/nouveau_drm.h              |  21 +++
 drivers/gpu/drm/nouveau/nouveau_platform.c         | 191 +++++++++++++++++++++
 9 files changed, 315 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_platform.c

-- 
1.9.2

