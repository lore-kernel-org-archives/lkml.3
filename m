Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaA2SXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:23:08 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:65300 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaA2SXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:23:04 -0500
Date: Wed, 29 Jan 2014 19:22:59 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Ying Han <yinghan@google.com>,
        Hugh Dickins <hughd@google.com>, Michel Lespinasse <walken@google.com>,
        Greg Thelen <gthelen@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 0/4] memcg: Low-limit reclaim
Message-ID: <20140129182259.GA6711@dhcp22.suse.cz>
References: <1386771355-21805-1-git-send-email-mhocko@suse.cz>
 <52E24956.3000007@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E24956.3000007@yandex-team.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 24-01-14 15:07:02, Roman Gushchin wrote:
> Hi, Michal!

Hi,

> As you can remember, I've proposed to introduce low limits about a year ago.
> 
> We had a small discussion at that time: http://marc.info/?t=136195226600004 .

yes I remember that discussion and vaguely remember the proposed
approach. I really wanted to prevent from introduction of a new knob but
things evolved differently than I planned since then and it turned out
that the knew knob is unavoidable. That's why I came with this approach
which is quite different from yours AFAIR.
 
> Since that time we intensively use low limits in our production
> (on thousands of machines). So, I'm very interested to merge this
> functionality into upstream.

Have you tried to use this implementation? Would this work as well?
My very vague recollection of your patch is that it didn't cover both
global and target reclaims and it didn't fit into the reclaim very
naturally it used its own scaling method. I will have to refresh my
memory though.

> In my experience, low limits also require some changes in memcg page accounting
> policy. For instance, an application in protected cgroup should have a guarantee
> that it's filecache belongs to it's cgroup and is protected by low limit
> therefore. If the filecache was created by another application in other cgroup,
> it can be not so. I've solved this problem by implementing optional page
> reaccouting on pagefaults and read/writes.

Memory sharing is a separate issue and we should discuss that
separately. 

> I can prepare my current version of patchset, if someone is interested.

Sure, having something to compare with is always valuable.

> Regards,
> Roman
-- 
Michal Hocko
SUSE Labs
