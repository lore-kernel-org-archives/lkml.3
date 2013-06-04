Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab3FDTiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:38:24 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:37856 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3FDTiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:38:22 -0400
Date: Tue, 4 Jun 2013 12:36:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ying Han <yinghan@google.com>, Hugh Dickins <hughd@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [patch -v4 4/8] memcg: enhance memcg iterator to support
 predicates
Message-ID: <20130604193619.GA14916@htj.dyndns.org>
References: <1370254735-13012-1-git-send-email-mhocko@suse.cz>
 <1370254735-13012-5-git-send-email-mhocko@suse.cz>
 <20130604010737.GF29989@mtj.dyndns.org>
 <20130604134523.GH31242@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604134523.GH31242@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Michal.

On Tue, Jun 04, 2013 at 03:45:23PM +0200, Michal Hocko wrote:
> Is this something that you find serious enough to block this series?
> I do not want to push hard but I would like to settle with something
> finally. This is taking way longer than I would like.

I really don't think memcg can afford to add more mess than there
already is.  Let's try to get things right with each change, please.
Can we please see how the other approach would look like?  I have a
suspicion that it's likely be simpler but the devils are in the
details and all...

> > The iteration only depends on the current position.  Can't you factor
> > out skipping part outside the function rather than rolling into this
> > monstery thing with predicate callback?  Just test the condition
> > outside and call a function to skip whatever is necessary?
> > 
> > Also, cgroup_rightmost_descendant() can be pretty expensive depending
> > on how your tree looks like. 
> 
> I have no problem using something else. This was just the easiest to
> use and it behaves more-or-less good for hierarchies which are more or
> less balanced. If this turns out to be a problem we can introduce a
> new cgroup_skip_subtree which would get to last->sibling or go up the
> parent chain until there is non-NULL sibling. But what would be the next
> selling point here if we made it perfect right now? ;)

Yeah, sure thing.  I was just worried because the skipping here might
not be as good as the code seems to indicate.  There will be cases,
which aren't too uncommon, where the skipping doesn't save much
compared to just continuing the pre-order walk, so....  And nobody
would really notice it unless [s]he looks really hard for it, which is
the more worrisome part for me.  Maybe just stick a comment there
explaining that we probably want something better in the future?

Thanks.

-- 
tejun
