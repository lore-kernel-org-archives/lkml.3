Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3LQT1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 14:27:46 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65515 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3LQT1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 14:27:44 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Sasha Levin <sasha.levin@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/3] Timekeeping fixes for 3.13 via tip/timers/urgent
Date: Tue, 17 Dec 2013 11:27:34 -0800
Message-Id: <1387308457-25364-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo, Thomas,
	Here are the timekeeping fixes I'd like to submit for 3.13.

The first is a regression caused by the shadow time code that
causes the tai offset to be overwritten. This keeps ntpd from being
able to initialize the tai_offset.

The second fixes an issue where the action flag returned from
accumulate_nsecs_to_secs was not being passed all the way down
to where we update the pv notifiers. While not critical, this
change is a prerequisite for the following critical fix.

The last patch fixes the potential timekeeping/hrtimer
deadlock Sahsa found caused by clock_was_set_delayed() not actually
being safe to call while holding the timekeeping lock. This
leverages the previous patch to move the call outside the lock.

I have a number of other fixes queued, including the cleanup to the
tick code that will let us stop using clock_was_set_delayed all
together in the timekeeping code, but I'll save those for 3.14.

thanks
-john

Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>


John Stultz (3):
  timekeeping: Fix lost updates to tai adjustment
  timekeeping: Fix potential lost pv notification of time change
  timekeeping: Avoid possible deadlock from clock_was_set_delayed

 kernel/time/timekeeping.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

-- 
1.8.3.2

