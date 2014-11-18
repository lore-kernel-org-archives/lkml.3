Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbaKROky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:40:54 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:22353 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaKROkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:40:52 -0500
Message-ID: <546B5A3C.2080003@huawei.com>
Date: Tue, 18 Nov 2014 22:39:56 +0800
From: "Yun Wu (Abel)" <wuyun.wu@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiang Liu <jiang.liu@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Grant Likely" <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: Re: [patch 09/16] genirq: Add generic msi irq domain support
References: <20141112133941.647950773@linutronix.de> <20141112134120.569789374@linutronix.de> <546B3667.9040506@huawei.com> <546B4075.9050406@linux.intel.com> <546B4FC5.1050209@huawei.com> <alpine.DEB.2.11.1411181520580.3909@nanos>
In-Reply-To: <alpine.DEB.2.11.1411181520580.3909@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.136]
X-CFilter-Loop: Reflected
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
> 

"for (i--; i >= 0; i--)" is just the same as "while (i--)".

Thanks,
	Abel

