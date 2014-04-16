Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161511AbaDPXPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:15:30 -0400
Received: from mail-oa0-f74.google.com ([209.85.219.74]:48645 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161413AbaDPXP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:15:28 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-mmc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v2 0/3] Tegra SD/MMC fixes
Date: Wed, 16 Apr 2014 16:08:36 -0700
Message-Id: <1397689719-28882-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
References: <1397526163-20126-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches fix a couple of issues which prevented Venice2
boards from booting via eMMC and SD card reliably.  Note that this
includes disabling UHS support since SDR50 and above require a
Tegra-specific tuning procedure which is not supported yet (and still
seems to have issues even in downstream kernels).

This depends on the following patches which fix an issue where the
eMMC's power supply gets toggled, causing eMMC failures:
  http://patchwork.ozlabs.org/patch/339386/
  http://patchwork.ozlabs.org/patch/339710/

Tested on Tegra124-based Venice2 and Norrin boards.

Andrew Bresticker (3):
  mmc: tegra: disable UHS modes
  mmc: tegra: fix reporting of base clock frequency
  ARM: tegra: fix Venice2 SD card VQMMC supply

 arch/arm/boot/dts/tegra124-venice2.dts |  2 +-
 drivers/mmc/host/sdhci-tegra.c         | 40 +++++++++++++++++++++++++---------
 2 files changed, 31 insertions(+), 11 deletions(-)

-- 
1.9.1.423.g4596e3a

