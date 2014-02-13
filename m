Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaBMHPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:15:42 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:39645 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaBMHPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:15:41 -0500
MIME-Version: 1.0
Date: Wed, 12 Feb 2014 23:15:38 -0800
Message-ID: <CAKx2Y1kyfxzaWnFhSx-EkeCWKi+tn6e1YHCkbt4RtYmBskZHTQ@mail.gmail.com>
Subject: nouveau init unknown opcode error, when CONFIG_DRM_NOUVEAU=y
From: Kui Zhang <kuizhang@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When CONFIG_DRM_NOUVEAU=y, I get following error. Blank screen after initrd.

This was in the dmesg.

[    0.282559] [drm] hdmi device  not found 1 0 1
[    0.282688] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x046800a3
[    0.282693] nouveau  [  DEVICE][0000:01:00.0] Chipset: G72 (NV46)
[    0.282696] nouveau  [  DEVICE][0000:01:00.0] Family : NV40
[    0.284293] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[    0.366261] nouveau  [   VBIOS][0000:01:00.0] ... checksum invalid
[    0.366266] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[    0.366279] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    0.366283] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
[    0.366286] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    0.366290] nouveau  [   VBIOS][0000:01:00.0] checking PCIROM for image...
[    0.366454] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    0.366462] nouveau  [   VBIOS][0000:01:00.0] using image from PCIROM
[    0.366603] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    0.366609] nouveau  [   VBIOS][0000:01:00.0] version 05.72.22.41.19
[    0.367101] nouveau E[   VBIOS][0000:01:00.0] 0xe008[ ]: unknown opcode 0xc0
[    0.367107] nouveau E[ DEVINIT][0000:01:00.0] init failed, -22
[    0.367112] nouveau E[     DRM] failed to create 0x80000080, -22
[    0.367833] nouveau: probe of 0000:01:00.0 failed with error -22


When CONFIG_DRM_NOUVEAU=m. Everything appears to work as expected.

[    0.796974] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x046800a3
[    0.796980] nouveau  [  DEVICE][0000:01:00.0] Chipset: G72 (NV46)
[    0.796985] nouveau  [  DEVICE][0000:01:00.0] Family : NV40
[    0.799366] nouveau  [   VBIOS][0000:01:00.0] source: PRAMIN
[    0.887657] nouveau  [   VBIOS][0000:01:00.0] ... checksum invalid
[    0.887838] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    0.887844] nouveau  [   VBIOS][0000:01:00.0] version 05.72.22.41.19
[    0.888074] nouveau 0000:01:00.0: irq 47 for MSI/MSI-X
[    0.888087] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
[    0.888123] nouveau  [     PFB][0000:01:00.0] RAM type: DDR1
[    0.888128] nouveau  [     PFB][0000:01:00.0] RAM size: 64 MiB
[    0.888132] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[    0.901582] nouveau  [    VOLT][0000:01:00.0] GPU voltage: 1000000uv
[    0.927993] nouveau  [  PTHERM][0000:01:00.0] FAN control: none / external
[    0.928008] nouveau  [  PTHERM][0000:01:00.0] fan management: automatic
[    0.928013] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    0.948079] nouveau  [     CLK][0000:01:00.0] 20: core 100 MHz
shader 100 MHz memory 220 MHz
[    0.948089] nouveau  [     CLK][0000:01:00.0] 21: core 200 MHz
shader 200 MHz memory 400 MHz
[    0.948096] nouveau  [     CLK][0000:01:00.0] 22: core 450 MHz
shader 450 MHz memory 700 MHz
[    0.948109] nouveau  [     CLK][0000:01:00.0] --: core 199 MHz memory 391 MHz
[    0.948280] nouveau  [     DRM] VRAM: 60 MiB
[    0.948283] nouveau  [     DRM] GART: 512 MiB
[    0.948289] nouveau  [     DRM] TMDS table version 1.1
[    0.948292] nouveau W[     DRM] TMDS table script pointers not stubbed
[    0.948296] nouveau  [     DRM] DCB version 3.0
[    0.948301] nouveau  [     DRM] DCB outp 00: 030053f3 00000005
[    0.948305] nouveau  [     DRM] DCB outp 01: 01010300 00000028
[    0.948309] nouveau  [     DRM] DCB outp 02: 04016312 00000000
[    0.948313] nouveau  [     DRM] DCB conn 00: 0000
[    0.948317] nouveau  [     DRM] DCB conn 01: 0130
[    0.948321] nouveau  [     DRM] DCB conn 02: 0210
[    0.948325] nouveau  [     DRM] DCB conn 03: 0211
[    0.948328] nouveau  [     DRM] DCB conn 04: 0213
[    0.948332] nouveau  [     DRM] DCB conn 05: 0340
[    0.948335] nouveau  [     DRM] DCB conn 06: 1431
[    0.948346] nouveau  [     DRM] BIOS FP mode: 1280x800 (83500kHz pixel clock)
[    0.950596] nouveau  [     DRM] 0xD409: Parsing digital output script table
[    1.003680] nouveau  [     DRM] MM: using M2MF for buffer copies
[    1.003694] nouveau  [     DRM] Calling LVDS script 6:
[    1.003699] nouveau  [     DRM] 0xD143: Parsing digital output script table
[    1.071498] nouveau  [     DRM] allocated 1280x800 fb: 0x9000, bo
ffff880037991400
[    1.071614] fbcon: nouveaufb (fb0) is primary device
[    1.092292] nouveau  [     DRM] Calling LVDS script 2:
[    1.092295] nouveau  [     DRM] 0xD1A4: Parsing digital output script table
[    1.224348] nouveau  [     DRM] Calling LVDS script 5:
[    1.224350] nouveau  [     DRM] 0xD134: Parsing digital output script table
[    1.225793] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    1.225801] nouveau 0000:01:00.0: registered panic notifier
[    1.225819] [drm] Initialized nouveau 1.1.1 20120801 for
0000:01:00.0 on minor 0
[   30.396123] nouveau  [     DRM] Calling LVDS script 6:
[   30.396131] nouveau  [     DRM] 0xD143: Parsing digital output script table
[   30.456806] nouveau  [     DRM] Calling LVDS script 2:
[   30.456814] nouveau  [     DRM] 0xD1A4: Parsing digital output script table
[   30.588863] nouveau  [     DRM] Calling LVDS script 5:
[   30.588869] nouveau  [     DRM] 0xD134: Parsing digital output script table


Thanks
Kui.Z
