Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaGBMWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:22:31 -0400
Received: from gnurou.org ([207.192.72.5]:55650 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaGBMW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:22:28 -0400
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/4] drm/dsi/tegra: continuous clock support
Date: Wed,  2 Jul 2014 21:19:16 +0900
Message-Id: <1404303560-32209-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This small series adds support for DSI continuous clock as required by the
DSI specification and as needed for NVIDIA SHIELD's panel. Continuous clock
mode can be specified as the flags of a DSI device, and host drivers can check
this flag to adapt their behavior.

The flag is then added to the panel embedded in NVIDIA SHIELD, which allows
us to finally enable the panel in its device tree.

Alexandre Courbot (4):
  drm/dsi: Add flag for continuous clock behavior
  drm/tegra: dsi - Handle continuous clock flag
  drm/panel: LG LH500WX1-SD03 uses continuous clock
  ARM: tegra: roth: add display DT node

 arch/arm/boot/dts/tegra114-roth.dts  | 23 ++++++++++++++++++++---
 drivers/gpu/drm/panel/panel-simple.c |  2 +-
 drivers/gpu/drm/tegra/dsi.c          |  3 ++-
 include/drm/drm_mipi_dsi.h           |  2 ++
 4 files changed, 25 insertions(+), 5 deletions(-)

-- 
2.0.0

