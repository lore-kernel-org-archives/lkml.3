Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3JEQqJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 12:46:09 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35471 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab3JEQqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 12:46:07 -0400
Message-ID: <52504239.8090803@gmail.com>
Date: Sun, 06 Oct 2013 00:45:45 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Wen Congyang <wency@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, isimatu.yasuaki@jp.fujitsu.com,
        Linux MM <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] mm/sparsemem: Fix a bug in free_map_bootmem when
 CONFIG_SPARSEMEM_VMEMMAP
References: <524CE4C1.8060508@gmail.com> <524CE532.1030001@gmail.com> <20131003134204.e408977b42cb85984473cfd6@linux-foundation.org>
In-Reply-To: <20131003134204.e408977b42cb85984473cfd6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello andrew,

On 10/04/2013 04:42 AM, Andrew Morton wrote:
> On Thu, 03 Oct 2013 11:32:02 +0800 Zhang Yanfei <zhangyanfei.yes@gmail.com> wrote:
> 
>> We pass the number of pages which hold page structs of a memory
>> section to function free_map_bootmem. This is right when
>> !CONFIG_SPARSEMEM_VMEMMAP but wrong when CONFIG_SPARSEMEM_VMEMMAP.
>> When CONFIG_SPARSEMEM_VMEMMAP, we should pass the number of pages
>> of a memory section to free_map_bootmem.
>>
>> So the fix is removing the nr_pages parameter. When
>> CONFIG_SPARSEMEM_VMEMMAP, we directly use the prefined marco
>> PAGES_PER_SECTION in free_map_bootmem. When !CONFIG_SPARSEMEM_VMEMMAP,
>> we calculate page numbers needed to hold the page structs for a
>> memory section and use the value in free_map_bootmem.
> 
> What were the runtime user-visible effects of that bug?
> 
> Please always include this information when fixing a bug.


Sorry....This was found by reading the code. And I have no machine that
support memory hot-remove to test the bug now. But I believe it is a bug.

BTW, I've made a mistake in this patch which was found by wanpeng. I'll
send v2.

-- 
Thanks.
Zhang Yanfei
