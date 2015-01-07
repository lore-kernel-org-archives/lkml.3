Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbbAGJSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:18:20 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:53683 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbAGJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:18:17 -0500
X-Greylist: delayed 170819 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Jan 2015 04:18:17 EST
Date: Wed, 7 Jan 2015 10:18:13 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 3/4] mm: reduce try_to_compact_pages parameters
Message-ID: <20150107091813.GA16553@dhcp22.suse.cz>
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz>
 <1420478263-25207-4-git-send-email-vbabka@suse.cz>
 <20150106145710.GD20860@dhcp22.suse.cz>
 <54ACF851.3040002@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ACF851.3040002@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-01-15 10:11:45, Vlastimil Babka wrote:
> On 01/06/2015 03:57 PM, Michal Hocko wrote:
> > Hmm, wait a minute
> > 
> > On Mon 05-01-15 18:17:42, Vlastimil Babka wrote:
> > [...]
> >> -unsigned long try_to_compact_pages(struct zonelist *zonelist,
> >> -			int order, gfp_t gfp_mask, nodemask_t *nodemask,
> >> -			enum migrate_mode mode, int *contended,
> >> -			int alloc_flags, int classzone_idx)
> >> +unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
> >> +			int alloc_flags, const struct alloc_context *ac,
> >> +			enum migrate_mode mode, int *contended)
> >>  {
> >> -	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
> >>  	int may_enter_fs = gfp_mask & __GFP_FS;
> >>  	int may_perform_io = gfp_mask & __GFP_IO;
> >>  	struct zoneref *z;
> > 
> > gfp_mask might change since the high_zoneidx was set up in the call
> > chain. I guess this shouldn't change to the gfp_zone output but it is
> > worth double checking.
> 
> Yeah I checked that. gfp_zone() operates just on GFP_ZONEMASK part of the flags,
> and we don't change that.

That was my understanding as well. Maybe we want
VM_BUG_ON(gfp_zone(gfp_mask) != ac->high_zoneidx);
-- 
Michal Hocko
SUSE Labs
