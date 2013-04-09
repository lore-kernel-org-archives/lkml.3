Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935126Ab3DIF7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 01:59:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47436 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3DIF7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 01:59:41 -0400
Message-ID: <5163AE40.40304@huawei.com>
Date: Tue, 9 Apr 2013 13:59:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Glauber Costa <glommer@parallels.com>, LKML <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH] tcp_memcontrol: remove a redundant statement in tcp_destroy_cgroup()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We read the value but make no use of it.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 net/ipv4/tcp_memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/tcp_memcontrol.c b/net/ipv4/tcp_memcontrol.c
index b6f3583..d52196f 100644
--- a/net/ipv4/tcp_memcontrol.c
+++ b/net/ipv4/tcp_memcontrol.c
@@ -72,8 +72,6 @@ void tcp_destroy_cgroup(struct mem_cgroup *memcg)
 
 	tcp = tcp_from_cgproto(cg_proto);
 	percpu_counter_destroy(&tcp->tcp_sockets_allocated);
-
-	val = res_counter_read_u64(&tcp->tcp_memory_allocated, RES_LIMIT);
 }
 EXPORT_SYMBOL(tcp_destroy_cgroup);
 
-- 
1.8.0.2
