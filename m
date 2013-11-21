Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab3KURNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:13:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab3KURNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:13:10 -0500
Date: Thu, 21 Nov 2013 18:13:07 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Vladimir Murzin <murzin.v@gmail.com>, linux-mm@kvack.org,
        Greg Thelen <gthelen@google.com>, Glauber Costa <glommer@gmail.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Joern Engel <joern@logfs.org>,
        Hugh Dickins <hughd@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: user defined OOM policies
Message-ID: <20131121171307.GB16703@dhcp22.suse.cz>
References: <20131119131400.GC20655@dhcp22.suse.cz>
 <20131119134007.GD20655@dhcp22.suse.cz>
 <20131120172119.GA1848@hp530>
 <20131120173357.GC18809@dhcp22.suse.cz>
 <alpine.DEB.2.02.1311201937120.7167@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311201937120.7167@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-11-13 19:38:56, David Rientjes wrote:
> On Wed, 20 Nov 2013, Michal Hocko wrote:
> 
> > OK, I was a bit vague it seems. I meant to give zonelist, gfp_mask,
> > allocation order and nodemask parameters to the modules. So they have a
> > better picture of what is the OOM context.
> > What everything ould modules need to do an effective work is a matter
> > for discussion.
> > 
> 
> It's an interesting idea but unfortunately a non-starter for us because 
> our users don't have root,

I wouldn't see this as a problem. You can still have a module which
exports the notification interface you need. Including timeout
fallback. That would be trivial to implement and maybe more appropriate
to very specific environments. Moreover the global OOM handling wouldn't
be memcg bound.

> we create their memcg tree and then chown it to the user.  They can
> freely register for oom notifications but cannot load their own kernel
> modules for their own specific policy.

yes I see but that requires just a notification interface. It doesn't
have to be memcg specific, right?
-- 
Michal Hocko
SUSE Labs
