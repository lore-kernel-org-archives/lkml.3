Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaFUUiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 16:38:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35091 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301AbaFUUiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 16:38:07 -0400
Date: Sat, 21 Jun 2014 13:37:25 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-889235ce2b26cdd231c7a1d6005928ec42f11637@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, stefanr@s5r6.in-berlin.de, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, stefanr@s5r6.in-berlin.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20140611234607.351283464@linutronix.de>
References: <20140611234607.351283464@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] firewire: Use ktime_get_ts()
Git-Commit-ID: 889235ce2b26cdd231c7a1d6005928ec42f11637
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  889235ce2b26cdd231c7a1d6005928ec42f11637
Gitweb:     http://git.kernel.org/tip/889235ce2b26cdd231c7a1d6005928ec42f11637
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 11 Jun 2014 23:59:16 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 12 Jun 2014 16:18:45 +0200

firewire: Use ktime_get_ts()

do_posix_clock_monotonic_gettime() is a leftover from the initial
posix timer implementation which maps to ktime_get_ts()

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Link: http://lkml.kernel.org/r/20140611234607.351283464@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/firewire/core-cdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index d7d5c8a..5d997a3 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1214,9 +1214,9 @@ static int ioctl_get_cycle_timer2(struct client *client, union ioctl_arg *arg)
 	cycle_time = card->driver->read_csr(card, CSR_CYCLE_TIME);
 
 	switch (a->clk_id) {
-	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
-	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
-	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
+	case CLOCK_REALTIME:      getnstimeofday(&ts);	break;
+	case CLOCK_MONOTONIC:     ktime_get_ts(&ts);	break;
+	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);	break;
 	default:
 		ret = -EINVAL;
 	}
