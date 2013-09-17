Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3IQSNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:13:52 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50574 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab3IQSNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:13:51 -0400
Message-ID: <52389BDD.8070801@linaro.org>
Date: Tue, 17 Sep 2013 11:13:49 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] First set of timekeeping changes for 3.13
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,
    So these were items I had hoped to get merged in 3.12, but I'm
guessing got buried in Thomas inbox while he was traveling/busy (and its
my fault for not cc'ing Ingo). So now 3.12-rc1 is out, I wanted to send
this in for tip/timers/core right away so these don't get missed in this
next cycle.

Please let me know if there are any objections or issues with these changes.

thanks
-john


The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://git.linaro.org/people/jstultz/linux.git fortglx/3.13/time

for you to fetch changes up to 389e067032fbb96e439abafae848dd447e4cafb4:

  Merge branch 'fortglx/3.12/time' into fortglx/3.13/time (2013-09-16
18:54:07 -0700)

----------------------------------------------------------------

John Stultz (2):
      Merge branch 'fortglx/3.12/sched-clock64-base' into fortglx/3.13/time
      Merge branch 'fortglx/3.12/time' into fortglx/3.13/time

Miroslav Lichvar (1):
      ntp: Make periodic RTC update more reliable

Prarit Bhargava (1):
      clocksource: Fix !CONFIG_CLOCKSOURCE_WATCHDOG compile

Stephen Boyd (4):
      clocksource: Extract max nsec calculation into separate function
      sched_clock: Use seqcount instead of rolling our own
      sched_clock: Use an hrtimer instead of timer
      sched_clock: Add support for >32 bit sched_clock

Zoran Markovic (1):
      rtc: Keep system awake until all expired RTC timers are handled

 drivers/rtc/interface.c     |  13 ++++--
 include/linux/clocksource.h |   2 +
 include/linux/sched_clock.h |   2 +
 kernel/time/clocksource.c   |  46 ++++++++++++------
 kernel/time/ntp.c           |   3 +-
 kernel/time/sched_clock.c   | 111
++++++++++++++++++++++++--------------------
 6 files changed, 107 insertions(+), 70 deletions(-)
