Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3HBTlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:41:49 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:51406 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3HBTlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:41:46 -0400
Date: Fri, 2 Aug 2013 15:41:40 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        Daniel Wagner <daniel.wagner@bmw-carit.de>,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 08/23] cgroup: pass around cgroup_subsys_state instead of
 cgroup in subsystem methods
Message-ID: <20130802194140.GE29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-9-git-send-email-tj@kernel.org>
 <51FB2F3D.5050904@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB2F3D.5050904@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:02:05PM +0800, Li Zefan wrote:
> > @@ -4199,12 +4208,13 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
> >  /* invoke ->css_online() on a new CSS and mark it online if successful */
> >  static int online_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
> >  {
> > +	struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
> >  	int ret = 0;
> >  
> >  	lockdep_assert_held(&cgroup_mutex);
> >  
> >  	if (ss->css_online)
> > -		ret = ss->css_online(cgrp);
> > +		ret = ss->css_online(css);
> >  	if (!ret)
> >  		cgrp->subsys[ss->subsys_id]->flags |= CSS_ONLINE;
> 
> Then this can be changed to css->flags |= CSS_ONLINE.

Aye aye.

-- 
tejun
