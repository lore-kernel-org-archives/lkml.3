Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbaEKMim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 08:38:42 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35616 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbaEKMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 08:38:40 -0400
Date: Sun, 11 May 2014 08:38:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] cgroup: implement css_tryget()
Message-ID: <20140511123837.GC22945@htj.dyndns.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-15-git-send-email-tj@kernel.org>
 <20140511045459.GA25009@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140511045459.GA25009@cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 12:54:59AM -0400, Johannes Weiner wrote:
> >  /**
> > + * css_tryget - try to obtain a reference on the specified css
> > + * @css: target css
> > + *
> > + * Obtain a reference on @css unless it already has reached zero and is
> > + * being released.  This function doesn't care whether @css is on or
> > + * offline.  The caller naturally needs to ensure that @css is accessible
> > + * but doesn't have to be holding a reference on it - IOW, RCU protected
> > + * access is good enough for this function.  Returns %true if a reference
> > + * count was successfully obtained; %false otherwise.
> > + */
> > +static inline bool css_tryget(struct cgroup_subsys_state *css)
> > +{
> > +	return percpu_ref_tryget(&css->refcnt);
> > +}
> 
> percpu_ref_tryget() fails once killed (transitioned from per-cpu to
> atomic mode), but exactly this happens during offlining and so this
> would actually be equivalent to css_tryget_online(), no?

Not any more.  percpu/for-3.16 already contains the updates to
percpu_ref_tryget[_live]().  percpu_ref_tryget() succeeds as long as
the refcnt is above zero.

Thanks.

-- 
tejun
