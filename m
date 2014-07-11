Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbaGKNpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:45:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:56237 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaGKNpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:45:01 -0400
Message-Id: <20140711133708.668617691@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 11 Jul 2014 13:44:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [patch 40/55] iio: Use ktime_get_real_ns()
References: <20140711133623.530368377@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=iio-use-ktime-get-ns.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No idea why iio needs wall clock based time stamps, but we can avoid
the timespec conversion dance by using the new interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jonathan Cameron <jic23@kernel.org>
---
 include/linux/iio/iio.h |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

Index: tip/include/linux/iio/iio.h
===================================================================
--- tip.orig/include/linux/iio/iio.h
+++ tip/include/linux/iio/iio.h
@@ -277,14 +277,7 @@ static inline bool iio_channel_has_info(
  **/
 static inline s64 iio_get_time_ns(void)
 {
-	struct timespec ts;
-	/*
-	 * calls getnstimeofday.
-	 * If hrtimers then up to ns accurate, if not microsecond.
-	 */
-	ktime_get_real_ts(&ts);
-
-	return timespec_to_ns(&ts);
+	return ktime_get_real_ns();
 }
 
 /* Device operating modes */


