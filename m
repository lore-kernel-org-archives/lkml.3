Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaIZCKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 22:10:47 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44975 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbaIZCKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 22:10:45 -0400
Message-ID: <5424CB0F.2030406@huawei.com>
Date: Fri, 26 Sep 2014 10:10:23 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xinwei Hu <huxinwei@huawei.com>,
        Wuyun <wuyun.wu@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>, <Bharat.Bhushan@freescale.com>,
        <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-mips@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-s390@vger.kernel.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        "Tony Luck" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <sparclinux@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        David Vrabel <david.vrabel@citrix.com>,
        "Sergei Shtylyov" <sergei.shtylyov@cogentembedded.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH v2 06/22] PCI/MSI: Introduce weak arch_find_msi_chip()
 to find MSI chip
References: <1411614872-4009-1-git-send-email-wangyijing@huawei.com> <1411614872-4009-7-git-send-email-wangyijing@huawei.com> <20140925072619.GI12423@ulmo>
In-Reply-To: <20140925072619.GI12423@ulmo>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/25 15:26, Thierry Reding wrote:
> On Thu, Sep 25, 2014 at 11:14:16AM +0800, Yijing Wang wrote:
>> Introduce weak arch_find_msi_chip() to find the match msi_chip.
>> Currently, MSI chip associates pci bus to msi_chip. Because in
>> ARM platform, there may be more than one MSI controller in system.
>> Associate pci bus to msi_chip help pci device to find the match
>> msi_chip and setup MSI/MSI-X irq correctly. But in other platform,
>> like in x86. we only need one MSI chip, because all device use
>> the same MSI address/data and irq etc. So it's no need to associate
>> pci bus to MSI chip, just use a arch function, arch_find_msi_chip()
>> to return the MSI chip for simplicity. The default weak
>> arch_find_msi_chip() used in ARM platform, find the MSI chip
>> by pci bus.
> 
> Can't x86 simply set the bus' .msi field anyway? It would seem to be
> easy to do and unifies the code rather than driving it further apart
> using even more of the __weak functions.

As mentioned in the first reply, I will rework this one when we find a better solution.

Thanks!
Yijing.

> 
> Thierry
> 


-- 
Thanks!
Yijing

