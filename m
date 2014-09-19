Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaISK0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:26:40 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41498 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaISK0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:26:38 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        rtc-linux@googlegroups.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v10 0/6] Add Maxim 77802 RTC support
Date: Fri, 19 Sep 2014 12:26:11 +0200
Message-Id: <1411122377-10426-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

This series add support for the Real Time clock present in
the Maxim 77802 Power Managment IC. The version number is
quite high because it previously was part of a bigger series
[0] that aimed to add support for all the devices in the
max77802 PMIC. But now that the max77802 dependencies were
already merged for 3.17, the series were split but I kept
the version numbering.

While working on the max77802 rtc support a lot of feedback
was given and the issues pointed out also apply to a driver
for a similar PMIC RTC (max77686). So patches 01/06 to 05/06
in the series are cleanups for the max77686 driver and patch
06/06 adds the support for the max77802 RTC.

This version address the issues pointed out on the previous
version [1] and changelog are present on each patch when is
applicable.

The series were tested on an Exynos5250 Snow (max77686) and
Exynos5420 Peach Pit (max77802) machines and applies cleanly
to both 3.17-rc1 and today's linux-next (20140919).

NOTE: The patches from the previous version [1] were already
present in the -mm tree [2] so I didn't know if I should had
sent this as a delta or as a new revision. I decided to do
the later but please let me know if you expected the former.

Doug Anderson (1):
  rtc: max77686: Allow the max77686 rtc to wakeup the system

Javier Martinez Canillas (5):
  rtc: max77686: Remove dead code for SMPL and WTSR.
  rtc: max77686: Fail to probe if no RTC regmap irqchip is set
  rtc: max77686: Remove unneded info log
  rtc: max77686: Use ffs() to calculate tm_wday
  rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock

 drivers/rtc/Kconfig        |  10 +
 drivers/rtc/Makefile       |   1 +
 drivers/rtc/rtc-max77686.c | 139 +++----------
 drivers/rtc/rtc-max77802.c | 501 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 542 insertions(+), 109 deletions(-)
 create mode 100644 drivers/rtc/rtc-max77802.c

[0]: http://lwn.net/Articles/605350/
[1]: https://lkml.org/lkml/2014/9/12/87
[2]: http://ozlabs.org/~akpm/mmots/series
