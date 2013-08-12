Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3HLNjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:39:12 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:50930 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3HLNjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:39:08 -0400
Date: Mon, 12 Aug 2013 09:39:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/14] cgroup: reorganize css init / exit paths
Message-ID: <20130812133904.GA15892@htj.dyndns.org>
References: <1375992831-4650-1-git-send-email-tj@kernel.org>
 <1375992831-4650-8-git-send-email-tj@kernel.org>
 <52084CC5.8050207@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52084CC5.8050207@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:47:33AM +0800, Li Zefan wrote:
> > +		/* each css holds a ref to the cgroup and the parent css */
> >  		dget(dentry);
> >  		percpu_ref_get(&css->parent->refcnt);
> 
> We called dget() and percpu_ref_get() for each css unconditionally...
> 
> > -	}
> >  
> > -	/* hold a ref to the parent's dentry */
> > -	dget(parent->dentry);
> > -
> > -	/* creation succeeded, notify subsystems */
> > -	for_each_root_subsys(root, ss) {
> > -		err = online_css(ss, cgrp);
> > +		/* creation succeeded, notify subsystems */
> > +		err = online_css(css);
> >  		if (err)
> >  			goto err_destroy;
> 
> but now dget() and percpu_ref_get() may not be called for some css's,
> but the code in failure path is not updated accordingly, which seems
> wrong.

Heh, yeah, brainfart.  Will post the updated version.

Thanks.

-- 
tejun
