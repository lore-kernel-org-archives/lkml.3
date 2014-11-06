Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaKFQ6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:58:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57717 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbaKFQ6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:58:30 -0500
Date: Thu, 6 Nov 2014 17:58:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141106165828.GL7202@dhcp22.suse.cz>
References: <20141105162929.GD14386@htj.dyndns.org>
 <20141105163956.GD28226@dhcp22.suse.cz>
 <20141105165428.GF14386@htj.dyndns.org>
 <20141105170111.GG14386@htj.dyndns.org>
 <20141106130543.GE7202@dhcp22.suse.cz>
 <20141106150927.GB25642@htj.dyndns.org>
 <20141106160158.GI7202@dhcp22.suse.cz>
 <20141106161211.GC25642@htj.dyndns.org>
 <20141106163124.GK7202@dhcp22.suse.cz>
 <20141106163304.GE25642@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106163304.GE25642@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-11-14 11:33:04, Tejun Heo wrote:
> On Thu, Nov 06, 2014 at 05:31:24PM +0100, Michal Hocko wrote:
> > On Thu 06-11-14 11:12:11, Tejun Heo wrote:
[...]
> > > Draining oom killer then doesn't mean anything, no?  OOM killer may
> > > have been disabled and drained but the killed tasks might wake up
> > > after the PM freezer considers them to be frozen, right?  What am I
> > > missing?
> > 
> > The mutual exclusion between OOM and the freezer will cause that the
> > victim will have TIF_MEMDIE already set when try_to_freeze_tasks even
> > starts. Then freezing_slow_path wouldn't allow the task to enter the
> > fridge so the wake up moment is not really that important.
> 
> What if it was already in the freezer?

Good question! You are right that there is a race window until the wake
up then. I will think about this case some more. There is simply no
control on when the task wakes up and freezer will see it as frozen
until then. An immediate way around would be to check for TIF_MEMDIE in
try_to_freeze_tasks.

I have to call it end of the day unfortunately and will be back on
Monday.
-- 
Michal Hocko
SUSE Labs
