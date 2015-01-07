Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963AbbAGToL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:44:11 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:48401 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbbAGToJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:44:09 -0500
Date: Wed, 7 Jan 2015 21:43:59 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Felipe Balbi <balbi@ti.com>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150107194359.GE6071@fuloong-minipc.musicnaut.iki.fi>
References: <20150106170433.GA5408@amd>
 <20150106172545.GK6502@saruman>
 <20150106175115.GA19487@amd>
 <20150106202857.GB32308@saruman>
 <20150106205000.GB13902@amd>
 <20150106205730.GA6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106220805.GD13902@amd>
 <20150106222717.GC6071@fuloong-minipc.musicnaut.iki.fi>
 <20150106225856.GB31990@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106225856.GB31990@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 06, 2015 at 11:58:56PM +0100, Pavel Machek wrote:
> On Wed 2015-01-07 00:27:17, Aaro Koskinen wrote:
> > On Tue, Jan 06, 2015 at 11:08:05PM +0100, Pavel Machek wrote:
> > > On Tue 2015-01-06 22:57:30, Aaro Koskinen wrote:
> > > > Hi,
> > > > 
> > > > On Tue, Jan 06, 2015 at 09:50:00PM +0100, Pavel Machek wrote:
> > > > > PS: Unfortunately, N900 will not boot using nfsroot in 3.16+ at least,
> > > > > and boot from MMC card is broken and has been for quite some time.
> > > > 
> > > > USB networking works fine with 3.19-rc3 and also MMC card rootfs.
> > > 
> > > Does nfsroot work for you? USB networking works as a module but not
> > > build-in. [Patch is available for this one.]
> > > 
> > > u-SD card seems to have similar problem. If I try it after boot, I can
> > > access it ok, but using u-SD card for rootfs fails. If it works for
> > > you, it would be interesting to know.
> > 
> > I haven't tried nfsroot, but I've been using USB networking for ssh
> > for a couple of years without issues. I have g_ether as module.
> > 
> > Also I recently switched rootfs to u-SD card, and it (MMC) works fine
> > as builtin.
> > 
> > But I'm mounting it from userspace (using builtin initramfs inside
> > zImage), with a poll loop that waits for a device to appear. Maybe if you
> > do it from kernel you need to use root wait/delay etc. options?
> 
> Yes, it works if I mount it later. It fails when done directly using
> root=, even with rootwait etc. Hard to believe, yes, but try it. You
> can watch the results on console.

Well, I tried and it works. 3.19-rc3 mounting logs are below.

I used "root=/dev/mmcblk0p2 rootwait". Note that the external MMC
is "mmcblk0" from kernel point of view.

Without serial console I guess you could maybe capture the failure
logs using mtdoops (assuming the kernel panics when it fails to mount
the rootfs). mtdoops was used even in the sales model kernel, so there
is MTD partition reserved already for it called "log".

I would also recommend using initramfs to do the mounting etc. Then you
could use the framebuffer console to observe and debug some obvious issues
(assuming the framebuffer works, it often regresses unfortunately...).

A.

...

[    2.145721] Waiting for root device /dev/mmcblk0p2...
[    2.194335] mmc0: host does not support reading read-only switch, assuming write-enable
[    2.213775] mmc0: new high speed SDHC card at address aaaa
[    2.227905] mmcblk0: mmc0:aaaa SL32G 29.7 GiB
[    2.252227]  mmcblk0: p1 p2
[    2.381958] EXT4-fs (mmcblk0p2): couldn't mount as ext3 due to feature incompatibilities
[    2.399627] EXT4-fs (mmcblk0p2): couldn't mount as ext2 due to feature incompatibilities
[    2.420196] EXT4-fs (mmcblk0p2): INFO: recovery required on readonly filesystem
[    2.435485] EXT4-fs (mmcblk0p2): write access will be enabled during recovery[    2.497375] mmc1: switch to bus width 2 failed
[    2.510620] mmc1: switch to bus width 1 failed
[    2.524658] mmc1: new high speed MMC card at address 0001
[    2.541229] mmcblk1: mmc1:0001 MMC32G 29.8 GiB
[    2.553710] mmcblk1boot0: mmc1:0001 MMC32G partition 1 512 KiB
[    2.569854] mmcblk1boot1: mmc1:0001 MMC32G partition 2 512 KiB
[    2.587646]  mmcblk1: p1 p2 p3
[    2.827606] EXT4-fs (mmcblk0p2): recovery complete
[    2.848327] EXT4-fs (mmcblk0p2): mounted filesystem with ordered data mode. Opts: (null)
[    2.863464] VFS: Mounted root (ext4 filesystem) readonly on device 179:2.
