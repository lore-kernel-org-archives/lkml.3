Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbaFKOLX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 10:11:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbaFKOLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 10:11:21 -0400
Date: Wed, 11 Jun 2014 16:11:17 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Roman Gushchin <klamm@yandex-team.ru>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] memcg: Allow hard guarantee mode for low limit
 reclaim
Message-ID: <20140611141117.GF4520@dhcp22.suse.cz>
References: <20140606144421.GE26253@dhcp22.suse.cz>
 <1402066010-25901-1-git-send-email-mhocko@suse.cz>
 <1402066010-25901-2-git-send-email-mhocko@suse.cz>
 <xr934mzt4rwc.fsf@gthelen.mtv.corp.google.com>
 <20140610165756.GG2878@cmpxchg.org>
 <20140611075729.GA4520@dhcp22.suse.cz>
 <20140611123109.GA17777@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140611123109.GA17777@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 11-06-14 08:31:09, Tejun Heo wrote:
> Hello, Michal.
> 
> On Wed, Jun 11, 2014 at 09:57:29AM +0200, Michal Hocko wrote:
> > Is this the kind of symmetry Tejun is asking for and that would make
> > change is Nack position? I am still not sure it satisfies his soft
> 
> Yes, pretty much.  What primarily bothered me was the soft/hard
> guarantees being chosen by a toggle switch while the soft/hard limits
> can be configured separately and combined.

The last consensus at LSF was that there would be a knob which will
distinguish hard/best effort behavior. The weaker semantic has strong
usecases IMHO so I wanted to start with it and add a knob for the hard
guarantee later when explicitly asked for.

Going with min, low, high and hard makes more sense to me of course.

> > guarantee objections from other email.
> 
> I was wondering about the usefulness of "low" itself in isolation and

I think it has more usecases than "min" from simply practical POV. OOM
means a potential service down time and that is a no go. Optimistic
isolation on the other hand adds an advantages of the isolation most of
the time while not getting completely flat on an exception (be it
misconfiguration or a corner case like mentioned during the discussion).

That doesn't mean "min" is not useful. It definitely is, the category
of usecases will be more specific though.

> I still think it'd be less useful than "high", but as there seem to be
> use cases which can be served with that and especially as a part of a
> consistent control scheme, I have no objection.
> 
> "low" definitely requires a notification mechanism tho.

Would vmpressure notification be sufficient? That one is in place for
any memcg which is reclaimed.

Or are you thinking about something more like oom_control?

-- 
Michal Hocko
SUSE Labs
