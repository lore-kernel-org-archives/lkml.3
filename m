Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaFPN5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:57:46 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:47807 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaFPN5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:57:44 -0400
Date: Mon, 16 Jun 2014 09:57:41 -0400
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
Message-ID: <20140616135741.GA11542@htj.dyndns.org>
References: <20140611075729.GA4520@dhcp22.suse.cz>
 <1402473624-13827-1-git-send-email-mhocko@suse.cz>
 <1402473624-13827-2-git-send-email-mhocko@suse.cz>
 <20140611153631.GH2878@cmpxchg.org>
 <20140612132207.GA32720@dhcp22.suse.cz>
 <20140612135600.GI2878@cmpxchg.org>
 <20140612142237.GB32720@dhcp22.suse.cz>
 <20140612161733.GC23606@htj.dyndns.org>
 <20140616125915.GB16915@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140616125915.GB16915@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michal.

On Mon, Jun 16, 2014 at 02:59:15PM +0200, Michal Hocko wrote:
> > There sure is a question of how fast userland will move to the new
> > interface. 
> 
> Yeah, I was mostly thinking about those who would need to to bigger
> changes. AFAIR threads will no longer be distributable between groups.

Thread-level granularity should go away no matter what, but this is
completely irrelevant to memcg which can't do per-thread anyway.  For
whatever reason, a user is stuck with thread-level granularity for
controllers which work that way, the user can use the old hierarchies
for them for the time being.

> > is used but I don't think there's any chance of removing the knob.
> > There's a reason why we're introducing a new version of the whole
> > cgroup interface which can co-exist with the existing one after all.
> > If you wanna version memcg interface separately, maybe that'd work but
> > it sounds like a lot of extra hassle for not much gain.
> 
> No, I didn't mean to version the interface. I just wanted to have
> gradual transition for potential soft_limit users.
> 
> Maybe I am misunderstanding something but I thought that new version of
> API will contain all knobs which are not marked .flags = CFTYPE_INSANE
> while the old API will contain all of them.

Nope, some changes don't fit that model.  CFTYPE_ON_ON_DFL is the
opposite.  Knobs marked with the flag only appear on the default
hierarchy (cgroup core internally calls it the default hierarchy as
this is the tree all the controllers are attached to by default).

Thanks.

-- 
tejun
