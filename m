Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab3LJFKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:10:16 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:42070 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab3LJFKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:10:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, David Vrabel <david.vrabel@citrix.com>
Subject: [RFC][PATCH 0/3] Couple of timekeeping fixes
Date: Mon,  9 Dec 2013 21:09:54 -0800
Message-Id: <1386652197-7035-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking into the lockdep splat reported by Sasha yesterday
and came across a few issues (unfortunately not related) in the
timekeeping code.

The first two are issues related to not updating the shadow
timekeeper after making changes to the timekeeper structure.
This  means those updates could be lost the next time we
do update_wall_time(), since update_wall_time assumes the
shadow_timekeeper is current as well.

The last change is an obvious issue that I should have
caught in review, but where we handle notifying the pvclock
code if time was set, there's one case in
logarithmic_accumulation where we just don't pass that flag
down.

Of the three patches, the first is really the most critical.
I'm thinking of pushing that one into 3.13, and immediately
back to 3.12-stable and 3.10-stable. Then leaving the last
two for 3.14, and pushing back to 3.13/10-stable once those
changes are merged.

I'm still running some tests on these, but I wanted to send
them out as RFCs to get some extra review and thoughts
before I send them out for real.

thanks
-john


Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: David Vrabel <david.vrabel@citrix.com>

John Stultz (3):
  timekeeping: Fix lost updates to tai adjustment
  timekeeping: Fix missing timekeeping_update in suspend path
  timekeeping: Fix potential lost pv notification of time change

 kernel/time/timekeeping.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

-- 
1.8.3.2

