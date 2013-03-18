Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3CRL3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 07:29:35 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61782 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3CRL33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 07:29:29 -0400
Message-ID: <5146FA90.6070906@gmail.com>
Date: Mon, 18 Mar 2013 19:29:20 +0800
From: Simon Jeons <simon.jeons@gmail.com>
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
Subject: Re: [PATCHv2, RFC 00/30] Transparent huge page cache
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <514691F5.2040204@gmail.com> <5146A4CC.3060306@gmail.com> <20130318111939.C8206E0085@blue.fi.intel.com>
In-Reply-To: <20130318111939.C8206E0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,
On 03/18/2013 07:19 PM, Kirill A. Shutemov wrote:
> Simon Jeons wrote:
>> On 03/18/2013 12:03 PM, Simon Jeons wrote:
>>> Hi Kirill,
>>> On 03/15/2013 01:50 AM, Kirill A. Shutemov wrote:
>>>> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>>>>
>>>> Here's the second version of the patchset.
>>>>
>>>> The intend of the work is get code ready to enable transparent huge page
>>>> cache for the most simple fs -- ramfs.
>>>>
>>>> We have read()/write()/mmap() functionality now. Still plenty work
>>>> ahead.
>>> One offline question.
>>>
>>> Why set PG_mlocked to page_tail which be splited in function
>>> __split_huge_page_refcount?
> Not set, but copied from head page. Head page represents up-to-date sate
> of compound page, we need to copy it to all tail pages on split.

I always see up-to-date state, could you conclude to me which state can 
be treated as up-to-date? :-)

>   
>> Also why can't find where _PAGE_SPLITTING and _PAGE_PSE flags are
>> cleared in split_huge_page path?
>   
> The pmd is invalidated and replaced with reference to page table at the end
> of __split_huge_page_map.

Since pmd is populated by page table and new flag why need 
invalidated(clear present flag) before it?

>   
>> Another offline question:
>> Why don't clear tail page PG_tail flag in function
>> __split_huge_page_refcount?
> We do:
>
>   page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP | __PG_HWPOISON;
>

Got it.
