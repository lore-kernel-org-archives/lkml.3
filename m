Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbaKTQVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:21:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757466AbaKTQVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:21:30 -0500
Date: Thu, 20 Nov 2014 16:21:22 +0000
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>,
        Metin Doslu <metin@citusdata.com>,
        Michel Lespinasse <walken@google.com>,
        Ozgun Erdogan <ozgun@citusdata.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Roman Gushchin <klamm@yandex-team.ru>, Ryan Mallon <rmallon@gmail.com>,
        Tejun Heo <tj@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.14 102/122] mm + fs: prepare for non-page entries in
 page cache radix trees
Message-ID: <20141120162122.GS2725@suse.de>
References: <20141119205208.812884198@linuxfoundation.org>
 <20141119205212.209198738@linuxfoundation.org>
 <20141120154937.GA325@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20141120154937.GA325@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 10:49:37AM -0500, Johannes Weiner wrote:
> On Wed, Nov 19, 2014 at 12:52:32PM -0800, Greg Kroah-Hartman wrote:
> > 3.14-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > commit 0cd6144aadd2afd19d1aca880153530c52957604 upstream.
> > 
> > shmem mappings already contain exceptional entries where swap slot
> > information is remembered.
> > 
> > To be able to store eviction information for regular page cache, prepare
> > every site dealing with the radix trees directly to handle entries other
> > than pages.
> 
> I don't see the rest of the thrash-detection patches in this series.
> Without anybody actually planting "entries other than pages" in the
> radix trees, why is this needed in -stable?

Patches later on in the stable series depended upon the code structure
introduced by this patch even though the thrash-detection stuff was not
backported. It could have been backported without it but then the
patches would look much different from their mainline equivalent.

-- 
Mel Gorman
SUSE Labs
