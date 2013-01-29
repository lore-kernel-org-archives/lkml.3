Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab3A2Uux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 15:50:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab3A2Uuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 15:50:52 -0500
Date: Tue, 29 Jan 2013 15:50:47 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 9/9] devcg: propagate local changes down the hierarchy
Message-ID: <20130129205047.GZ17632@redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190800.590181489@napanee.usersys.redhat.com>
 <20130129203500.GK6824@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129203500.GK6824@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 12:35:00PM -0800, Tejun Heo wrote:
> Generally looks good to me although I haven't really delved into the
> behavior (you're gonna be there for the fallouts, right?).  Just some
> minor comments.

yes, I'll.

> > +static int propagate_behavior(struct dev_cgroup *devcg_root)
> > +{
> > +	struct cgroup *root = devcg_root->css.cgroup, *pos;
> > +	struct dev_cgroup *parent, *devcg, *tmp;
> > +	int rc = 0;
> > +	LIST_HEAD(pending);
> > +
> > +	rcu_read_lock();
> > +	cgroup_for_each_descendant_pre(pos, root) {
> > +		devcg = cgroup_to_devcgroup(pos);
> > +		if (is_devcg_online(devcg))
> > +			list_add_tail(&devcg->propagate_pending, &pending);
> > +	}
> > +	rcu_read_unlock();
> 
> I think it could be a good idea to factor out the above and document
> what's going on and why.

ok, will fix the missing bits based on your comments and resubmit.

-- 
Aristeu

