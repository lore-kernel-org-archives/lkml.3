Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaKRLPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:15:39 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32915 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaKRLPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:15:38 -0500
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 0/5] y2038 in-kernel interface changes for drivers/rtc
Date: Tue, 18 Nov 2014 19:15:15 +0800
Message-Id: <1416309320-7498-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32bit systems, the kernel uses a 32bit signed time_t value
for seconds since 1970-01-01:00:00:00. This will overflow at
2038-01-19 03:14:08, and is widely known as the y2038 problem.

To address this, the plan is to create 64bit internal interfaces
which are 2038 safe, mark the unsafe versions as deprecated and 
then convert subsystems one by one over to the new interfaces.
Once all users are converted, the deprecated internal functions
will be removed.

NOTE: In some cases, there are issues with 32bit values that are
unsigned, and thus become y2106 issues. Since its somewhat simpler
to unify the time types, we'll try to convert those usage to 64bit
where it can be easily done. In those cases where a fix would be 
overly complicated, we'll simply explicitly mark the limitation.

This patchset introduces the 64bit interfaces needed to convert
the drivers/rtc subsystem, and to keep it relatively short some
patches to demonstrate how the conversion will be done. If the 
feedback is positive on this series, we'll provide the full 
conversion series as well.

pang.xunlei (5):
  time: Provide y2038 safe do_settimeofday() replacement
  time: Provide y2038 safe timekeeping_inject_sleeptime() replacement
  time: Provide y2038 safe mktime() replacement
  rtc/lib: Provide y2038 safe rtc_tm_to_time()/rtc_time_to_tm()
    replacement
  rtc/mc13xxx: Eliminate time problems

 drivers/rtc/rtc-lib.c       |   38 ++++++++++++++++++++------------------
 drivers/rtc/rtc-mc13xxx.c   |   25 +++++++++++--------------
 include/linux/rtc.h         |   21 +++++++++++++++++++--
 include/linux/time.h        |   17 ++++++++++++++---
 include/linux/timekeeping.h |   34 ++++++++++++++++++++++++++++++++--
 kernel/time/time.c          |   20 ++++++++------------
 kernel/time/timekeeping.c   |   29 +++++++++++++----------------
 7 files changed, 117 insertions(+), 67 deletions(-)

-- 
1.7.9.5

