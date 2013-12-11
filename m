Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3LKTLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:11:45 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45055 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab3LKTLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:11:43 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [RFC][PATCH 0/5] Timekeeping fixes v2
Date: Wed, 11 Dec 2013 11:11:33 -0800
Message-Id: <1386789098-17391-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In looking into the lockdep splat reported by Sasha this week,
and came across a number of issues in the timekeeping code
(some related and some not).

Since I sent out v1, I came across another problem, as well as
a fix for the lockdep issue, so I wanted to resend the patches
for comment.

My current thought is that the first three patches are probably
urgent 3.13 items, where as the last two can probably be deferred
to 3.14.

The TAI timer delay thinko is particularly embarrassing, but sine
CLOCK_TAI was introduced in 3.10, its not exactly a regression, and
probably doesn't yet have any users outside of my tests.

Ingo/Thomas: Let me know if you agree with the first three patches
as urgent. I'd probably skip the second, but it provides the
infrastructure for the lockdep solution.

Sigh. Back-porting that lockdep fix to 3.10 will be a bit of a
pain, and I'll have to look to see if we need it even further back
or not.

thanks
-john

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>

John Stultz (5):
  timekeeping: Fix lost updates to tai adjustment
  timekeeping: Fix potential lost pv notification of time change
  timekeeping: Avoid possible deadlock from clock_was_set_delayed
  timekeeping: Fix CLOCK_TAI timer/nanosleep delays
  timekeeping: Fix missing timekeeping_update in suspend path

 kernel/time/timekeeping.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

-- 
1.8.3.2

