Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072AbaDWHE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:04:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54792 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbaDWHEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:04:22 -0400
Date: Wed, 23 Apr 2014 09:04:15 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] memcg: mm_update_next_owner() should skip kthreads
Message-ID: <20140423070415.GA20969@dhcp22.suse.cz>
References: <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
 <20140416135741.GA9407@redhat.com>
 <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
 <20140418162359.GA4398@redhat.com>
 <20140418172631.GA13323@redhat.com>
 <20140418182444.GB22235@dhcp22.suse.cz>
 <20140418184441.GA26046@redhat.com>
 <20140422105228.GJ29311@dhcp22.suse.cz>
 <20140422132102.GN29311@dhcp22.suse.cz>
 <alpine.LSU.2.11.1404221432150.6603@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1404221432150.6603@eggly.anvils>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 22-04-14 14:35:14, Hugh Dickins wrote:
> On Tue, 22 Apr 2014, Michal Hocko wrote:
> > On Tue 22-04-14 12:52:28, Michal Hocko wrote:
> > > On Fri 18-04-14 20:44:41, Oleg Nesterov wrote:
> > [...]
> > > > I do not even understand why do we have CONFIG_MM_OWNER, perhaps it should
> > > > die?
> > > 
> > > I have to dig into history to check why it has been introduced in the
> > > first place. It might be possible it is not relevant anymore.
> > 
> > There didn't seem to be any other user of CONFIG_MM_OWNER outside of
> > MEMCG so it seems that a separate config option seems like an overkill.
> > Regarding the mm->owner itself it is hard to live without it at the
> > moment. Most of the charging places do charge the current task_struct
> > but there are some that rely on mm and we would need mm->task mapping.
> > The last obstacle would be threads migration but that one should go away
> > with unified hierarchy AFAIR.
> 
> Balbir had another user for mm->owner in mmotm back in 2008, his
> memrlimit controller; but that didn't make it through to mainline.

I see, thanks for the reference, Hugh!
-- 
Michal Hocko
SUSE Labs
