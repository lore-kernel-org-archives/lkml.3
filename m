Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109Ab3BXAMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 19:12:25 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:51969 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758602Ab3BXAMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 19:12:24 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AloJAGRXKVF5LJ7I/2dsb2JhbABFvD6FE4EGF3OCHwEBBTocIxAIAxgJJQ8FJQMhE4gSvnMVjhoiPQeCX2EDljyQZoMb
Date: Sun, 24 Feb 2013 11:12:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Marcus Sundman <marcus@hibox.fi>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130224001222.GB5551@dastard>
References: <509D014B.2080709@hibox.fi>
 <20121113135159.GA18651@quack.suse.cz>
 <50A592BA.8050709@hibox.fi>
 <20121121233021.GA8730@quack.suse.cz>
 <50B4E6F2.6010000@hibox.fi>
 <20121205153216.GF5706@quack.suse.cz>
 <51248C5F.4040606@hibox.fi>
 <5124B613.6040400@hibox.fi>
 <20130222205144.GA30600@quack.suse.cz>
 <5127FEEA.60207@hibox.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5127FEEA.60207@hibox.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 01:27:38AM +0200, Marcus Sundman wrote:
> >$ cat /proc/mounts
> >rootfs / rootfs rw 0 0
> >sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
> >proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
> >udev /dev devtmpfs rw,relatime,size=1964816k,nr_inodes=491204,mode=755 0 0
> >devpts /dev/pts devpts
> >rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
> >tmpfs /run tmpfs rw,nosuid,relatime,size=789652k,mode=755 0 0
> >/dev/disk/by-uuid/5bfa7a58-2d35-4758-954e-4deafb09b892 / ext4
> >rw,noatime,discard,errors=remount-ro 0 0
              ^^^^^^^

> >none /sys/fs/fuse/connections fusectl rw,relatime 0 0
> >none /sys/kernel/debug debugfs rw,relatime 0 0
> >none /sys/kernel/security securityfs rw,relatime 0 0
> >none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
> >none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
> >none /run/user tmpfs
> >rw,nosuid,nodev,noexec,relatime,size=102400k,mode=755 0 0
> >/dev/sda6 /home ext4 rw,noatime,discard 0 0
                                   ^^^^^^^

I'd say that's your problem....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
