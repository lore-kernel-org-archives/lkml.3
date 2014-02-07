Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642AbaBGPNr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:13:47 -0500
Received: from mail-qc0-f177.google.com ([209.85.216.177]:41982 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaBGPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:13:45 -0500
Date: Fri, 7 Feb 2014 10:13:41 -0500
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>,
        Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Message-ID: <20140207151341.GB3304@htj.dyndns.org>
References: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
 <20140207140402.GA3304@htj.dyndns.org>
 <20140207143740.GD5121@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140207143740.GD5121@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Fri, Feb 07, 2014 at 03:37:40PM +0100, Michal Hocko wrote:
> Hmm, this is a bit tricky. We cannot use memcg iterators to reach
> children because css_tryget would fail on them. We can use cgroup
> iterators instead, alright, and reparent pages from leafs but this all
> sounds like a lot of complications.

Hmmm... I think we're talking past each other here.  Why would the
parent need to reach down to the children?  Just bail out if it can't
make things down to zero and let the child when it finishes its own
cleaning walk up the tree propagating changes.  ->parent is always
accessible.  Would that be complicated too?

> Another option would be weakening css_offline reparenting and do not
> insist on having 0 charges. We want to get rid of as many charges as
> possible but do not need to have all of them gone
> (http://marc.info/?l=linux-kernel&m=139161412932193&w=2). The last part
> would be reparenting to the upmost parent which is still online.
> 
> I guess this is implementable but I would prefer Hugh's fix for now and
> for stable.

Yeah, for -stable, I think Hugh's patch is good but I really don't
want to keep it long term.

Thanks.

-- 
tejun
