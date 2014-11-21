Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaKUToe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:44:34 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61962 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaKUTod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:44:33 -0500
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
        "pang.xunlei" <pang.xunlei@linaro.org>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 00/12] 
Date: Fri, 21 Nov 2014 11:44:06 -0800
Message-Id: <1416599058-13836-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, All,

Just wanted to submit a handful of changes for 3.19

* udelay_test/test_udelay consistent file naming
* Time / ntp edge-case fixes from Xunlei
* y2038-safe internal interfaces from Xunlei and me
* Celanup suspend/resume timing y2038 issues
* Remove y2038 unsafe inject_sleeptime inteface

Just as an FYI, I'm trying out signing this tag with
a new subkey on my yubikey. Hopefully haven't mucked
it up.

If there's no objections, you can grab this via the
pull-request below.

Thanks
-john

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: pang.xunlei <pang.xunlei@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  https://git.linaro.org/people/john.stultz/linux.git tags/fortglx-3.19-time

for you to fetch changes up to b6adbbd9a2171aa4764ea8a56c4c1a5f63f2cca6:

  Merge commit '039348d8c131329742e80e37122f11d230fd270b' into fortglx/3.19/time (2014-11-20 21:37:59 -0800)


John Stultz (6):
  time: Rename udelay_test.c to test_udelay.c
  time: Expose getrawmonotonic64 for in-kernel uses
  time: Expose get_monotonic_corase64() for in-kernel uses
  time: Fixup comments to reflect usage of timespec64
  rtc: Update suspend/resume timing to use 64bit time
  time: Remove timekeeping_inject_sleeptime()

pang.xunlei (6):
  time: Avoid possible NTP adjustment mult overflow.
  time: Complete NTP adjustment threshold judging conditions
  time: Provide y2038 safe do_settimeofday() replacement
  time: Provide y2038 safe timekeeping_inject_sleeptime() replacement
  time: Provide y2038 safe mktime() replacement
  rtc/lib: Provide y2038 safe rtc_tm_to_time()/rtc_time_to_tm()
    replacement

