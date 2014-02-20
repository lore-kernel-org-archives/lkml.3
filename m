Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbaBTImb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 03:42:31 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58780 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaBTIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 03:42:29 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-ad-5305bff3cdec
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: [PATCH v3 1/6] tracing/trivial: Add CLOCK_BOOTIME and CLOCK_TAI for
 human readable clockid trace
Date: Thu, 20 Feb 2014 12:40:28 +0400
Message-id: <1392885633-7787-2-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xa7qf97MGGxzfJGAx9+55Fos569ew
	WfT/6mS1uP7lOavFmd+6Fmeb3rBbXN41h81i86apzA4cHneu7WHzeHfuHLvHiRm/WTy+7NnL
	7NG3ZRWjx+dNcgFsUVw2Kak5mWWpRfp2CVwZZxZOYi/Yy1ax/+ITtgbGKaxdjJwcEgImEpu+
	PWCGsMUkLtxbz9bFyMUhJLCUUWLC9jvMEE4Pk8SlxWcYuxg5ONgEDCT23bMFaRAR8JHYNfEj
	E0gNs0Afo0Rf+yuwScIC2RKfZm8Fs1kEVCX+NHSD2bwCbhITLyxhA5kjIaAgMWeSDYjJKeAu
	0fDEBqRCCKjiwZY/LBMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAmyLzsYFx+z
	OsQowMGoxMMbcZ0lWIg1say4MvcQowQHs5IIL08ma7AQb0piZVVqUX58UWlOavEhRiYOTqkG
	RmfVx5I3xdTrzdc9Oy4TMz3oem2t0ruOL0U1BT01n2q4VwVYiS/01mfJ13OvOXygqmt5Cpe2
	sO+5pYu1pCN1t72dvPPKl19pjHGT/ZZVblB5cHFl8syWzSmGhnVbuldFrTU2U0sQUvXb8rTR
	qZMvcNGqDdZJzXlPmRTlrldOXZ2om7VYOIFNiaU4I9FQi7moOBEAJ3Cs1RACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These clockids is also used in current hrtimer implementation.

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 include/trace/events/timer.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 185b2c6..547b79f 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -11,7 +11,10 @@
 #define clockid_to_string(clockid)						\
 	__print_symbolic(clockid,						\
 			 { CLOCK_MONOTONIC,		"CLOCK_MONOTONIC" },	\
-			 { CLOCK_REALTIME,		"CLOCK_REALTIME" })
+			 { CLOCK_REALTIME,		"CLOCK_REALTIME" },	\
+			 { CLOCK_BOOTTIME,		"CLOCK_BOOTTIME" },	\
+			 { CLOCK_TAI,			"CLOCK_TAI" }		\
+	)
 
 #define hrmode_to_string(hrmode)						\
 	__print_symbolic(hrmode,						\
-- 
1.7.9.5

