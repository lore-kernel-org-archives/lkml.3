Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaABFZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 00:25:10 -0500
Received: from mail.wdtv.com ([66.118.69.84]:39505 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbaABFZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 00:25:09 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: AMD microcode fails to update with v3.8.3 and newer, bisect failed
Date: Thu, 2 Jan 2014 00:24:56 -0500
Cc: linux-kernel@vger.kernel.org
References: <201401011752.00267.gheskett@wdtv.com> <20140102040815.GA25619@milliways> <20140102044534.GA26440@milliways>
In-Reply-To: <20140102044534.GA26440@milliways>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201401020024.56566.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 January 2014, Ken Moffat wrote:
>On Thu, Jan 02, 2014 at 04:08:15AM +0000, Ken Moffat wrote:
>>  Anyway, best of luck and I hope you get it sorted.
>
> One further suggestion, since you appear to be at the "running
>round in circles" stage -
>
>1. Start with a good kernel.  In this case, I suppose 3.8.2 is the
>right place to begin.

That has since died, won't boot, don't recall changing a thing in the 
.config either.

>2. But then change the .config to -
>
>2.1 ensure that your disk filesystems are built in - e.g. all of
>ext2, ext3, ext4 and anything else you know you are using.

Should I edit in the /etc/grub.d to remove the modprobe ext2, or will it 
more or less silently shake its head and go on. 

>Normally, only the fs for '/' needs to be built in, but you seem to
>have seen other issues so I would just build in everything you need.
>
>2.2 build in everything else you need to boot (normally, the disk
>controller(s) ) so that you don't need an initrd.

That would be forcedeath, nouveau, v4l1 and 2 and hda_audio for starters.

Since this kernel isn't near new enough for the config tricks mentioned, 
maybe I'll see if the linux-stable I have can do a 3.11.0 checkout.

>
>2.3 drop the things you don't need - this is merely to reduce the
>time it takes to build a kernel.  Distros normally build
>_everything_ as a module.  Provided you can boot without an initrd,
>reducing the number of modules only makes it quicker to build a new
>kernel - but if you are starting from something which looks like
>"allmodconfig" it can save a lot of time.

I'll nominate that for understatement of the month. ;-)
>
>2.4 for your convenience, ensure that you have enabled the config to
>be stored in /proc/config.gz - once you are building your own
>slimmed-down kernels, you probably won't want to mess about with
>distro "install" scripts so just copying the bzimage to
>/boot/vmlinuz-x.y.z, make modules_install, and editing
>/boot/grub/grub.cfg (yes, really!) will save a lot of time.

My present script does everything but edit grub.cfg.

>2.5 Add your own version, e.g. for 3.8.2 change EXTRAVERSION to 2-A
>so that the kernel will be 3.8.2-A (this stops it overwriting
>existing existing 3.8.2 modules, in case the first attempt doesn't
>do what you want).

Never has yet anyway.

>3.  That might take two or three attempts to get to a good config,
>but after that you should be able to use the slimmer config (from
>zcat /proc/config.gz) to create .config for any newer version you
>want to test or bisect, and then just run make oldconfig before you
>build.
>
> Also, when you get back to bisecting, the version in the kernel
>Makefile might not be what you expect.  If in doubt, you can change
>it to something which doesn't overwrite any existing modules, e.g.
>3.8.bisect-1 etc.

Presently it uses a + sign for in between versions.

> HTH

It will, if I don't lose my place...
>ĸen

My "makeit" script does cd's here and there, so its vital that the Makefile 
version matches the makeit version.  I've thought of that, and fixed it in 
the copy I use to make a linux-stable install, but I haven't moved that 
line of script into the tarball builds yet.

Having an automatic increment, I could eventually fill up the /boot 
partition too. ;-)

I take it that /proc/config.gz only keeps the lsmod output?  That would be 
sweet!  Great idea.

Thanks Ken & Cheers, Gene
