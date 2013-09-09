Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3IIIbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:31:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab3IIIbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:31:50 -0400
Date: Mon, 9 Sep 2013 10:31:47 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: memcg creates an unkillable task in 3.11-rc2
Message-ID: <20130909083147.GA18056@dhcp22.suse.cz>
References: <87r4eh70yg.fsf@xmission.com>
 <51F71DE2.4020102@huawei.com>
 <87ppu0a298.fsf_-_@tw-ebiederman.twitter.com>
 <20130730123120.GA15847@dhcp22.suse.cz>
 <874nbc3sx1.fsf@tw-ebiederman.twitter.com>
 <20130731073726.GC30514@dhcp22.suse.cz>
 <87zjt2tm9f.fsf@xmission.com>
 <20130801090620.GA5198@dhcp22.suse.cz>
 <20130905095653.GB9702@dhcp22.suse.cz>
 <87ob85kejy.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob85kejy.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-09-13 11:09:21, Eric W. Biederman wrote:
> Michal Hocko <mhocko@suse.cz> writes:
> 
> > It seems that this one fell though the cracks?
> 
> Not completely, but it happened just as I was doing my initial triage of
> memcg problems and I haven't quite made it back to this.

OK. I am primarily asking because I am not sure I understood whether the
proposed patch helped or not. It should as per my last email but it is
possible that I have missed something...

> I have an even nastier memcg hang (without yet an easy reproducer).
> During mkdir ext3 can add a page to the page cache with the ext3 journal
> transaction lock held.  Normally that isn't a problem but freezing there
> stops all writes to that filesystem, and the world stops.
> 
> It looks like the only way to avoid that kind of scenario is to move the
> the memcg sleep to the edge of userspace, like we do with signals and a
> few other things so we can be guaranteed not to increase lock hold
> times, when it is avoidable.  I think I saw some similar comments about
> the slab limiting.

Johannes has patches that move memcg oom out of any locks already: 
https://lkml.org/lkml/2013/8/3/81. There is some development going on
there and I guess he will post v3 soon but that sounds it might help
with what you describe above.

Thanks!
-- 
Michal Hocko
SUSE Labs
