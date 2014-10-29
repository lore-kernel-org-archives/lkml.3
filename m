Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933432AbaJ2OvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:51:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60427 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbaJ2OvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:51:22 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 0/3] Add support for Tegra Activity Monitor
Date: Wed, 29 Oct 2014 15:50:10 +0100
Message-Id: <1414594232-15684-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

these patches implement support for setting the rate of the EMC clock based on
stats collected from the ACTMON, a piece of hw in the Tegra124 that counts
memory accesses (among others).

It depends on the following in-flight patches:

* MC driver: http://thread.gmane.org/gmane.linux.ports.tegra/19623
* EMC driver: http://thread.gmane.org/gmane.linux.ports.arm.kernel/365125
* CPUFreq driver: http://thread.gmane.org/gmane.linux.kernel/1812962

I have pushed a branch here for testing:

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=actmon

Regards,

Tomeu

Tomeu Vizoso (3):
  of: Add binding for NVIDIA Tegra ACTMON node
  soc/tegra: add support for Tegra Activity Monitor
  ARM: tegra: Add Tegra124 ACTMON support

 .../devicetree/bindings/arm/tegra/actmon.txt       |  26 +
 arch/arm/boot/dts/tegra124.dtsi                    |  11 +
 drivers/soc/tegra/Makefile                         |   1 +
 drivers/soc/tegra/actmon.c                         | 523 +++++++++++++++++++++
 4 files changed, 561 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/actmon.txt
 create mode 100644 drivers/soc/tegra/actmon.c

-- 
1.9.3

