Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaHRGVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 02:21:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34514 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaHRGVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 02:21:15 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <53F19B4A.5090409@jp.fujitsu.com>
Date: Mon, 18 Aug 2014 15:20:58 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Zhang Zhen <zhenzhang.zhang@huawei.com>, Toshi Kani <toshi.kani@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>, <n-horiguchi@ah.jp.nec.com>,
        <wangnan0@huawei.com>, <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH v2] memory-hotplug: add sysfs zones_online_to attribute
References: <1407902811-4873-1-git-send-email-zhenzhang.zhang@huawei.com>  <53EAE534.8030303@huawei.com> <1408138647.26567.42.camel@misato.fc.hp.com> <53F17230.5020409@huawei.com>
In-Reply-To: <53F17230.5020409@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/08/18 12:25), Zhang Zhen wrote:
> On 2014/8/16 5:37, Toshi Kani wrote:
>> On Wed, 2014-08-13 at 12:10 +0800, Zhang Zhen wrote:
>>> Currently memory-hotplug has two limits:
>>> 1. If the memory block is in ZONE_NORMAL, you can change it to
>>> ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.
>>> 2. If the memory block is in ZONE_MOVABLE, you can change it to
>>> ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.
>>>
>>> With this patch, we can easy to know a memory block can be onlined to
>>> which zone, and don't need to know the above two limits.
>>>
>>> Updated the related Documentation.
>>>
>>> Change v1 -> v2:
>>> - optimize the implementation following Dave Hansen's suggestion
>>>
>>> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
>>> ---
>>>   Documentation/ABI/testing/sysfs-devices-memory |  8 ++++
>>>   Documentation/memory-hotplug.txt               |  4 +-
>>>   drivers/base/memory.c                          | 62 ++++++++++++++++++++++++++
>>>   include/linux/memory_hotplug.h                 |  1 +
>>>   mm/memory_hotplug.c                            |  2 +-
>>>   5 files changed, 75 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
>>> index 7405de2..2b2a1d7 100644
>>> --- a/Documentation/ABI/testing/sysfs-devices-memory
>>> +++ b/Documentation/ABI/testing/sysfs-devices-memory
>>> @@ -61,6 +61,14 @@ Users:		hotplug memory remove tools
>>>   		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
>>>
>>>

>>> +What:           /sys/devices/system/memory/memoryX/zones_online_to
>>
>> I think this name is a bit confusing.  How about "valid_online_types"?
>>
> Thanks for your suggestion.
>
> This patch has been added to -mm tree.
> If most people think so, i would like to modify the interface name.

I like Toshi's idea (valid_online_types).

Thanks,
Yasuaki Ishimatsu

> If not, let's leave it as it is.
>
> Best regards!
>> Thanks,
>> -Toshi
>>
>>
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>
>>
>
>


