Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968233AbaLLNzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:55:41 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52993 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967834AbaLLNzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:55:35 -0500
Date: Fri, 12 Dec 2014 14:55:33 +0100
From: Pavel Machek <pavel@ucw.cz>
To: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com
Subject: 3.19-rc0: video stops working after update
Message-ID: <20141212135533.GA31299@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After updating tree based on -pali to
2756d373a3f45a3a9ebf4ac389f9e0e02bd35a93 (and trimming down dts to
make it boot, as I'm still hiting dts size limit), video stops
working.

I also found this nastiness in dmesg:

Ideas welcome.

Best regards,
								Pavel

[    0.285583] Thumb binaries may crash randomly without this
workaround
[    0.285644] RX-51: Registring OMAP3 HWRNG device
[    0.290679] hw-breakpoint: debug architecture 0x4 unsupported.
[    0.293182] In-band Error seen by MPU  at address 0
[    0.293243] ------------[ cut here ]------------
[    0.293304] WARNING: CPU: 0 PID: 1 at drivers/bus/omap_l3_smx.c:166
omap3_l3_app_irq+0
xd4/0x124()
[    0.293365] Modules linked in:
[    0.293426] CPU: 0 PID: 1 Comm: swapper Not tainted
3.18.0-omap3-76150-g3d3c12d-dirty #737
[    0.293487] Backtrace:
[    0.293548] [<c0011630>] (dump_backtrace) from [<c00117cc>]
(show_stack+0x18/0x1c)
[    0.293579]  r6:c06cad30 r5:000000a6 r4:00000000 r3:00000000
[    0.293670] [<c00117b4>] (show_stack) from [<c056f86c>]
(dump_stack+0x20/0x28)
[    0.293731] [<c056f84c>] (dump_stack) from [<c0036f90>]
(warn_slowpath_common+0x7c/0xb4)
[    0.293823] [<c0036f14>] (warn_slowpath_common) from [<c0036fec>]
(warn_slowpath_null+0x24/0x2c)
[    0.293853]  r8:00000013 r7:f8001400 r6:00000000 r5:00000000
r4:04001b00
[    0.293945] [<c0036fc8>] (warn_slowpath_null) from [<c0225c84>]
(omap3_l3_app_irq+0xd4/0x124)
[    0.294036] [<c0225bb0>] (omap3_l3_app_irq) from [<c00628dc>]
(handle_irq_event_percpu+0x54/0x164)
[    0.294097]  r7:00000000 r6:00000000 r5:cf89ec40 r4:cf89ec40
[    0.294158] [<c0062888>] (handle_irq_event_percpu) from
[<c0062a44>] (handle_irq_event+0x58/0x8c)
[    0.294219]  r10:cf803200 r9:20000113 r8:0000000a r7:cf843ce0
r6:00000000 r5:cf89ec40
[    0.294311]  r4:cf8ed240
[    0.294342] [<c00629ec>] (handle_irq_event) from [<c0065478>]
(handle_level_irq+0xdc/0x15c)
[    0.294403]  r5:00000000 r4:cf8ed240
[    0.294464] [<c006539c>] (handle_level_irq) from [<c0062130>]
(generic_handle_irq+0x28/0x38)
[    0.294494]  r4:00000013 r3:c006539c
[    0.294555] [<c0062108>] (generic_handle_irq) from [<c0062300>]
(__handle_domain_irq+0x68/0xc4)
[    0.294616]  r4:c07a9cf8 r3:00000103
[    0.294677] [<c0062298>] (__handle_domain_irq) from [<c0008700>]
(omap_intc_handle_irq+0xbc/0xcc)
[    0.294738]  r10:60000113 r8:00000000 r7:c08d8700 r6:cf843ce0
r5:c07a9ed0 r4:0000000a
[    0.294830] [<c0008644>] (omap_intc_handle_irq) from [<c0012280>]
(__irq_svc+0x40/0x74)
[    0.294891] Exception stack(0xcf843ce0 to 0xcf843d28)
[    0.294921] 3ce0: cf978600 c079fe88 00000001 00000000 cf978600
c079fe88 0000001c 00000000
[    0.294982] 3d00: cf978634 20000113 60000113 cf843d54 cf843d28
cf843d28 c0063c50 c0063d2c
[    0.295043] 3d20: 60000113 ffffffff
[    0.295074]  r8:cf978634 r7:cf843d14 r6:ffffffff r5:60000113
r4:c0063d2c r3:c0063c50
[    0.295166] [<c0063990>] (__setup_irq) from [<c00640f0>]
(setup_irq+0x48/0x90)
[    0.295227]  r10:cf842000 r8:ffffffff r7:80000000 r6:c079fe88
r5:0000001c r4:cf978600
[    0.295318] [<c00640a8>] (setup_irq) from [<c0031a98>]
(omap_system_dma_probe+0x214/0x2fc)
[    0.295379]  r6:0000001c r5:c07cb044 r4:00000020 r3:00000000
[    0.295471] [<c0031884>] (omap_system_dma_probe) from [<c029aaac>]
(platform_drv_probe+0x50/0xac)
[    0.295532]  r10:cf842000 r9:00000000 r8:00000000 r7:c079fe44
r6:fffffdfb r5:cf985e10
[    0.295593]  r4:ffffffed
[    0.295654] [<c029aa5c>] (platform_drv_probe) from [<c029934c>]
(driver_probe_device+0x10c/0x22c)
[    0.295715]  r7:c079fe44 r6:00000000 r5:cf985e10 r4:c08def30
[    0.295776] [<c0299240>] (driver_probe_device) from [<c0299500>]
(__driver_attach+0x94/0x98)
[    0.295837]  r8:c07527f0 r7:00000000 r6:cf985e44 r5:c079fe44
r4:cf985e10 r3:00000000
[    0.295928] [<c029946c>] (__driver_attach) from [<c02979c8>]
(bus_for_each_dev+0x5c/0x90)
[    0.295989]  r6:c029946c r5:c079fe44 r4:00000000 r3:00000000
[    0.296081] [<c029796c>] (bus_for_each_dev) from [<c0298e48>]
(driver_attach+0x24/0x28)
[    0.296112]  r6:c07b0410 r5:cf881a80 r4:c079fe44
[    0.296173] [<c0298e24>] (driver_attach) from [<c0298ac8>]
(bus_add_driver+0xdc/0x1d8)
[    0.296264] [<c02989ec>] (bus_add_driver) from [<c0299bf0>]
(driver_register+0x80/0xfc)
[    0.296295]  r7:000000b8 r6:cf988580 r5:c0789be0 r4:c079fe44
[    0.296386] [<c0299b70>] (driver_register) from [<c029a928>]
(__platform_driver_register+0x50/0x64)
[    0.296447]  r5:c0789be0 r4:c0789be0
[    0.296508] [<c029a8d8>] (__platform_driver_register) from
[<c0752808>] (omap_system_dma_init+0x18/0x20)
[    0.296569] [<c07527f0>] (omap_system_dma_init) from [<c0008998>]
(do_one_initcall+0x88/0x1cc)
[    0.296661] [<c0008910>] (do_one_initcall) from [<c0744d94>]
(kernel_init_freeable+0xf0/0x1b8)
[    0.296691]  r10:c0773014 r9:c0772ffc r8:c07445ec r7:000000b8
r6:c07ca440 r5:00000003
[    0.296783]  r4:c077e570
[    0.296844] [<c0744ca4>] (kernel_init_freeable) from [<c056b04c>]
(kernel_init+0x10/0xec)
[    0.296874]  r10:00000000 r9:00000000 r8:00000000 r7:00000000
r6:00000000 r5:c056b03c
[    0.296966]  r4:00000000
[    0.296997] [<c056b03c>] (kernel_init) from [<c000ebd8>]
(ret_from_fork+0x14/0x3c)
[    0.297058]  r4:00000000 r3:00000000
[    0.297149] ---[ end trace d174f22d07c1fabd ]---
[    0.297241] Reserving DMA channels 0 and 1 for HS ROM code
[    0.297302] OMAP DMA hardware revision 4.0
[    0.445098] omap-dma-engine 48056000.dma-controller: OMAP DMA
engine driver
[    0.452148] SCSI subsystem initialized



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
