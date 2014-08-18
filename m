Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaHRCCl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:02:41 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:3368 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaHRCCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:02:39 -0400
Message-ID: <53F15E33.40705@huawei.com>
Date: Mon, 18 Aug 2014 10:00:19 +0800
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
References: <53E8C5AA.5040506@huawei.com> <20140816130456.GH9305@htj.dyndns.org> <53EF6C79.3000603@huawei.com> <20140817110821.GM9305@htj.dyndns.org>
In-Reply-To: <20140817110821.GM9305@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.25.179]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/17 19:08, Tejun Heo wrote:

> Hello,
> 
> On Sat, Aug 16, 2014 at 10:36:41PM +0800, Xishi Qiu wrote:
>> numa_clear_node_hotplug()? There is only numa_clear_kernel_node_hotplug().
> 
> Yeah, that one.
> 
>> If we don't clear hotpluggable flag in free_low_memory_core_early(), the 
>> memory which marked hotpluggable flag will not free to buddy allocator.
>> Because __next_mem_range() will skip them.
>>
>> free_low_memory_core_early
>> 	for_each_free_mem_range
>> 		for_each_mem_range
>> 			__next_mem_range		
> 
> Ah, okay, so the patch fixes __next_mem_range() and thus makes
> free_low_memory_core_early() to skip hotpluggable regions unlike
> before.  Please explain things like that in the changelog.  Also,

OK, I will send V2.

Thanks,
Xishi Qiu

> what's its relationship with numa_clear_kernel_node_hotplug()?  Do we
> still need them?  If so, what are the different roles that these two
> separate places serve?
> 
> Thanks.
> 



