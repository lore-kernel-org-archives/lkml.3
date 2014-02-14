Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaBNQCa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:02:30 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:45760 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaBNQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:02:29 -0500
Date: Fri, 14 Feb 2014 11:02:25 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf.kern@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: fix top cgroup refcnt leak
Message-ID: <20140214160225.GD31544@htj.dyndns.org>
References: <52FDE393.6050607@huawei.com>
 <52FDFAC6.1080802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FDFAC6.1080802@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 07:15:18PM +0800, Li Zefan wrote:
> >  		/*
> > +		 * A root's lifetime is governed by its top cgroup.  Zero
> > +		 * ref indicate that the root is being destroyed.  Wait for
> > +		 * destruction to complete so that the subsystems are free.
> > +		 * We can use wait_queue for the wait but this path is
> > +		 * super cold.  Let's just sleep for a bit and retry.
> > +		 */
> > +		if (!atomic_read(&root->top_cgroup.refcnt)) {
> 
> oops, this fix is wrong. We call kernfs_mount() without cgroup locks and it
> drops cgroup refcnt if failed.
> 
> I guess we need to bump the refcnt and then drop it after kernfs_mount().

Alright, will wait for the updated fix.

Thanks!

-- 
tejun
