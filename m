Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbaELPZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:25:19 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:62961 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758994AbaELPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:25:11 -0400
Date: Mon, 12 May 2014 11:25:07 -0400
From: Tejun Heo <tj@kernel.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH] memcg: deprecate memory.force_empty knob
Message-ID: <20140512152507.GD1421@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-3-git-send-email-tj@kernel.org>
 <20140512145324.GE9564@dhcp22.suse.cz>
 <20140512145803.GF9564@dhcp22.suse.cz>
 <20140512150014.GB1421@htj.dyndns.org>
 <20140512152015.GH9564@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512152015.GH9564@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 05:20:15PM +0200, Michal Hocko wrote:
> On Mon 12-05-14 11:00:14, Tejun Heo wrote:
> > On Mon, May 12, 2014 at 04:58:03PM +0200, Michal Hocko wrote:
> > > @@ -4793,6 +4793,10 @@ static int mem_cgroup_force_empty_write(struct cgroup_subsys_state *css,
> > >  
> > >  	if (mem_cgroup_is_root(memcg))
> > >  		return -EINVAL;
> > > +	pr_info("%s (%d): memory.force_empty is deprecated and will be removed.",
> > > +			current->comm, task_pid_nr(current));
> > > +	pr_cont(" Let us know if you know if it needed in your usecase at");
> > > +	pr_cont(" linux-mm@kvack.org\n");
> > >  	return mem_cgroup_force_empty(memcg);
> > 
> > It probably would be way easier to just mark the knob with
> > CFTYPE_INSANE.
> 
> That would prevent from creating the file, right? I do not mind that but
> I would like to see people complaining before.

Oh sure, if you wanna see people complaining before the roll out of
unified hierarchy, but let's make sure it's also marked with
CFTYPE_INSANE.  It's easy to remove the flag afterwards.  The other
way isn't, so...

Thanks.

-- 
tejun
