Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbaHQKsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 06:48:18 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48478 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaHQKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 06:48:16 -0400
Date: Sun, 17 Aug 2014 13:48:07 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: chunkeey@googlemail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH] carl9170: Replace rcu_dereference() with rcu_access_pointer()
Message-ID: <20140817104806.GA14533@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rcu_dereference() call is used directly in a condition.
Since its return value is never dereferenced it is recommended to use
"rcu_access_pointer()" instead of "rcu_dereference()".
Therefore, this patch makes the replacement.

The following Coccinelle semantic patch was used:
@@
@@

(
 if(
 (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
|
  while(
  (<+...
- rcu_dereference
+ rcu_access_pointer
  (...)
  ...+>)) {...}
)

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
 drivers/net/wireless/ath/carl9170/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index f8ded84..12018ff 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1431,7 +1431,7 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 			return -EOPNOTSUPP;
 
 		rcu_read_lock();
-		if (rcu_dereference(sta_info->agg[tid])) {
+		if (rcu_access_pointer(sta_info->agg[tid])) {
 			rcu_read_unlock();
 			return -EBUSY;
 		}
-- 
1.9.1

