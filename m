Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbaFLClx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 22:41:53 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:56487 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaFLClw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 22:41:52 -0400
Message-ID: <53991353.5040607@huawei.com>
Date: Thu, 12 Jun 2014 10:41:23 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <gregkh@linuxfoundation.org>, <laijs@cn.fujitsu.com>,
        <sjenning@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Wang Nan <wangnan0@huawei.com>
Subject: Re: Proposal to realize hot-add *several sections one time*
References: <53981D81.5060708@huawei.com> <alpine.DEB.2.02.1406111503050.27885@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406111503050.27885@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/6/12 6:08, David Rientjes wrote:
> On Wed, 11 Jun 2014, Zhang Zhen wrote:
> 
>> Hi,
>>
>> Now we can hot-add memory by
>>
>> % echo start_address_of_new_memory > /sys/devices/system/memory/probe
>>
>> Then, [start_address_of_new_memory, start_address_of_new_memory +
>> memory_block_size] memory range is hot-added.
>>
>> But we can only hot-add *one section one time* by this way.
>> Whether we can add an argument on behalf of the count of the sections to add ?
>> So we can can hot-add *several sections one time*. Just like:
>>
> 
> Not necessarily true, it depends on sections_per_block.  Don't believe 
> Documentation/memory-hotplug.txt that suggests this is only for powerpc, 
> x86 and sh allow this interface as well.
> 
>> % echo start_address_of_new_memory count_of_sections > /sys/devices/system/memory/probe
>>
>> Then, [start_address_of_new_memory, start_address_of_new_memory +
>> count_of_sections * memory_block_size] memory range is hot-added.
>>
>> If this proposal is reasonable, i will send a patch to realize it.
>>
> 
> The problem is knowing how much memory is being onlined so that you can 
> definitively determine what count_of_sections should be.  The number of 
> pages per memory section depends on PAGE_SIZE and SECTION_SIZE_BITS which 
> differ depending on the architectures that support this interface.  So if 
> you support count_of_sections, it would return errno even though you have 
> onlined some sections.
> 
Hum, sorry.
My expression is not right. The count of sections one time hot-added
depends on sections_per_block.

Now we are porting the memory-hotplug to arm.
But we can only hot-add *fixed number of sections one time* on particular architecture.

Whether we can add an argument on behalf of the count of the blocks to add ?

% echo start_address_of_new_memory count_of_blocks > /sys/devices/system/memory/probe

Then, [start_address_of_new_memory, start_address_of_new_memory + count_of_blocks * memory_block_size]
memory range is hot-added.

So user don't need execute several times of echo when they want to hot add multi-block size memory.

Any comments are welcome.

Best regards!
> 


