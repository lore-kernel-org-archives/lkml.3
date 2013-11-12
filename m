Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab3KLN5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 08:57:53 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:51673 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3KLNyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 08:54:09 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ipvs: Remove unused variable ret from sync_thread_master()
Date: Tue, 12 Nov 2013 14:53:16 +0100
Message-Id: <1384264396-14550-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

net/netfilter/ipvs/ip_vs_sync.c: In function 'sync_thread_master':
net/netfilter/ipvs/ip_vs_sync.c:1640:8: warning: unused variable 'ret' [-Wunused-variable]

Introduced by commit 35a2af94c7ce7130ca292c68b1d27fcfdb648f6b ("sched/wait:
Make the __wait_event*() interface more friendly")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/netfilter/ipvs/ip_vs_sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index f63c2388f38d..d258125c4202 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1637,7 +1637,7 @@ static int sync_thread_master(void *data)
 			continue;
 		}
 		while (ip_vs_send_sync_msg(tinfo->sock, sb->mesg) < 0) {
-			int ret = __wait_event_interruptible(*sk_sleep(sk),
+			__wait_event_interruptible(*sk_sleep(sk),
 						   sock_writeable(sk) ||
 						   kthread_should_stop());
 			if (unlikely(kthread_should_stop()))
-- 
1.7.9.5

