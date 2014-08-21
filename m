Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaHUCcO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:32:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50831 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaHUCcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:32:13 -0400
From: Zhu Yanjun <zyjzyj2000@gmail.com>
X-Google-Original-From: Zhu Yanjun <Yanjun.Zhu@windriver.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, zyjzyj2000@gmail.com,
        Yue.Tao@windriver.com, alexandre.dietsch@windriver.com,
        davem@davemloft.net, honkiko@gmail.com, cwang@twopensource.com
Cc: Zhu Yanjun <Yanjun.Zhu@windriver.com>
Subject: [PATCH V2 0/1] ipv4: net namespace does not inherit network configurations
Date: Thu, 21 Aug 2014 10:32:00 +0800
Message-Id: <1408588321-13537-1-git-send-email-Yanjun.Zhu@windriver.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

V2: Following the advice from Cong Wang, I submit a patch as normal.

Hi,all

I did a test on kernel3.16 rc6:

root@qemu1:~# echo 1 > /proc/sys/net/ipv6/conf/all/forwarding
root@qemu1:~# echo 1 > /proc/sys/net/ipv4/conf/all/forwarding
root@qemu1:~# ip netns list
root@qemu1:~# ip netns add fib1
root@qemu1:~# ip netns exec fib1 bash
root@qemu1:~# cat /proc/sys/net/ipv6/conf/all/forwarding
0
root@qemu1:~# cat /proc/sys/net/ipv4/conf/all/forwarding
1

The behavior of ipv4 and ipv6 is very inconsistent. I checked
the kernel source code. I found that from this patch
[ipv6: fix bad free of addrconf_init_net], the above difference
appeared.

Since a net namespace is independent to another. That is, there
is no any relationship between the net namespaces. So the behavior
of ipv4 is not correct.

Based on this patch [ipv6: fix bad free of addrconf_init_net], I made
a new patch to fix this problem on ipv4.

Any reply is appreciated. 

Zhu Yanjun (1):
  ipv4: net namespace does not inherit network configurations

 net/ipv4/devinet.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

-- 
1.9.1

