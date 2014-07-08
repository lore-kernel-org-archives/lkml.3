Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbaGHMhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:37:21 -0400
Received: from gnurou.org ([207.192.72.5]:48198 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbaGHMhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:37:13 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Andrzej Hajda <a.hajda@samsung.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 0/4] drm/dsi/tegra: continuous clock support
Date: Tue,  8 Jul 2014 21:32:10 +0900
Message-Id: <1404822734-8603-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series adds a flag that allows to specify that a DSI device supports
non-continuous clock mode, and uses it in the Tegra DSI driver to only enable
this mode on panels that support it. Until now, the Tegra DSI driver
unconditionally enabled non-continuous mode, which prevented continous-mode-only
panels from working with it.

This allows us to enable the panel embedded in NVIDIA SHIELD and which only
supports continuous mode.

Changes since v2:
- Changed the flag to enable non-continuous behavior instead of the contrary,
  to match the DSI spec more closely and highlight the fact continuous behavior
  is the default

Changes since v1:
- Removed unneeded regulator-always-on property for vdd_lcd regulator

Alexandre Courbot (4):
  drm/dsi: Flag for non-continuous clock behavior
  drm/panel: Set non-continuous clock flag on supporting panels
  drm/tegra: dsi - Handle non-continuous clock flag
  ARM: tegra: roth: add display DT node

 arch/arm/boot/dts/tegra114-roth.dts  | 22 +++++++++++++++++++---
 drivers/gpu/drm/panel/panel-simple.c |  5 +++--
 drivers/gpu/drm/tegra/dsi.c          |  3 ++-
 include/drm/drm_mipi_dsi.h           |  2 ++
 4 files changed, 26 insertions(+), 6 deletions(-)

-- 
2.0.0

