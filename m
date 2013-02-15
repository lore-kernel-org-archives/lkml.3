Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab3BOW5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:57:12 -0500
Received: from hosting.visp.net.lb ([194.146.153.11]:59653 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3BOW5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:57:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 16 Feb 2013 00:57:07 +0200
From: Denys Fedoryshchenko <denys@visp.net.lb>
To: <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>
Subject: 3.8.0-rc7, nouveau, possible recursive locking,
 =?UTF-8?Q?nouveau=5Finstobj=5Fcreate=5F=20and=20nv=35=30=5Fdisp=5Fdata=5F?=
 =?UTF-8?Q?ctor?=
Message-ID: <d4a52379a6aaf48bb47a6927e9a0de75@visp.net.lb>
User-Agent: VISP Webmail/0.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Booted on Toshiba laptop, x86_64, NVIDIA Corporation GT218 [GeForce 
310M], latest rc, and got this.
Please let me know if you need additional information.

[   16.595094] [TTM] Zone   dma32: Available graphics memory: 2097152 
kiB
[   16.595096] [TTM] Initializing pool allocator
[   16.595147] [TTM] Initializing DMA pool allocator
[   16.600363] nouveau  [     DRM] VRAM: 512 MiB
[   16.600367] nouveau  [     DRM] GART: 512 MiB
[   16.600387] nouveau  [     DRM] BIT BIOS found
[   16.600391] nouveau  [     DRM] Bios version 70.18.5f.00
[   16.600394] nouveau  [     DRM] TMDS table version 2.0
[   16.600397] nouveau  [     DRM] DCB version 4.0
[   16.600400] nouveau  [     DRM] DCB outp 00: 01000323 00010034
[   16.600419] nouveau  [     DRM] DCB outp 01: 02011300 00000000
[   16.600421] nouveau  [     DRM] DCB outp 02: 08022382 00020010
[   16.600424] nouveau  [     DRM] DCB conn 00: 00000040
[   16.600427] nouveau  [     DRM] DCB conn 01: 00000100
[   16.600430] nouveau  [     DRM] DCB conn 02: 00002261
[   16.677661]
[   16.678006] =============================================
[   16.678006] [ INFO: possible recursive locking detected ]
[   16.678006] 3.8.0-rc7-lap #1 Tainted: G        W
[   16.678006] ---------------------------------------------
[   16.678006] udevd/1236 is trying to acquire lock:
[   16.678006]  (&subdev->mutex){+.+.+.}, at: [<ffffffffa0291ca4>] 
nouveau_instobj_create_+0x3c/0x7a [nouveau]
[   16.678006]
[   16.678006] but task is already holding lock:
[   16.678006]  (&subdev->mutex){+.+.+.}, at: [<ffffffffa02993be>] 
nv50_disp_data_ctor+0x40/0xaf [nouveau]
[   16.678006]
[   16.678006] other info that might help us debug this:
[   16.678006]  Possible unsafe locking scenario:
[   16.678006]
[   16.678006]        CPU0
[   16.678006]        ----
[   16.678006]   lock(&subdev->mutex);
[   16.678006]   lock(&subdev->mutex);
[   16.678006]
[   16.678006]  *** DEADLOCK ***
[   16.678006]
[   16.678006]  May be due to missing lock nesting notation
[   16.678006]
[   16.678006] 4 locks held by udevd/1236:
[   16.678006]  #0:  (&__lockdep_no_validate__){......}, at: 
[<ffffffff812daaf4>] device_lock+0xf/0x11
[   16.678006]  #1:  (&__lockdep_no_validate__){......}, at: 
[<ffffffff812daaf4>] device_lock+0xf/0x11
[   16.678006]  #2:  (drm_global_mutex){+.+.+.}, at: 
[<ffffffff812c6fa7>] drm_get_pci_dev+0xb9/0x265
[   16.678006]  #3:  (&subdev->mutex){+.+.+.}, at: [<ffffffffa02993be>] 
nv50_disp_data_ctor+0x40/0xaf [nouveau]
[   16.678006]
[   16.678006] stack backtrace:
[   16.678006] Pid: 1236, comm: udevd Tainted: G        W    
3.8.0-rc7-lap #1
[   16.678006] Call Trace:
[   16.678006]  [<ffffffff81070969>] __lock_acquire+0xaa2/0xebc
[   16.678006]  [<ffffffff81077bd4>] ? __module_text_address+0xd/0x5a
[   16.678006]  [<ffffffff8107b745>] ? is_module_text_address+0x1d/0x29
[   16.678006]  [<ffffffff810711a4>] lock_acquire+0x7e/0x94
[   16.678006]  [<ffffffffa0291ca4>] ? 
nouveau_instobj_create_+0x3c/0x7a [nouveau]
[   16.678006]  [<ffffffff815372a3>] __mutex_lock_common+0x5c/0x379
[   16.678006]  [<ffffffffa0291ca4>] ? 
nouveau_instobj_create_+0x3c/0x7a [nouveau]
[   16.678006]  [<ffffffffa0291ca4>] ? 
nouveau_instobj_create_+0x3c/0x7a [nouveau]
[   16.678006]  [<ffffffff815376bb>] mutex_lock_nested+0x3b/0x40
[   16.678006]  [<ffffffffa0291ca4>] nouveau_instobj_create_+0x3c/0x7a 
[nouveau]
[   16.678006]  [<ffffffffa029275b>] nv50_instobj_ctor+0x45/0xde 
[nouveau]
[   16.678006]  [<ffffffffa027c893>] nouveau_object_ctor+0x28/0x9c 
[nouveau]
[   16.678006]  [<ffffffffa029259c>] nv50_instmem_alloc+0x21/0x23 
[nouveau]
[   16.678006]  [<ffffffffa027b3af>] nouveau_gpuobj_create_+0xaa/0x22a 
[nouveau]
[   16.678006]  [<ffffffff810715e6>] ? 
trace_hardirqs_on_caller+0x121/0x158
[   16.678006]  [<ffffffffa027a366>] nouveau_engctx_create_+0xaf/0x199 
[nouveau]
[   16.678006]  [<ffffffffa029940a>] nv50_disp_data_ctor+0x8c/0xaf 
[nouveau]
[   16.678006]  [<ffffffffa027db0d>] ? nouveau_subdev_reset+0x52/0x56 
[nouveau]
[   16.678006]  [<ffffffffa027c893>] nouveau_object_ctor+0x28/0x9c 
[nouveau]
[   16.678006]  [<ffffffffa027d0a3>] nouveau_object_new+0x129/0x1fb 
[nouveau]
[   16.678006]  [<ffffffffa02f2458>] nv50_display_create+0x158/0x7c4 
[nouveau]
[   16.678006]  [<ffffffff81045117>] ? __cancel_work_timer+0x81/0xaf
[   16.678006]  [<ffffffff81045132>] ? __cancel_work_timer+0x9c/0xaf
[   16.678006]  [<ffffffffa02e16b5>] nouveau_display_create+0x40a/0x466 
[nouveau]
[   16.678006]  [<ffffffffa02d4d7c>] nouveau_drm_load+0x245/0x4c0 
[nouveau]
[   16.678006]  [<ffffffff812d9092>] ? device_register+0x19/0x1e
[   16.678006]  [<ffffffff812c5db0>] ? drm_get_minor+0x226/0x280
[   16.678006]  [<ffffffff812c7048>] drm_get_pci_dev+0x15a/0x265
[   16.678006]  [<ffffffff8123d7a0>] ? __pci_set_master+0x1f/0x67
[   16.678006]  [<ffffffffa02d47b5>] nouveau_drm_probe+0x1dd/0x201 
[nouveau]
[   16.678006]  [<ffffffff81240de3>] local_pci_probe+0x39/0x61
[   16.678006]  [<ffffffff81241ce5>] pci_device_probe+0x63/0x8d
[   16.678006]  [<ffffffff812dae6e>] ? driver_sysfs_add+0x6b/0x90
[   16.678006]  [<ffffffff812db172>] driver_probe_device+0xab/0x1c4
[   16.678006]  [<ffffffff812db2d5>] __driver_attach+0x4a/0x6b
[   16.678006]  [<ffffffff812db28b>] ? driver_probe_device+0x1c4/0x1c4
[   16.678006]  [<ffffffff812d9a0e>] bus_for_each_dev+0x57/0x84
[   16.678006]  [<ffffffff812dae01>] driver_attach+0x19/0x1b
[   16.678006]  [<ffffffff812da8c4>] bus_add_driver+0xa8/0x1fa
[   16.678006]  [<ffffffff812db7c5>] driver_register+0x8e/0x108
[   16.678006]  [<ffffffff81241df3>] __pci_register_driver+0x5f/0x64
[   16.678006]  [<ffffffff812c71d8>] drm_pci_init+0x85/0xea
[   16.678006]  [<ffffffffa0335000>] ? 0xffffffffa0334fff
[   16.678006]  [<ffffffffa0335000>] ? 0xffffffffa0334fff
[   16.678006]  [<ffffffffa033504d>] nouveau_drm_init+0x4d/0x4f 
[nouveau]
[   16.678006]  [<ffffffff81000232>] do_one_initcall+0x7a/0x130
[   16.678006]  [<ffffffff8107acd4>] load_module+0x168b/0x19c0
[   16.678006]  [<ffffffff8107863d>] ? free_notes_attrs+0x46/0x46
[   16.678006]  [<ffffffff8107b0b2>] sys_init_module+0xa9/0xab
[   16.678006]  [<ffffffff8153ef96>] system_call_fastpath+0x1a/0x1f
[   16.776320] [drm] Supports vblank timestamp caching Rev 1 
(10.10.2010).
[   16.777184] [drm] No driver support for vblank timestamp query.
[   16.778029] nouveau  [     DRM] ACPI backlight interface available, 
not registering our own



---
Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.
