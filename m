Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab3CDM7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 07:59:55 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34313 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486Ab3CDM7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 07:59:51 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        netem@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH -v3 18/23] net/sched: rename random32() to prandom_u32()
Date: Mon,  4 Mar 2013 21:58:26 +0900
Message-Id: <1362401911-14074-19-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
References: <1362401911-14074-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netem@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: netdev@vger.kernel.org
---

No change from v2

 net/sched/sch_choke.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index cc37dd5..ef53ab8 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -80,7 +80,7 @@ struct choke_sched_data {
 /* deliver a random number between 0 and N - 1 */
 static u32 random_N(unsigned int N)
 {
-	return reciprocal_divide(random32(), N);
+	return reciprocal_divide(prandom_u32(), N);
 }
 
 /* number of elements in queue including holes */
-- 
1.8.1.2

