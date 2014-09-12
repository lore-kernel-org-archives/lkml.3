Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaILVWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:22:38 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50335 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbaILVWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:22:36 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Sharvil Nanavati <sharvil@google.com>, Paul Turner <pjt@google.com>,
        Andrew Hunter <ahh@google.com>, Aaron Jacobs <jacobsa@google.com>,
        Richard Larocque <rlarocque@google.com>
Subject: [PATCH 0/4] Time related fixes for 3.17/stable
Date: Fri, 12 Sep 2014 14:22:20 -0700
Message-Id: <1410556944-14944-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas, Ingo,

  Here are a few fixes for 3.17/stable that came in over the last week or so.

The first is a fix to the timeval to jiffies conversion that was incorrectly
rounding up by one even when the value divided precisely. This issue is
apparently quite long standing, but shows up as in increasing timeout when
folks re-use the returned old_value from setitimer.

The second group are yet further fixes to the alarmtimer code. This time
catching incorrect timer_gettime semantics as well as fixes for improper
signaling and locking. These all go back to 3.0, and the timer_gettime
change could cause problems with existing apps, but I suspect that aspect
of the interface hasn't been used much until recently.

These are against tip/timers/urgent, and have run successfully through
my timekeeping tests for x86_64, i386 and arm.

Let me know if you have any comments or objections.

thanks
-john

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Sharvil Nanavati <sharvil@google.com>
Cc: Paul Turner <pjt@google.com>
Cc: Andrew Hunter <ahh@google.com>
Cc: Aaron Jacobs <jacobsa@google.com>
Cc: Richard Larocque <rlarocque@google.com>

Pull request below if you'd prefer to take it that way:


The following changes since commit 9bf2419fa7bffa16ce58a4d5c20399eff8c970c9:
  timekeeping: Update timekeeper before updating vsyscall and pvclock (2014-09-06 12:58:18 +0200)

are available in the git repository at:

  https://git.linaro.org/people/john.stultz/linux.git fortglx/3.17/time

for you to fetch changes up to 474e941bed9262f5fa2394f9a4a67e24499e5926:

  alarmtimer: Lock k_itimer during timer callback (2014-09-12 13:59:12 -0700)

----------------------------------------------------------------
Andrew Hunter (1):
      jiffies: Fix timeval conversion to jiffies

Richard Larocque (3):
      alarmtimer: Return relative times in timer_gettime
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback

 include/linux/jiffies.h  | 12 ------------
 kernel/time/alarmtimer.c | 34 +++++++++++++++++++++++-----------
 kernel/time/time.c       | 56 +++++++++++++++++++++++++++++++-------------------------
 3 files changed, 54 insertions(+), 48 deletions(-)

Andrew Hunter (1):
  jiffies: Fix timeval conversion to jiffies

Richard Larocque (3):
  alarmtimer: Return relative times in timer_gettime
  alarmtimer: Do not signal SIGEV_NONE timers
  alarmtimer: Lock k_itimer during timer callback

 include/linux/jiffies.h  | 12 -----------
 kernel/time/alarmtimer.c | 34 +++++++++++++++++++----------
 kernel/time/time.c       | 56 +++++++++++++++++++++++++++---------------------
 3 files changed, 54 insertions(+), 48 deletions(-)

-- 
1.9.1

