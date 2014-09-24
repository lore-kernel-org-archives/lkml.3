Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbaIXQUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:20:21 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:40444 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaIXQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:20:19 -0400
From: Stefan Agner <stefan@agner.ch>
To: shawn.guo@freescale.com, kernel@pengutronix.de, daniel.lezcano@linaro.org,
        tglx@linutronix.de
Cc: festevam@gmail.com, jingchang.lu@freescale.com, bpringlemeir@nbsps.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>
Subject: [PATCH v2 0/3] ARM: vf610: Fix/add clocksource
Date: Wed, 24 Sep 2014 18:20:07 +0200
Message-Id: <1411575610-20895-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset came out of need for a clocksource which supports shutdown.
In the first version I proposed to just replace the current clocksource
with the ARM Global Timer and even proposed to remove the PIT clocksource
driver. But Bill Pringlemeir brought up a reasonable point why we should
keep the PIT clocksource.

Since we need shutdown support for suspend/resume, I added another patch
which fixes shutdown functionality for the PIT driver. Now it's possible
to use suspend/resume functionality with each of the two clocksources.

Changes in v2:
- Added shutdown support for PIT clocksource (and hence clocksource
  maintainers as receipient).
- Create Kconfig entries which allow to choose between the two
  clocksources
- Clarified commit message
- Renamed device tree node to "timer"

Stefan Agner (3):
  clocksource: vf_pit_timer: Support shutdown mode
  ARM: dts: vf610: Add ARM Global Timer
  ARM: vf610: Add ARM Global Timer clocksource option

 arch/arm/boot/dts/vf610.dtsi       |  8 ++++++++
 arch/arm/mach-imx/Kconfig          | 19 ++++++++++++++++++-
 drivers/clocksource/vf_pit_timer.c |  5 +++++
 3 files changed, 31 insertions(+), 1 deletion(-)

-- 
2.1.0

