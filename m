Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbbAMVfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:35:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:45061 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbbAMVfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:35:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511774541"
Message-ID: <54B58F9B.4050100@linux.intel.com>
Date: Tue, 13 Jan 2015 13:35:23 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: rename mm->nr_ptes to mm->nr_pgtables
References: <1421176456-21796-1-git-send-email-kirill.shutemov@linux.intel.com> <1421176456-21796-2-git-send-email-kirill.shutemov@linux.intel.com> <54B581C7.50206@linux.intel.com> <20150113204144.GA1865@node.dhcp.inet.fi>
In-Reply-To: <20150113204144.GA1865@node.dhcp.inet.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 12:41 PM, Kirill A. Shutemov wrote:
> On Tue, Jan 13, 2015 at 12:36:23PM -0800, Dave Hansen wrote:
>> On 01/13/2015 11:14 AM, Kirill A. Shutemov wrote:
>>>  	pgd_t * pgd;
>>>  	atomic_t mm_users;			/* How many users with user space? */
>>>  	atomic_t mm_count;			/* How many references to "struct mm_struct" (users count as 1) */
>>> -	atomic_long_t nr_ptes;			/* Page table pages */
>>> +	atomic_long_t nr_pgtables;		/* Page table pages */
>>>  	int map_count;				/* number of VMAs */
>>
>> One more crazy idea...
>>
>> There are 2^9 possible pud pages, 2^18 pmd pages and 2^27 pte pages.
>> That's only 54 bits (technically minus one bit each because the upper
>> half of the address space is for the kernel).
> 
> Does this math make sense for all architecures? IA64? Power?

No, the sizes will be different on the other architectures.  But, 4k
pages with 64-bit ptes is as bad as it gets, I think.  Larger page sizes
mean fewer page tables on powerpc.  So the values should at least _fit_
in a long.

Maybe it's not even worth the trouble.

