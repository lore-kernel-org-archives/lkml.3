Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaHKCEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 22:04:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:30484 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHKCEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 22:04:38 -0400
Message-ID: <53E82488.2030607@huawei.com>
Date: Mon, 11 Aug 2014 10:03:52 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: tangchen <tangchen@cn.fujitsu.com>
CC: <akpm@linux-foundation.org>, <santosh.shilimkar@ti.com>,
        <grygorii.strashko@ti.com>, <phacht@linux.vnet.ibm.com>,
        <yinghai@kernel.org>, <fabf@skynet.be>, <Emilian.Medve@freescale.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memblock, memhotplug: Fix wrong type in memblock_find_in_range_node().
References: <1407651123-10994-1-git-send-email-tangchen@cn.fujitsu.com> <53E70DB4.4000606@cn.fujitsu.com>
In-Reply-To: <53E70DB4.4000606@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/10 14:14, tangchen wrote:

> Sorry, add Xishi Qiu <qiuxishi@huawei.com>
> 
> On 08/10/2014 02:12 PM, Tang Chen wrote:
>> In memblock_find_in_range_node(), we defeind ret as int. But it shoule
>> be phys_addr_t because it is used to store the return value from
>> __memblock_find_range_bottom_up().
>>
>> The bug has not been triggered because when allocating low memory near
>> the kernel end, the "int ret" won't turn out to be minus. When we started
>> to allocate memory on other nodes, and the "int ret" could be minus.
>> Then the kernel will panic.
>>
>> A simple way to reproduce this: comment out the following code in numa_init(),
>>
>>          memblock_set_bottom_up(false);
>>
>> and the kernel won't boot.
>>
>> Reported-by: Xishi Qiu <qiuxishi@huawei.com>
>> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
>> ---
>>   mm/memblock.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/mm/memblock.c b/mm/memblock.c
>> index 6d2f219..70fad0c 100644
>> --- a/mm/memblock.c
>> +++ b/mm/memblock.c
>> @@ -192,8 +192,7 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
>>                       phys_addr_t align, phys_addr_t start,
>>                       phys_addr_t end, int nid)
>>   {
>> -    int ret;
>> -    phys_addr_t kernel_end;
>> +    phys_addr_t kernel_end, ret;
>>         /* pump up @end */
>>       if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
> 
> 

Hi, Tang Chen

It is OK now.

Tested-by: Xishi Qiu <qiuxishi@huawei.com>

> .
> 



