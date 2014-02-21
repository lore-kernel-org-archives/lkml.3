Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbaBUNtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:49:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46921 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbaBUMuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        John Stultz <john.stultz@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 041/121] timekeeping: Fix clock_set/clock_was_set think-o
Date: Fri, 21 Feb 2014 12:47:45 +0000
Message-Id: <1392986945-9693-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <john.stultz@linaro.org>

In backporting 6fdda9a9c5db367130cf32df5d6618d08b89f46a
(timekeeping: Avoid possible deadlock from clock_was_set_delayed),
I ralized the patch had a think-o where instead of checking
clock_set I accidentally typed clock_was_set (which is a function
- so the conditional always is true).

Upstream this was resolved in the immediately following patch
47a1b796306356f358e515149d86baf0cc6bf007 (tick/timekeeping: Call
update_wall_time outside the jiffies lock). But since that patch
really isn't -stable material, so this patch only pulls
the name change.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/timekeeping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 111c47e..f223826 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1441,7 +1441,7 @@ static void update_wall_time(void)
 	write_seqcount_end(&timekeeper_seq);
 out:
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
-	if (clock_was_set) {
+	if (clock_set) {
 		/*
 		 * XXX -  I'd rather we just call clock_was_set(), but
 		 * since we're currently holding the jiffies lock, calling
-- 
1.9.0

