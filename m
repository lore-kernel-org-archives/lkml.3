Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434AbaLPImA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 03:42:00 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50239 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLPIl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 03:41:57 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v5 0/3] Add support for Tegra Activity Monitor
Date: Tue, 16 Dec 2014 09:41:18 +0100
Message-Id: <1418719298-25314-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this v5 addresses a few comments from Alexandre:

* Clarify the units of avg_dependency_threshold
* Remove unused references to platform_device
* Enable and disable interrupts on governor events
* Make sure we handle all interrupts for any of the devices we are sampling
* Move locking to be per-actmon-device

These patches implement support for setting the rate of the EMC clock based on
stats collected from the ACTMON, a piece of hw in the Tegra124 that counts
memory accesses (among others).

It depends on the following in-flight patches:

* EMC driver: http://thread.gmane.org/gmane.linux.drivers.devicetree/99304
* CPUFreq driver: http://thread.gmane.org/gmane.linux.kernel/1812962

I have pushed a branch here for testing:

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=actmon-v5

Regards,

Tomeu

Tomeu Vizoso (3):
  of: Add binding for NVIDIA Tegra ACTMON node
  PM / devfreq: tegra: add devfreq driver for Tegra Activity Monitor
  ARM: tegra: Add Tegra124 ACTMON support

 .../devicetree/bindings/arm/tegra/actmon.txt       |  38 +
 arch/arm/boot/dts/tegra124.dtsi                    |  23 +
 drivers/devfreq/Kconfig                            |   9 +
 drivers/devfreq/Makefile                           |   1 +
 drivers/devfreq/tegra-actmon-devfreq.c             | 767 +++++++++++++++++++++
 5 files changed, 838 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/actmon.txt
 create mode 100644 drivers/devfreq/tegra-actmon-devfreq.c

-- 
1.9.3

