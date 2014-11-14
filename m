Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbaKNASt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:18:49 -0500
Received: from mga03.intel.com ([134.134.136.65]:64772 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbaKNASs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:18:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="487365591"
Message-ID: <54654A63.6040202@linux.intel.com>
Date: Fri, 14 Nov 2014 08:18:43 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Patch V1 3/6] genirq: Introduce msi_domain_{alloc|free}_irqs()
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com> <1415879029-20098-4-git-send-email-jiang.liu@linux.intel.com> <5465134B.7070709@arm.com>
In-Reply-To: <5465134B.7070709@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/14 4:23, Marc Zyngier wrote:
> On 13/11/14 11:43, Jiang Liu wrote:
>> Introduce msi_domain_{alloc|free}_irqs() to alloc/free interrupts
>> from generic MSI irqdomain.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>>  include/linux/msi.h |   35 ++++++++++++++++++++++++++++++
>>  kernel/irq/msi.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 94 insertions(+)
>>
>> +/*
>> + * Default structure for MSI interrupt allocation.
>> + * Arch may overwrite it by define msi_alloc_info_t.
>> + */
>> +struct msi_alloc_info {
>> +	struct msi_desc *desc;
>> +	irq_hw_number_t hwirq;
>> +	long		scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
> 
> As much as I'm relieved to see a generic structure here, could
> scratchpad be slightly less awkward to use? Something like:
> 
> struct msi_alloc_info {
> 	[...]
> 	union	{
> 		unsigned long ul;
> 		void *ptr;
> 	} scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
> };
> 
> That would avoid some very ugly casting.
Great, will changed to this way in next version:)

> 
> Thanks,
> 
> 	M.
> 
