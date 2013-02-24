Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab3BXREx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:04:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759154Ab3BXREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:04:52 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Subject: Re: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG compile
Date: Sun, 24 Feb 2013 12:04:40 -0500
Message-Id: <1361725480-22270-1-git-send-email-prarit@redhat.com>
In-Reply-To: <alpine.LFD.2.02.1302222111400.22263@ionos>
References: <alpine.LFD.2.02.1302222111400.22263@ionos>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 03:14 PM, Thomas Gleixner wrote:
>> +void clocksource_mark_unstable(struct clocksource *cs) { }
> 
> Unless this is defined as
> 
>> +static inline void clocksource_mark_unstable(struct clocksource *cs) { }
> 
> Right?

Whups.  Of course ... new patch ...

-----8<----

If I explicitly disable the clocksource watchdog in the x86 Kconfig,
the x86 kernel will not compile unless this is properly defined.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
---
 kernel/time/clocksource.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index c958338..3d81a76 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -450,6 +450,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
 static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
 static inline void clocksource_resume_watchdog(void) { }
 static inline int clocksource_watchdog_kthread(void *data) { return 0; }
+static inline void clocksource_mark_unstable(struct clocksource *cs) { }
 
 #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
 
-- 
1.7.9.3

