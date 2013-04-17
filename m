Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab3DQHjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:39:01 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43952 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871Ab3DQHi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:38:59 -0400
Message-ID: <516E517F.5000003@huawei.com>
Date: Wed, 17 Apr 2013 15:38:39 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH] mm: fix build warning about kernel_physical_mapping_remove()
References: <1366182958-21892-1-git-send-email-wangyijing@huawei.com> <20130417072214.GA25283@hacker.(null)>
In-Reply-To: <20130417072214.GA25283@hacker.(null)>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/17 15:22, Wanpeng Li wrote:
> On Wed, Apr 17, 2013 at 03:15:58PM +0800, Yijing Wang wrote:
>> If CONFIG_MEMORY_HOTREMOVE is not set, a build warning about
>> "warning: ‘kernel_physical_mapping_remove’ defined but not used"
>> report.
>>
> 
> This has already been fixed by Tang Chen. 
> http://marc.info/?l=linux-mm&m=136614697618243&w=2

OK, I will drop this one, thanks!

> 
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Cc: Tang Chen <tangchen@cn.fujitsu.com>
>> Cc: Wen Congyang <wency@cn.fujitsu.com>
>> ---
>> arch/x86/mm/init_64.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 474e28f..dafdeb2 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -1019,6 +1019,7 @@ void __ref vmemmap_free(struct page *memmap, unsigned long nr_pages)
>> 	remove_pagetable(start, end, false);
>> }
>>
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> static void __meminit
>> kernel_physical_mapping_remove(unsigned long start, unsigned long end)
>> {
>> @@ -1028,7 +1029,6 @@ kernel_physical_mapping_remove(unsigned long start, unsigned long end)
>> 	remove_pagetable(start, end, true);
>> }
>>
>> -#ifdef CONFIG_MEMORY_HOTREMOVE
>> int __ref arch_remove_memory(u64 start, u64 size)
>> {
>> 	unsigned long start_pfn = start >> PAGE_SHIFT;
>> -- 
>> 1.7.1
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 
> .
> 


-- 
Thanks!
Yijing

