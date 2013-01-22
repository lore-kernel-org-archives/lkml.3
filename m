Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab3AVTmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 14:42:45 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:38878 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3AVTmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 14:42:44 -0500
Message-ID: <50FEEBB1.5020507@linaro.org>
Date: Tue, 22 Jan 2013 11:42:41 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: lkml <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Kees Cook <keescook@chromium.org>, Bernd Faust <berndfaust@gmail.com>
Subject: [GIT PULL] Timekeeping changes for 3.9
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
     Here's my current queue I wanted to send to you in preparation for 
3.9 (so they can have some time for testing in -next). There's also a 
few items that barely missed 3.8. Let me know if you have any issues 
with these.

thanks
-john



The following changes since commit 9c3f9e281697d02889c3b08922f3b30be75f56c2:

   Merge branch 'fortglx/3.8/time' of 
git://git.linaro.org/people/jstultz/linux into timers/core (2012-11-21 
20:31:52 +0100)

are available in the git repository at:


   git://git.linaro.org/people/jstultz/linux.git fortglx/3.9/time

for you to fetch changes up to e90c83f757fffdacec8b3c5eee5617dcc038338f:

   x86: Select HAS_PERSISTENT_CLOCK on x86 (2013-01-15 18:16:09 -0800)

----------------------------------------------------------------
Bernd Faust (1):
       Round the calculated scale factor in set_cyc2ns_scale()

Feng Tang (3):
       timekeeping: Add persistent_clock_exist flag
       rtc: Skip the suspend/resume handling if persistent clock exist
       timekeeping: Add CONFIG_HAS_PERSISTENT_CLOCK option

Jason Gunthorpe (1):
       NTP: Add a CONFIG_RTC_SYSTOHC configuration

John Stultz (2):
       MAINTAINERS: Update John Stultz's email
       x86: Select HAS_PERSISTENT_CLOCK on x86

Kees Cook (1):
       time: create __getnstimeofday for WARNless calls

Miroslav Lichvar (1):
       posix-timers: Fix clock_adjtime to always return timex data on 
success

  MAINTAINERS                |    2 +-
  arch/powerpc/kernel/time.c |    2 +-
  arch/x86/Kconfig           |    1 +
  arch/x86/kernel/tsc.c      |    3 ++-
  drivers/rtc/Kconfig        |   12 +++++++++++-
  drivers/rtc/Makefile       |    1 +
  drivers/rtc/class.c        |    7 +++++++
  drivers/rtc/systohc.c      |   44 
+++++++++++++++++++++++++++++++++++++++++++
  fs/pstore/ram.c            |   10 +++++++---
  include/linux/rtc.h        |    1 +
  include/linux/time.h       |   12 ++++++++++++
  kernel/posix-timers.c      |    2 +-
  kernel/time/Kconfig        |    5 +++++
  kernel/time/ntp.c          |   16 ++++++++++++----
  kernel/time/timekeeping.c  |   45 
++++++++++++++++++++++++++++++++++----------
  15 files changed, 141 insertions(+), 22 deletions(-)
  create mode 100644 drivers/rtc/systohc.c
