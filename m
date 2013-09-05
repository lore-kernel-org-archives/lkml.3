Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3IED6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 23:58:24 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:64361 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3IED6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 23:58:23 -0400
Message-ID: <52280058.5070803@huawei.com>
Date: Thu, 5 Sep 2013 11:54:00 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Jianguo Wu <wujianguo106@gmail.com>, <akpm@linux-foundation.org>,
        <aarcange@redhat.com>, <kirill.shutemov@linux.intel.com>,
        <mgorman@suse.de>, <xiaoguangrong@linux.vnet.ibm.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/thp: fix comments in transparent_hugepage_flags
References: <1378301422-9468-1-git-send-email-wujianguo@huawei.com> <5227e870.ab42320a.62d4.3d12SMTPIN_ADDED_BROKEN@mx.google.com> <5227F4B6.40009@huawei.com> <20130905033704.GA18909@hacker.(null)>
In-Reply-To: <20130905033704.GA18909@hacker.(null)>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/5 11:37, Wanpeng Li wrote:

> On Thu, Sep 05, 2013 at 11:04:22AM +0800, Jianguo Wu wrote:
>> Hi Wanpeng,
>>
>> On 2013/9/5 10:11, Wanpeng Li wrote:
>>
>>> Hi Jianguo,
>>> On Wed, Sep 04, 2013 at 09:30:22PM +0800, Jianguo Wu wrote:
>>>> Since commit d39d33c332(thp: enable direct defrag), defrag is enable
>>>> for all transparent hugepage page faults by default, not only in
>>>> MADV_HUGEPAGE regions.
>>>>
>>>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
>>>> ---
>>>> mm/huge_memory.c | 6 ++----
>>>> 1 file changed, 2 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index a92012a..abf047e 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -28,10 +28,8 @@
>>>>
>>>> /*
>>>>  * By default transparent hugepage support is enabled for all mappings
>>>
>>> This is also stale. TRANSPARENT_HUGEPAGE_ALWAYS is not configured by default in
>>> order that avoid to risk increase the memory footprint of applications w/o a 
>>> guaranteed benefit.
>>>
>>
>> Right, how about this:
>>
>> By default transparent hugepage support is disabled in order that avoid to risk
> 
> I don't think it's disabled. TRANSPARENT_HUGEPAGE_MADVISE is configured
> by default.
> 

Hi Wanpeng,

We have TRANSPARENT_HUGEPAGE and TRANSPARENT_HUGEPAGE_ALWAYS/TRANSPARENT_HUGEPAGE_MADVISE,
TRANSPARENT_HUGEPAGE_ALWAYS or TRANSPARENT_HUGEPAGE_MADVISE is configured only if TRANSPARENT_HUGEPAGE
is configured.

By default, TRANSPARENT_HUGEPAGE=n, and TRANSPARENT_HUGEPAGE_ALWAYS is configured when TRANSPARENT_HUGEPAGE=y.

commit 13ece886d9(thp: transparent hugepage config choice):

 config TRANSPARENT_HUGEPAGE
-       bool "Transparent Hugepage Support" if EMBEDDED
+       bool "Transparent Hugepage Support"
        depends on X86 && MMU
-       default y

+choice
+       prompt "Transparent Hugepage Support sysfs defaults"
+       depends on TRANSPARENT_HUGEPAGE
+       default TRANSPARENT_HUGEPAGE_ALWAYS

Thanks,
Jianguo Wu

> Regards,
> Wanpeng Li 
> 
>> increase the memory footprint of applications w/o a guaranteed benefit, and
>> khugepaged scans all mappings when transparent hugepage enabled.
>> Defrag is invoked by khugepaged hugepage allocations and by page faults for all
>> hugepage allocations.
>>
>> Thanks,
>> Jianguo Wu
>>
>>> Regards,
>>> Wanpeng Li 
>>>
>>>> - * and khugepaged scans all mappings. Defrag is only invoked by
>>>> - * khugepaged hugepage allocations and by page faults inside
>>>> - * MADV_HUGEPAGE regions to avoid the risk of slowing down short lived
>>>> - * allocations.
>>>> + * and khugepaged scans all mappings. Defrag is invoked by khugepaged
>>>> + * hugepage allocations and by page faults for all hugepage allocations.
>>>>  */
>>>> unsigned long transparent_hugepage_flags __read_mostly =
>>>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS
>>>> -- 
>>>> 1.8.1.2
>>>>
>>>> --
>>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>>> see: http://www.linux-mm.org/ .
>>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>>
>>> --
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>>>
>>>
>>
>>
> 
> 
> .
> 



