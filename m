Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaDDGk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:40:57 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63973 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbaDDGkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:40:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: tglx@linutronix.de
Cc: linaro-kernel@lists.linaro.org, fweisbec@gmail.com,
        linaro-networking@linaro.org, Arvind.Chauhan@arm.com,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 04/36] hrtimer: remove {} around a single liner 'for' loop in migrate_hrtimers()
Date: Fri,  4 Apr 2014 12:05:47 +0530
Message-Id: <b71eb9fcda02eb4355687fb307ab2e70f7f61e07.1396592516.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396592516.git.viresh.kumar@linaro.org>
References: <cover.1396592516.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'for' loop in migrate_hrtimers() has only one line in its body and so doesn't
require {} as per coding guidelines. Remove it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index c87e896..514b53a 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1712,10 +1712,9 @@ static void migrate_hrtimers(int scpu)
 	raw_spin_lock(&new_base->lock);
 	raw_spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);
 
-	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++) {
+	for (i = 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		migrate_hrtimer_list(&old_base->clock_base[i],
 				     &new_base->clock_base[i]);
-	}
 
 	raw_spin_unlock(&old_base->lock);
 	raw_spin_unlock(&new_base->lock);
-- 
1.7.12.rc2.18.g61b472e

