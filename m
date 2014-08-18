Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaHRIey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 04:34:54 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41505 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaHRIew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 04:34:52 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v9 0/5] Add Maxim 77802 RTC support
Date: Mon, 18 Aug 2014 10:34:32 +0200
Message-Id: <1408350877-15921-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alessandro,

This series add support for the Real Time clock present in
the Maxim 77802 Power Managment IC. Previously, the series
was part of a bigger one [0] that aimed to add support for
all the devices in the max77802 PMIC. But now the max77802
dependencies were already merged for 3.17 so the series can
be split and each driver can go through the relevant tree.

While working on the max77802 rtc support a lot of feedback
was given and the issues pointed out also apply to a driver
for a similar PMIC RTC (max77686). So patches 01/05 to 04/05
in the series are cleanups for the max77686 driver and patch
05/05 adds the support for the max77802 RTC.

I kept the version numbering from the old series so this is
version 9 although there were no changes on the max77802 rtc
driver since v6 of the old series, only patches 03 and 04 were
added on this version which are cleanups for the max77686 rtc.

The series were tested on an Exynos5250 Snow (max77686) and
Exynos5420 Peach Pit (max77802) machines and applies cleanly
to both 3.17-rc1 and today's linux-next (20140818).

Doug Anderson (1):
  rtc: max77686: Allow the max77686 rtc to wakeup the system

Javier Martinez Canillas (4):
  rtc: max77686: Remove dead code for SMPL and WTSR.
  rtc: max77686: Fail to probe if no RTC regmap irqchip is set
  rtc: max77686: Remove unneded info log
  rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock

 drivers/rtc/Kconfig        |  10 +
 drivers/rtc/Makefile       |   1 +
 drivers/rtc/rtc-max77686.c | 127 +++--------
 drivers/rtc/rtc-max77802.c | 513 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 553 insertions(+), 98 deletions(-)
 create mode 100644 drivers/rtc/rtc-max77802.c

Best regards,
Javier

[0]: http://lwn.net/Articles/605350/
