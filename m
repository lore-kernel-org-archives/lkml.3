Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab3KZU60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:58:26 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:42119 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757480Ab3KZU6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:58:22 -0500
Date: Tue, 26 Nov 2013 15:57:41 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Rik van Riel <riel@redhat.com>,
        Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Greg Thelen <gthelen@google.com>,
        Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        Ozgun Erdogan <ozgun@citusdata.com>, Metin Doslu <metin@citusdata.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 7/9] mm: thrash detection-based file cache sizing
Message-ID: <20131126205741.GF22729@cmpxchg.org>
References: <1385336308-27121-1-git-send-email-hannes@cmpxchg.org>
 <1385336308-27121-8-git-send-email-hannes@cmpxchg.org>
 <5293FFC7.5070907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5293FFC7.5070907@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:56:23PM +1100, Ryan Mallon wrote:
> > + *   fault ------------------------+
> > + *                                 |
> > + *              +--------------+   |            +-------------+
> > + *   reclaim <- |   inactive   | <-+-- demotion |    active   | <--+
> > + *              +--------------+                +-------------+    |
> > + *                     |                                           |
> > + *                     +-------------- promotion ------------------+
> > + *
> > + *
> > + *		Access frequency and refault distance
> > + *
> > + * A workload is trashing when its pages are frequently used but they
> 
> "thrashing".

Thanks ;)
