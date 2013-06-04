Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759824Ab3FDHc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:32:27 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:54202 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab3FDHcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:32:24 -0400
Date: Tue, 4 Jun 2013 09:32:09 +0200
From: Marcus Gelderie <redmnic@gmail.com>
To: john.stultz@linaro.org
Cc: linux-kernel@vger.kernel.org, redmnic@gmail.com
Subject: Re: [PATCH 1/1] kernel:time Export symbols of functions declared in
 linux/alarmtimer.h
Message-ID: <20130604073140.GB4096@cantor.Speedport_W_503V_Typ_C>
References: <1370104746-20993-1-git-send-email-redmnic@gmail.com>
 <51ACECB2.40407@linaro.org>
 <20130604072455.GA4096@cantor.Speedport_W_503V_Typ_C>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130604072455.GA4096@cantor.Speedport_W_503V_Typ_C>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 12:21:22PM -0700, John Stultz wrote:
> These probably should be EXPORT_SYMBOL_GPL, no? Also there's a bunch of 
> new alarm functions that Todd Poynor that I have queued, which will 
> probably need similar.
> 
> thanks
> -john
Opps, yes they should, thanks. I've corrected that. 

Your new alarm functions are not in the tree yet, are they? At least I didn't
find them.

cheers
Marcus

New patch below
-----------------

Export symbols so they can be used by
drivers/staging/android/alarm-dev.c. So far this is built-in but LKM
support is planned (see drivers/staging/android/TODO).

Signed-off-by: Marcus Gelderie <redmnic@gmail.com>
---
 kernel/time/alarmtimer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index f11d83b..1e7d514 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -303,6 +303,7 @@ void alarm_init(struct alarm *alarm, enum alarmtimer_type type,
 	alarm->type = type;
 	alarm->state = ALARMTIMER_STATE_INACTIVE;
 }
+EXPORT_SYMBOL_GPL(alarm_init);
 
 /**
  * alarm_start - Sets an alarm to fire
@@ -323,6 +324,7 @@ int alarm_start(struct alarm *alarm, ktime_t start)
 	spin_unlock_irqrestore(&base->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(alarm_start);
 
 /**
  * alarm_try_to_cancel - Tries to cancel an alarm timer
@@ -344,6 +346,7 @@ int alarm_try_to_cancel(struct alarm *alarm)
 	spin_unlock_irqrestore(&base->lock, flags);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(alarm_try_to_cancel);
 
 
 /**
@@ -361,6 +364,7 @@ int alarm_cancel(struct alarm *alarm)
 		cpu_relax();
 	}
 }
+EXPORT_SYMBOL_GPL(alarm_cancel);
 
 
 u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
@@ -393,6 +397,7 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 	alarm->node.expires = ktime_add(alarm->node.expires, interval);
 	return overrun;
 }
+EXPORT_SYMBOL_GPL(alarm_forward);
 
 
 
-- 
1.8.1.5


