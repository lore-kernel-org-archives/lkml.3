Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805AbaLWKkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:40:10 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17927 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbaLWKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:40:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Dec 2014 02:38:23 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: thierry.reding@gmail.com, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com
CC: nouveau@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH 0/11] Add suspend/resume support for GK20A
Date: Tue, 23 Dec 2014 18:39:53 +0800
Message-ID: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series includes some pieces of fixes to complete the GK20A power
on/off sequences and add the suspend/resume support.

The patches 1/11 - 4/11 are based on the linux-next-20141219.
The patches 5/11 - 11/11 are based on the branch "linux-3.19" of Ben Skeggs's
tree (http://cgit.freedesktop.org/~darktama/nouveau).

Thanks,
Vince

Vince Hsu (4): (linux-next-20141219)
  ARM: tegra: add function to control the GPU rail clamp
  memory: tegra: add mc flush support
  memory: tegra: add flush operation for Tegra124 memory clients
  ARM: tegra: add mc node for Tegra124 GPU

 arch/arm/boot/dts/tegra124.dtsi |  1 +
 drivers/memory/tegra/mc.c       | 21 +++++++++++
 drivers/memory/tegra/tegra124.c | 82 +++++++++++++++++++++++++++++++++++++++++
 drivers/soc/tegra/pmc.c         | 34 +++++++++++------
 include/soc/tegra/mc.h          | 23 +++++++++++-
 include/soc/tegra/pmc.h         |  2 +
 6 files changed, 151 insertions(+), 12 deletions(-)

Vince Hsu (7): (linux-3.19 / http://cgit.freedesktop.org/~darktama/nouveau)
  platform: switch to the new gpu rail clamping function
  platform: complete the power up/down sequence
  instmem: make nv50_instmem_priv public
  instmem: add dummy support for GK20A
  drm: export some variable and functions to resue the PM functions
  platform: add suspend/resume support
  platform: add PM runtime suspend/resume support

 drm/Kbuild                     |   1 +
 drm/core/subdev/instmem/nv50.h |   1 +
 drm/nouveau_drm.c              |  16 ++--
 drm/nouveau_drm.h              |   2 +
 drm/nouveau_platform.c         | 174 ++++++++++++++++++++++++++++++++++++++++-
 drm/nouveau_platform.h         |   3 +
 nvkm/engine/device/nve0.c      |   2 +-
 nvkm/include/subdev/instmem.h  |   1 +
 nvkm/subdev/instmem/gk20a.c    |  70 +++++++++++++++++
 nvkm/subdev/instmem/nv50.c     |   9 +--
 nvkm/subdev/instmem/nv50.h     |  14 ++++
 11 files changed, 279 insertions(+), 14 deletions(-)
 create mode 120000 drm/core/subdev/instmem/nv50.h
 create mode 100644 nvkm/subdev/instmem/gk20a.c
 create mode 100644 nvkm/subdev/instmem/nv50.h

-- 
1.9.1

