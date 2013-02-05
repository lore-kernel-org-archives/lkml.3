Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3BEXnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 18:43:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47285 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab3BEXnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 18:43:11 -0500
From: Sean Paul <seanpaul@chromium.org>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, inki.dae@samsung.com,
        t.stanislaws@samsung.com, tomasz.figa@gmail.com,
        sylvester.nawrocki@gmail.com, olofj@chromium.org,
        rahul.sharma@samsung.com, Sean Paul <seanpaul@chromium.org>
Subject: [PATCH v3 0/2] Get the HDMI IP block version from device tree
Date: Tue,  5 Feb 2013 15:42:55 -0800
Message-Id: <1360107777-17490-1-git-send-email-seanpaul@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set changes the hdmi device tree node to properly represent the version of
the IP block. The first patch changes the drm hdmi driver to use the compatible
field to determine which registers/functions to call, and removes the
unfortunate v1.3/v1.4 naming convention. The second patch updates the arch-
specific bits for exynos5.

Changes in v3:
 - Use compatible field in device tree instead of hdmi-version field
 - Change hdmi driver's naming to use IP version instead of hdmi version


Sean Paul (2):
  drm/exynos: Get HDMI version from device tree
  ARM: Change exynos5-hdmi references to exynos4-hdmi

 .../devicetree/bindings/drm/exynos/hdmi.txt        |    9 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    3 +-
 arch/arm/mach-exynos/clock-exynos5.c               |    4 +-
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    4 +-
 drivers/gpu/drm/exynos/exynos_hdmi.c               |  354 ++++++++++----------
 drivers/gpu/drm/exynos/regs-hdmi.h                 |   78 +++---
 6 files changed, 229 insertions(+), 223 deletions(-)

-- 
1.7.7.3

