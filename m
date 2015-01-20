Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbbATQWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:22:19 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39314 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbATQWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:22:18 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Richard Henderson <rth@twiddle.net>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 0/8] Provide y2038/y2106 safe rtc_class_ops.set_mmss64()
Date: Tue, 20 Jan 2015 16:21:31 +0000
Message-Id: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series relies on a former patchset[1], it provides y2038/y2106
safe rtc_class_ops.set_mmss64(), and converts some possible users of set_mmss()
to use set_mmss64(), in the hope that making these users(i.e. rtc drivers)
y2038/y2106 safe.

[1] https://lkml.org/lkml/2014/11/18/218
[2] v1: https://lkml.org/lkml/2014/11/27/341
[3] v2: https://lkml.org/lkml/2015/1/13/403

v2->v3:
* Remove get_seconds64(), use ktime_get_real_seconds() to replace get_seconds()
* Refine rtc-test.c

Xunlei Pang (8):
  rtc: Provide y2038 safe rtc_class_ops.set_mmss() replacement
  rtc/test: Update driver to address y2038/y2106 issues
  rtc/ab3100: Update driver to address y2038/y2106 issues
  rtc/mc13xxx: Update driver to address y2038/y2106 issues
  rtc/mxc: Modify rtc_update_alarm() not to touch the alarm time
  rtc/mxc: Convert get_alarm_or_time()/set_alarm_or_time() to use
    time64_t
  rtc/mxc: Update driver to address y2038/y2106 issues
  alpha: rtc: change to use rtc_class_ops's set_mmss64()

 arch/alpha/kernel/rtc.c   |  8 +++----
 drivers/rtc/interface.c   |  7 +++++-
 drivers/rtc/rtc-ab3100.c  | 55 +++++++++++++++++++++++------------------------
 drivers/rtc/rtc-mc13xxx.c | 32 ++++++++++++---------------
 drivers/rtc/rtc-mxc.c     | 55 +++++++++++++++++------------------------------
 drivers/rtc/rtc-test.c    | 19 ++++++++++++++--
 drivers/rtc/systohc.c     |  5 ++++-
 include/linux/rtc.h       |  1 +
 8 files changed, 93 insertions(+), 89 deletions(-)

-- 
1.9.1

