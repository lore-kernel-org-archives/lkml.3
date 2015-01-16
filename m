Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbbAPTCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:02:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbbAPTCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:02:08 -0500
Message-ID: <54B9602E.70707@suse.cz>
Date: Fri, 16 Jan 2015 20:02:06 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        Mel Gorman <mgorman@suse.de>, Suleiman Souhlal <suleiman@google.com>,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm/vmscan: fix highidx argument type
References: <1421360175-18899-1-git-send-email-mst@redhat.com> <20150115144920.33c446af388ed74c11dc573e@linux-foundation.org> <20150116070744.GA12190@redhat.com> <54B95E41.5010305@suse.cz>
In-Reply-To: <54B95E41.5010305@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2015 07:53 PM, Vlastimil Babka wrote:
> BTW, I wonder if the whole code couldn't be much simpler by capping high_zoneidx
> by ZONE_NORMAL before traversing the zonelist, like this:
> 
> int high_zoneidx = min(gfp_zone(gfp_mask), ZONE_NORMAL);
> 
> first_zones_zonelist(zonelist, high_zoneidx, NULL, &zone);

Erm, s/NULL/nodemask/ here. I copy/pasted this from before 675becce15f32, where
it didn't actually use the nodemask parameter of throttle_direct_reclaim(),
Wonder why, looks like another bug to me, that the commit has silently fixed.

> pgdat = zone->zone_pgdat;
> 
> if (!pgdat || pfmemalloc_watermark_ok(pgdat))
> 	goto out;
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

