Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780Ab3ECV1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:27:11 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:42411 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763616Ab3ECV1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:27:09 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ntp: Remove unused variable flags in __hardpps
Date: Fri,  3 May 2013 23:27:07 +0200
Message-Id: <1367616427-4223-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/time/ntp.c: In function ‘__hardpps’:
kernel/time/ntp.c:877: warning: unused variable ‘flags’

commit a076b2146fabb0894cae5e0189a8ba3f1502d737 ("ntp: Remove ntp_lock,
using the timekeeping locks to protect ntp state") removed its users,
but not the actual variable.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/time/ntp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 12ff13a..8f5b3b9 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -874,7 +874,6 @@ static void hardpps_update_phase(long error)
 void __hardpps(const struct timespec *phase_ts, const struct timespec *raw_ts)
 {
 	struct pps_normtime pts_norm, freq_norm;
-	unsigned long flags;
 
 	pts_norm = pps_normalize_ts(*phase_ts);
 
-- 
1.7.0.4

