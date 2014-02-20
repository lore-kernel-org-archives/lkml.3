Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbaBTQYg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:24:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27148 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbaBTQYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:24:35 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-60-53062c400439
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@enomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: [PATCH v4 1/6] Replace ternary operator to macro
Date: Thu, 20 Feb 2014 20:23:40 +0400
Message-id: <1392913425-29369-2-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t/xa7oOOmzBBjcWK1rMvXuexWLO+jVs
	Fge3alpc//Kc1eLMb12Ls01v2C0u75rDZrF501RmBw6PCf2fGD3uXNvD5vHu3Dl2jxMzfrN4
	9G1ZxejxeZNcAFsUl01Kak5mWWqRvl0CV0bfzz/sBZ+4Kpb+mcDawPiNo4uRk0NCwERi64FX
	7BC2mMSFe+vZuhi5OIQEljJKrPkwkQXC6WGSeLn+MGsXIwcHm4CBxL57tiANIgI+ErsmfmQC
	qWEW6GeUOPNmASNIQljAUmLBmaNMIDaLgKrExH2nWEBsXgF3iTe9m5lB5kgIKEjMmWQDYnIK
	eEh0rZMBqRACqjiy8BzbBEbeBYwMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFCQuzrDsal
	x6wOMQpwMCrx8J6UYgsWYk0sK67MPcQowcGsJMLrrgIU4k1JrKxKLcqPLyrNSS0+xMjEwSnV
	wHhN496H4JStMv2Zy3M2plZc2sb/PHh6yAuP7/8LhP8/rJksHnbdx2cyc6tjfPm92VuW+p4x
	d90TkHrPImzTttyTMZdcfIvvcR05o7fpqgrTw6VhXV1em8JMFxjcKXnRq+GckFj71Uqy9Wb1
	1viYBfsn/bGpnpbvtm6v/MSZ3LfmHrT+EiL5+r0SS3FGoqEWc1FxIgDw0+HHDwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For extensibility purpose it's better to have _switch_ type mechanism
for representing human readable CLOCKID* and HRMODE.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/trace/events/timer.h |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 68c2c20..185b2c6 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -8,6 +8,16 @@
 #include <linux/hrtimer.h>
 #include <linux/timer.h>
 
+#define clockid_to_string(clockid)						\
+	__print_symbolic(clockid,						\
+			 { CLOCK_MONOTONIC,		"CLOCK_MONOTONIC" },	\
+			 { CLOCK_REALTIME,		"CLOCK_REALTIME" })
+
+#define hrmode_to_string(hrmode)						\
+	__print_symbolic(hrmode,						\
+			 { HRTIMER_MODE_ABS,		"HRTIMER_MODE_ABS" },	\
+			 { HRTIMER_MODE_REL,		"HRTIMER_MODE_REL" })
+
 DECLARE_EVENT_CLASS(timer_class,
 
 	TP_PROTO(struct timer_list *timer),
@@ -147,10 +157,8 @@ TRACE_EVENT(hrtimer_init,
 	),
 
 	TP_printk("hrtimer=%p clockid=%s mode=%s", __entry->hrtimer,
-		  __entry->clockid == CLOCK_REALTIME ?
-			"CLOCK_REALTIME" : "CLOCK_MONOTONIC",
-		  __entry->mode == HRTIMER_MODE_ABS ?
-			"HRTIMER_MODE_ABS" : "HRTIMER_MODE_REL")
+		  clockid_to_string(__entry->clockid),
+		  hrmode_to_string(__entry->mode))
 );
 
 /**
-- 
1.7.9.5

