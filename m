Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700AbaHRBMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 21:12:44 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:62786 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372AbaHRBMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 21:12:42 -0400
X-IronPort-AV: E=Sophos;i="5.04,345,1406563200"; 
   d="scan'208";a="34714805"
Message-ID: <53F15330.5070606@cn.fujitsu.com>
Date: Mon, 18 Aug 2014 09:13:20 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Xishi Qiu <qiuxishi@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Wen Congyang <wency@cn.fujitsu.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@zytor.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH] mem-hotplug: let memblock skip the hotpluggable memory
 regions in __next_mem_range()
References: <53E8C5AA.5040506@huawei.com> <20140816130456.GH9305@htj.dyndns.org> <53EF6C79.3000603@huawei.com> <20140817110821.GM9305@htj.dyndns.org>
In-Reply-To: <20140817110821.GM9305@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tj,

On 08/17/2014 07:08 PM, Tejun Heo wrote:
> Hello,
>
> On Sat, Aug 16, 2014 at 10:36:41PM +0800, Xishi Qiu wrote:
>> numa_clear_node_hotplug()? There is only numa_clear_kernel_node_hotplug().
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
> Ah, okay, so the patch fixes __next_mem_range() and thus makes
> free_low_memory_core_early() to skip hotpluggable regions unlike
> before.  Please explain things like that in the changelog.  Also,
> what's its relationship with numa_clear_kernel_node_hotplug()?  Do we
> still need them?  If so, what are the different roles that these two
> separate places serve?

numa_clear_kernel_node_hotplug() only clears hotplug flags for the nodes
the kernel resides in, not for hotpluggable nodes. The reason why we did
this is to enable the kernel to allocate memory in case all the nodes are
hotpluggable.

And we clear hotplug flags for all the nodes in free_low_memory_core_early()
is because if we do not, all hotpluggable memory won't be able to be freed
to buddy after Qiu's patch.

Thanks.

