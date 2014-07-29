Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaG2Gz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 02:55:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:47181 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaG2Gzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 02:55:52 -0400
Message-ID: <53D74564.90302@huawei.com>
Date: Tue, 29 Jul 2014 14:55:32 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>
CC: David Rientjes <rientjes@google.com>, <shaohui.zheng@intel.com>,
        <mgorman@suse.de>, <mingo@redhat.com>, Linux MM <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <wangnan0@huawei.com>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH] memory hotplug: update the variables after memory removed
References: <1406550617-19556-1-git-send-email-zhenzhang.zhang@huawei.com> <53D642E5.2010305@huawei.com> <53D6685C.1060509@intel.com> <alpine.DEB.2.02.1407281610340.8998@chino.kir.corp.google.com> <53D6DB9C.7030109@intel.com>
In-Reply-To: <53D6DB9C.7030109@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/29 7:24, Dave Hansen wrote:
> On 07/28/2014 04:12 PM, David Rientjes wrote:
>> I agree, but I'm not sure the suggestion is any better than the patch.  I 
>> think it would be better to just figure out whether anything needs to be 
>> updated in the caller and then call a generic function.
>>
>> So in arch_add_memory(), do
>>
>> 	end_pfn = PFN_UP(start + size);
>> 	if (end_pfn > max_pfn)
>> 		update_end_of_memory_vars(end_pfn);
>>
>> and in arch_remove_memory(),
>>
>> 	end_pfn = PFN_UP(start);
>> 	if (end_pfn < max_pfn)
>> 		update_end_of_memory_vars(end_pfn);
>>
>> and then update_end_of_memory_vars() becomes a three-liner.
> 
> That does look better than my suggestion, generally.
> 
> It is broken in the remove case, though.  In your example, the memory
> being removed is assumed to be coming from the end of memory, and that
> isn't always the case.  I think you need something like:
> 
> 	if ((max_pfn >= start_pfn) && (max_pfn < end_pfn)
> 		update_end_of_memory_vars(start);
> 
> But, yeah, that's a lot better than new functions.
> 
Thanks for your comments!

I will change according to your suggestions.
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
> 


