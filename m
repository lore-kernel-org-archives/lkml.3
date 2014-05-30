Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaE3Pjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:39:48 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:47984 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaE3Pjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:39:47 -0400
Date: Fri, 30 May 2014 11:39:43 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 02/12] block, bfq: add full hierarchical
 scheduling and cgroups support
Message-ID: <20140530153943.GC24871@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-3-git-send-email-paolo.valente@unimore.it>
 <20140530153718.GB24871@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140530153718.GB24871@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 11:37:18AM -0400, Tejun Heo wrote:
> On Thu, May 29, 2014 at 11:05:33AM +0200, Paolo Valente wrote:
> > diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> > index 768fe44..cdd2528 100644
> > --- a/include/linux/cgroup_subsys.h
> > +++ b/include/linux/cgroup_subsys.h
> > @@ -39,6 +39,10 @@ SUBSYS(net_cls)
> >  SUBSYS(blkio)
> >  #endif
> >  
> > +#if IS_ENABLED(CONFIG_CGROUP_BFQIO)
> > +SUBSYS(bfqio)
> > +#endif
> 
> So, ummm, I don't think this is a good idea.  Why aren't you plugging
> into the blkcg infrastructure as cfq does?  Why does it need to be a
> separate controller?

If there's something which doesn't work for bfq in blkcg, please let
me know.  I'd be happy to make it work.

Thanks.

-- 
tejun
