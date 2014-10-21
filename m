Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbaJUOMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:12:42 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48689 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaJUOMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:12:41 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: rmk+kernel@arm.linux.org.uk, arm@kernel.org
Cc: kaixu.xia@linaro.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/4] ARM: get a strict multiplatform kernel that can run on any hardware
Date: Tue, 21 Oct 2014 22:11:30 +0800
Message-Id: <1413900694-29571-1-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current allmodconfig kernel boot fails on OMAP4460. There
are several configuration options that can only work on a subset
of the available machines, and enabling them will break other
machines that may be enabled in a multiplatform kernel.

Now we introduce a CONFIG_ARCH_MULTIPLATFORM_STRICT Kconfig 
option that prevent those other options from getting enabled
and get a strict multiplatform kernel.

This patch set is not complete yet(missing the console).

I am not sure who will pick up this patch set, so I just send 
it to arm@kernel.org and rmk.

Xia Kaixu (4):
  ARM: introduce a CONFIG_ARCH_MULTIPLATFORM_STRICT Kconfig option
  ARM: change the corresponding arm/mach defconfigs
  ARM: restrict CPU_BIG_ENDIAN configuration option
  ARM: allow errata and XIP options to be enabled without ARCH_MULTIPLATFORM_STRICT

 arch/arm/Kconfig                   | 28 +++++++++++++++++++++-------
 arch/arm/configs/bcm2835_defconfig |  1 +
 arch/arm/configs/moxart_defconfig  |  1 +
 arch/arm/configs/s5pv210_defconfig |  1 +
 arch/arm/configs/tegra_defconfig   |  1 +
 arch/arm/mm/Kconfig                |  1 +
 6 files changed, 26 insertions(+), 7 deletions(-)

-- 
2.1.1

