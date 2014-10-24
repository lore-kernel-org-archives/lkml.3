Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaJXHma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 03:42:30 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:50338 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbaJXHm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 03:42:28 -0400
Message-ID: <544A029D.3080508@huawei.com>
Date: Fri, 24 Oct 2014 15:41:17 +0800
From: "Zhangjie (HZ)" <zhangjie14@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <kvm@vger.kernel.org>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <liuyongan@huawei.com>,
        <qinchuanyu@huawei.com>
Subject: [QA-TCP] How to send tcp small packages immediately?
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.210]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A02020A.544A02E1.015A,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7b244e9a0f1228d845df0a925fc15909
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I use netperf to test the performance of small tcp package, with TCP_NODELAY set :

netperf -H 129.9.7.164 -l 100 -- -m 512 -D

Among the packages I got by tcpdump, there is not only small packages, also lost of
big ones (skb->len=65160).

IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 65160
IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 65160
IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
IP 129.9.7.164.34607 > 129.9.7.186.60840: tcp 0
IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 80
IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 512
IP 129.9.7.186.60840 > 129.9.7.164.34607: tcp 512

SO, how to test small tcp packages? Including TCP_NODELAY, What else should be set?

Thanks!
-- 
Best Wishes!
Zhang Jie

