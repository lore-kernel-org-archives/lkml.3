Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3HZVXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 17:23:33 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:36268 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3HZVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 17:23:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Subject: Re: Asus F5RL laptop unable to resume from S3 because of radeon module
Date: Mon, 26 Aug 2013 23:23:00 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Kernel development list <linux-kernel@vger.kernel.org>
References: <201308222018.00905.linux@rainbow-software.org> <201308251912.32746.linux@rainbow-software.org> <201308260001.12329.linux@rainbow-software.org>
In-Reply-To: <201308260001.12329.linux@rainbow-software.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201308262323.01062.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Monday 26 August 2013 00:01:11 Ondrej Zary wrote:
> On Sunday 25 August 2013 19:12:32 Ondrej Zary wrote:
> > On Sunday 25 August 2013 16:51:06 Deucher, Alexander wrote:
> > > > -----Original Message-----
> > > > From: Ondrej Zary [mailto:linux@rainbow-software.org]
> > > > Sent: Friday, August 23, 2013 1:55 PM
> > > > To: Deucher, Alexander
> > > > Cc: Kernel development list
> > > > Subject: Re: Asus F5RL laptop unable to resume from S3 because of
> > > > radeon module
> > > >
> > > > On Friday 23 August 2013 00:08:33 Ondrej Zary wrote:
> > > > > On Thursday 22 August 2013 22:56:03 Ondrej Zary wrote:
> > > > > > On Thursday 22 August 2013 22:24:17 Deucher, Alexander wrote:
> > > > > > > > -----Original Message-----
> > > > > > > > From: Ondrej Zary [mailto:linux@rainbow-software.org]
> > > > > > > > Sent: Thursday, August 22, 2013 4:00 PM
> > > > > > > > To: Deucher, Alexander
> > > > > > > > Cc: Kernel development list
> > > > > > > > Subject: Re: Asus F5RL laptop unable to resume from S3
> > > > > > > > because of radeon module
> > > > > > > >
> > > > > > > > On Thursday 22 August 2013 21:49:41 Deucher, Alexander wrote:
> > > > > > > > > > -----Original Message-----
> > > > > > > > > > From: Ondrej Zary [mailto:linux@rainbow-software.org]
> > > > > > > > > > Sent: Thursday, August 22, 2013 2:18 PM
> > > > > > > > > > To: Kernel development list
> > > > > > > > > > Cc: Deucher, Alexander
> > > > > > > > > > Subject: Asus F5RL laptop unable to resume from S3
> > > > > > > > > > because of radeon module
> > > > > > > > > >
> > > > > > > > > > Hello,
> > > > > > > > > > resume from suspend-to-RAM (S3) on Asus F5RL laptop does
> > > > > > > > > > not work. According to many reports found by Google, it
> > > > > > > > > > was always been that and there
> > > > > > > > > > is no fix or workaround.
> > > > > > > > >
> > > > > > > > > Make sure your kernel has this patch:
> > > > > > > > > http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.
> > > > > > > > >gi t/ comm it /? id=c
> > > > > > > > > ef1d00cd56f600121ad121875655ad410a001b8
> > > > > > > >
> > > > > > > > Just tried latest git (3.11-rc6+) and the problem persists.
> > > > > > >
> > > > > > > You might try adding a quirk for your system in
> > > > > > > radeon_combios_asic_init() in radeon_combios.c.  You can try
> > > >
> > > > something
> > > >
> > > > > > > like this for testing:
> > > > > > >
> > > > > > > diff --git a/drivers/gpu/drm/radeon/radeon_combios.c
> > > > > > > b/drivers/gpu/drm/radeon/radeon_combios.c index
> > > > > > > 68ce360..0419a2c
> > > >
> > > > 100644
> > > >
> > > > > > > --- a/drivers/gpu/drm/radeon/radeon_combios.c
> > > > > > > +++ b/drivers/gpu/drm/radeon/radeon_combios.c
> > > > > > > @@ -3398,6 +3398,8 @@ void radeon_combios_asic_init(struct
> > > >
> > > > drm_device
> > > >
> > > > > > > *dev) rdev->pdev->subsystem_device == 0x30ae)
> > > > > > >                 return;
> > > > > > >
> > > > > > > +       return;
> > > > > > > +
> > > > > > >         /* DYN CLK 1 */
> > > > > > >         table = combios_get_table_offset(dev,
> > > >
> > > > COMBIOS_DYN_CLK_1_TABLE);
> > > >
> > > > > > >         if (table)
> > > > > > >
> > > > > > > If that doesn't work, you'll probably have to track down where
> > > > > > > it's hanging during resume, or compare registers before and
> > > > > > > after resume
> > > >
> > > > to
> > > >
> > > > > > > see if it's some particular state that's causing a problem.
> > > > > >
> > > > > > No change.
> > > > > >
> > > > > > Inserted "return -1;" before radeon_device_init() to
> > > > > > radeon_driver_load_kms() - driver fails to load and resume works.
> > > > > > Moved it (and changed to "r = -1; goto out;") a bit down before
> > > > > > radeon_modeset_init() - driver fails to load and resume stopped
> > > >
> > > > working.
> > > >
> > > > > Going deeper... it works before rs400_startup() and does not work
> > > > > after that. Will continue later.
> > > >
> > > > Tracked the problem down to rs400_gart_enable(). When this "Disable
> > > > AGP mode"
> > > > code is commented out, the machine resumes fine:
> > > >
> > > >         if ((rdev->family == CHIP_RS690) || (rdev->family ==
> > > > CHIP_RS740)) { WREG32_MC(RS480_MC_MISC_CNTL,
> > > >                         (RS480_GART_INDEX_REG_EN |
> > > > RS690_BLOCK_GFX_D3_EN)); } else {
> > > >               WREG32_MC(RS480_MC_MISC_CNTL, RS480_GART_INDEX_REG_EN);
> > > >         }
> > >
> > > Does the driver work properly after resume with that part commented out
> > > or does it just avoid the hang?
> >
> > Console seems to work fine, haven't tested X, 3D or video.
>
> Testing it right now - everything seems to work. X, accelerated video
> (mplayer), 3D (glxgears). Both before and after suspend.
> That code does something with GART so maybe I should test something like
> OpenArena (have to download it first).

