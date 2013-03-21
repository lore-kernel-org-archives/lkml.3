Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3CUC5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 22:57:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:57253 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab3CUC5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 22:57:18 -0400
Message-ID: <514A767B.7000307@huawei.com>
Date: Thu, 21 Mar 2013 10:54:51 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Neil Horman <nhorman@tuxdriver.com>, LKML <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH] net: remove redundant ifdef CONFIG_CGROUPS
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cgroup code has been surrounded by ifdef CONFIG_NET_CLS_CGROUP
and CONFIG_NETPRIO_CGROUP.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 net/core/sock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index b261a79..a19e728 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1298,7 +1298,6 @@ static void sk_prot_free(struct proto *prot, struct sock *sk)
 	module_put(owner);
 }
 
-#ifdef CONFIG_CGROUPS
 #if IS_ENABLED(CONFIG_NET_CLS_CGROUP)
 void sock_update_classid(struct sock *sk, struct task_struct *task)
 {
@@ -1321,7 +1320,6 @@ void sock_update_netprioidx(struct sock *sk, struct task_struct *task)
 }
 EXPORT_SYMBOL_GPL(sock_update_netprioidx);
 #endif
-#endif
 
 /**
  *	sk_alloc - All socket objects are allocated here
-- 
1.8.0.2

