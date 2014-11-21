Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbaKUBW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:22:59 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:41078 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756956AbaKUBW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:22:58 -0500
Message-ID: <546E93DC.8010902@huawei.com>
Date: Fri, 21 Nov 2014 09:22:36 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <will.deacon@arm.com>,
        "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com>
In-Reply-To: <546E1771.4030201@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/21 0:31, Marc Zyngier wrote:
> Bjorn, Yijing,
> 
> I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
> bus->msi assignment) completely breaks MSI on arm64 when using the new
> MSI stacked domain:

Sorry, this is my first part to refactor MSI related code, now
how to get pci msi_controller depends arch functions(pcibios_msi_controller() or
arch_setup_msi_irq()), we are working on generic pci_host_bridge, after that,
we could eventually eliminate MSI arch functions and find pci dev 's msi controller
by pci_host_bridge->get_msi_controller().

Marc, could you tell me what pci host driver in your test platform ?

> 
> This patch relies on architectures to implement either
> pcibios_msi_controller() or arch_setup_msi_irq(). It turns out that with
> stacked domains, none of this is actually necessary, as long as you can
> access to the msi_controller.
> 
> And everything was fine until this patch came around (and managed to
> test on a system where the PCI devices are not directly attached to the
> root bus). Of course, everything now breaks, as we cannot get to the MSI
> controller (which contains the domain we allocate the MSIs from).
> 
> In short, this patch breaks an important feature on which arm64 relies,
> and I believe this patch should be reverted ASAP.

Bjorn, could you help to revert this patch ?


> 
> Thanks,
> 
> 	M.
> 


-- 
Thanks!
Yijing

