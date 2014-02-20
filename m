Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbaBTQYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:24:42 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27638 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbaBTQYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:24:39 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-6f-53062c46e501
From: Alexey Perevalov <a.perevalov@samsung.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, john.stultz@linaro.org
Cc: Alexey Perevalov <a.perevalov@samsung.com>, anton@enomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: [PATCH v4 2/6] tracing/trivial: Add CLOCK_BOOTIME and CLOCK_TAI for
 human readable clockid trace
Date: Thu, 20 Feb 2014 20:23:41 +0400
Message-id: <1392913425-29369-3-git-send-email-a.perevalov@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
References: <1392913425-29369-1-git-send-email-a.perevalov@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDJMWRmVeSWpSXmKPExsVy+t/xa7puOmzBBre6uCzm3j3PYjFn/Ro2
	i4NbNS2uf3nOanHmt67F2aY37BaXd81hs9i8aSqzA4fHhP5PjB53ru1h83h37hy7x4kZv1k8
	+rasYvT4vEkugC2KyyYlNSezLLVI3y6BK+PMwknsBXvZKvZffMLWwDiFtYuRk0NCwETie9tx
	KFtM4sK99WxdjFwcQgJLGSWWLFsL5fQwSVzZtBLI4eBgEzCQ2HfPFqRBRMBHYtfEj0wgNcwC
	/YwSZ94sYARJCAtkS1yYvA/MZhFQlXgw5zcbiM0r4C4xo/UX2BwJAQWJOZNsQExOAQ+JrnUy
	IBVCQBVHFp5jm8DIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSIh92cG4+JjVIUYB
	DkYlHt4CCbZgIdbEsuLK3EOMEhzMSiK87ipAId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyS3ytL
	Cz04Wj/b7ZI0v7ehZWLqg2PHmC9yXmWzLqtiso/KrZ/ncbi32T3+9n1fPYE/s5q9iryXPA2K
	87HNfnF3y98P+29u8dNMzp+6RaR2rtDH+ywf153jfd795C5vX9ypqXM116VvurunhKmRvZ6j
	9LVTpLTuiikFK/aq25x/4dF+r2vXxDQlluKMREMt5qLiRAA00uz3DwIAAA==
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

