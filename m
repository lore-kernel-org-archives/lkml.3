Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965149AbaKNO0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:26:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:30993 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964875AbaKNO0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487505614"
Message-ID: <54661103.8000707@linux.intel.com>
Date: Fri, 14 Nov 2014 22:26:11 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Yijing Wang <wangyijing0307@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yijing Wang <wangyijing@huawei.com>
CC: Marc Zyngier <marc.zyngier@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 0/6] Refine generic/PCI MSI irqodmian interfaces
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com> <54654C10.2040102@linux.intel.com> <54655632.2040209@huawei.com> <alpine.DEB.2.11.1411140211480.3935@nanos> <54655D44.1070703@linux.intel.com> <54660D7F.70702@gmail.com>
In-Reply-To: <54660D7F.70702@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 22:11, Yijing Wang wrote:
> 
> 在 2014/11/14 9:39, Jiang Liu 写道:
>> On 2014/11/14 9:31, Thomas Gleixner wrote:
>>> On Fri, 14 Nov 2014, Yijing Wang wrote:
>>>
>> Hi Thomas,
>>     So we need something like:
>> struct msi_chip *pci_get_msi_chip(struct pci_dev *);
>> or:
>> struct irq_domain *pci_get_msi_domain(struct pci_dev *);
> 
> Hi Gerry,
> what about associate the platform specific  struct msi_chip
> *pci_get_msi_chip(struct pci_dev *)
> with struct pci_host_bridge. we could provide the private
> "pci_get_msi_chip()" in the PCI
> host drivers.
Hi Yijing,
	Still need some time to dig into msi_chip related code.
When refining the PCI MSI code, I feel the best way is:
1) Every PCI device is associated with an PCI MSI irqdomain.
2) PCI MSI core directly talks to irqdomain to allocate/free
   interrupts.
3) Kill all weak functions in pci/drivers/msi.c.
4) Kill struct msi_chip.

We have achieved 1 and 2. And seems we could also achieve 3 by
converting all arch specific PCI MSI code to use hierarchy
irqdomain. But not sure whether we could achieve 4, not familiar
with ARM world:)

On x86, we could kill all PCI MSI weak function after converting
Xen to irqdomain. I think we may have a prototype for x86 in next
week.
Thanks!
Gerry

