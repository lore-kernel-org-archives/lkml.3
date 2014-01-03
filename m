Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaACDNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:13:31 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:53971 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbaACDN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:13:29 -0500
Message-ID: <52C62A44.4070304@huawei.com>
Date: Fri, 3 Jan 2014 11:11:00 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <jhs@mojatatu.com>,
        Li Zefan <lizefan@huawei.com>
CC: <edumazet@google.com>, <pshelar@nicira.com>, <jasowang@redhat.com>,
        <horms@verge.net.au>, Serge Hallyn <serge.hallyn@ubuntu.com>,
        <netdev@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <containers@lists.linux-foundation.org>, <kaber@trash.net>,
        <xemul@openvz.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH net-next 0/4] net_cls for sys container
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

Now, lxc created with veth can not be under control by
cls_cgroup.

the former discussion:
http://lkml.indiana.edu/hypermail/linux/kernel/1312.1/00214.html

In short, because cls_cgroup relys classid attached to sock
filter skb, but sock will be cleared inside dev_forward_skb()
in veth_xmit().

so I add backup_classid in struct sk_buffer to save classid
before dev_forward_skb(). In cls_cgroup_classify(), if skb->sk
is NULL, we can try to restore classid form skb->bk_classid.


Libo Chen (4):
  net: introduce bk_classid to struct sk_buff
  cls_cgroup: introduce a helper: bk_cls_classid()
  veth: backup classid befor switch net_ns
  cls_cgroup: restore classid from skb->sk_classid

 drivers/net/veth.c       |  5 +++++
 include/linux/skbuff.h   |  3 +++
 include/net/cls_cgroup.h | 11 +++++++++++
 net/sched/cls_cgroup.c   |  8 ++++----
 4 files changed, 23 insertions(+), 4 deletions(-)

