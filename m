Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaHPOjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 10:39:16 -0400
Received: from [119.145.14.65] ([119.145.14.65]:48001 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaHPOjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 10:39:15 -0400
Message-ID: <53EF6C79.3000603@huawei.com>
Date: Sat, 16 Aug 2014 22:36:41 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Wen Congyang" <wency@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mem-hotplug: let memblock skip the hotpluggable memory
 regions in __next_mem_range()
References: <53E8C5AA.5040506@huawei.com> <20140816130456.GH9305@htj.dyndns.org>
In-Reply-To: <20140816130456.GH9305@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/16 21:04, Tejun Heo wrote:

> On Mon, Aug 11, 2014 at 09:31:22PM +0800, Xishi Qiu wrote:
>> Let memblock skip the hotpluggable memory regions in __next_mem_range(),
>> it is used to to prevent memblock from allocating hotpluggable memory 
>> for the kernel at early time. The code is the same as __next_mem_range_rev().
>>
>> Clear hotpluggable flag before releasing free pages to the buddy allocator.
> 
> Please try to explain "why" in addition to "what".  Why do we need to
> clear hotpluggable flag in free_low_memory_core_early() in addition to
> numa_clear_node_hotplug() in x86 numa.c?  Does this make x86 code
> redundant?  If not, why?
> 

Hi Tejun,

numa_clear_node_hotplug()? There is only numa_clear_kernel_node_hotplug().

If we don't clear hotpluggable flag in free_low_memory_core_early(), the 
memory which marked hotpluggable flag will not free to buddy allocator.
Because __next_mem_range() will skip them.

free_low_memory_core_early
	for_each_free_mem_range
		for_each_mem_range
			__next_mem_range		

Thanks,
Xishi Qiu

