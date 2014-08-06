Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbaHFBEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:04:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27212 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaHFBEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:04:49 -0400
Message-ID: <53E17F06.30401@oracle.com>
Date: Tue, 05 Aug 2014 21:04:06 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
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
References: <53DD5F20.8010507@oracle.com> <alpine.LSU.2.11.1408040418500.3406@eggly.anvils> <20140805144439.GW10819@suse.de> <alpine.LSU.2.11.1408051649330.6591@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1408051649330.6591@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Hugh, Mel. I've added both patches to my local tree and will update tomorrow
with the weather.

Also:

On 08/05/2014 08:42 PM, Hugh Dickins wrote:
> One thing I did wonder, though: at first I was reassured by the
> VM_BUG_ON(!pte_present(pte)) you add to pte_mknuma(); but then thought
> it would be better as VM_BUG_ON(!(val & _PAGE_PRESENT)), being stronger
> - asserting that indeed we do not put NUMA hints on PROT_NONE areas.
> (But I have not tested, perhaps such a VM_BUG_ON would actually fire.)

I've added VM_BUG_ON(!(val & _PAGE_PRESENT)) in just as a curiosity, I'll
update how that one looks as well.


Thanks,
Sasha
