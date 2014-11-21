Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbaKUKLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 05:11:21 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36299 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758418AbaKUKLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 05:11:18 -0500
Message-ID: <546F0FB6.3050404@arm.com>
Date: Fri, 21 Nov 2014 10:11:02 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: Removal of bus->msi assignment breaks MSI with stacked domains
References: <546E1771.4030201@arm.com> <546E93DC.8010902@huawei.com>
In-Reply-To: <546E93DC.8010902@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/14 01:22, Yijing Wang wrote:
> On 2014/11/21 0:31, Marc Zyngier wrote:
>> Bjorn, Yijing,
>>
>> I've just realized that patch c167caf8d174 (PCI/MSI: Remove useless
>> bus->msi assignment) completely breaks MSI on arm64 when using the new
>> MSI stacked domain:
> 
> Sorry, this is my first part to refactor MSI related code, now
> how to get pci msi_controller depends arch functions(pcibios_msi_controller() or
> arch_setup_msi_irq()), we are working on generic pci_host_bridge, after that,
> we could eventually eliminate MSI arch functions and find pci dev 's msi controller
> by pci_host_bridge->get_msi_controller().
> 
> Marc, could you tell me what pci host driver in your test platform ?

I'm using pci-host-generic (with a couple of patches to help it fit the
new "generic pci" infrastructure).

This lives at:
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
irq/arm64-pci

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
