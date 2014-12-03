Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaLCIHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 03:07:43 -0500
Received: from [119.145.14.66] ([119.145.14.66]:43499 "EHLO
	szxga03-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCIHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 03:07:41 -0500
Message-ID: <547EC4A3.6060408@huawei.com>
Date: Wed, 3 Dec 2014 16:06:59 +0800
From: Qin Chuanyu <qinchuanyu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: <netdev@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: What's the concern about setting irq thread's policy as SCHED_FIFO
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.21.101]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020208.547EC4AD.0100,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 5feaae0133f1305aacef6603134b4a07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am doing network performance test under suse11sp3 and intel 82599 nic,
Becasuse the softirq is out of schedule policy's control, so netserver 
thread couldn't always get 100% cpu usage, then packet dropped in kernel 
udp socket's receive queue.

In order to get a stable result, I did some patch in ixgbe driver and 
then use irq_thread instead of softirq to handle rx.
It seems work well, but irq_thread's SCHED_FIFO schedule policy cause 
that when the cpu is limited, netserver couldn't work at all.

So I change the irq_thread's schedule policy from SCHED_FIFO to 
SCHED_NORMAL, then the irq_thread could share the cpu usage with 
netserver thread.

the question is:
What's the concrete reason about setting irq thread's policy as SCHED_FIFO?
Except the priority affecting the cpu usage, any function would be 
broken if irq thread change to SCHED_NORMAL?

