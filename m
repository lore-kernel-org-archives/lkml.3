Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LLXkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 18:40:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:62507 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831Ab3LLXkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 18:40:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,475,1384329600"; 
   d="scan'208";a="449233537"
Date: Thu, 12 Dec 2013 15:40:38 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Christoph Lameter <cl@linux.com>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kirill.shutemov@linux.intel.com
Subject: Re: [RFC][PATCH 2/3] mm: slab: move around slab ->freelist for
 cmpxchg
Message-ID: <20131212234038.GQ22695@tassilo.jf.intel.com>
References: <20131211224022.AA8CF0B9@viggo.jf.intel.com>
 <20131211224025.70B40B9C@viggo.jf.intel.com>
 <00000142e7ea519d-8906d225-c99c-44b5-b381-b573c75fd097-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000142e7ea519d-8906d225-c99c-44b5-b381-b573c75fd097-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 05:46:02PM +0000, Christoph Lameter wrote:
> On Wed, 11 Dec 2013, Dave Hansen wrote:
> 
> >
> > The write-argument to cmpxchg_double() must be 16-byte aligned.
> > We used to align 'struct page' itself in order to guarantee this,
> > but that wastes 8-bytes per page.  Instead, we take 8-bytes
> > internal to the page before page->counters and move freelist
> > between there and the existing 8-bytes after counters.  That way,
> > no matter how 'stuct page' itself is aligned, we can ensure that
> > we have a 16-byte area with which to to this cmpxchg.
> 
> Well this adds additional branching to the fast paths.

The branch should be predictible and compare the cost of a branch
(near nothing on a modern OOO CPU with low IPC code like this when
predicted) to the cost of a cache miss (due to larger struct page)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
