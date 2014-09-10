Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaIJRFM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 13:05:12 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:40526 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaIJRFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 13:05:10 -0400
Date: Wed, 10 Sep 2014 19:05:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave@sr71.net>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
Message-ID: <20140910170506.GL25219@dhcp22.suse.cz>
References: <54061505.8020500@sr71.net>
 <5406262F.4050705@intel.com>
 <54062F32.5070504@sr71.net>
 <20140904142721.GB14548@dhcp22.suse.cz>
 <5408CB2E.3080101@sr71.net>
 <20140905092537.GC26243@dhcp22.suse.cz>
 <20140910162936.GI25219@dhcp22.suse.cz>
 <54108314.80400@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54108314.80400@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-09-14 09:57:56, Dave Hansen wrote:
> On 09/10/2014 09:29 AM, Michal Hocko wrote:
> > I do not have a bigger machine to play with unfortunately. I think the
> > patch makes sense on its own. I would really appreciate if you could
> > give it a try on your machine with !root memcg case to see how much it
> > helped. I would expect similar results to your previous testing without
> > the revert and Johannes' patch.
> 
> So you want to see before/after this patch:
> 
> Subject: [PATCH] mm, memcg: Do not kill release batching in
>  free_pages_and_swap_cache
> 
> And you want it on top of a kernel with the revert or without?

Revert doesn't make any difference if you run the load inside a memcg
(without any limit set).
So just before and after the patch would be sufficient.

Thanks a lot Dave!
-- 
Michal Hocko
SUSE Labs
