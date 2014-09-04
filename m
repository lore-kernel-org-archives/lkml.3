Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaIDQkg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:40:36 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52361 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754394AbaIDQke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:40:34 -0400
X-Yandex-Uniq: 02745975-e525-44dc-8a65-9734300d787c
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 16/19] smart: change default RR timeslice to 5ms
Date: Thu,  4 Sep 2014 20:31:02 +0400
Message-Id: <1409848265-17150-16-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

By default, SCHED_RR timeslice is 100ms. Change it to 5ms to achieve
better responsibility.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 include/linux/sched/rt.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/sched/rt.h b/include/linux/sched/rt.h
index 440434d..988eae8 100644
--- a/include/linux/sched/rt.h
+++ b/include/linux/sched/rt.h
@@ -59,6 +59,10 @@ extern void normalize_rt_tasks(void);
  * default timeslice is 100 msecs (used only for SCHED_RR tasks).
  * Timeslices get refilled after they expire.
  */
+#ifdef CONFIG_SMART
+#define RR_TIMESLICE		(5 * HZ / 1000)
+#else
 #define RR_TIMESLICE		(100 * HZ / 1000)
+#endif
 
 #endif /* _SCHED_RT_H */
-- 
1.9.3

