Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840Ab3E1Qdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:33:41 -0400
Received: from www.sr71.net ([198.145.64.142]:37468 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934675Ab3E1Qdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:33:39 -0400
Message-ID: <51A4DC5F.7050406@sr71.net>
Date: Tue, 28 May 2013 09:33:35 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
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
Subject: Re: [PATCHv4 15/39] thp, mm: trigger bug in replace_page_cache_page()
 on THP
References: <1368321816-17719-1-git-send-email-kirill.shutemov@linux.intel.com> <1368321816-17719-16-git-send-email-kirill.shutemov@linux.intel.com> <519BD65C.1050709@sr71.net> <20130528125328.5385CE0090@blue.fi.intel.com>
In-Reply-To: <20130528125328.5385CE0090@blue.fi.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 05:53 AM, Kirill A. Shutemov wrote:
> Dave Hansen wrote:
>> On 05/11/2013 06:23 PM, Kirill A. Shutemov wrote:
>>> +	VM_BUG_ON(PageTransHuge(old));
>>> +	VM_BUG_ON(PageTransHuge(new));
>>>  	VM_BUG_ON(!PageLocked(old));
>>>  	VM_BUG_ON(!PageLocked(new));
>>>  	VM_BUG_ON(new->mapping);
>>
>> The code calling replace_page_cache_page() has a bunch of fallback and
>> error returning code.  It seems a little bit silly to bring the whole
>> machine down when you could just WARN_ONCE() and return an error code
>> like fuse already does:
> 
> What about:
> 
> 	if (WARN_ONCE(PageTransHuge(old) || PageTransHuge(new),
> 		     "%s: unexpected huge page\n", __func__))
> 		return -EINVAL;

That looks sane to me.  But, please do make sure to differentiate in the
error message between thp and hugetlbfs (if you have the room).

BTW, I'm also not sure you need to print the function name.  The
WARN_ON() register dump usually has the function name.
