Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbaDSTDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:03:11 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:56232 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbaDSTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:03:08 -0400
Date: Sat, 19 Apr 2014 21:03:05 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Subject: Re: [git pull] drm fixes
Message-ID: <20140419190305.GA267@x4>
References: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.00.1404190810001.7507@skynet.skynet.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.04.19 at 08:19 +0100, Dave Airlie wrote:
> 
> Unfortunately this contains no easter eggs, its a bit larger than I'd 
> like, but I included a patch that just moves code from one file to another 
> and I'd like to avoid merge conflicts with that later, so it makes it seem 
> worse than it is,

> Christian König (2):
>       drm/radeon: apply more strict limits for PLL params v2
>       drm/radeon: improve PLL params if we don't match exactly v2

commit f8a2645ecede4eaf90b3d785f2805c8ecb76d43e
Author: Christian König <christian.koenig@amd.com>
Date:   Wed Apr 16 11:54:21 2014 +0200

    drm/radeon: improve PLL params if we don't match exactly v2

The commit above causes my monitor to just stay blank after boot.
No framebuffer, no Xorg, no nothing. I'm using a Radeon RS780.


Apr 19 20:55:45 x4 kernel: Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Apr 19 20:55:45 x4 kernel: [drm] Initialized drm 1.1.0 20060810
Apr 19 20:55:45 x4 kernel: [drm] radeon kernel modesetting enabled.
Apr 19 20:55:45 x4 kernel: [drm] initializing kernel modesetting (RS780 0x1002:0x9614 0x1043:0x834D).
Apr 19 20:55:45 x4 kernel: [drm] register mmio base: 0xFBEE0000
Apr 19 20:55:45 x4 kernel: [drm] register mmio size: 65536
Apr 19 20:55:45 x4 kernel: ATOM BIOS: 113
Apr 19 20:55:45 x4 kernel: radeon 0000:01:05.0: VRAM: 128M 0x00000000C0000000 - 0x00000000C7FFFFFF (128M used)
Apr 19 20:55:45 x4 kernel: radeon 0000:01:05.0: GTT: 512M 0x00000000A0000000 - 0x00000000BFFFFFFF
Apr 19 20:55:45 x4 kernel: [drm] Detected VRAM RAM=128M, BAR=128M
Apr 19 20:55:45 x4 kernel: [drm] RAM width 32bits DDR
Apr 19 20:55:45 x4 kernel: [TTM] Zone  kernel: Available graphics memory: 4083362 kiB
Apr 19 20:55:45 x4 kernel: [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
Apr 19 20:55:45 x4 kernel: [TTM] Initializing pool allocator
Apr 19 20:55:45 x4 kernel: [TTM] Initializing DMA pool allocator
Apr 19 20:55:45 x4 kernel: [drm] radeon: 128M of VRAM memory ready
Apr 19 20:55:45 x4 kernel: [drm] radeon: 512M of GTT memory ready.
Apr 19 20:55:45 x4 kernel: [drm] Loading RS780 Microcode
Apr 19 20:55:45 x4 kernel: == power state 0 ==
Apr 19 20:55:45 x4 kernel:      ui class: none
Apr 19 20:55:45 x4 kernel:      internal class: boot
Apr 19 20:55:45 x4 kernel:      caps: video
Apr 19 20:55:45 x4 kernel:      uvd    vclk: 0 dclk: 0
Apr 19 20:55:45 x4 kernel:              power level 0    sclk: 50000 vddc_index: 2
Apr 19 20:55:45 x4 kernel:              power level 1    sclk: 50000 vddc_index: 2
Apr 19 20:55:45 x4 kernel:      status: c r b
Apr 19 20:55:45 x4 kernel: == power state 1 ==
Apr 19 20:55:45 x4 kernel:      ui class: performance
Apr 19 20:55:45 x4 kernel:      internal class: none
Apr 19 20:55:45 x4 kernel:      caps: video
Apr 19 20:55:45 x4 kernel:      uvd    vclk: 0 dclk: 0
Apr 19 20:55:45 x4 kernel:              power level 0    sclk: 50000 vddc_index: 1
Apr 19 20:55:45 x4 kernel:              power level 1    sclk: 70000 vddc_index: 2
Apr 19 20:55:45 x4 kernel:      status:
Apr 19 20:55:45 x4 kernel: == power state 2 ==
Apr 19 20:55:45 x4 kernel:      ui class: none
Apr 19 20:55:45 x4 kernel:      internal class: uvd
Apr 19 20:55:45 x4 kernel:      caps: video
Apr 19 20:55:45 x4 kernel:      uvd    vclk: 53300 dclk: 40000
Apr 19 20:55:45 x4 kernel:              power level 0    sclk: 50000 vddc_index: 1
Apr 19 20:55:45 x4 kernel:              power level 1    sclk: 50000 vddc_index: 1
Apr 19 20:55:45 x4 kernel:      status:
Apr 19 20:55:45 x4 kernel: [drm] radeon: dpm initialized
Apr 19 20:55:45 x4 kernel: [drm] GART: num cpu pages 131072, num gpu pages 131072
Apr 19 20:55:45 x4 kernel: [drm] PCIE GART of 512M enabled (table at 0x00000000C0040000).
Apr 19 20:55:45 x4 kernel: radeon 0000:01:05.0: WB enabled
Apr 19 20:55:45 x4 kernel: radeon 0000:01:05.0: fence driver on ring 0 use gpu addr 0x00000000a0000c00 and cpu addr 0xffff8800db8d0c00
Apr 19 20:55:45 x4 kernel: [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
Apr 19 20:55:45 x4 kernel: [drm] Driver supports precise vblank timestamp query.
Apr 19 20:55:45 x4 kernel: [drm] radeon: irq initialized.
Apr 19 20:55:45 x4 kernel: [drm] ring test on 0 succeeded in 1 usecs
Apr 19 20:55:45 x4 kernel: [drm] ib test on ring 0 succeeded in 0 usecs
Apr 19 20:55:45 x4 kernel: [drm] Radeon Display Connectors
Apr 19 20:55:45 x4 kernel: [drm] Connector 0:
Apr 19 20:55:45 x4 kernel: [drm]   VGA-1
Apr 19 20:55:45 x4 kernel: [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
Apr 19 20:55:45 x4 kernel: [drm]   Encoders:
Apr 19 20:55:45 x4 kernel: [drm]     CRT1: INTERNAL_KLDSCP_DAC1
Apr 19 20:55:45 x4 kernel: [drm] Connector 1:
Apr 19 20:55:45 x4 kernel: [drm]   DVI-D-1
Apr 19 20:55:45 x4 kernel: [drm]   HPD3
Apr 19 20:55:45 x4 kernel: [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
Apr 19 20:55:45 x4 kernel: [drm]   Encoders:
Apr 19 20:55:45 x4 kernel: [drm]     DFP3: INTERNAL_KLDSCP_LVTMA
Apr 19 20:55:45 x4 kernel: switching from power state:
Apr 19 20:55:45 x4 kernel:      ui class: none
Apr 19 20:55:45 x4 kernel:      internal class: boot
Apr 19 20:55:45 x4 kernel:      caps: video
Apr 19 20:55:45 x4 kernel:      uvd    vclk: 0 dclk: 0
Apr 19 20:55:45 x4 kernel:              power level 0    sclk: 50000 vddc_index: 2
Apr 19 20:55:45 x4 kernel:              power level 1    sclk: 50000 vddc_index: 2
Apr 19 20:55:45 x4 kernel:      status: c b
Apr 19 20:55:45 x4 kernel: switching to power state:
Apr 19 20:55:45 x4 kernel:      ui class: performance
Apr 19 20:55:45 x4 kernel:      internal class: none
Apr 19 20:55:45 x4 kernel:      caps: video
Apr 19 20:55:45 x4 kernel:      uvd    vclk: 0 dclk: 0
Apr 19 20:55:45 x4 kernel:              power level 0    sclk: 50000 vddc_index: 1
Apr 19 20:55:45 x4 kernel:              power level 1    sclk: 70000 vddc_index: 2
Apr 19 20:55:45 x4 kernel:      status: r
Apr 19 20:55:45 x4 kernel: [drm] fb mappable at 0xF0141000
Apr 19 20:55:45 x4 kernel: [drm] vram apper at 0xF0000000
Apr 19 20:55:45 x4 kernel: [drm] size 7299072
Apr 19 20:55:45 x4 kernel: [drm] fb depth is 24
Apr 19 20:55:45 x4 kernel: [drm]    pitch is 6912
Apr 19 20:55:45 x4 kernel: fbcon: radeondrmfb (fb0) is primary device
Apr 19 20:55:45 x4 kernel: Console: switching to colour frame buffer device 131x105
Apr 19 20:55:45 x4 kernel: radeon 0000:01:05.0: fb0: radeondrmfb frame buffer device
Apr 19 20:55:45 x4 kernel: radeon 0000:01:05.0: registered panic notifier
Apr 19 20:55:45 x4 kernel: [drm] Initialized radeon 2.38.0 20080528 for 0000:01:05.0 on minor 0

-- 
Markus
