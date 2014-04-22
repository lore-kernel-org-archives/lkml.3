Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbaDVViH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:38:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbaDVVh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:37:59 -0400
Date: Tue, 22 Apr 2014 17:37:26 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        aarcange@redhat.com, mgorman@suse.de, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com,
        kirill@shutemov.name
Subject: Re: [PATCH v3 0/5] hugetlb: add support gigantic page allocation at
 runtime
Message-ID: <20140422173726.738d0635@redhat.com>
In-Reply-To: <20140417160110.3f36b972b25525fbbe23681b@linux-foundation.org>
References: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
	<20140417160110.3f36b972b25525fbbe23681b@linux-foundation.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 16:01:10 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 10 Apr 2014 13:58:40 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
> > The HugeTLB subsystem uses the buddy allocator to allocate hugepages during
> > runtime. This means that hugepages allocation during runtime is limited to
> > MAX_ORDER order. For archs supporting gigantic pages (that is, page sizes
> > greater than MAX_ORDER), this in turn means that those pages can't be
> > allocated at runtime.
> 
> Dumb question: what's wrong with just increasing MAX_ORDER?

To be honest I'm not a buddy allocator expert and I'm not familiar with
what is involved in increasing MAX_ORDER. What I do know though is that it's
not just a matter of increasing a macro's value. For example, for sparsemem
support we have this check (include/linux/mmzone.h:1084):

#if (MAX_ORDER - 1 + PAGE_SHIFT) > SECTION_SIZE_BITS
#error Allocator MAX_ORDER exceeds SECTION_SIZE
#endif

I _guess_ it's because we can't allocate more pages than what's within a
section on sparsemem. Can sparsemem and the other stuff be changed to
accommodate a bigger MAX_ORDER? I don't know. Is it worth it to increase
MAX_ORDER and do all the required changes, given that a bigger MAX_ORDER is
only useful for HugeTLB and the archs supporting gigantic pages? I'd guess not.
