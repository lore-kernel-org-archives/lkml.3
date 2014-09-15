Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaIONNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 09:13:24 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:63723 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349AbaIONNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 09:13:22 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: inki.dae@samsung.com, seanpaul@google.com, kishon@ti.com,
        ajaykumar.rs@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 0/3]  drm-exynos-dp/phy-exynos-dp: Refactor to use pmu-system-controller and dp driver cleanup
Date: Mon, 15 Sep 2014 18:43:02 +0530
Message-Id: <1410786785-9838-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are based on 'for-next' branch of kgene's linux-samsung tree.

Refactoring the exynos-dp-video phy to use pmu-system-controller handle
and access the register using mfd-syscon and regmap.
Simultaneously, removing the support for older dptx-phy, since it's obsolete
now and noone uses it.

Vivek Gautam (3):
  phy: exynos-dp-video: Use syscon support to control pmu register
  drm/exynos: dp: Remove support for unused dptx-phy
  arm: dts: Exynos5: Use pmu_system_controller phandle for dp phy

 .../devicetree/bindings/phy/samsung-phy.txt        |    7 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |    2 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |    4 +-
 drivers/gpu/drm/exynos/exynos_dp_core.c            |   58 ++++-----------
 drivers/gpu/drm/exynos/exynos_dp_core.h            |    2 -
 drivers/phy/phy-exynos-dp-video.c                  |   76 ++++++++++++++------
 6 files changed, 75 insertions(+), 74 deletions(-)

-- 
1.7.10.4

