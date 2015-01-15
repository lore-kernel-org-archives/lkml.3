Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbbAOH4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:56:24 -0500
Received: from mx2.parallels.com ([199.115.105.18]:43215 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbbAOH4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 02:56:23 -0500
Date: Thu, 15 Jan 2015 10:56:10 +0300
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] vmscan: move reclaim_state handling to shrink_slab
Message-ID: <20150115075610.GF11264@esperanza>
References: <1421243736-21367-1-git-send-email-vdavydov@parallels.com>
 <20150114153449.038bc61b1bd6fc262f9cea01@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150114153449.038bc61b1bd6fc262f9cea01@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:34:49PM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2015 16:55:36 +0300 Vladimir Davydov <vdavydov@parallels.com> wrote:
> > This patch also makes shrink_slab() return the number of reclaimed slab
> > pages (obtained from reclaim_state) instead of the number of reclaimed
> > objects, because the latter is not of much use - it was only checked by
> > drop_slab() to decide whether it should continue reclaim or abort. The
> > number of reclaimed pages is more appropriate, because it also can be
> > used by shrink_zone() to accumulate scan_control->nr_reclaimed.
> 
> Not sure that this is a good change.  If shrink_slab() managed to free
> some objects but didn't free any pages then that's a good sign that
> additional calls to shrink_slab() *will* free some pages.  With this
> change, drop_slab_node() can give up too early.

Fair enough. We'd better leave the return value intact then. I think we
should add an additional argument to add the number of reclaimed slab
pages to, as I intended to do initially. Will resend.

Thanks,
Vladimir
