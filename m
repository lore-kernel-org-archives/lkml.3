Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaKQLhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:37:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:47324 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaKQLhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:37:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,402,1413270000"; 
   d="scan'208";a="638197183"
Message-ID: <5469DE01.6030308@linux.intel.com>
Date: Mon, 17 Nov 2014 19:37:37 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch V3 6/9] genirq: Introduce msi_domain_{alloc|free}_irqs()
References: <1416222202-28002-1-git-send-email-jiang.liu@linux.intel.com> <1416222202-28002-7-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.11.1411171230090.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411171230090.3909@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/17 19:30, Thomas Gleixner wrote:
> On Mon, 17 Nov 2014, Jiang Liu wrote:
>> +
>> +/*
>> + * Default structure for MSI interrupt allocation.
>> + * Arch may overwrite it by defining msi_alloc_info_t.
>> + */
>> +struct msi_alloc_info {
>> +	struct msi_desc			*desc;
>> +	irq_hw_number_t			hwirq;
>> +	union {
>> +		unsigned long		ul;
>> +		void			*ptr;
>> +	} scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
>> +};
>> +
>> +#ifndef msi_alloc_info_t
>> +typedef struct msi_alloc_info msi_alloc_info_t;
>> +#endif
> 
> Hmm. Do we really need that?
Hi Thomas,
	Do you mean msi_alloc_info_t? It acts as a flag
to use common struct msi_alloc_info or architecture specific
data structures. For most architecture, they will use the default
struct msi_alloc_info. But for x86, it will use struct irq_alloc_info.
Regards!
Gerry
