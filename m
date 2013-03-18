Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab3CRLmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:42:45 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:45406 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3CRLmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:42:43 -0400
Message-ID: <5146FDAA.3040100@gmail.com>
Date: Mon, 18 Mar 2013 19:42:34 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Simon Jeons <simon.jeons@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 00/30] Transparent huge page cache
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <514691F5.2040204@gmail.com> <5146A4CC.3060306@gmail.com> <20130318111939.C8206E0085@blue.fi.intel.com> <5146FA90.6070906@gmail.com> <20130318114221.5C5A3E0085@blue.fi.intel.com>
In-Reply-To: <20130318114221.5C5A3E0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2013 07:42 PM, Kirill A. Shutemov wrote:
> Simon Jeons wrote:
>> Hi Kirill,
>> On 03/18/2013 07:19 PM, Kirill A. Shutemov wrote:
>>> Simon Jeons wrote:
>>>> On 03/18/2013 12:03 PM, Simon Jeons wrote:
>>>>> Hi Kirill,
>>>>> On 03/15/2013 01:50 AM, Kirill A. Shutemov wrote:
>>>>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>>>>>
>>>>>> Here's the second version of the patchset.
>>>>>>
>>>>>> The intend of the work is get code ready to enable transparent huge page
>>>>>> cache for the most simple fs -- ramfs.
>>>>>>
>>>>>> We have read()/write()/mmap() functionality now. Still plenty work
>>>>>> ahead.
>>>>> One offline question.
>>>>>
>>>>> Why set PG_mlocked to page_tail which be splited in function
>>>>> __split_huge_page_refcount?
>>> Not set, but copied from head page. Head page represents up-to-date sate
>>> of compound page, we need to copy it to all tail pages on split.
>> I always see up-to-date state, could you conclude to me which state can
>> be treated as up-to-date? :-)
> While we work with huge page we only alter flags (like mlocked or
> uptodate) of head page, but not tail, so we have to copy flags to all tail
> pages on split. We also need to distribute _count and _mapcount properly.
> Just read the code.

Sorry, you can treat this question as an offline one and irrelevant thp. 
Which state of page can be treated as up-to-date?

>
>>>    
>>>> Also why can't find where _PAGE_SPLITTING and _PAGE_PSE flags are
>>>> cleared in split_huge_page path?
>>>    
>>> The pmd is invalidated and replaced with reference to page table at the end
>>> of __split_huge_page_map.
>> Since pmd is populated by page table and new flag why need
>> invalidated(clear present flag) before it?
> Comment just before pmdp_invalidate() in __split_huge_page_map() is fairly
> informative.
>

