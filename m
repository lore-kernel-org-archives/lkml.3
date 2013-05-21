Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab3EUCZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:25:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:38581 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab3EUCZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:25:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [RFC PATCH v1 0/5] BTRFS hot relocation support
Date: Tue, 21 May 2013 02:22:34 +0000 (UTC)
Message-ID: <pan$d5913$460afe14$f9be182d$7f8dbe54@cox.net>
References: <1369062687-23544-1-git-send-email-zwu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-231-22-224.ph.ph.cox.net
User-Agent: Pan/0.140 (Chocolate Salty Balls; GIT b00f96e
	/usr/src/portage/src/egit-src/pan2)
Cc: linux-btrfs@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zwu.kernel posted on Mon, 20 May 2013 23:11:22 +0800 as excerpted:

> The patchset is trying to introduce hot relocation support
> for BTRFS. In hybrid storage environment, when the data in rotating disk
> get hot, it can be relocated to nonrotating disk by BTRFS hot relocation
> support automatically; also, if nonrotating disk ratio exceed its upper
> threshold, the data which get cold can be looked up and relocated to
> rotating disk to make more space in nonrotating disk at first, and then
> the data which get hot will be relocated to nonrotating disk
> automatically.

One advantage of a filesystem implementation, as opposed to bcache or 
dmcache, is arguably a corner-case, but it's /my/ corner-case, so...

I run an intr*-less (I guess technically, empty initramfs) monolithic-
kernel boot, using the kernel commandline root= and (formerly) md= and 
related logic to choose/assemble/mount root directly from the kernel 
command line via bootloader (grub2).  Thus, any user-space-required-to-
mount-root is out, since I don't have an initr* and thus no early 
userspace.  That means both lvm2 and dmcache (AFAIK) are out.  I'm not 
sure about bcache, but it has other negatives, particularly against btrfs-
raid-1 and I'd guess md/raid-1 as well.

Much like md before it, btrfs, while normally requiring the user-space-
required device-scan to properly handle multiple devices, has kernel-
command-line options that allow direct kernel multi-device assembly 
without the help of early-userspace/initr*.

So in-btrfs hot-relocation support building on the existing kernel-
command-line multi-device assembly options would definitely be welcomed 
by all us no-initr* folks looking at SSDs but not able to afford them 
for /everything/ just yet. =:^)

(That said, even if accepted, your solution's a bit late for my own 
current needs, but there's surely going to be others hitting the same 
issue in a few kernel cycles when your patches could be mainline btrfs, 
and having the option at my next upgrade cycle say a couple years out 
would be very nice, indeed. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

