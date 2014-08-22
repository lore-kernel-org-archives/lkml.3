Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaHVTOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:14:43 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:38399 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaHVTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:14:41 -0400
Date: Fri, 22 Aug 2014 22:14:31 +0300
From: Andreea-Cristina Bernat <bernat.ada@gmail.com>
To: chunkeey@googlemail.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH v2] carl9170: Remove redundant protection check
Message-ID: <20140822191431.GA5827@ada>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The carl9170_op_ampdu_action() function is used only by the mac80211
framework.
Since the mac80211 already takes care of checks and properly serializing
calls to the driver's function there is no need for the driver to do the same
thing.

Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
---
Changes in v2:
 - Change subject line from
   "carl9170: Replace rcu_dereference() with rcu_access_pointer()"
   to
   "carl9170: Remove redundant protection check"
 - Update the commit message according to the modifications
 - Delete the lines of interest at the suggestion and explanations of
   Christian Lamparter <chunkeey@googlemail.com>

 drivers/net/wireless/ath/carl9170/main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 12018ff..6758b9a 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1430,12 +1430,6 @@ static int carl9170_op_ampdu_action(struct ieee80211_hw *hw,
 		if (!sta_info->ht_sta)
 			return -EOPNOTSUPP;
 
-		rcu_read_lock();
-		if (rcu_access_pointer(sta_info->agg[tid])) {
-			rcu_read_unlock();
-			return -EBUSY;
-		}
-
 		tid_info = kzalloc(sizeof(struct carl9170_sta_tid),
 				   GFP_ATOMIC);
 		if (!tid_info) {
-- 
1.9.1

