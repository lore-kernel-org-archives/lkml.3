Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaEFRVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:21:22 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:15212 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052AbaEFRVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:21:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al4UAN0YaVNbtAAq/2dsb2JhbABZgwarbQQBAQEBAQEFAZoHAgKBHxd0gmYcIxiBAiQTiEUBzjeFVoh8hEYBA48bihsBknuDNjs
Date: Tue, 6 May 2014 19:21:14 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/rcu/tree.c: make rcu node arrays static const
 char * const
Message-Id: <20140506192114.60ed15ab76cba9fc10a6e7f3@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those 2 arrays are being passed to lockdep_init_map with const char *
and stored in lockdep_map the same way

Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/rcu/tree.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 0c47e30..90ebc83 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3357,14 +3357,16 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
 static void __init rcu_init_one(struct rcu_state *rsp,
 		struct rcu_data __percpu *rda)
 {
-	static char *buf[] = { "rcu_node_0",
-			       "rcu_node_1",
-			       "rcu_node_2",
-			       "rcu_node_3" };  /* Match MAX_RCU_LVLS */
-	static char *fqs[] = { "rcu_node_fqs_0",
-			       "rcu_node_fqs_1",
-			       "rcu_node_fqs_2",
-			       "rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const buf[] = {
+		"rcu_node_0",
+		"rcu_node_1",
+		"rcu_node_2",
+		"rcu_node_3" };  /* Match MAX_RCU_LVLS */
+	static const char * const fqs[] = {
+		"rcu_node_fqs_0",
+		"rcu_node_fqs_1",
+		"rcu_node_fqs_2",
+		"rcu_node_fqs_3" };  /* Match MAX_RCU_LVLS */
 	int cpustride = 1;
 	int i;
 	int j;
-- 
1.8.4.5

