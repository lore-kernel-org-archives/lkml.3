Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaHTN3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:29:51 -0400
Received: from mail-oi0-f52.google.com ([209.85.218.52]:43070 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaHTN3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:29:48 -0400
MIME-Version: 1.0
Date: Wed, 20 Aug 2014 09:29:48 -0400
X-Google-Sender-Auth: 3Zt72akjxPX-_J1DEtr3eNgqvM0
Message-ID: <CA+5PVA7__ynffp8a_2L-BLFAG3cxX1YEjv-OyHsY5sYZavRXzA@mail.gmail.com>
Subject: WARN_ON in qxl_ttm.c with v3.17-rc1-22-g480cadc2b7e0
From: Josh Boyer <jwboyer@fedoraproject.org>
To: David Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

With Linus' latest tree as of this morning I'm hitting the WARN_ON
below on my KVM guest using the qxl driver.  The guest still boots and
things appear to still be working (I can log in via GDM, etc), so I'm
not sure exactly what the overall issue is.  Hoping you have some
ideas.

josh

[    4.826872] ------------[ cut here ]------------
[    4.826886] WARNING: CPU: 0 PID: 232 at
drivers/gpu/drm/qxl/qxl_ttm.c:414 qxl_sync_obj_wait+0x182/0x220
[qxl]()
[    4.826889] sync obj 301 still has outstanding releases 0 0 0 4096 1
[    4.826890] Modules linked in: btrfs qxl xor drm_kms_helper
raid6_pq ttm drm 8139too virtio_pci virtio_ring virtio 8139cp
ata_generic mii pata_acpi
[    4.826907] CPU: 0 PID: 232 Comm: plymouthd Not tainted
3.17.0-0.rc1.git1.1.fc22.x86_64 #1
[    4.826909] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    4.826910]  0000000000000000 00000000cd82f575 ffff88003a143750
ffffffff818141eb
[    4.826914]  ffff88003a143798 ffff88003a143788 ffffffff8109fecd
0000000000000001
[    4.826917]  ffff880035effd18 0000000000000001 ffff880035effd30
0000000000000000
[    4.826921] Call Trace:
[    4.826927]  [<ffffffff818141eb>] dump_stack+0x4d/0x66
[    4.826931]  [<ffffffff8109fecd>] warn_slowpath_common+0x7d/0xa0
[    4.826934]  [<ffffffff8109ff4c>] warn_slowpath_fmt+0x5c/0x80
[    4.827019]  [<ffffffff8181ca93>] ? schedule_hrtimeout_range+0x13/0x20
[    4.827025]  [<ffffffffa01020f2>] qxl_sync_obj_wait+0x182/0x220 [qxl]
[    4.827030]  [<ffffffffa00b86f1>] ttm_bo_wait+0xb1/0x1b0 [ttm]
[    4.827035]  [<ffffffffa00ba2b3>] ttm_bo_evict+0x63/0x3b0 [ttm]
[    4.827039]  [<ffffffffa00ba66c>] ? ttm_mem_evict_first+0x6c/0x1c0 [ttm]
[    4.827043]  [<ffffffff810f71e5>] ? mark_held_locks+0x75/0xa0
[    4.827047]  [<ffffffffa00ba72b>] ? ttm_mem_evict_first+0x12b/0x1c0 [ttm]
[    4.827052]  [<ffffffffa00ba745>] ttm_mem_evict_first+0x145/0x1c0 [ttm]
[    4.827056]  [<ffffffffa00baa28>] ttm_bo_mem_space+0x268/0x310 [ttm]
[    4.827060]  [<ffffffffa00baf9a>] ttm_bo_validate+0x23a/0x2f0 [ttm]
[    4.827063]  [<ffffffff810f730d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
[    4.827067]  [<ffffffff810f00dd>] ? print_cpu+0x41d/0xaa0
[    4.827071]  [<ffffffffa00bb311>] ttm_bo_init+0x2c1/0x470 [ttm]
[    4.827076]  [<ffffffffa010421f>] qxl_bo_create+0x13f/0x1a0 [qxl]
[    4.827080]  [<ffffffffa0103fa0>] ? qxl_fbdev_qobj_is_fb+0x30/0x30 [qxl]
[    4.827084]  [<ffffffffa0105516>] qxl_alloc_bo_reserved+0x46/0xc0 [qxl]
[    4.827088]  [<ffffffffa01065ae>] qxl_image_alloc_objects+0xae/0x140 [qxl]
[    4.827092]  [<ffffffffa0106f9a>] qxl_draw_dirty_fb+0x15a/0x470 [qxl]
[    4.827104]  [<ffffffffa0073c59>] ?
drm_modeset_lock_all_crtcs+0x49/0x70 [drm]
[    4.827108]  [<ffffffffa00ffde1>]
qxl_framebuffer_surface_dirty+0xa1/0xf0 [qxl]
[    4.827117]  [<ffffffffa006934e>] drm_mode_dirtyfb_ioctl+0xbe/0x160 [drm]
[    4.827124]  [<ffffffffa005a38c>] drm_ioctl+0x1ec/0x660 [drm]
[    4.827129]  [<ffffffff8136cd53>] ? inode_has_perm.isra.52+0x53/0x80
[    4.827132]  [<ffffffff81262ac0>] do_vfs_ioctl+0x300/0x520
[    4.827135]  [<ffffffff81262d61>] SyS_ioctl+0x81/0xa0
[    4.827138]  [<ffffffff8181e2e9>] system_call_fastpath+0x16/0x1b
[    4.827140] ---[ end trace fd5e51032668621b ]---
[    4.827144] [TTM] Failed to expire sync object before buffer eviction
[    4.827330] qxl 0000:00:02.0: object_init failed for (3149824, 0x00000001)
[    4.827333] [drm:qxl_alloc_bo_reserved] *ERROR* failed to allocate VRAM BO
