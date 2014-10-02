Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaJBS6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:58:49 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50978 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaJBS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:58:47 -0400
Message-ID: <542DA038.9000908@oracle.com>
Date: Thu, 02 Oct 2014 14:58:00 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
CC: Dave Jones <davej@redhat.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>,
        Michel Lespinasse <walken@google.com>,
        Kirill A Shutemov <kirill.shutemov@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] mm: numa: Do not mark PTEs pte_numa when splitting
 huge pages
References: <1412256558-9995-1-git-send-email-mgorman@suse.de>	<1412256558-9995-5-git-send-email-mgorman@suse.de> <CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>
In-Reply-To: <CA+55aFzJtoEXEzoyYQ=j+AMxyZNL3Gr3bhXPr3twyuGzvES1PA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/2014 12:36 PM, Linus Torvalds wrote:
> On Thu, Oct 2, 2014 at 6:29 AM, Mel Gorman <mgorman@suse.de> wrote:
>> > This patch reverts 1ba6e0b50b ("mm: numa: split_huge_page: transfer the
>> > NUMA type from the pmd to the pte"). If a huge page is being split due
>> > a protection change and the tail will be in a PROT_NONE vma then NUMA
>> > hinting PTEs are temporarily created in the protected VMA.
> So this is the particular bug I was worried about when tracing through the code.
> 
> Should I just apply this as-is? And mark it for stable, since this has
> been around since 3.8 or so. It would seem to be a very safe change to
> do, regardless of whether this is actually the issue that Dave and
> maybe Sasha are seeing.
> 
> Sasha, I notice that you weren't on the cc for Mel's patches (probably
> because you got added later to the other thread), but they were all
> cc'd to lkml so you should see them there. Or I can forward them
> separately.

I grabbed them and will keep them in my tree for now instead of your
NUMA-chainsaw-massacre patch.

You've also mentioned that while I can tell you if nothing dies, I can't
really tell you if everything is working well. Is there a reasonable way
to easily say if NUMA is working properly? Even something that would just
tell me "your NUMA balancing seems to be sane" would be good.


Thanks,
Sasha
