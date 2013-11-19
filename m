Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab3KSWxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:53:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab3KSWxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:53:21 -0500
Date: Tue, 19 Nov 2013 23:52:52 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pravin Shelar <pshelar@nicira.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Christoph Lameter <cl@linux.com>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] mm: hugetlbfs: fix hugetlbfs optimization v2
Message-ID: <20131119225252.GD10493@redhat.com>
References: <1384537668-10283-1-git-send-email-aarcange@redhat.com>
 <528A56A7.3020301@oracle.com>
 <528BC9AA.5020300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528BC9AA.5020300@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5~Hi Khalid,

On Tue, Nov 19, 2013 at 01:27:22PM -0700, Khalid Aziz wrote:
> > Block size        3.12         3.12+patch 1      3.12+patch 1,2,3
> > ----------        ----         ------------      ----------------
> > 1M                8467           8114              7648
> > 64K               4049           4043              4175
> >
> > Performance numbers with 64K reads look good but there is further
> > deterioration with 1M reads.
> >
> > --
> > Khalid
> 
> Hi Andrea,
> 
> I found that a background task running on my test server had influenced 
> the performance numbers for 1M reads. I cleaned that problem up and 
> re-ran the test. I am seeing 8456 MB/sec with all three patches applied, 
> so 1M number is looking good as well.

Good news thanks!

1/3 should go in -mm I think as it fixes many problems.

The rest can be applied with less priority and is not as urgent.

I've also tried to optimize it further in the meantime as I thought it
wasn't fully ok yet. So I could send another patchset. I haven't
changed 1/3 and I don't plan changing it. And I kept 3/3 at the end as
it's the one with a bit more of complexity than the rest.

I basically removed a few more atomic ops for each put_page/get_page
for both hugetlbfs and slab, and the important thing is they're zero
cost changes for the non-hugetlbfs/slab fast paths so they're probably
worth it.
