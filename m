Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751985Ab3DEEF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:05:57 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:60034 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab3DEEFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:05:55 -0400
Message-ID: <515E4D99.5090603@gmail.com>
Date: Fri, 05 Apr 2013 12:05:45 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Dave Hansen <dave@sr71.net>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2, RFC 12/30] thp, mm: add event counters for huge page
 alloc on write to a file
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com> <1363283435-7666-13-git-send-email-kirill.shutemov@linux.intel.com> <514B4A9F.5090004@sr71.net> <20130326084012.CEF0AE0085@blue.fi.intel.com>
In-Reply-To: <20130326084012.CEF0AE0085@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kirill,
On 03/26/2013 04:40 PM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 03/14/2013 10:50 AM, Kirill A. Shutemov wrote:
>>> --- a/include/linux/vm_event_item.h
>>> +++ b/include/linux/vm_event_item.h
>>> @@ -71,6 +71,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>>>   		THP_FAULT_FALLBACK,
>>>   		THP_COLLAPSE_ALLOC,
>>>   		THP_COLLAPSE_ALLOC_FAILED,
>>> +		THP_WRITE_ALLOC,
>>> +		THP_WRITE_FAILED,
>>>   		THP_SPLIT,
>>>   		THP_ZERO_PAGE_ALLOC,
>>>   		THP_ZERO_PAGE_ALLOC_FAILED,
>> I think these names are a bit terse.  It's certainly not _writes_ that
>> are failing and "THP_WRITE_FAILED" makes it sound that way.
> Right. s/THP_WRITE_FAILED/THP_WRITE_ALLOC_FAILED/
>
>> Also, why do we need to differentiate these from the existing anon-hugepage
>> vm stats?  The alloc_pages() call seems to be doing the exact same thing in
>> the end.  Is one more likely to succeed than the other?
> Existing stats specify source of thp page: fault or collapse. When we
> allocate a new huge page with write(2) it's nither fault nor collapse. I
> think it's reasonable to introduce new type of event for that.

Why when we allocated a new huge page with write(2) is not a write fault?

>

