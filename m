Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402Ab3DPVYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 17:24:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262Ab3DPVYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 17:24:09 -0400
Date: Tue, 16 Apr 2013 17:10:10 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Rami Rosen <ramirose@gmail.com>, tj@kernel.org, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, serge.hallyn@canonical.com
Subject: Re: [PATCH] devcg: remove parent_cgroup.
Message-ID: <20130416211010.GQ24899@redhat.com>
References: <1366143895-21535-1-git-send-email-ramirose@gmail.com>
 <20130416203700.GP24899@redhat.com>
 <20130416210725.GA21536@sergelap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416210725.GA21536@sergelap>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 04:07:25PM -0500, Serge Hallyn wrote:
> Quoting Aristeu Rozanski (aris@redhat.com):
> > On Tue, Apr 16, 2013 at 11:24:55PM +0300, Rami Rosen wrote:
> > > In devcgroup_css_alloc(), there is no longer need for parent_cgroup.
> > > bd2953ebbb("devcg: propagate local changes down the hierarchy") made
> > > the variable parent_cgroup redundant. This patch removes parent_cgroup
> > > from devcgroup_css_alloc().
> > > 
> > > Signed-off-by: Rami Rosen <ramirose@gmail.com>
> > > ---
> > >  security/device_cgroup.c | 2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> > > index 994aecc..dd0dc57 100644
> > > --- a/security/device_cgroup.c
> > > +++ b/security/device_cgroup.c
> > > @@ -236,7 +236,6 @@ static void devcgroup_offline(struct cgroup *cgroup)
> > >  static struct cgroup_subsys_state *devcgroup_css_alloc(struct cgroup *cgroup)
> > >  {
> > >  	struct dev_cgroup *dev_cgroup;
> > > -	struct cgroup *parent_cgroup;
> > >  
> > >  	dev_cgroup = kzalloc(sizeof(*dev_cgroup), GFP_KERNEL);
> > >  	if (!dev_cgroup)
> > > @@ -244,7 +243,6 @@ static struct cgroup_subsys_state *devcgroup_css_alloc(struct cgroup *cgroup)
> > >  	INIT_LIST_HEAD(&dev_cgroup->exceptions);
> > >  	INIT_LIST_HEAD(&dev_cgroup->propagate_pending);
> > >  	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
> > > -	parent_cgroup = cgroup->parent;
> > >  
> > >  	return &dev_cgroup->css;
> > >  }
> > 
> > oops
> > 
> > ACK
> 
> Not seeing the patches this is based on in Linus' tree yet, but given
> the context above I don't see how it could not be right :)

they're on Tejun's tree

-- 
Aristeu

