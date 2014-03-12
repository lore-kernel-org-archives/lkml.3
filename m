Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbaCLMQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:16:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbaCLMQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:16:32 -0400
Message-ID: <53205014.2050602@redhat.com>
Date: Wed, 12 Mar 2014 08:16:20 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>
CC: Sasha Levin <sasha.levin@oracle.com>, David Rientjes <rientjes@google.com>,
        hhuang@redhat.com, knoel@redhat.com, aarcange@redhat.com,
        Davidlohr Bueso <davidlohr@hp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: numa: Recheck for transhuge pages under lock during
 protection changes
References: <20140307140650.GA1931@suse.de> <20140307150923.GB1931@suse.de> <20140307182745.GD1931@suse.de> <20140311162845.GA30604@suse.de> <531F3F15.8050206@oracle.com> <531F4128.8020109@redhat.com> <531F48CC.303@oracle.com> <20140311180652.GM10663@suse.de> <531F616A.7060300@oracle.com> <20140311122859.fb6c1e772d82d9f4edd02f52@linux-foundation.org> <20140312103602.GN10663@suse.de>
In-Reply-To: <20140312103602.GN10663@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2014 06:36 AM, Mel Gorman wrote:
> Andrew, this should go with the patches 
> mmnuma-reorganize-change_pmd_range.patch
> mmnuma-reorganize-change_pmd_range-fix.patch
> move-mmu-notifier-call-from-change_protection-to-change_pmd_range.patch
> in mmotm please.
> 
> Thanks.

That would be nice indeed :)

I am still not entirely sure why the kernel did not hit this race
before my reorganize change_pmd_range patch. Maybe gcc used to do
one load and now it does two?

> The problem is that a transhuge check is made without holding the PTL. It's
> possible at the time of the check that a parallel fault clears the pmd
> and inserts a new one which then triggers the VM_BUG_ON check.  This patch
> removes the VM_BUG_ON but fixes the race by rechecking transhuge under the
> PTL when marking page tables for NUMA hinting and bailing if a race occurred.
> It is not a problem for calls to mprotect() as they hold mmap_sem for write.
> 
> Reported-by: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
