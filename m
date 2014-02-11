Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbaBKTGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:06:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39815 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbaBKTGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sasha.levin@oracle.com>,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 3.13 115/120] 3.13.y: timekeeping: Fix clock_set/clock_was_set think-o
Date: Tue, 11 Feb 2014 11:05:56 -0800
Message-Id: <20140211184826.925176633@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timekeeping.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


