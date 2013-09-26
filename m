Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756941Ab3IZMWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 08:22:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45682 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756560Ab3IZMWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 08:22:40 -0400
Message-ID: <524426F5.5010106@huawei.com>
Date: Thu, 26 Sep 2013 20:22:13 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: IRQ Affinity Problem
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yinghai,
   I'm sorry to disturb you. These days I was confused about IRQ Affinity Set and IrqBalance utility. And I found you committed a patch to remove CONFIG_IRQBALANCE
by git log. And recommend using IrqBalance instead in commit 8b8e8c1bf7275. So I try to seek help from you. :)
I found Ingo said in Documentation/IRQ-affinity.txt, users can set /proc/irq/xxx/smp_affinity to balance IRQ between CPUs.
But in my Intel Xeon, I can not balance IRQ by setting /proc/irq/xxx/smp_affinity, the interrupt always deliver to the first CPU in smp_affinity mask.

Storage:~ # cat /proc/interrupts
            CPU0       CPU1       CPU2       CPU3
   0:        103          0          0          0   IO-APIC-edge      timer
   4:        786         71          0          0   IO-APIC-edge      serial
   5:         28          0          0          0   IO-APIC-edge      irqnum
   8:        255          0          0          0   IO-APIC-edge      rtc0
   9:          1          0          0          0   IO-APIC-fasteoi   acpi
  16:         29          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb1
  23:         33          0          0          0   IO-APIC-fasteoi   ehci_hcd:usb2
  64:          0          0          0          0   PCI-MSI-edge      PCIe PME
  65:          0          0          0          0   PCI-MSI-edge      PCIe PME
  66:          0          0          0          0   PCI-MSI-edge      PCIe PME
  67:          0          0          0          0   PCI-MSI-edge      PCIe PME
  68:          0          0          0          0   PCI-MSI-edge      PCIe PME
  69:          0          0          0          0   PCI-MSI-edge      PCIe PME
  70:          0          0          0          0   PCI-MSI-edge      PCIe PME
  71:          0          0          0          0   PCI-MSI-edge      PCIe PME
  72:          0          0          0          0   PCI-MSI-edge      PCIe PME
  80:      63387        297          0          0   PCI-MSI-edge      ahci
  84:     243698     201963        279     246029   PCI-MSI-edge      eth1-rx-0
  85:     108983        213     116870      80864   PCI-MSI-edge      eth1-tx-0
  86:        243          0          0         13   PCI-MSI-edge      eth1
  87:      48053      57019     533965          0   PCI-MSI-edge      eth2-rx-0
  88:      85205       3120     416349          0   PCI-MSI-edge      eth2-tx-0

Because nums of CPUs is 4 < 8, so I think apic will use apic_flat to configure LAPIC.

Storage:~ # cat /proc/irq/87/smp_affinity
00000000,0000000c
Storage:~ # cat /proc/irq/88/smp_affinity
00000000,0000000c

But IRQ 87/88 always deliver to CPU2, no one to CPU3.

I found Linux always set TPR to 0, and never change it, so IOAPIC always select CPU2 as the lowest priority CPU?. And this case like above is normal?

Thanks very much!

Best Regards!
Yijing.


-- 
Thanks!
Yijing

