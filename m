Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288Ab3ECEFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 00:05:53 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19675 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab3ECEFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 00:05:52 -0400
From: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
To: kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
CC: Luonengjun <luonengjun@huawei.com>, Zanghongyong <zanghongyong@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Qinchuanyu <qinchuanyu@huawei.com>
Subject: KVM VM(rhel-5.5) %si is too high when TX/RX packets
Thread-Topic: KVM VM(rhel-5.5) %si is too high when TX/RX packets
Thread-Index: Ac5Hs1wISEMZKpucRUKMj7M5PG0M3g==
Date: Fri, 3 May 2013 04:05:01 +0000
Message-ID: <D3E216785288A145B7BC975F83A2ED103FE3BBB3@szxeml556-mbx.china.huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: AhDY CCQa C9Fq E2+r FfzL GZIN KNwr LPBJ M0Lb OQ6K QIa4
 ZZoN c3MY c65d d0Gy
 eKiy;3;awB2AG0AQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBxAGUAbQB1AC0AZABlAHYAZQBsAEAAbgBvAG4AZwBuAHUALgBvAHIAZwA=;Sosha1_v1;7;{64596230-311B-4B9A-AF24-3C756A30F6F8};aABhAG8AeQB1AC4AegBoAGEAbgBnAEAAaAB1AGEAdwBlAGkALgBjAG8AbQA=;Fri,
 03 May 2013 04:04:54
 GMT;SwBWAE0AIABWAE0AKAByAGgAZQBsAC0ANQAuADUAKQAgACUAcwBpACAAaQBzACAAdABvAG8AIABoAGkAZwBoACAAdwBoAGUAbgAgAFQAWAAvAFIAWAAgAHAAYQBjAGsAZQB0AHMA
x-cr-puzzleid: {64596230-311B-4B9A-AF24-3C756A30F6F8}
x-originating-ip: [10.135.68.97]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I running a VM(RHEL-5.5) on KVM hypervisor(linux-3.8 + QEMU-1.4.1), and direct-assign intel 82576 VF to the VM. When TX/RX packets on VM to the other host via iperf tool, top tool result on VM shown that the %si is too high, approximately 95% ~ 100%, but from the view of host, the VM's total CPU usage is about 20% - 30%. And the throughput rate is approximately 200Mb/s, far from the line rate 1Gb/s, 
And, I found  the hardirq rate is lower than normal by running "watch -d -n 1 cat /proc/interrupts", I think it's caused by the too high %si, because the NIC's hardirq was disabled during the softirq process.
Then, I direct-assign the intel 82576 to the VM, the same case happened too. 
I found the intel 82576 and intel 82576 VF's interrupt mode are both PCI-MSI-X.

And,
I rmmod the igb driver, and, re-insmod the igb driver(igb-4.1.2) with the parameter IntMode=0/1(0:legacy, 1:MSI, 2:MSI-x), the problem then gone, the %si is approximately 20% -30%, and the throughput rate came to the line rate, about 940Mb/s.
I update the VM to RHEL-6.1, the problem disappeared too.
And, I found a very strange thing, the VM's 82576VF's irq routing is set one time on Vf's one interrupt received, so frequently.

Thanks,
Zhang Haoyu
