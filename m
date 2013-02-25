Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411Ab3BYNFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:05:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47087 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab3BYNFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:05:50 -0500
Date: Mon, 25 Feb 2013 14:05:46 +0100
From: Jan Kara <jack@suse.cz>
To: Marcus Sundman <marcus@hibox.fi>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130225130546.GA8232@quack.suse.cz>
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
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 23-02-13 01:27:38, Marcus Sundman wrote:
> Sure:
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
> >none /sys/fs/fuse/connections fusectl rw,relatime 0 0
> >none /sys/kernel/debug debugfs rw,relatime 0 0
> >none /sys/kernel/security securityfs rw,relatime 0 0
> >none /run/lock tmpfs rw,nosuid,nodev,noexec,relatime,size=5120k 0 0
> >none /run/shm tmpfs rw,nosuid,nodev,relatime 0 0
> >none /run/user tmpfs
> >rw,nosuid,nodev,noexec,relatime,size=102400k,mode=755 0 0
> >/dev/sda6 /home ext4 rw,noatime,discard 0 0
> >binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc
> >rw,nosuid,nodev,noexec,relatime 0 0
> >gvfsd-fuse /run/user/marcus/gvfs fuse.gvfsd-fuse
> >rw,nosuid,nodev,relatime,user_id=1000,group_id=100 0 0
> 
> Both / and /home are on the same SSD and suffer from the same
> problem. (I think the swap does as well, but I have my swappiness
> set very low to minimize swapping.)
  Yeah, my suspicion is confirmed. Try removing the 'discard' option. See
Ted's email for more details.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
