Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaDIGVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:21:09 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37256 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932556AbaDIGVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:21:07 -0400
Date: Wed, 9 Apr 2014 08:21:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Steven Noonan <steven@uplinklabs.net>, Rik van Riel <riel@redhat.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Use an alternative to _PAGE_PROTNONE for
 _PAGE_NUMA v2
Message-ID: <20140409062103.GA7294@gmail.com>
References: <1396962570-18762-1-git-send-email-mgorman@suse.de>
 <53440A5D.6050301@zytor.com>
 <CA+55aFwc6Jdf+As9RJ3wJWuOGEGmiaYWNa-jp2aCb9=ZiiqV+A@mail.gmail.com>
 <20140408164652.GL7292@suse.de>
 <20140408173031.GS10526@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408173031.GS10526@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Apr 08, 2014 at 05:46:52PM +0100, Mel Gorman wrote:
> > Someone will ask why automatic NUMA balancing hints do not use "real"
> > PROT_NONE but as it would need VMA information to do that on all
> > architectures it would mean that VMA-fixups would be required when marking
> > PTEs for NUMA hinting faults so would be expensive.
> 
> Like this:
> 
>   https://lkml.org/lkml/2012/11/13/431
> 
> That used the generic PROT_NONE infrastructure and compared, on fault,
> the page protection bits against the vma->vm_page_prot bits?
> 
> So the objection to that approach was the vma-> dereference in
> pte_numa() ?

I think the real underlying objection was that PTE_NUMA was the last 
leftover from AutoNUMA, and removing it would have made it not a 
'compromise' patch set between 'AutoNUMA' and 'sched/numa', but would 
have made the sched/numa approach 'win' by and large.

The whole 'losing face' annoyance that plagues all of us (me 
included).

I didn't feel it was important to the general logic of adding access 
pattern aware NUMA placement logic to the scheduler, and I obviously 
could not ignore the NAKs from various mm folks insisting on PTE_NUMA, 
so I conceded that point and Mel built on that approach as well.

Nice it's being cleaned up, and I'm pretty happy about how NUMA 
balancing ended up looking like.

Thanks,

	Ingo
