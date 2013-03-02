Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab3CBU0V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 15:26:21 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36615 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3CBU0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 15:26:20 -0500
Date: Sat, 2 Mar 2013 12:26:15 -0800
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 30/31] driver/base: implement subsys_virtual_register()
Message-ID: <20130302202615.GA3678@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-31-git-send-email-tj@kernel.org>
 <20130302181727.GB2051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130302181727.GB2051@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

On Sat, Mar 02, 2013 at 10:17:27AM -0800, Greg Kroah-Hartman wrote:
> I'm almost afraid to ask what you want to export to userspace for a
> workqueue that userspace would care about...

Workqueue is being extended to support worker pools with custom
attributes so that it can replace private worker pool implementations
in writeback, btrfs and other places.  They want to expose
per-workqueue tunables to userland - nice level, cpu affinity and
cgroup association of those IO threads to userland, so that's where
the sysfs interface comes in.  The export is opt-in and those
workqueues should have well defined name.

> If you create a subsystem, the devices will show up under the virtual
> "bus" if you don't give them a parent, so this patch shouldn't be
> needed, unless you are abusing the driver model.  What am I missing
> here?

If you don't give the parent, it ends up in /sys/devices/ with
symlinks appearing under /sys/bus/.  I didn't know where to put it.
Right under /sys/devices/ doesn't seem right to me.  We already have
one like that /sys/devices/software/ which actually is for perf
software events and it just is weird.  I was wondering where to put it
and Kay told me that /sys/devices/virtual/ would be the best fit
although we don't yet have proper interface for it, so the patch.  I
don't really care where it shows up and it apparently shouldn't matter
for userland as long as /sys/bus/ part is there but /sys/virtual/
seems to be the best fit at the moment.

Thanks.

-- 
tejun
