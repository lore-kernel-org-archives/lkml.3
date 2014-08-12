Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbaHLD3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 23:29:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35947 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaHLD3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 23:29:41 -0400
Message-ID: <53E989FB.5000904@oracle.com>
Date: Mon, 11 Aug 2014 23:28:59 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: mm: BUG in unmap_page_range
References: <53DD5F20.8010507@oracle.com> <alpine.LSU.2.11.1408040418500.3406@eggly.anvils> <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils> <53E17F06.30401@oracle.com>
In-Reply-To: <53E17F06.30401@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 09:04 PM, Sasha Levin wrote:
> Thanks Hugh, Mel. I've added both patches to my local tree and will update tomorrow
> with the weather.
> 
> Also:
> 
> On 08/05/2014 08:42 PM, Hugh Dickins wrote:
>> One thing I did wonder, though: at first I was reassured by the
>> VM_BUG_ON(!pte_present(pte)) you add to pte_mknuma(); but then thought
>> it would be better as VM_BUG_ON(!(val & _PAGE_PRESENT)), being stronger
>> - asserting that indeed we do not put NUMA hints on PROT_NONE areas.
>> (But I have not tested, perhaps such a VM_BUG_ON would actually fire.)
> 
> I've added VM_BUG_ON(!(val & _PAGE_PRESENT)) in just as a curiosity, I'll
> update how that one looks as well.

Sorry for the rather long delay.

The patch looks fine, the issue didn't reproduce.

The added VM_BUG_ON didn't trigger either, so maybe we should consider adding
it in.


Thanks,
Sasha

