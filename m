Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaKXM3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 07:29:34 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53498 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbaKXM3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 07:29:31 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH v2 0/3] Add support for Tegra Activity Monitor
Date: Mon, 24 Nov 2014 13:28:15 +0100
Message-Id: <1416832111-367-1-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

in this v2 I have made the driver use devfreq. It works just as fine as the
previous revision, but it's almost 200 lines more of code for not that much
gain.

Though I don't see much point in using devfreq, I think it's probably better
than an ad-hoc driver because in the future I hope that devfreq will gain
functionality that will be of use (PM_QOS_MEMORY_BANDWIDTH support, for
example).

These patches implement support for setting the rate of the EMC clock based on
stats collected from the ACTMON, a piece of hw in the Tegra124 that counts
memory accesses (among others).

It depends on the following in-flight patches:

* EMC driver: http://thread.gmane.org/gmane.linux.drivers.devicetree/99304
* CPUFreq driver: http://thread.gmane.org/gmane.linux.kernel/1812962

I have pushed a branch here for testing:

http://cgit.collabora.com/git/user/tomeu/linux.git/log/?h=actmon-v2

Regards,

Tomeu

Tomeu Vizoso (3):
  of: Add binding for NVIDIA Tegra ACTMON node
  PM / devfreq: tegra: add devfreq driver for Tegra Activity Monitor
  ARM: tegra: Add Tegra124 ACTMON support

 .../devicetree/bindings/arm/tegra/actmon.txt       |  38 ++
 arch/arm/boot/dts/tegra124.dtsi                    |  23 +
 drivers/devfreq/Kconfig                            |  10 +
 drivers/devfreq/Makefile                           |   1 +
 drivers/devfreq/tegra-devfreq.c                    | 718 +++++++++++++++++++++
 5 files changed, 790 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/tegra/actmon.txt
 create mode 100644 drivers/devfreq/tegra-devfreq.c

-- 
1.9.3

