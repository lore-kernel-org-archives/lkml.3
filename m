Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbbAVHiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:38:54 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:44823 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbbAVHis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:38:48 -0500
From: Olliver Schinagl <o.schinagl@ultimaker.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Olliver Schinagl <oliver@schinagl.nl>
Subject: [PATCH] hrtimer: add hrtimer_start_now()
Date: Thu, 22 Jan 2015 07:12:41 +0100
Message-Id: <1421907161-5744-1-git-send-email-o.schinagl@ultimaker.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

When using a hrtimer for repeating periodic ticks, hrtimer_forward_now()
is often used. Quite possibly the timer loop is thus probably fully
controlled by hrtimer_forward_now() and we don't really care when the
timer is started. With hrtimer_start() we need to define exactly when a
event has to start. By introducing hrtimer_start_now() we do the same as
what hrtimer_forward_now() does, start as soon as possible and get into
the timer loop.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 include/linux/hrtimer.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index a036d05..080a5f5 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -353,6 +353,12 @@ static inline void destroy_hrtimer_on_stack(struct hrtimer *timer) { }
 /* Basic timer operations: */
 extern int hrtimer_start(struct hrtimer *timer, ktime_t tim,
 			 const enum hrtimer_mode mode);
+
+static inline int hrtimer_start_now(struct hrtimer *timer,
+				    const enum hrtimer_mode mode)
+{
+	return hrtimer_start(timer, timer->base->get_time(), mode);
+}
 extern int hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 			unsigned long range_ns, const enum hrtimer_mode mode);
 extern int
-- 
2.1.4

