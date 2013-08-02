Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab3HBTo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:44:58 -0400
Received: from mail-qe0-f52.google.com ([209.85.128.52]:47220 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3HBTo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:44:56 -0400
Date: Fri, 2 Aug 2013 15:44:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 21/23] cgroup: make cftype->[un]register_event() deal
 with cgroup_subsys_state instead of cgroup
Message-ID: <20130802194451.GF29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
 <1375393801-4817-22-git-send-email-tj@kernel.org>
 <51FB30D3.9030900@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FB30D3.9030900@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 12:08:51PM +0800, Li Zefan wrote:
> > @@ -506,15 +506,17 @@ struct cftype {
> >  	 * you want to provide this functionality. Use eventfd_signal()
> >  	 * on eventfd to send notification to userspace.
> >  	 */
> > -	int (*register_event)(struct cgroup *cgrp, struct cftype *cft,
> > -			struct eventfd_ctx *eventfd, const char *args);
> > +	int (*register_event)(struct cgroup_subsys_state *css,
> > +			      struct cftype *cft, struct eventfd_ctx *eventfd,
> > +			      const char *args);
> >  	/*
> >  	 * unregister_event() callback will be called when userspace
> >  	 * closes the eventfd or on cgroup removing.
> >  	 * This callback must be implemented, if you want provide
> >  	 * notification functionality.
> >  	 */
> > -	void (*unregister_event)(struct cgroup *cgrp, struct cftype *cft,
> > +	void (*unregister_event)(struct cgroup_subsys_state *css,
> > +				 struct cftype *cft,
> >  			struct eventfd_ctx *eventfd);
> 
> align this line?

Done.

-- 
tejun
