Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaHMRLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 13:11:23 -0400
Received: from mail-yk0-f179.google.com ([209.85.160.179]:43600 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaHMRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 13:11:22 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] jiffies_64: Use the same data section attribute
Date: Wed, 13 Aug 2014 13:11:41 -0400
Message-Id: <1407949903-32517-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jiffies_64 is defined with different section attribute. This commit changes the
extern definition to be the same as the actual definition.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/jiffies.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 1f44466..ec84da22 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -73,7 +73,7 @@ extern int register_refined_jiffies(long clock_tick_rate);
  * without sampling the sequence number in jiffies_lock.
  * get_jiffies_64() will do this for you as appropriate.
  */
-extern u64 __jiffy_data jiffies_64;
+extern u64 jiffies_64 __cacheline_aligned_in_smp;
 extern unsigned long volatile __jiffy_data jiffies;
 
 #if (BITS_PER_LONG < 64)
-- 
1.9.1

