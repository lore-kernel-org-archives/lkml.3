Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaFMJxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 05:53:14 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19220 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaFMJxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 05:53:12 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 13 Jun 2014 02:47:50 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v2 0/3] drm/nouveau: support for probing platform devices
Date: Fri, 13 Jun 2014 18:52:43 +0900
Message-ID: <1402653166-8441-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for probing platform devices on Nouveau, as well as
the DT bindings for GK20A. It doesn't enable the GPU yet on Tegra boards since
a few extra things need to be supported before that.

Thanks to the input received for v1, this version is more self-contained and
shares less stuff between nouveau_drm and nouveau_platform. The major change
is that nouveau_platform is now a module of its own. The main reason for this
is that it allows us to register/unregister the driver from the module init
functions instead of parasiting the ones of nouveau_drm. It also makes it
simpler to build Nouveau without platform support at all.

Changes since v1:
* Moved the platform device driver to its own module. This allows it to be more
  self-contained and saves us the need to export too many functions from
  nouveau_drm and nouveau_platform.
* Register the DRM device without using the platform helpers, which is made
  possible by drm_dev_set_unique(). This allows us to catch and register the
  DRM device during platform probe.
* Fixed the clock names in the DT bindings.
* Removed the patches enabling GK20A on Venice2 and Jetson TK1 as support
  is not complete yet.

Alexandre Courbot (2):
  drm/nouveau: support for probing platform devices
  ARM: tegra: of: add GK20A device tree binding

Thierry Reding (1):
  ARM: tegra: add GK20A GPU to Tegra124 DT

 .../devicetree/bindings/gpu/nvidia,gk20a.txt       |  43 +++++
 arch/arm/boot/dts/tegra124.dtsi                    |  15 ++
 drivers/gpu/drm/nouveau/Kconfig                    |   8 +
 drivers/gpu/drm/nouveau/Makefile                   |   3 +
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  56 +++++--
 drivers/gpu/drm/nouveau/nouveau_drm.h              |   3 +
 drivers/gpu/drm/nouveau/nouveau_platform.c         | 182 +++++++++++++++++++++
 7 files changed, 299 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,gk20a.txt
 create mode 100644 drivers/gpu/drm/nouveau/nouveau_platform.c

-- 
2.0.0

