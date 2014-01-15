Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbaAOIet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:34:49 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:62281 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaAOIer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:34:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAKx2Y1=zz9j3dV6csMv2TQWCQA8-rPs8=VVihac9k9epagZ+-g@mail.gmail.com>
References: <CAKx2Y1=zz9j3dV6csMv2TQWCQA8-rPs8=VVihac9k9epagZ+-g@mail.gmail.com>
Date: Wed, 15 Jan 2014 03:34:46 -0500
X-Google-Sender-Auth: nO7n3VAaIQSXJA4oZLzYbp0KgNI
Message-ID: <CAKb7Uvg1FdmNXksgMcoqwHpZC603MwBzqSRU8TMxbBA7rdOFVg@mail.gmail.com>
Subject: Re: nouveau - BUG: unable to handle kernel NULL pointer dereference
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Kui Zhang <kuizhang@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 3:28 AM, Kui Zhang <kuizhang@gmail.com> wrote:
> Hello,
>
> I am getting a blank screen after loading initrd, with nouveau.
>
> the laptop seem to boot ok, just no video.This is in dmesg.
>
> Sorry if dupes, html version bounced.
>
> [    0.855961] nouveau  [   VBIOS][0000:01:00.0] ... checksum invalid
> [    0.856120] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
> [    0.856126] nouveau  [   VBIOS][0000:01:00.0] version 05.72.22.41.19
> [    0.856303] nouveau 0000:01:00.0: irq 47 for MSI/MSI-X
> [    0.856315] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
> [    0.856347] nouveau  [     PFB][0000:01:00.0] RAM type: DDR1
> [    0.856351] nouveau  [     PFB][0000:01:00.0] RAM size: 64 MiB
> [    0.856355] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
> [    0.858309] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000080
> [    0.858316] IP: [<ffffffffa001d0ed>]
> nouveau_gpuobj_create_+0x1fd/0x2a0 [nouveau]
> [    0.858360] PGD c1be4067 PUD c1be5067 PMD 0
> [    0.858366] Oops: 0000 [#1] SMP
> [    0.858370] Modules linked in: firewire_ohci(+) sky2 sr_mod cdrom
> firewire_core crc_itu_t thermal uhci_hcd nouveau(+) hwmon ttm
> [    0.858386] CPU: 1 PID: 800 Comm: systemd-udevd Tainted: G        W
>    3.13.0-rc8+ #19
> [    0.858391] Hardware name: Sony Corporation VGN-SZ320CP/VAIO
>                     , BIOS R0112N0 04/12/2007
> [    0.858396] task: ffff8800c2e5d400 ti: ffff880037800000 task.ti:
> ffff880037800000
> [    0.858400] RIP: 0010:[<ffffffffa001d0ed>]  [<ffffffffa001d0ed>]
> nouveau_gpuobj_create_+0x1fd/0x2a0 [nouveau]
> [    0.858429] RSP: 0000:ffff880037801928  EFLAGS: 00010246
> [    0.858432] RAX: 0000000000000000 RBX: ffff8800378019a0 RCX: 0000000000000000
> [    0.858436] RDX: 0000000000010000 RSI: ffff8800378bba00 RDI: 0000000000000000
> [    0.858440] RBP: 0000000000010000 R08: ffff880037801940 R09: 0000000000010000
> [    0.858443] R10: ffffffffa00d2b10 R11: 0000000000000000 R12: ffff8800378bba00
> [    0.858447] R13: ffff880037801940 R14: 0000000000000000 R15: 0000000000000016
> [    0.858451] FS:  00007fb109aed880(0000) GS:ffff8800c7b00000(0000)
> knlGS:0000000000000000
> [    0.858455] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.858459] CR2: 0000000000000080 CR3: 00000000c1be3000 CR4: 00000000000007e0
> [    0.858462] Stack:
> [    0.858464]  ffffffffa00d2b10 0000000081a0dc98 0000000000000000
> ffff8800378bba00
> [    0.858470]  ffff8800378019b8 ffff8800c2e81000 ffff8800378bbab8
> ffffffffa00d2b40
> [    0.858476]  ffff8800378bba00 0000000000000016 ffffffffa001d1c5
> ffffffff00000000
> [    0.858482] Call Trace:
> [    0.858510]  [<ffffffffa001d1c5>] ? _nouveau_gpuobj_ctor+0x35/0x50 [nouveau]
> [    0.858538]  [<ffffffffa001e688>] ? nouveau_object_ctor+0x28/0xd0 [nouveau]
> [    0.858565]  [<ffffffffa001d225>] ? nouveau_gpuobj_new+0x45/0x50 [nouveau]
> [    0.858598]  [<ffffffffa005440a>] ? nv40_instmem_ctor+0x12a/0x290 [nouveau]
> [    0.858626]  [<ffffffffa001e688>] ? nouveau_object_ctor+0x28/0xd0 [nouveau]
> [    0.858661]  [<ffffffffa00607de>] ? nouveau_devobj_ctor+0x18e/0x6e0 [nouveau]
> [    0.858689]  [<ffffffffa001e688>] ? nouveau_object_ctor+0x28/0xd0 [nouveau]
> [    0.858717]  [<ffffffffa001eeb0>] ? nouveau_object_new+0x160/0x210 [nouveau]
> [    0.858758]  [<ffffffffa0093aa8>] ? nouveau_drm_load+0x1b8/0x870 [nouveau]
> [    0.858766]  [<ffffffff813b1929>] ? drm_get_minor+0x189/0x1f0
> [    0.858771]  [<ffffffff813b1a26>] ? drm_dev_register+0x96/0x1d0
> [    0.858776]  [<ffffffff813b3584>] ? drm_get_pci_dev+0x84/0x130
> [    0.858814]  [<ffffffffa0094352>] ? nouveau_drm_probe+0x1f2/0x280 [nouveau]
> [    0.858821]  [<ffffffff81326338>] ? pci_device_probe+0x78/0xd0
> [    0.858827]  [<ffffffff81440ba8>] ? driver_probe_device+0x68/0x220
> [    0.858831]  [<ffffffff81440e1b>] ? __driver_attach+0x7b/0x80
> [    0.858836]  [<ffffffff81440da0>] ? __device_attach+0x40/0x40
> [    0.858840]  [<ffffffff8143ef73>] ? bus_for_each_dev+0x53/0x90
> [    0.858845]  [<ffffffff81440370>] ? bus_add_driver+0x170/0x220
> [    0.858849]  [<ffffffffa0113000>] ? 0xffffffffa0112fff
> [    0.858854]  [<ffffffff814411c6>] ? driver_register+0x56/0xd0
> [    0.858858]  [<ffffffffa0113000>] ? 0xffffffffa0112fff
> [    0.858863]  [<ffffffff810002ea>] ? do_one_initcall+0xea/0x130
> [    0.858870]  [<ffffffff8109c5fc>] ? __blocking_notifier_call_chain+0x4c/0x60
> [    0.858876]  [<ffffffff810d74d7>] ? load_module+0x1947/0x2090
> [    0.858880]  [<ffffffff810d4670>] ? m_show+0x1a0/0x1a0
> [    0.858885]  [<ffffffff810d7d3d>] ? SyS_finit_module+0x6d/0x70
> [    0.858890]  [<ffffffff815e08e3>] ? tracesys+0xe1/0xe6
> [    0.858893] Code: ea 10 00 00 85 c0 74 a1 e9 e2 fe ff ff 8b 4c 24
> 58 4c 8d 6c 24 18 48 89 fe 4d 89 e8 44 89 ca 48 89 c7 44 89 5c 24 0c
> 4c 89 14 24 <ff> 90 80 00 00 00 48 8b 74 24 18 85 c0 48 89 74 24 10 0f
> 85 ac
> [    0.858934] RIP  [<ffffffffa001d0ed>]
> nouveau_gpuobj_create_+0x1fd/0x2a0 [nouveau]
> [    0.858962]  RSP <ffff880037801928>
> [    0.858965] CR2: 0000000000000080
> [    0.858969] ---[ end trace ce522875c83a3c40 ]---
>
>
>
> 01:00.0 VGA compatible controller: NVIDIA Corporation G72M [GeForce Go
> 7400] (rev a1) (prog-if 00 [VGA controller])
> Subsystem: Sony Corporation Device 81e6
> Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx+
> Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
> Latency: 0, Cache Line Size: 64 bytes
> Interrupt: pin A routed to IRQ 47
> Region 0: Memory at cd000000 (32-bit, non-prefetchable) [size=16M]
> Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
> Region 3: Memory at ce000000 (64-bit, non-prefetchable) [size=16M]
> Expansion ROM at <unassigned> [disabled]
> Capabilities: <access denied>
> Kernel driver in use: nouveau
>
>
> Last working: commit e70988d1aaf73221355e06125c9937bd4b27761c

This should be fixed by
http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-fixes&id=fdd239ac99a0cc298b382c5ab5e7bcd09e8933d7
and on its way to 3.13.

  -ilia
