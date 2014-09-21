Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaIUQAS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 12:00:18 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40496 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaIUQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 12:00:16 -0400
Date: Sun, 21 Sep 2014 12:00:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Greg Thelen <gthelen@google.com>, Dave Chinner <david@fromorbit.com>,
        Glauber Costa <glommer@gmail.com>,
        Suleiman Souhlal <suleiman@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -mm 00/14] Per memcg slab shrinkers
Message-ID: <20140921160012.GA996@mtj.dyndns.org>
References: <cover.1411301245.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1411301245.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Sep 21, 2014 at 07:14:32PM +0400, Vladimir Davydov wrote:
...
> list. This is really important, because this allows us to release
> memcg_cache_id used for indexing in per-memcg arrays. If we don't do
> this, the arrays will grow uncontrollably, which is really bad. Note, in
> comparison to user memory reparenting, which Johannes is going to get

I don't know the code well and haven't read the patches and could
easilya be completely off the mark, but, if the size of slab array is
the only issue, wouldn't it be easier to separate that part out?  The
indexing is only necessary for allocating new items, right?  Can't
that part be shutdown and the index freed on offline and the rest stay
till release?  Things like reparenting tends to add fair amount of
complexity and hot path overheads which aren't necessary otherwise.

Thanks.

-- 
tejun
