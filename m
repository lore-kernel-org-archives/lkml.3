Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbaLINQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:16:05 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52737 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbaLINQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:16:02 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v4 0/3] Add support for Tegra Activity Monitor
Date: Tue,  9 Dec 2014 14:15:03 +0100
Message-Id: <1418130912-24725-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this v4 just fixes a botched rename in v3. The original cover letter for v3 follows:

this v3 addresses the comments that the devfreq implementation got, namely:

* Address misc. style issues found by Thierry and Alexander
* Added helpers for register i/o
* Further documented the structs
* Enable the ACTMON after the IRQ handler has been installed
* Disable the ACTMON before removing the IRQ handler
* Add governor in a subsys initcall

There's an open question on whether some functionality currently in this
devfreq driver should be moved into the devfreq framework, but without knowing
of other SoC family that would benefit from it, I'm reticent. It would be
great to hear from the devfreq maintainers if they have any plans regarding
this, or if they have any suggestion.

These patches implement support for setting the rate of the EMC clock based on
stats collected from the ACTMON, a piece of hw in the Tegra124 that counts
memory accesses (among others).

It depends on the following in-flight patches:

* EMC driver: http://thread.gmane.org/gmane.linux.drivers.devicetree/99304
* CPUFreq driver: http://thread.gmane.org/gmane.linux.kernel/1812962

I have pushed a branch here for testing:

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=actmon-v4

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
 drivers/devfreq/tegra-actmon-devfreq.c             | 777 +++++++++++++++++++++
 5 files changed, 848 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/actmon.txt
 create mode 100644 drivers/devfreq/tegra-actmon-devfreq.c

-- 
1.9.3

