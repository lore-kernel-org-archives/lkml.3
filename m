Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaIDQgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:36:35 -0400
Received: from forward-corp1f.mail.yandex.net ([95.108.130.40]:52243 "EHLO
	forward-corp1f.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbaIDQge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:36:34 -0400
X-Greylist: delayed 314 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 12:36:33 EDT
X-Yandex-Uniq: 438c0a1c-7670-4a15-99a7-8ef095fee979
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: klamm@yandex-team.ru
To: peterz@infradead.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Cc: stfomichev@yandex-team.ru, Roman Gushchin <klamm@yandex-team.ru>
Subject: [PATCH 17/19] smart: disable RT runtime sharing
Date: Thu,  4 Sep 2014 20:31:03 +0400
Message-Id: <1409848265-17150-17-git-send-email-klamm@yandex-team.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
References: <77161409833206@webcorp01h.yandex-team.ru>
 <1409848265-17150-1-git-send-email-klamm@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roman Gushchin <klamm@yandex-team.ru>

This patch disables runtime sharing for rt tasks (RT_RUNTIME_SHARE).
It's necessary to guarantee that CFS tasks (including system threads
like rcu workers) will get time slice regularly on each cpu even when
system is heavily loaded with rt tasks.

Signed-off-by: Roman Gushchin <klamm@yandex-team.ru>
---
 kernel/sched/features.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..0945d38 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -57,7 +57,7 @@ SCHED_FEAT(NONTASK_POWER, true)
 SCHED_FEAT(TTWU_QUEUE, true)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
-SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(RT_RUNTIME_SHARE, false)
 SCHED_FEAT(LB_MIN, false)
 
 /*
-- 
1.9.3

