Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab3LKVR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:17:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3LKVRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:17:22 -0500
Date: Wed, 11 Dec 2013 13:19:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, kay@vrfy.org
Subject: Re: [PATCHSET driver-core-next] kernfs: implement kernfs_dir_ops
Message-ID: <20131211211907.GA20491@kroah.com>
References: <1386795780-23324-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386795780-23324-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 04:02:54PM -0500, Tejun Heo wrote:
> Hello,
> 
> kernfs is now properly separated out from sysfs and can be used for
> other pseudo filesystems too; however, there are still some missing
> features - kernfs filesystems can't process any directory manipulation
> systemcalls such as mkdir(2), rmdir(2) and rename(2), which cgroup,
> one of the prospect kernfs users, requires for cgroup management.
> 
> This patchset implements those directory operation hooks so that
> kernfs users can be hooked into those system calls and implement
> appropriate actions, which may or may not match the actual semantics
> of those syscalls.
> 
> The implementation is mostly straight forward except for one aspect.
> sysfs, and thus kernfs, never allowed negative dentries.  They are
> actively shot down and lookup callback assumes that there's no
> negative dentries.  This doesn't really have a lot of benefits and
> changing isn't difficult.  The lookup path simply needs to tell the
> vfs layer that a full fresh lookup is necessary for negative dentries.

Very cool, will this let us move configfs to use kernfs as well?  That's
one of the reasons that the two filesystems couldn't be merged in the
past from what I remember.

thanks,

greg k-h
