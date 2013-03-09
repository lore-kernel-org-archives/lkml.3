Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3CISoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 13:44:37 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:56666 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737Ab3CISof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 13:44:35 -0500
Date: Sat, 9 Mar 2013 20:44:31 +0200
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org
Subject: linux 3.9-rc1: nouveau crash on PPC
Message-ID: <20130309184431.GF14552@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There's nouveau crash during boot with 3.9-rc1 on iMac G5 (nVidia GeForce
FX 5200 Ultra). This happens also with current mainline kernel HEAD
(0aefda3e8188ad71168bd32152d41b3d72f04087).

git bisect tells the first bad commit is
1d7c71a3e2f77336df536855b0efd2dc5bdeb41b (drm/nouveau/disp: port vblank
handling to event interface).

The crash is (manually copied from screen):

[...]

Unable to handle kernel paging request for data at address 0x100000000

call trace:
nouveau_event_trigger
nv04_disp_intr
nouveau_mc_intr
nouveau_irq_handler

[...]

I also tried to capture it with netconsole, and got this much:

[   23.114208] nouveau  [  DEVICE][0000:f0:10.0] BOOT0  : 0x034900b1
[   23.114257] nouveau  [  DEVICE][0000:f0:10.0] Chipset: NV34 (NV34)
[   23.114266] nouveau  [  DEVICE][0000:f0:10.0] Family : NV30
[   23.114672] nouveau  [   VBIOS][0000:f0:10.0] checking OpenFirmware for image...
[   23.114712] nouveau  [   VBIOS][0000:f0:10.0] ... checksum invalid
[   23.114720] nouveau  [   VBIOS][0000:f0:10.0] checking PRAMIN for image...
[   23.114754] nouveau  [   VBIOS][0000:f0:10.0] ... signature not found
[   23.114761] nouveau  [   VBIOS][0000:f0:10.0] checking PROM for image...
[   23.114845] nouveau  [   VBIOS][0000:f0:10.0] ... signature not found
[   23.114853] nouveau  [   VBIOS][0000:f0:10.0] checking ACPI for image...
[   23.114862] nouveau  [   VBIOS][0000:f0:10.0] ... signature not found
[   23.114881] nouveau  [   VBIOS][0000:f0:10.0] checking PCIROM for image...
[   23.114930] nouveau 0000:f0:10.0: Invalid ROM contents
[   23.114946] nouveau  [   VBIOS][0000:f0:10.0] ... signature not found
[   23.114976] nouveau  [   VBIOS][0000:f0:10.0] using image from OpenFirmware
[   23.114987] nouveau  [   VBIOS][0000:f0:10.0] BMP version 5.26
[   23.115035] nouveau  [   VBIOS][0000:f0:10.0] version 04.34.20.18.00
[   23.134608] nouveau W[   VBIOS][0000:f0:10.0] unknown i2c type 3
[   23.134637] nouveau W[   VBIOS][0000:f0:10.0] unknown i2c type 3
[   23.136488] nouveau W[  PTIMER][0000:f0:10.0] unknown input clock freq
[   23.136536] nouveau  [     PFB][0000:f0:10.0] RAM type: DDR1
[   23.136544] nouveau  [     PFB][0000:f0:10.0] RAM size: 32 MiB
[   23.136552] nouveau  [     PFB][0000:f0:10.0]    ZCOMP: 0 tags
[   23.150773] [TTM] Zone  kernel: Available graphics memory: 744988 kiB
[   23.150800] [TTM] Initializing pool allocator
[   23.150882] nouveau  [     DRM] VRAM: 31 MiB
[   23.150890] nouveau  [     DRM] GART: 128 MiB
[   23.150927] nouveau  [     DRM] BMP version 5.38
[   23.150937] nouveau  [     DRM] DCB version 2.2
[   23.150971] nouveau  [     DRM] DCB outp 00: 01000122 00000004
[   23.150981] nouveau  [     DRM] DCB outp 01: 02010200 11b088b8
[   23.150988] nouveau  [     DRM] DCB outp 02: 02010201 11b00703
[   23.151040] nouveau  [     DRM] Loading NV17 power sequencing microcode
[   23.170180] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   23.170212] [drm] No driver support for vblank timestamp query.
[   23.170277] nouveau E[     DRM] Pixel clock comparison table not found
[   23.171010] nouveau  [     DRM] 0 available performance level(s)
[   23.171028] nouveau  [     DRM] c: core 241MHz memory 475MHz
[   23.177822] nouveau  [     DRM] MM: using M2MF for buffer copies
[   23.177917] nouveau  [     DRM] Setting dpms mode 3 on TV encoder (output 2)
[   23.285783] nouveau  [     DRM] allocated 1680x1050 fb: 0x9000, bo c000000056d52c00
[   23.306569] nouveau E[     DRM] Pixel clock comparison table not found
[   23.317565] Console: switching to colour frame buffer device 210x65
[   23.321370] nouveau 0000:f0:10.0: fb0: nouveaufb frame buffer device
[   23.321386] nouveau 0000:f0:10.0: registered panic notifier
[   23.321444] [drm] Initialized nouveau 1.1.0 20120801 for 0000:f0:10.0 on minor 0
[   23.329860] Unable to handle kernel paging request for data at address 0x100000000
[   23.329918] Faulting instruction address: 0xd000000000801394
[   23.329939] Oops: Kernel access of bad area, sig: 11 [#1]
[   23.329953] PREEMPT PowerMac
[   23.329982] Modules linked in: nouveau ttm drm_kms_helper
[   23.330035] NIP: d000000000801394 LR: d0000000008013a8 CTR: c0000000000178e0
[   23.330052] REGS: c00000000fff78b0 TRAP: 0300   Not tainted  (3.9.0-rc1-imac-00277-g0aefda3-dirty)
[   23.330065] MSR: 9000000000009032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28000084  XER: 00000000
[   23.330174] SOFTE: 0
[   23.330187] DAR: 0000000100000000, DSISR: 40000000
[   23.330202] TASK = c000000000805aa0[0] 'swapper' THREAD: c000000000894000
GPR00: d0000000008013a8 c00000000fff7b30 d0000000009272c0 c000000056de5458 
GPR04: 0000000000000000 0000000000000000 0000000000000002 0000000000000000 
GPR08: [   24.321933] Kernel panic - not syncing: Fatal exception in interrupt
[   24.321951] drm_kms_helper: panic occurred, switching back to text console
[   24.322013] ------------[ cut here ]------------
[   24.322029] WARNING: at drivers/gpu/drm/drm_crtc.c:82
[   24.322041] Modules linked in: nouveau ttm drm_kms_helper
[   24.322087] NIP: c0000000002e8640 LR: d0000000000a4024 CTR: c0000000002e8610
[   24.322103] REGS: c00000000fff7130 TRAP: 0700   Tainted: G      D       (3.9.0-rc1-imac-00277-g0aefda3-dirty)
[   24.322116] MSR: 9000000000021032 <SF,HV,ME,IR,DR,RI>  CR: 28002048  XER: 00000000
[   24.322201] SOFTE: 0
[   24.322216] TASK = c000000000805aa0[0] 'swapper' THREAD: c000000000894000
GPR00: d0000000000a40f8 c00000000fff73b0 c00000000089ac08 c000000056f09000 
GPR04: 0000000000000001 0000000000000001 0000000000000009 0000000000000000 
GPR08: 

A.
