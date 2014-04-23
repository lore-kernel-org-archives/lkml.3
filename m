Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757818AbaDWRcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:32:00 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaDWRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:31:59 -0400
Message-ID: <5357F909.7070205@infradead.org>
Date: Wed, 23 Apr 2014 10:31:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Robin Gong <b38343@freescale.com>
CC: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v1] dma: imx-sdma: add support for sdma memory copy
References: <1397728870-22086-1-git-send-email-b38343@freescale.com>	 <1397730289.11914.225.camel@smile.fi.intel.com>	 <20140418094057.GA11496@Robin-OptiPlex-780>	 <1398162484.11914.234.camel@smile.fi.intel.com>	 <20140422105142.GA9693@Robin-OptiPlex-780> <1398165864.11914.241.camel@smile.fi.intel.com>
In-Reply-To: <1398165864.11914.241.camel@smile.fi.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/14 04:24, Andy Shevchenko wrote:
> On Tue, 2014-04-22 at 18:51 +0800, Robin Gong wrote:
>> On Tue, Apr 22, 2014 at 10:28:05AM +0000, Shevchenko, Andriy wrote:
>>> On Fri, 2014-04-18 at 17:41 +0800, Robin Gong wrote:
>>>> On Thu, Apr 17, 2014 at 10:24:50AM +0000, Shevchenko, Andriy wrote:
>>>>> On Thu, 2014-04-17 at 18:01 +0800, Robin Gong wrote:
>>>
>>> []
>>>
>>>>>> +	dev_dbg(sdma->dev, "memcpy: %x->%x, len=%d, channel=%d.\n",
>>>>>
>>>>> %pad for dma_addr_t variables.
>>>>>
>>>> Yes, %x here is not proper, will be %#llx here to align with others similar
>>>> code in this file.
>>>
>>> Why %#llx? You don't need the specific casting since kernel has special
>>> specifiers for phys_addr_t and dma_addr_t and their derivatives (see
>>> Documentation/printk-formats.txt)
>>>
>> I think both are ok, why I choose %llx is only for align the code style,
> 
> Yes, but it was started being developed earlier than kernel gains the
> feature.
> 
>>  you
>> can find the same code in sdma_prep_dma_cyclic function. below description also
>> copy from Documentation/printk-formats.txt:
>>
>>
>> If <type> is dependent on a config option for its size (e.g., sector_t,
>> blkcnt_t, phys_addr_t, resource_size_t) or is architecture-dependent
>> for its size (e.g., tcflag_t), use a format specifier of its largest
>> possible type and explicitly cast to it.  Example:
>>
>> 	printk("test: sector number/total blocks: %llu/%llu\n",
>> 		(unsigned long long)sector, (unsigned long long)blockcount);
> 
> Yeah, I think it requires to be updated accordingly to last changes
> regarding to new specifiers.
> 
> +Cc Randy. Randy, do you think is a matter of fact that we have to
> update that paragraph somehow and recommend to prefer special specifiers
> over explicit casting to longest possible type?

Yes, I agree, if there is a printk format specifier that supports a certain type
to be printed, we should prefer to use that instead of the generic casting method.

IMO, the cast to (long long) or (unsigned long long) or (u64) or (s64) should be a last
resort safe method.


>>>>>> +		dev_dbg(sdma->dev, "entry %d: count: %d dma: 0x%08x %s%s\n",
>>>>>> +				i, count, sg_src->dma_address,
>>>>>
>>>>> %pad for dma_addr_t.
>>>>>
>>>> Accept the idea, same as the above.
>>>
>>> Same as above.
> 
> 


-- 
~Randy
