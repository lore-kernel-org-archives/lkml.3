Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaACDLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:11:52 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:52715 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaACDLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:11:45 -0500
Message-ID: <52C62A48.1050604@huawei.com>
Date: Fri, 3 Jan 2014 11:11:04 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <edumazet@google.com>, <jasowang@redhat.com>, <horms@verge.net.au>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, <netdev@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <kaber@trash.net>, <xemul@openvz.org>, <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, <jhs@mojatatu.com>,
        Li Zefan <lizefan@huawei.com>
Subject: [RFC PATCH net-next 1/4] net: introduce backup_classid to struct
 skbuff
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


introduce backup_classid to struct skbuff,
we can use it to backup sk_classid when net_ns switch.

Signed-off-by: Libo Chen <clbchenlibo.chen@huawei.com>
---
 include/linux/skbuff.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index c5cd016..b76e871 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -492,6 +492,9 @@ struct sk_buff {
 #ifdef CONFIG_NET_CLS_ACT
 	__u16			tc_verd;	/* traffic control verdict */
 #endif
+#ifdef CONFIG_NET_CLS_CGROUP
+	__u32			backup_classid;
+#endif
 #endif

 	__u16			queue_mapping;
-- 
1.8.2.2


