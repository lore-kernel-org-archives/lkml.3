Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbbAGJVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:21:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33287 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbbAGJVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:21:33 -0500
Message-ID: <54ACFA9A.8000405@suse.cz>
Date: Wed, 07 Jan 2015 10:21:30 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, David Rientjes <rientjes@google.com>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH V4 3/4] mm: reduce try_to_compact_pages parameters
References: <1420478263-25207-1-git-send-email-vbabka@suse.cz> <1420478263-25207-4-git-send-email-vbabka@suse.cz> <20150106145710.GD20860@dhcp22.suse.cz> <54ACF851.3040002@suse.cz> <20150107091813.GA16553@dhcp22.suse.cz>
In-Reply-To: <20150107091813.GA16553@dhcp22.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 10:18 AM, Michal Hocko wrote:
> On Wed 07-01-15 10:11:45, Vlastimil Babka wrote:
>> On 01/06/2015 03:57 PM, Michal Hocko wrote:
>> > Hmm, wait a minute
>> > 
>> > On Mon 05-01-15 18:17:42, Vlastimil Babka wrote:
>> > [...]
>> >> -unsigned long try_to_compact_pages(struct zonelist *zonelist,
>> >> -			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>> >> -			enum migrate_mode mode, int *contended,
>> >> -			int alloc_flags, int classzone_idx)
>> >> +unsigned long try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
>> >> +			int alloc_flags, const struct alloc_context *ac,
>> >> +			enum migrate_mode mode, int *contended)
>> >>  {
>> >> -	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>> >>  	int may_enter_fs = gfp_mask & __GFP_FS;
>> >>  	int may_perform_io = gfp_mask & __GFP_IO;
>> >>  	struct zoneref *z;
>> > 
>> > gfp_mask might change since the high_zoneidx was set up in the call
>> > chain. I guess this shouldn't change to the gfp_zone output but it is
>> > worth double checking.
>> 
>> Yeah I checked that. gfp_zone() operates just on GFP_ZONEMASK part of the flags,
>> and we don't change that.
> 
> That was my understanding as well. Maybe we want
> VM_BUG_ON(gfp_zone(gfp_mask) != ac->high_zoneidx);

That sounds like an arbitrary overkill to me. I think that gfp_zone() was just
used here to save an extra parameter.
