Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab3HBTgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:36:50 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:33758 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3HBTgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:36:48 -0400
Date: Fri, 2 Aug 2013 15:36:43 -0400
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
Message-ID: <20130802193643.GC29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-9-git-send-email-tj@kernel.org>
 <51FB2D70.3040208@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB2D70.3040208@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:54:24AM +0800, Li Zefan wrote:
> > @@ -4298,7 +4308,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
> >  	for_each_root_subsys(root, ss) {
> >  		struct cgroup_subsys_state *css;
> >  
> > -		css = ss->css_alloc(cgrp);
> > +		css = ss->css_alloc(parent->subsys[ss->subsys_id]);
> 
> As this patchset is based on for-3.12 branch, which lacks the fix in for-3.11,
> so the css_alloc() in that bug fix is not converted.

Hmm... I'll pull for-3.11-fixes into for-3.12 and rebase this series
on top of it.

Thanks.

-- 
tejun
