Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbbAXBoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:44:14 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39795 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbAXBoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:44:11 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nico@linaro.org>
Subject: [GIT PULL] Time items for 3.20
Date: Fri, 23 Jan 2015 17:43:52 -0800
Message-Id: <1422063840-2837-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
  Just wanted to send out my current 3.20 queue so it can
get some time in -next.

Let me know if you have any objections or concerns.

thanks
-john

Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Nicolas Pitre <nico@linaro.org>

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  https://git.linaro.org/people/john.stultz/linux.git tags/fortglx-3.20-time

for you to fetch changes up to 9a4a445e30f0b601ca2d9433274047cbf48ebf9e:

  rtc: Convert rtc_set_ntp_time() to use timespec64 (2015-01-23 17:21:57 -0800)

----------------------------------------------------------------
Couple of items for 3.20

* ktime division optimization
* Expose a few more y2038-safe timekeeping interfaces
* RTC core changes to address y2038

Signed-off-by: John Stultz <john.stultz@linaro.org>

----------------------------------------------------------------
John Stultz (2):
      time: Expose getboottime64 for in-kernel uses
      time: Expose get_monotonic_boottime64 for in-kernel use

Nicolas Pitre (1):
      ktime: Optimize ktime_divns for constant divisors

Xunlei Pang (5):
      rtc: Update interface.c to use y2038-safe time interfaces
      rtc: Update rtc-dev to use y2038-safe time interfaces
      rtc: Modify rtc_hctosys() to address y2038 issues
      rtc: Remove redundant rtc_valid_tm() from rtc_hctosys()
      rtc: Convert rtc_set_ntp_time() to use timespec64

 drivers/rtc/hctosys.c       | 18 +++++-------------
 drivers/rtc/interface.c     | 22 ++++++++++------------
 drivers/rtc/rtc-dev.c       |  8 ++++----
 drivers/rtc/systohc.c       |  6 +++---
 include/linux/ktime.h       | 12 +++++++++++-
 include/linux/rtc.h         |  2 +-
 include/linux/timekeeping.h | 21 +++++++++++++++++++--
 kernel/time/hrtimer.c       |  4 ++--
 kernel/time/ntp.c           |  4 ++--
 kernel/time/timekeeping.c   | 12 ++++++------
 10 files changed, 63 insertions(+), 46 deletions(-)
