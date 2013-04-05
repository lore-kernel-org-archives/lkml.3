Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161560Ab3DEDsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 23:48:17 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58540 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390Ab3DEDsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 23:48:15 -0400
Message-ID: <515E4977.3040002@gmail.com>
Date: Fri, 05 Apr 2013 11:48:07 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 07/30] thp, mm: introduce mapping_can_have_hugepages()
 predicate
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-8-git-send-email-kirill.shutemov@linux.intel.com> <515E48D1.2090505@gmail.com>
In-Reply-To: <515E48D1.2090505@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2013 11:45 AM, Ric Mason wrote:
> Hi Kirill,
> On 03/15/2013 01:50 AM, Kirill A. Shutemov wrote:
>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>
>> Returns true if mapping can have huge pages. Just check for __GFP_COMP
>> in gfp mask of the mapping for now.
>>
>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> ---
>>   include/linux/pagemap.h |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>> index e3dea75..3521b0d 100644
>> --- a/include/linux/pagemap.h
>> +++ b/include/linux/pagemap.h
>> @@ -84,6 +84,16 @@ static inline void mapping_set_gfp_mask(struct 
>> address_space *m, gfp_t mask)
>>                   (__force unsigned long)mask;
>>   }
>>   +static inline bool mapping_can_have_hugepages(struct address_space 
>> *m)
>> +{
>> +    if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>> +        gfp_t gfp_mask = mapping_gfp_mask(m);
>> +        return !!(gfp_mask & __GFP_COMP);
>
> I always see !! in kernel, but why check directly instead of have !! 
> prefix?

s/why/why not

>
>> +    }
>> +
>> +    return false;
>> +}
>> +
>>   /*
>>    * The page cache can done in larger chunks than
>>    * one page, because it allows for more efficient
>

