Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab3KSVV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:21:28 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:46626 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3KSVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:21:26 -0500
Date: Tue, 19 Nov 2013 22:21:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Expose sysctls for enabling slab/file_cache interleaving
Message-ID: <20131119212123.GA9339@dhcp22.suse.cz>
References: <1384822222-28795-1-git-send-email-andi@firstfloor.org>
 <20131119104203.GB18872@dhcp22.suse.cz>
 <20131119184200.GD29695@two.firstfloor.org>
 <20131119191135.GA8634@dhcp22.suse.cz>
 <20131119201333.GD19762@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119201333.GD19762@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-11-13 12:13:33, Andi Kleen wrote:
> On Tue, Nov 19, 2013 at 08:11:35PM +0100, Michal Hocko wrote:
> > On Tue 19-11-13 19:42:00, Andi Kleen wrote:
> > > On Tue, Nov 19, 2013 at 11:42:03AM +0100, Michal Hocko wrote:
> > > > On Mon 18-11-13 16:50:22, Andi Kleen wrote:
> > > > [...]
> > > > > diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> > > > > index cc1b01c..10966f5 100644
> > > > > --- a/include/linux/cpuset.h
> > > > > +++ b/include/linux/cpuset.h
> > > > > @@ -72,12 +72,14 @@ extern int cpuset_slab_spread_node(void);
> > > > >  
> > > > >  static inline int cpuset_do_page_mem_spread(void)
> > > > >  {
> > > > > -	return current->flags & PF_SPREAD_PAGE;
> > > > > +	return (current->flags & PF_SPREAD_PAGE) ||
> > > > > +		sysctl_spread_file_cache;
> > > > >  }
> > > > 
> > > > But this might break applications that explicitly opt out from
> > > > spreading.
> > > 
> > > What do you mean? There's no such setting at the moment.
> > > 
> > > They can only enable it.
> > 
> > cpuset_update_task_spread_flag allows disabling both flags. You can do
> > so for example via cpuset cgroup controller.
> 
> Ok.
> 
> So you're saying it should look up the cpuset. I'm reluctant do 
> that. It would make this path quite a bit more expensive.

Another option would be to use sysctl values for the top cpuset as a
default. But then why not just do it manually without sysctl?
 
> Is it really a big problem to override that setting with
> the global sysctl. Seems like sensible semantics for me.

If you create a cpuset and explicitly disable spreading then you would
be quite surprised that your process gets pages from all nodes, no?

> 
> -Andi

-- 
Michal Hocko
SUSE Labs
