Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaJUKlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 06:41:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59353 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228AbaJUKlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 06:41:47 -0400
Date: Tue, 21 Oct 2014 12:41:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        laijs@cn.fujitsu.com, dave@stgolabs.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 5/6] mm: Provide speculative fault infrastructure
Message-ID: <20141021104130.GA12706@worktop.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141020222841.490529442@infradead.org>
 <20141021083548.GA22200@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021083548.GA22200@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:35:48AM +0300, Kirill A. Shutemov wrote:
> pud_huge() too. Or filter out VM_HUGETLB altogether.

Oh right, giga pages, all this new fangled stuff ;-) But yes, I suppose
we can exclude hugetlbfs, we should arguably make the thp muck work
though.

> BTW, what keeps mm_struct around? It seems we don't take reference during
> page fault.

Last I checked tasks have a ref on their own mm, and seeing this all
runs in task context, the mm should be pretty safe.
