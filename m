Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaILISA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:18:00 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36813 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbaILIRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:17:55 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH RESEND v9 0/5] Add Maxim 77802 RTC support
Date: Fri, 12 Sep 2014 10:17:38 +0200
Message-Id: <1410509864-10019-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

I posted this series many times in the last few months,
it was first meant to be for 3.17 but never got feedback
from the maintainer (still on cc) so I reposted about a
month ago [0] for 3.18 but didn't get feedback either.
Other people have shown interest in the series though so
Reviewed-by tags were collected for most patches.

I noticed that you are picking other RTC drivers on your
-mm tree [1] so I wondered if you can pick this one too.

This series add support for the Real Time clock present in
the Maxim 77802 Power Managment IC. Previously, the series
was part of a bigger one [2] that aimed to add support for
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

[0]: https://lkml.org/lkml/2014/8/18/85
[1]: http://ozlabs.org/~akpm/mmots/series
[2]: http://lwn.net/Articles/605350/
