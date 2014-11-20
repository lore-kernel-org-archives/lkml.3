Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756AbaKTPuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:50:08 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:59475 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaKTPuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:50:05 -0500
Date: Thu, 20 Nov 2014 10:49:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>,
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
Message-ID: <20141120154937.GA325@phnom.home.cmpxchg.org>
References: <20141119205208.812884198@linuxfoundation.org>
 <20141119205212.209198738@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119205212.209198738@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 12:52:32PM -0800, Greg Kroah-Hartman wrote:
> 3.14-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> commit 0cd6144aadd2afd19d1aca880153530c52957604 upstream.
> 
> shmem mappings already contain exceptional entries where swap slot
> information is remembered.
> 
> To be able to store eviction information for regular page cache, prepare
> every site dealing with the radix trees directly to handle entries other
> than pages.

I don't see the rest of the thrash-detection patches in this series.
Without anybody actually planting "entries other than pages" in the
radix trees, why is this needed in -stable?
