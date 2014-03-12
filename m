Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaCLUNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:13:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbaCLUNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:13:33 -0400
Date: Wed, 12 Mar 2014 16:13:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, tj@kernel.org, ssorce@redhat.com,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
Subject: Re: [PATCH 1/2] cgroup: Provide empty definition of
 task_cgroup_path()
Message-ID: <20140312201329.GL14981@redhat.com>
References: <1394649942-5854-1-git-send-email-vgoyal@redhat.com>
 <1394649942-5854-2-git-send-email-vgoyal@redhat.com>
 <20140312.150020.340861233360073600.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312.150020.340861233360073600.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 03:00:20PM -0400, David Miller wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Wed, 12 Mar 2014 14:45:41 -0400
> 
> > Compilation with !CONFIG_CGROUP fails for task_cgroup_path() user. So
> > provide an emtpy definition.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  include/linux/cgroup.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> > index 9450f02..bf40adb 100644
> > --- a/include/linux/cgroup.h
> > +++ b/include/linux/cgroup.h
> > @@ -869,6 +869,8 @@ static inline int cgroup_attach_task_all(struct task_struct *from,
> >  	return 0;
> >  }
> >  
> > +static inline int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen) {return 0;}
> > +
> 
> Please properly format this just like any other function.
> 
> static inline int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
> {
> 	eturn 0;
> }
> 
> It looked like a plain static declaration on first glance.

Sure I will.

Also, looks like I have introduced a bug in second round of changes I made. I
will fix that too and do a new posting.

Thanks
Vivek
