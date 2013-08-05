Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3HEPkX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:40:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54174 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HEPkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:40:21 -0400
Date: Mon, 5 Aug 2013 11:40:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] cgroup: export __cgroup_from_dentry() and
 __cgroup_dput()
Message-ID: <20130805154016.GE19631@mtj.dyndns.org>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <1375632446-2581-3-git-send-email-tj@kernel.org>
 <51FF14C5.4040003@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FF14C5.4040003@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 10:58:13AM +0800, Li Zefan wrote:
> > +struct cgroup *__cgroup_from_dentry(struct dentry *dentry, struct cftype **cftp)
> >  {
> > -	if (file_inode(file)->i_fop != &cgroup_file_operations)
> > -		return ERR_PTR(-EINVAL);
> > -	return __d_cft(file->f_dentry);
> > +	if (!dentry->d_inode ||
> > +	    dentry->d_inode->i_op != &cgroup_file_inode_operations)
> > +		return NULL;
> > +
> > +	if (cftp)
> > +		*cftp = __d_cft(dentry);
> > +	return __d_cgrp(dentry->d_parent);
> >  }
> > +EXPORT_SYMBOL_GPL(__cgroup_from_dentry);
> 
> As we don't expect new users, why export this symbol? memcg can't be
> built as a module.

Yeah, I for some reason was thinking memcg could be bulit as module.
Brainfart.  Dropped.

Thanks.

-- 
tejun
