Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaFKFfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 01:35:20 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58680 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaFKFfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 01:35:16 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: mturquette@linaro.org, t.figa@samsung.com, linux@arm.linux.org.uk,
        galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kgene.kim@samsung.com, khilman@linaro.org, dianders@google.com,
        trblinux@gmail.com
Subject: [PATCH 0/3] Fix boot-hang on Peach-pit and Enable audio
Date: Wed, 11 Jun 2014 11:02:16 +0530
Message-Id: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With next-20140610, Peach-pit/Peach-pi board hangs during boot if we
run 'sound init' during u-boot. The issue is fixed in following patches.
While at it, also enable audio support for Peach-pi board.

How to test audio on Peach-pi:
* On top of exynos_defconfig, enable SND_SOC_SNOW and PL330_DMA.
* Run 'sound init' at u-boot prompt.

Tushar Behera (3):
  clk: exynos-audss: Keep the parent of mout_audss always enabled
  ARM: dts: Update the parent for Audss clocks in Exynos5420
  ARM: dts: Enable audio support for Peach-pi board

 arch/arm/boot/dts/exynos5420.dtsi         |    2 +-
 arch/arm/boot/dts/exynos5800-peach-pi.dts |   31 +++++++++++++++++++++++++++++
 drivers/clk/samsung/clk-exynos-audss.c    |   17 +++++++++++++---
 3 files changed, 46 insertions(+), 4 deletions(-)

-- 
1.7.9.5

