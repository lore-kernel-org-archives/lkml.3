Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaESPuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:50:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbaESPuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:50:20 -0400
Date: Mon, 19 May 2014 17:50:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Message-ID: <20140519155018.GF3017@dhcp22.suse.cz>
References: <1399994956-3907-1-git-send-email-mhocko@suse.cz>
 <xr9338g9o03z.fsf@gthelen.mtv.corp.google.com>
 <20140519140248.GD3017@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519140248.GD3017@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 19-05-14 16:02:48, Michal Hocko wrote:
> On Fri 16-05-14 15:00:16, Greg Thelen wrote:
[...]
> > -- First, demonstrate that just rmdir, without memory.force_empty,
> >    temporarily hides reparented child memory stats.
> > 
> > $ /test
> > p/memory.stat:rss 0
> > p/memory.stat:total_rss 69632
> > p/c/memory.stat:rss 69632
> > p/c/memory.stat:total_rss 69632
> > For a small time the p/c memory has not been reparented to p.
> > p/memory.stat:rss 0
> > p/memory.stat:total_rss 0
> 
> OK, this is a bug. Our iterators skip the children because css_tryget
> fails on it but css_offline still not done.

Or use the cgroups iterator directly. Which would be even easier to fix.
-- 
Michal Hocko
SUSE Labs
