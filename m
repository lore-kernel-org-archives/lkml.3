Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbaHSBoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 21:44:12 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:18392 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaHSBoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 21:44:10 -0400
Message-ID: <53F2ABD0.1010706@huawei.com>
Date: Tue, 19 Aug 2014 09:43:44 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, <toshi.kani@hp.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <n-horiguchi@ah.jp.nec.com>,
        <wangnan0@huawei.com>, <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v2] memory-hotplug: add sysfs zones_online_to attribute
References: <1407902811-4873-1-git-send-email-zhenzhang.zhang@huawei.com> <53EAE534.8030303@huawei.com> <alpine.DEB.2.02.1408181447260.4796@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1408181447260.4796@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/19 5:48, David Rientjes wrote:
> On Wed, 13 Aug 2014, Zhang Zhen wrote:
> 
>> Currently memory-hotplug has two limits:
>> 1. If the memory block is in ZONE_NORMAL, you can change it to
>> ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.
>> 2. If the memory block is in ZONE_MOVABLE, you can change it to
>> ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.
>>
>> With this patch, we can easy to know a memory block can be onlined to
>> which zone, and don't need to know the above two limits.
>>
>> Updated the related Documentation.
>>
>> Change v1 -> v2:
>> - optimize the implementation following Dave Hansen's suggestion
>>
>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
> 
> linux-next build failure:
> 
> drivers/built-in.o: In function `show_zones_online_to':
> memory.c:(.text+0x13ee09): undefined reference to `test_pages_in_a_zone'
> 
The function implementation in mm/memory_hotplug.c is only built if
CONFIG_MEMORY_HOTREMOVE is enabled.

A fix has been proposed.
http://ozlabs.org/~akpm/mmots/broken-out/memory-hotplug-add-sysfs-zones_online_to-attribute-fix-2.patch

Thanks!
> 


