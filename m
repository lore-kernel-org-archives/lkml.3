Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbaD2MzC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:55:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbaD2MzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:55:00 -0400
Date: Tue, 29 Apr 2014 14:54:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/4] memcg: Low-limit reclaim
Message-ID: <20140429125457.GG15058@dhcp22.suse.cz>
References: <1398688005-26207-1-git-send-email-mhocko@suse.cz>
 <10861398700008@webcorp2f.yandex-team.ru>
 <xr938uqoa8ei.fsf@gthelen.mtv.corp.google.com>
 <7441398768618@webcorp2f.yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7441398768618@webcorp2f.yandex-team.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-04-14 14:50:18, Roman Gushchin wrote:
> 29.04.2014, 11:42, "Greg Thelen" <gthelen@google.com>:
> > On Mon, Apr 28 2014, Roman Gushchin <klamm@yandex-team.ru> wrote:
> >
> >>  28.04.2014, 16:27, "Michal Hocko" <mhocko@suse.cz>:
> >>>  The series is based on top of the current mmotm tree. Once the series
> >>>  gets accepted I will post a patch which will mark the soft limit as
> >>>  deprecated with a note that it will be eventually dropped. Let me know
> >>>  if you would prefer to have such a patch a part of the series.
> >>>
> >>>  Thoughts?
> >>  Looks good to me.
> >>
> >>  The only question is: are there any ideas how the hierarchy support
> >>  will be used in this case in practice?
> >>  Will someone set low limit for non-leaf cgroups? Why?
> >>
> >>  Thanks,
> >>  Roman
> >
> > I imagine that a hosting service may want to give X MB to a top level
> > memcg (/a) with sub-jobs (/a/b, /a/c) which may(not) have their own
> > low-limits.

I would expect the limit would be set on leaf nodes most of the time
because intermediate nodes have charges inter-mixed with charges from
children so it is not entirely clear who to protect.
On the on the other hand I can imagine that the higher level node might
get some portion of memory by an admin without any way to set the limit
down the hierarchy for its user as described by Greg.

> > Examples:
> >
> > case_1) only set low limit on /a.  /a/b and /a/c may overcommit /a's
> >         memory (b.limit_in_bytes + c.limit_in_bytes > a.limit_in_bytes).
> >
> > case_2) low limits on all memcg.  But not overcommitting low_limits
> >         (b.low_limit_in_in_bytes + c.low_limit_in_in_bytes <=
> >         a.low_limit_in_in_bytes).
> 
> Thanks!
> 
> With use_hierarchy turned on it looks perfectly usable.

use_hierarchy is becoming the default and we even complain about deeper
directory structures without it being enabled.

-- 
Michal Hocko
SUSE Labs
