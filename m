Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab3CTPAW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:00:22 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:39476 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3CTPAU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:00:20 -0400
Date: Wed, 20 Mar 2013 02:03:20 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] init: fix name of root device in /proc/mounts
To: William Hubbs <w.d.hubbs@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        mpagano@gentoo.org, ryao@gentoo.org, gregkh@gentoo.org,
        torvalds@linux-foundation.org
In-Reply-To: <20130320002017.GA2810@linux1> (from w.d.hubbs@gmail.com on Tue
	Mar 19 19:20:17 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1363763000.15703.47@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 07:20:17 PM, William Hubbs wrote:
> On Tue, Mar 19, 2013 at 04:17:11PM -0700, H. Peter Anvin wrote:
> > On 03/19/2013 03:28 PM, William Hubbs wrote:
> > > The issue is that /dev/root appears in /proc/mounts if you do not
> > > boot with an initramfs, but /dev/root is not a device node. In the
> > > past, udev created a symbolic link from /dev/root to the
> > > appropriate block device, but it does not do this any longer.  
> Also,
> > > devtmpfs does not create this symbolic link.
> > >
> > > This is causing bugs with software that depends on the existence
> > > of /dev/root [2] for example.
> >
> > Seems okay to me, although even better would be to use the udev name
> > of the device in question.
> 
> I'm not following what you mean.
> 
> The problem is that "/dev/root" should not be in /proc/mounts,
> since there is always another entry that points to the root
> file system.

What gave you that idea?

wget http://landley.net/aboriginal/bin/system-image-i686.tar.bz2
extract it and ./run-emulator.sh and in there:

(i686:1) /home # cat /proc/mounts
rootfs / rootfs rw 0 0
/dev/root / squashfs ro,relatime 0 0
proc /proc proc rw,relatime 0 0
sys /sys sysfs rw,relatime 0 0
dev /dev devtmpfs rw,relatime,size=63072k,nr_inodes=15768,mode=755 0 0
dev/pts /dev/pts devpts rw,relatime,mode=600 0 0
/tmp /tmp tmpfs rw,relatime 0 0
/home /home tmpfs rw,relatime 0 0

Userspace can totally determine what /dev/root points to, I made mdev  
do it in 2006 (udev started doing so shortly thereafter). Busybox git  
commit a7e3d052.

Heck, the userspace "stat /" command says "Device: 801h" and /dev/sda1  
is 08:01 on my netbook.

Rob