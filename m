Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab3JWMtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:49:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58624 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab3JWMtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:49:13 -0400
Date: Wed, 23 Oct 2013 05:48:31 -0700
From: tip-bot for Thierry Reding <tipbot@zytor.com>
Message-ID: <tip-92ec11809565cf6429c75204e99e0f583b5c9d7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, treding@nvidia.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, thierry.reding@gmail.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, treding@nvidia.com,
        tglx@linutronix.de
In-Reply-To: <1382528455-29911-1-git-send-email-treding@nvidia.com>
References: <1382528455-29911-1-git-send-email-treding@nvidia.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Fix build breakage
Git-Commit-ID: 92ec11809565cf6429c75204e99e0f583b5c9d7c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 05:48:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92ec11809565cf6429c75204e99e0f583b5c9d7c
Gitweb:     http://git.kernel.org/tip/92ec11809565cf6429c75204e99e0f583b5c9d7c
Author:     Thierry Reding <thierry.reding@gmail.com>
AuthorDate: Wed, 23 Oct 2013 13:40:55 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 23 Oct 2013 14:44:10 +0200

sched/wait: Fix build breakage

The wait_event_interruptible_lock_irq() macro is missing a
semi-colon which causes a build failure in the i915 DRM driver.

Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1382528455-29911-1-git-send-email-treding@nvidia.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index ec099b0..3b23afa 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -732,7 +732,7 @@ do {									\
 	int __ret = 0;							\
 	if (!(condition))						\
 		__ret = __wait_event_interruptible_lock_irq(wq,		\
-						condition, lock,)	\
+						condition, lock,);	\
 	__ret;								\
 })
 
