Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbaKSGnY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 01:43:24 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52717 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbaKSGnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 01:43:23 -0500
MIME-Version: 1.0
Date: Tue, 18 Nov 2014 22:43:18 -0800
Message-ID: <CAHW-aUcEipi+NeU3wapLABV41Sud7Qy_=EYXCei9Dmf18SxuZA@mail.gmail.com>
Subject: 3.18-rc regression: drm/nouveau: use shared fences for readable objects
From: Michael Marineau <mike@marineau.org>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.18-rc kernel's I have been intermittently experiencing GPU
lockups shortly after startup, accompanied with one or both of the
following errors:

nouveau E[   PFIFO][0000:01:00.0] read fault at 0x000734a000 [PTE]
from PBDMA0/HOST_CPU on channel 0x007faa3000 [unknown]
nouveau E[     DRM] GPU lockup - switching to software fbcon

I was able to trace the issue with bisect to commit
809e9447b92ffe1346b2d6ec390e212d5307f61c "drm/nouveau: use shared
fences for readable objects". The lockups appear to have cleared up
since reverting that and a few related followup commits:

809e9447: "drm/nouveau: use shared fences for readable objects"
055dffdf: "drm/nouveau: bump driver patchlevel to 1.2.1"
e3be4c23: "drm/nouveau: specify if interruptible wait is desired in
nouveau_fence_sync"
15a996bb: "drm/nouveau: assign fence_chan->name correctly"

For reference here is what the driver reports about my hardware:
nouveau 0000:01:00.0: enabling device (0006 -> 0007)
nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e7290a2
nouveau  [  DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
nouveau  [   VBIOS][0000:01:00.0] using image from PRAMIN
nouveau  [   VBIOS][0000:01:00.0] BIT signature found
nouveau  [   VBIOS][0000:01:00.0] version 80.07.c7.04.01
nouveau 0000:01:00.0: irq 39 for MSI/MSI-X
nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
nouveau  [     PFB][0000:01:00.0] RAM size: 2048 MiB
nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
nouveau  [  PTHERM][0000:01:00.0] FAN control: none / external
nouveau  [  PTHERM][0000:01:00.0] fan management: automatic
nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
nouveau  [     CLK][0000:01:00.0] 07: core 270-405 MHz memory 838 MHz
nouveau  [     CLK][0000:01:00.0] 0a: core 270-925 MHz memory 1560 MHz
nouveau  [     CLK][0000:01:00.0] 0e: core 270-925 MHz memory 4000 MHz
nouveau  [     CLK][0000:01:00.0] 0f: core 270-925 MHz memory 5016 MHz
nouveau  [     CLK][0000:01:00.0] --: core 405 MHz memory 680 MHz
nouveau  [     DRM] VRAM: 2048 MiB
nouveau  [     DRM] GART: 1048576 MiB
nouveau  [     DRM] TMDS table version 2.0
nouveau  [     DRM] DCB version 4.0
nouveau  [     DRM] DCB outp 00: 04810fb6 0f230010
nouveau  [     DRM] DCB outp 01: 01821fd6 0f420020
nouveau  [     DRM] DCB outp 02: 01021f12 00020020
nouveau  [     DRM] DCB outp 03: 08832fc6 0f420010
nouveau  [     DRM] DCB outp 04: 08032f02 00020010
nouveau  [     DRM] DCB outp 05: 02843f62 00020010
nouveau  [     DRM] DCB conn 00: 00020047
nouveau  [     DRM] DCB conn 01: 02208146
nouveau  [     DRM] DCB conn 02: 01104246
nouveau  [     DRM] DCB conn 03: 00410361
nouveau  [     DRM] MM: using COPY for buffer copies
nouveau  [     DRM] allocated 2880x1800 fb: 0x80000, bo ffff88046b26f800

-- 
Michael Marineau
