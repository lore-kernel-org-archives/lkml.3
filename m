Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbaKTC3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 21:29:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:1500 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527AbaKTC3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 21:29:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="488950839"
Message-ID: <546D5212.1030806@linux.intel.com>
Date: Thu, 20 Nov 2014 10:29:38 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
CC: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 09/16] genirq: Add generic msi irq domain support
References: <20141112133941.647950773@linutronix.de> <20141112134120.569789374@linutronix.de> <546B3667.9040506@huawei.com> <546B4075.9050406@linux.intel.com> <546B4FC5.1050209@huawei.com> <alpine.DEB.2.11.1411181520580.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411181520580.3909@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 22:24, Thomas Gleixner wrote:
> On Tue, 18 Nov 2014, Yun Wu (Abel) wrote:
>> On 2014/11/18 20:49, Jiang Liu wrote:
>>>>> +	ret = irq_domain_alloc_irqs_parent(domain, virq, nr_irqs, arg);
>>>>> +	if (ret < 0)
>>>>> +		return ret;
>>>>> +
>>>>> +	for (i = 0; i < nr_irqs; i++) {
>>>>> +		ret = ops->msi_init(domain, info, virq + i, hwirq + i, arg);
>>>>> +		if (ret < 0) {
>>>>> +			if (ops->msi_free) {
>>>>> +				for (i--; i > 0; i--)
>>>>
>>>> while (i--) ?
> 
> The allocation for 'i' failed. So we don't free i. You missed the real
> bug here:
> 
>>>>> +				for (i--; i > 0; i--)
> 
> Must be i >= 0.
Hi Thomas,
	You will take care of this bug, right? Or should I send a patch
for it?
Regards!
Gerry
