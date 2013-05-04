Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366Ab3EDHsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:48:13 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:38414 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755082Ab3EDHsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:48:11 -0400
Message-ID: <5184BD35.2000207@redhat.com>
Date: Sat, 04 May 2013 09:48:05 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Zhanghaoyu (A)" <haoyu.zhang@huawei.com>
CC: kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>, Luonengjun <luonengjun@huawei.com>,
        Zanghongyong <zanghongyong@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        Qinchuanyu <qinchuanyu@huawei.com>
Subject: Re: KVM VM(rhel-5.5) %si is too high when TX/RX packets
References: <D3E216785288A145B7BC975F83A2ED103FE3BBB3@szxeml556-mbx.china.huawei.com>
In-Reply-To: <D3E216785288A145B7BC975F83A2ED103FE3BBB3@szxeml556-mbx.china.huawei.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/05/2013 06:05, Zhanghaoyu (A) ha scritto:
> I running a VM(RHEL-5.5) on KVM hypervisor(linux-3.8 + QEMU-1.4.1), and direct-assign intel 82576 VF to the VM. When TX/RX packets on VM to the other host via iperf tool, top tool result on VM shown that the %si is too high, approximately 95% ~ 100%, but from the view of host, the VM's total CPU usage is about 20% - 30%. And the throughput rate is approximately 200Mb/s, far from the line rate 1Gb/s, 
> And, I found  the hardirq rate is lower than normal by running "watch -d -n 1 cat /proc/interrupts", I think it's caused by the too high %si, because the NIC's hardirq was disabled during the softirq process.
> Then, I direct-assign the intel 82576 to the VM, the same case happened too. 
> I found the intel 82576 and intel 82576 VF's interrupt mode are both PCI-MSI-X.
> 
> And,
> I rmmod the igb driver, and, re-insmod the igb driver(igb-4.1.2) with the parameter IntMode=0/1(0:legacy, 1:MSI, 2:MSI-x), the problem then gone, the %si is approximately 20% -30%, and the throughput rate came to the line rate, about 940Mb/s.
> I update the VM to RHEL-6.1, the problem disappeared too.
> And, I found a very strange thing, the VM's 82576VF's irq routing is set one time on Vf's one interrupt received, so frequently.

RHEL 5.5 is a very old update.  Can you try RHEL 5.9?

In any case, this looks a lot like a bug in the version of the driver
that was included in RHEL5.5; you should contact Red Hat support
services if you can still reproduce it with the latest RHEL5 update.

Paolo
