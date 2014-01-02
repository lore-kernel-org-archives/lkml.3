Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaABWW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:22:28 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52181 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbaABWW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:22:26 -0500
Message-ID: <52C5E6A0.7010507@linaro.org>
Date: Thu, 02 Jan 2014 14:22:24 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Timekeeping changes for 3.14
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,
  Hope you're having a good new years! Here's my current timekeeping
queue for 3.14.

This includes a number of changes I had earlier proposed for 3.13, but
decided to defer due to it being so late in the 3.13 cycle.

The only two items not previously posted are:
   tick/timekeeping: Call update_wall_time outside the jiffies lock
   timekeeping: Remove comment that's mostly out of date

I'll send the entire queue in reply to this mail.

Please take a look and let me know if you have any objections.

thanks
-john


The following changes since commit 0e6601eee039893a3f6420596ae4588d90d13cbe:

  Merge branch 'timers/posix-timers-for-tip-v2' of
git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks
into timers/core (2013-12-10 12:32:36 +0100)

are available in the git repository at:


  git://git.linaro.org/people/john.stultz/linux.git fortglx/3.14/time

for you to fetch changes up to 38aef31ce7773624c8f09ff58c4c27b3b955faaf:

  timekeeping: Remove comment that's mostly out of date (2013-12-23
12:53:22 -0800)

----------------------------------------------------------------
Borislav Petkov (1):
      rtc-cmos: Add an alarm disable quirk

John Stultz (7):
      timekeeping: Fix lost updates to tai adjustment
      timekeeping: Fix potential lost pv notification of time change
      timekeeping: Avoid possible deadlock from clock_was_set_delayed
      tick/timekeeping: Call update_wall_time outside the jiffies lock
      timekeeping: Fix CLOCK_TAI timer/nanosleep delays
      timekeeping: Fix missing timekeeping_update in suspend path
      timekeeping: Remove comment that's mostly out of date

Yijing Wang (1):
      timekeeper: fix comment typo for tk_setup_internals()

 drivers/rtc/rtc-cmos.c      | 52
+++++++++++++++++++++++++++++++++++++++++++-
 kernel/time/tick-common.c   |  1 +
 kernel/time/tick-internal.h |  1 +
 kernel/time/tick-sched.c    |  1 +
 kernel/time/timekeeping.c   | 53
++++++++++++++++++++++-----------------------
 5 files changed, 80 insertions(+), 28 deletions(-)
