Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3LKVZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:25:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3LKVZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:25:47 -0500
Date: Wed, 11 Dec 2013 13:27:32 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, neilb@suse.de, linus.walleij@linaro.org,
        ashutosh.dixit@intel.com, kbuild test robot <fengguang.wu@intel.com>
Subject: Re: [PATCH 1/6] kernfs: s/sysfs_dirent/kernfs_node/ and rename its
 friends accordingly
Message-ID: <20131211212732.GA21129@kroah.com>
References: <1386789118-24733-1-git-send-email-tj@kernel.org>
 <1386789118-24733-2-git-send-email-tj@kernel.org>
 <20131211212238.GC20491@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211212238.GC20491@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 01:22:38PM -0800, Greg KH wrote:
> On Wed, Dec 11, 2013 at 02:11:53PM -0500, Tejun Heo wrote:
> > kernfs has just been separated out from sysfs and we're already in
> > full conflict mode.  Nothing can make the situation any worse.  Let's
> > take the chance to name things properly.
> > 
> > This patch performs the following renames.
> > 
> > * s/sysfs_elem_dir/kernfs_elem_dir/
> > * s/sysfs_elem_symlink/kernfs_elem_symlink/
> > * s/sysfs_elem_attr/kernfs_elem_file/
> > * s/sysfs_dirent/kernfs_node/
> > * s/sd/kn/ in kernfs proper
> > * s/parent_sd/parent/
> > * s/target_sd/target/
> > * s/dir_sd/parent/
> > * s/to_sysfs_dirent()/rb_to_kn()/
> > * misc renames of local vars when they conflict with the above
> > 
> > Because md, mic and gpio dig into sysfs details, this patch ends up
> > modifying them.  All are sysfs_dirent renames and trivial.  While we
> > can avoid these by introducing a dummy wrapping struct sysfs_dirent
> > around kernfs_node, given the limited usage outside kernfs and sysfs
> > proper, I don't think such workaround is called for.
> 
> Ugh, why are those drivers digging into sysfs core bits anyway?  I'll
> look and see if they should be fixed up as well, as I really doubt a
> "normal" driver should ever care about this type of thing...

Ok, to answer my own question, it looks like these drivers need to be
fixed up, they just want to handle userspace doing a poll() on a sysfs
file, but shouldn't need to muck around with "raw" sysfs file calls for
this, the driver core should be able to handle this for them.

I'll work on fixing that up later.

thanks,

greg k-h
