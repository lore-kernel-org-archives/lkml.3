Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaDYWaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:30:23 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:47674 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaDYWaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:30:19 -0400
Date: Fri, 25 Apr 2014 18:30:06 -0400
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
        eparis@parisplace.org, serge.hallyn@ubuntu.com, lennart@poettering.net,
        kay@vrfy.org, lizefan@huawei.com, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
Message-ID: <20140425223006.GB20460@htj.dyndns.org>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397056052-2829-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 11:07:29AM -0400, Tejun Heo wrote:
> Hello,
> 
> (inotify folks, can you please review the second patch which hooks up
>  kernfs_notify() with fsnotify?  It works but directly invoking
>  fsnotify_parent() and fsnotify() feels a bit dirty.  Maybe something
>  like fsnotify_notify_modify_by_dentry() would make more sense?)
> 
> cgroup users often need a way to determine when a cgroup's
> subhierarchy becomes empty so that it can be cleaned up.  cgroup
> currently provides release_agent for it; unfortunately, this mechanism
> is riddled with issues.  This patchset implements a replacement
> mechanism "cgroup.subtree_populated" which can be used to monitor
> whether the cgroup's subhierarchy has tasks in it or not and triggers
> poll and [di]notify events when its content changes.
> 
> This patchset contains the following three patches.
> 
>  0001-kernfs-implement-kernfs_root-supers-list.patch
>  0002-kernfs-make-kernfs_notify-trigger-inotify-events-too.patch
>  0003-cgroup-implement-cgroup.subtree_populated-for-the-de.patch

0001-0002 are applied to driver-core-next, which was pulled into
cgroup/for-3.16.   0003 applied to cgroup/for-3.16.

Thanks.

-- 
tejun