OpenArena works fine with the code commented out. Both before and after 
suspend.

> > > Alex
> > >
> > > > > > > Alex
> > > > > > >
> > > > > > > > > Alex
> > > > > > > > >
> > > > > > > > > > Did some tests:
> > > > > > > > > >
> > > > > > > > > > radeon module loaded (usual state):
> > > > > > > > > > After "echo mem>/sys/power/state", the laptop suspends
> > > >
> > > > correctly
> > > >
> > > > > > > > (power
> > > > > > > >
> > > > > > > > > > LED
> > > > > > > > > > blinks). When power button is pressed, power LED goes on
> > > > > > > > > > and that's all. No more activity, machine is frozen
> > > > > > > > > > completely.
> > > > > > > > > >
> > > > > > > > > > radeon module not loaded at all:
> > > > > > > > > > Laptop resumes correctly (keyboard LED work, network
> > > > > > > > > > works),
> > > >
> > > > only
> > > >
> > > > > > > > > > the
> > > > > > > >
> > > > > > > > LCD
> > > > > > > >
> > > > > > > > > > is
> > > > > > > > > > blank (obviously). Loading radeon module now initializes
> > > > > > > > > > the card properly: LCD goes on and console works.
> > > > > > > > > >
> > > > > > > > > > radeon module loaded (but fbcon module not loaded) and
> > > > > > > > > > then
> > > > > > > >
> > > > > > > > unloaded:
> > > > > > > > > > Machine freezes the same way as when the module is
> > > > > > > > > > loaded.
> > > > > > > > > >
> > > > > > > > > > So it looks like the radeon module does some
> > > > > > > > > > initialization that prevents resume from working.
> > > > > > > > > >
> > > > > > > > > > Hibernation works fine.
> > > > > > > > > >
> > > > > > > > > > Any ideas what to test or how to debug this?
> > > > > > > > > >
> > > > > > > > > > Details:
> > > > > > > > > > 01:05.0 VGA compatible controller [0300]: Advanced Micro
> > > >
> > > > Devices,
> > > >
> > > > > > > > > > Inc. [AMD/ATI] RC410M [Mobility Radeon Xpress 200M]
> > > >
> > > > [1002:5a62]
> > > >
> > > > > > > > > > (prog-if
> > > > > > > >
> > > > > > > > 00
> > > > > > > >
> > > > > > > > > > [VGA controller])
> > > > > > > > > >         Subsystem: ASUSTeK Computer Inc. Device
> > > > > > > > > > [1043:1402] Flags: bus master, 66MHz, medium devsel,
> > > > > > > > > > latency 64, IRQ 10 Memory at c0000000 (32-bit,
> > > > > > > > > > prefetchable) [size=256M] I/O ports at 9800 [size=256]
> > > > > > > > > >         Memory at fa8f0000 (32-bit, non-prefetchable)
> > > > > > > > > > [size=64K] Expansion ROM at fa8c0000 [disabled]
> > > > > > > > > > [size=128K] Capabilities: [50] Power Management version 2
> > > > > > > > > > Capabilities: [80] MSI: Enable- Count=1/1 Maskable-
> > > > > > > > > > 64bit- Kernel driver in use: radeon
> > > > > > > > > >
> > > > > > > > > > [    4.836009] [drm] radeon kernel modesetting enabled.
> > > > > > > > > > [    4.837169] [drm] initializing kernel modesetting
> > > > > > > > > > (RS400 0x1002:0x5A62 0x1043:0x1402).
> > > > > > > > > > [    4.837251] [drm] register mmio base: 0xFA8F0000
> > > > > > > > > > [    4.837302] [drm] register mmio size: 65536
> > > > > > > > > > [    4.837570] [drm] Generation 2 PCI interface, using
> > > > > > > > > > max accessible memory [    4.837653] radeon 0000:01:05.0:
> > > > > > > > > > VRAM:
> > > >
> > > > 128M
> > > >
> > > > > > > > 0x0000000078000000
> > > > > > > >
> > > > > > > > > > - 0x000000007FFFFFFF (128M used)
> > > > > > > > > > [    4.837714] radeon 0000:01:05.0: GTT: 512M
> > > > > > > > > > 0x0000000080000000 - 0x000000009FFFFFFF
> > > > > > > > > > [    4.837787] [drm] Detected VRAM RAM=128M, BAR=256M
> > > > > > > > > > [    4.837839] [drm] RAM width 128bits DDR
> > > > > > > > > > [    4.839854] [TTM] Zone  kernel: Available graphics
> > > > > > > > > > memory: 444588 kiB [    4.839907] [TTM] Zone highmem:
> > > > > > > > > > Available graphics memory: 972784
> > > > > > > >
> > > > > > > > kiB
> > > > > > > >
> > > > > > > > > > [    4.839959] [TTM] Initializing pool allocator
> > > > > > > > > > [    4.840042] [drm] radeon: 128M of VRAM memory ready
> > > > > > > > > > [    4.840094] [drm] radeon: 512M of GTT memory ready.
> > > > > > > > > > [    4.840160] [drm] GART: num cpu pages 131072, num gpu
> > > > > > > > > > pages 131072 [    4.866905] [drm] radeon: 2 quad pipes, 1
> > > > > > > > > > z pipes initialized. [    4.872945] [drm] PCIE GART of
> > > > > > > > > > 512M enabled (table at
> > > > > > > > > > 0x0000000035A00000).
> > > > > > > > > > [    4.873213] radeon 0000:01:05.0: WB enabled
> > > > > > > > > > [    4.873301] radeon 0000:01:05.0: fence driver on ring
> > > > > > > > > > 0 use gpu addr 0x0000000080000000 and cpu addr 0xf592c000
> > > > > > > > > > [    4.874929] [drm] Supports vblank timestamp caching
> > > > > > > > > > Rev 1 (10.10.2010). [    4.874988] [drm] Driver supports
> > > > > > > > > > precise vblank timestamp query. [    4.875055] [drm]
> > > > > > > > > > radeon: irq initialized. [    4.875119] [drm] Loading
> > > > > > > > > > R300 Microcode [    4.962083] ohci_hcd: USB 1.1 'Open'
> > > > > > > > > > Host Controller (OHCI) Driver [    5.088150] ohci-pci:
> > > > > > > > > > OHCI PCI platform driver [    5.141799] [drm] radeon:
> > > > > > > > > > ring at 0x0000000080001000 [    5.141883] [drm] ring test
> > > > > > > > > > succeeded in 2 usecs
> > > > > > > > > > [    5.142064] spurious 8259A interrupt: IRQ7.
> > > > > > > > > > [    5.142073] [drm] ib test succeeded in 0 usecs
> > > > > > > > > > [    5.142317] [drm] Panel ID String: LPL
> > > > > > > > > > [    5.142370] [drm] Panel Size 1280x800
> > > > > > > > > > [    5.166305] [drm] radeon legacy LVDS backlight
> > > > > > > > > > initialized [    5.166358] [drm] Radeon Display
> > > > > > > > > > Connectors [    5.166408] [drm] Connector 0:
> > > > > > > > > > [    5.166458] [drm]   VGA-1
> > > > > > > > > > [    5.166509] [drm]   DDC: 0x68 0x68 0x68 0x68 0x68 0x68
> > > > > > > > > > 0x68 0x68 [    5.166560] [drm]   Encoders:
> > > > > > > > > > [    5.166610] [drm]     CRT1: INTERNAL_DAC2
> > > > > > > > > > [    5.166660] [drm] Connector 1:
> > > > > > > > > > [    5.166710] [drm]   LVDS-1
> > > > > > > > > > [    5.166760] [drm]   DDC: 0x198 0x198 0x19c 0x19c 0x1a0
> > > > > > > > > > 0x1a0 0x1a4 0x1a4 [    5.166812] [drm]   Encoders:
> > > > > > > > > > [    5.166862] [drm]     LCD1: INTERNAL_LVDS
> > > > > > > > > > [    5.426968] [drm] fb mappable at 0xC0040000
> > > > > > > > > > [    5.427026] [drm] vram apper at 0xC0000000
> > > > > > > > > > [    5.427076] [drm] size 4096000
> > > > > > > > > > [    5.427126] [drm] fb depth is 24
> > > > > > > > > > [    5.427176] [drm]    pitch is 5120
> > > > > > > > > > [    5.427388] radeon 0000:01:05.0: fb0: radeondrmfb
> > > > > > > > > > frame buffer device [    5.427442] radeon 0000:01:05.0:
> > > > > > > > > > registered panic notifier [    5.427501] [drm]
> > > > > > > > > > Initialized radeon 2.34.0 20080528 for 0000:01:05.0 on
> > > > > > > > > > minor 0
> > > > > > > > > >
> > > > > > > > > > --
> > > > > > > > > > Ondrej Zary
> > > > > > > >
> > > > > > > > --
> > > > > > > > Ondrej Zary
> > > >
> > > > --
> > > > Ondrej Zary
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > > in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/


-- 
Ondrej Zary
