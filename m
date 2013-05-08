Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3EHVrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:47:47 -0400
Received: from mail-ye0-f181.google.com ([209.85.213.181]:59818 "EHLO
	mail-ye0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3EHVrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:47:46 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 May 2013 17:47:45 EDT
Date: Wed, 8 May 2013 17:39:46 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-iMac
To: =?ISO-8859-15?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
cc: Parag Warudkar <parag.lkml@gmail.com>,
        =?ISO-8859-15?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] radeon: Allow disabling UVD
In-Reply-To: <518A1B94.6090001@vodafone.de>
Message-ID: <alpine.DEB.2.02.1305081730440.7947@parag-iMac>
References: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com> <1367910123.12136.7.camel@thor.local> <5188BEF7.7090505@vodafone.de> <CAOULuObffavZs9+p-C_C5Y6y=6aJhnYVf_d0nXWXb9Zt2A7rBw@mail.gmail.com> <518A1B94.6090001@vodafone.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1174860910-1368049211=:7947"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1174860910-1368049211=:7947
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT



On Wed, 8 May 2013, Christian König wrote:

> Am 07.05.2013 23:13, schrieb Parag Warudkar:
> > On Tue, May 7, 2013 at 4:44 AM, Christian König <deathsimple@vodafone.de>
> > wrote:
> > Without SUMO_uvd.bin - suspends fine and only wakes up when I want it to.
> 
> Hui? Wait a second, the firmware doesn't work but still causes an instant
> resume on suspend? Very strange.

Yes, I tested this multiple times - if firmware loads and the init bails 
out, machine resume instantly, like this -

[ 3631.441257] PM: Entering mem sleep
[ 3631.441274] Suspending console(s) (use no_console_suspend to debug)
[ 3631.441825] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 3631.442003] sd 0:0:0:0: [sda] Stopping disk
[ 3631.755076] PM: suspend of devices complete after 313.257 msecs
[ 3631.755219] PM: late suspend of devices complete after 0.134 msecs
[ 3631.795185] PM: noirq suspend of devices complete after 39.904 msecs
[ 3631.821922] pcieport 0000:00:1c.1: power state changed by ACPI to D0
[ 3631.915378] PM: noirq resume of devices complete after 119.999 msecs
[ 3631.915459] PM: early resume of devices complete after 0.062 msecs
[ 3631.915525] ahci 0000:00:1f.2: setting latency timer to 64
[ 3631.915609] ehci-pci 0000:00:1a.7: setting latency timer to 64
[ 3631.915654] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[ 3631.915690] usb usb1: root hub lost power or was reset
[ 3631.915709] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[ 3631.915770] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[ 3631.915792] usb usb2: root hub lost power or was reset
[ 3631.915804] ehci-pci 0000:00:1d.7: setting latency timer to 64
[ 3631.915821] snd_hda_intel 0000:01:00.1: irq 48 for MSI/MSI-X
[ 3631.918662] [drm] probing gen 2 caps for device 8086:101 = 2212d02/0
[ 3631.918665] [drm] PCIE gen 2 link speeds already enabled
[ 3631.921479] [drm] PCIE GART of 512M enabled (table at 
0x0000000000040000).
[ 3631.921584] radeon 0000:01:00.0: WB enabled

Right now, I have removed SUMO_uvd.bin and suspend resume is working 
without fail. Strange indeed, and I only noticed it when the machine did 
not instant resume when running with the UVD disable patch and no_uvd=1 
which skips uvd init just like firmware lodaing failure does I suppose.

> 
> My best guess is that it has something todo with a different clock routing on
> Macs, but without access to the hardware (or precise documentation from Apple
> what the heck they did different) I don't really see a chance to solve that
> problem.

Hopefully it is not that hard and we'll find a way! I will experiment the 
clocks and see how that goes.

> If you want to hack a bit on it you could try commenting out the calls to
> "radeon_set_uvd_clocks" in radeon_uvd.c. That should give you the default
> clocks of 100Mhz, not enough for usable decoding, but on SUMO based UVD blocks
> a very failsafe default.
> 
> Whatever it is, please send me an output of lspci, so I can blacklist the
> offending chip.
> 
Here is the lspci -nn output :

01:00.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD] nee 
ATI Whistler [Radeon HD 6600M/6700M/7600M Series] [1002:6741]

Parag
--8323329-1174860910-1368049211=:7947--
