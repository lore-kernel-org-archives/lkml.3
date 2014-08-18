Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaHRDZt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 23:25:49 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62385 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaHRDZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 23:25:48 -0400
Message-ID: <53F17230.5020409@huawei.com>
Date: Mon, 18 Aug 2014 11:25:36 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>, <isimatu.yasuaki@jp.fujitsu.com>,
        <n-horiguchi@ah.jp.nec.com>, <wangnan0@huawei.com>,
        <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v2] memory-hotplug: add sysfs zones_online_to attribute
References: <1407902811-4873-1-git-send-email-zhenzhang.zhang@huawei.com>  <53EAE534.8030303@huawei.com> <1408138647.26567.42.camel@misato.fc.hp.com>
In-Reply-To: <1408138647.26567.42.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.53F1723A.0029,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: c7bc47f269dc7965e9b8e935dd9c1286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/16 5:37, Toshi Kani wrote:
> On Wed, 2014-08-13 at 12:10 +0800, Zhang Zhen wrote:
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
>> ---
>>  Documentation/ABI/testing/sysfs-devices-memory |  8 ++++
>>  Documentation/memory-hotplug.txt               |  4 +-
>>  drivers/base/memory.c                          | 62 ++++++++++++++++++++++++++
>>  include/linux/memory_hotplug.h                 |  1 +
>>  mm/memory_hotplug.c                            |  2 +-
>>  5 files changed, 75 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
>> index 7405de2..2b2a1d7 100644
>> --- a/Documentation/ABI/testing/sysfs-devices-memory
>> +++ b/Documentation/ABI/testing/sysfs-devices-memory
>> @@ -61,6 +61,14 @@ Users:		hotplug memory remove tools
>>  		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
>>
>>
>> +What:           /sys/devices/system/memory/memoryX/zones_online_to
> 
> I think this name is a bit confusing.  How about "valid_online_types"?
> 
Thanks for your suggestion.

This patch has been added to -mm tree.
If most people think so, i would like to modify the interface name.
If not, let's leave it as it is.

Best regards!
> Thanks,
> -Toshi
> 
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 


