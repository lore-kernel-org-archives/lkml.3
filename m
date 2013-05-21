Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab3EUSn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:43:56 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:59716 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3EUSnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:43:55 -0400
Message-ID: <519BC066.5080600@acm.org>
Date: Tue, 21 May 2013 20:43:50 +0200
From: Bart Van Assche <bart.vanassche@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Arjan van de Ven <arjan@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] timer: Fix jiffies wrap behavior of round_jiffies*()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that the round_jiffies*() functions return a time that is
in the future when the jiffies counter is about to wrap.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/timer.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 15ffdb3..aa8b964 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -149,9 +149,7 @@ static unsigned long round_jiffies_common(unsigned long j, int cpu,
 	/* now that we have rounded, subtract the extra skew again */
 	j -= cpu * 3;
-	if (j <= jiffies) /* rounding ate our timeout entirely; */
-		return original;
-	return j;
+	return time_is_after_jiffies(j) ? j : original;
 }
  /**
-- 
1.7.10.4

