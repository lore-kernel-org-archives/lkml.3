Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493AbaJaHzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:55:10 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:55468 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaJaHzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:55:07 -0400
X-ASG-Debug-ID: 1414742103-0759e7758414bbe0002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
Date: Fri, 31 Oct 2014 08:54:49 +0100
From: Frans Klaver <frans.klaver@xsens.com>
To: Roy Spliet <rspliet@eclipso.eu>
CC: Ben Skeggs <bskeggs@redhat.com>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: [bisected] nouveau dual monitor setup broken
Message-ID: <20141031075449.GA6170@ci00147.xsens-tech.local>
X-ASG-Orig-Subj: [bisected] nouveau dual monitor setup broken
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1414742103
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.11069
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

My dual monitor setup on the Dell Precision M4500 is broken by commit
1dce6264045cd23e9c07574ed0bb31c7dce9354f ("drm/nv50/kms: Set VBLANK time
in modeset script"). I am no longer able to have more than one monitor
active.

Full dmesg can be found at http://pastebin.com/7e68yMRy, but I've
included an excerpt as well.

[    0.000000] Linux version 3.18.0-rc2-00106-ga7ca10f (frans@bwaark) (gcc version 4.8.2 (Gentoo 4.8.2 p1.3r1, pie-0.5.8r1) ) #27 SMP Fri Oct 31 08:30:15 CET 2014
...
[    1.920869] fb: switching to nouveaufb from VESA VGA
[    1.953160] Console: switching to colour dummy device 80x25
[    1.965235] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a5e00a2
[    1.965247] nouveau  [  DEVICE][0000:01:00.0] Chipset: GT216 (NVA5)
[    1.965255] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
[    1.965303] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[    2.017175] tsc: Refined TSC clocksource calibration: 1595.999 MHz
[    2.060360] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    2.060369] nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
[    2.060704] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    2.060713] nouveau  [   VBIOS][0000:01:00.0] version 70.16.5c.01.06
[    2.075227] ACPI: Battery Slot [BAT1] (battery absent)
[    2.075329] nouveau 0000:01:00.0: irq 29 for MSI/MSI-X
[    2.075342] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
[    2.075376] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
[    2.075380] nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
[    2.075384] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 1920 tags
[    2.079057] nouveau  [    VOLT][0000:01:00.0] GPU voltage: 930000uv
[    2.108300] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / external
[    2.108328] nouveau  [  PTHERM][0000:01:00.0] fan management: automatic
[    2.108338] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    2.128401] nouveau  [     CLK][0000:01:00.0] 03: core 135 MHz shader 270 MHz memory 135 MHz
[    2.128414] nouveau  [     CLK][0000:01:00.0] 07: core 405 MHz shader 810 MHz memory 324 MHz
[    2.128426] nouveau  [     CLK][0000:01:00.0] 0f: core 550 MHz shader 1210 MHz memory 790 MHz
[    2.128469] nouveau  [     CLK][0000:01:00.0] --: core 405 MHz shader 810 MHz memory 324 MHz
[    2.129501] [TTM] Zone  kernel: Available graphics memory: 4080170 kiB
[    2.129514] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    2.129522] [TTM] Initializing pool allocator
[    2.129540] [TTM] Initializing DMA pool allocator
[    2.129575] nouveau  [     DRM] VRAM: 1024 MiB
[    2.129584] nouveau  [     DRM] GART: 1048576 MiB
[    2.129596] nouveau  [     DRM] TMDS table version 2.0
[    2.129605] nouveau  [     DRM] DCB version 4.0
[    2.129615] nouveau  [     DRM] DCB outp 00: 048003b6 0f220014
[    2.129626] nouveau  [     DRM] DCB outp 01: 02033300 00000000
[    2.129637] nouveau  [     DRM] DCB outp 02: 028113a6 0f220010
[    2.129647] nouveau  [     DRM] DCB outp 03: 02011362 00020010
[    2.129657] nouveau  [     DRM] DCB outp 04: 088223c6 0f220010
[    2.129667] nouveau  [     DRM] DCB outp 05: 08022382 00020010
[    2.129676] nouveau  [     DRM] DCB conn 00: 00002047
[    2.129687] nouveau  [     DRM] DCB conn 01: 00101146
[    2.129696] nouveau  [     DRM] DCB conn 02: 00410246
[    2.129705] nouveau  [     DRM] DCB conn 03: 00000300
[    2.183136] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    2.183142] [drm] Driver supports precise vblank timestamp query.
[    2.229885] nouveau  [     DRM] MM: using COPY for buffer copies
[    2.545100] nouveau  [     DRM] allocated 1920x1080 fb: 0x70000, bo ffff880225962c00
[    2.545330] fbcon: nouveaufb (fb0) is primary device
[    2.596432] nouveau E[   PDISP][0000:01:00.0] INVALID_STATE [UNK05] chid 0 mthd 0x0080 data 0x00000000
[    2.596435] nouveau E[   PDISP][0000:01:00.0] Core:
[    2.596441] nouveau E[   PDISP][0000:01:00.0] 	0x0084: 0x01e00280 -> 0x00000000
[    2.596447] nouveau E[   PDISP][0000:01:00.0] 	0x0088: 0xf0000000              
[    2.596450] nouveau E[   PDISP][0000:01:00.0] Core - DAC 0:
[    2.596455] nouveau E[   PDISP][0000:01:00.0] 	0x0400: 0x00000000              
[    2.596460] nouveau E[   PDISP][0000:01:00.0] 	0x0404: 0x00000000              
[    2.596465] nouveau E[   PDISP][0000:01:00.0] 	0x0420: 0x00010000              
[    2.596468] nouveau E[   PDISP][0000:01:00.0] Core - DAC 1:
[    2.596473] nouveau E[   PDISP][0000:01:00.0] 	0x0480: 0x00000000              
[    2.596477] nouveau E[   PDISP][0000:01:00.0] 	0x0484: 0x00000000              
[    2.596482] nouveau E[   PDISP][0000:01:00.0] 	0x04a0: 0x00010000              
[    2.596484] nouveau E[   PDISP][0000:01:00.0] Core - DAC 2:
[    2.596489] nouveau E[   PDISP][0000:01:00.0] 	0x0500: 0x00000000              
[    2.596494] nouveau E[   PDISP][0000:01:00.0] 	0x0504: 0x00000000              
[    2.596498] nouveau E[   PDISP][0000:01:00.0] 	0x0520: 0x00010000              
[    2.596501] nouveau E[   PDISP][0000:01:00.0] Core - SOR 0:
[    2.596506] nouveau E[   PDISP][0000:01:00.0] 	0x0600: 0x00000000              
[    2.596508] nouveau E[   PDISP][0000:01:00.0] Core - SOR 1:
[    2.596513] nouveau E[   PDISP][0000:01:00.0] 	0x0640: 0x00000101              
[    2.596516] nouveau E[   PDISP][0000:01:00.0] Core - SOR 2:
[    2.596521] nouveau E[   PDISP][0000:01:00.0] 	0x0680: 0x00000000              
[    2.596523] nouveau E[   PDISP][0000:01:00.0] Core - SOR 3:
[    2.596528] nouveau E[   PDISP][0000:01:00.0] 	0x06c0: 0x00000000 -> 0x00000102
[    2.596531] nouveau E[   PDISP][0000:01:00.0] Core - PIOR 0:
[    2.596536] nouveau E[   PDISP][0000:01:00.0] 	0x0700: 0x00000000              
[    2.596538] nouveau E[   PDISP][0000:01:00.0] Core - PIOR 1:
[    2.596543] nouveau E[   PDISP][0000:01:00.0] 	0x0740: 0x00000000              
[    2.596545] nouveau E[   PDISP][0000:01:00.0] Core - PIOR 2:
[    2.596550] nouveau E[   PDISP][0000:01:00.0] 	0x0780: 0x00000000              
[    2.596553] nouveau E[   PDISP][0000:01:00.0] Core - HEAD 0:
...

Hope this rings a bell,
Frans
