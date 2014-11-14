Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161300AbaKNPZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 10:25:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:3925 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965431AbaKNPZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:25:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487520172"
Message-ID: <54661ED9.8090901@linux.intel.com>
Date: Fri, 14 Nov 2014 23:25:13 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Yijing Wang <wangyijing0307@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yijing Wang <wangyijing@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
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
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <54651BE2.9080008@arm.com> <54654C10.2040102@linux.intel.com> <54655632.2040209@huawei.com> <alpine.DEB.2.11.1411140211480.3935@nanos> <54655D44.1070703@linux.intel.com> <54660D7F.70702@gmail.com> <54661103.8000707@linux.intel.com> <54661CB8.2070704@arm.com>
In-Reply-To: <54661CB8.2070704@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 23:16, Marc Zyngier wrote:
> On 14/11/14 14:26, Jiang Liu wrote:
>> On 2014/11/14 22:11, Yijing Wang wrote:
>>>
>> We have achieved 1 and 2. And seems we could also achieve 3 by
>> converting all arch specific PCI MSI code to use hierarchy
>> irqdomain. But not sure whether we could achieve 4, not familiar
>> with ARM world:)
> 
> Killing all the weak functions shouldn't be a problem for ARM, we're
> trying very hard not to rely on them.
> 
> Killing msi_chip is a different story, as this is what we use to match a
> PCI host controller with its MSI controller (that's what the of_node
> field in msi_chip is for). See drivers/of/of_pci.c for details.
> 
> Also, we use msi_chip directly in the MSI drivers as a way to go from a
> pci_dev to the MSI controller specific structure:
> 
> http://git.kernel.org/cgit/linux/kernel/git/maz/arm-platforms.git/tree/drivers/irqchip/irq-gic-v3-its.c?h=irq/stacked-its-v2#n1143
> 
> If we're going to kill msi_chip, we must make sure we have mechanisms
> that allow the conversion of the existing code.
Hi Marc,
	Seem it doesn't worth the effort to remove irq_chip,
so I will focus on killing all weak functions first:)
After that, we may kill setup_irq and teardown_irq in irq_chip,
but seems irq_chip still has other usages, so I won't try to
kill irq_chip.
Regards!
Gerry
> 
> Thanks,
> 
> 	M.
> 
