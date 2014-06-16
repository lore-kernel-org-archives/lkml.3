Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaFPOMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:12:38 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:46212 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPOMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:12:37 -0400
Date: Mon, 16 Jun 2014 10:12:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Roman Gushchin <klamm@yandex-team.ru>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 2/2] memcg: Allow guarantee reclaim
Message-ID: <20140616141233.GB11542@htj.dyndns.org>
References: <1402473624-13827-1-git-send-email-mhocko@suse.cz>
 <1402473624-13827-2-git-send-email-mhocko@suse.cz>
 <20140611153631.GH2878@cmpxchg.org>
 <20140612132207.GA32720@dhcp22.suse.cz>
 <20140612135600.GI2878@cmpxchg.org>
 <20140612142237.GB32720@dhcp22.suse.cz>
 <20140612161733.GC23606@htj.dyndns.org>
 <20140616125915.GB16915@dhcp22.suse.cz>
 <20140616135741.GA11542@htj.dyndns.org>
 <20140616140448.GE16915@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616140448.GE16915@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:04:48PM +0200, Michal Hocko wrote:
> > For whatever reason, a user is stuck with thread-level granularity for
> > controllers which work that way, the user can use the old hierarchies
> > for them for the time being.
> 
> So he can mount memcg with new cgroup API and others with old?

Yes, you can read Documentation/cgroups/unified-hierarchy.txt for more
details.  I think I cc'd you when posting unified hierarchy patchset,
didn't I?

> > Nope, some changes don't fit that model.  CFTYPE_ON_ON_DFL is the
> > opposite. 
> 
> OK, I wasn't aware of this. On which branch I find this?

They're all in the mainline now.

> > Knobs marked with the flag only appear on the default
> > hierarchy (cgroup core internally calls it the default hierarchy as
> > this is the tree all the controllers are attached to by default).
> 
> I am not sure I understand. So they are visible only in the hierarchy
> mounted with the new cgroup API (sane or how is it called)?

Yeap.

Thanks.

-- 
tejun
