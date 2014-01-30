Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaA3TDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:03:20 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52695 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaA3TDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:03:18 -0500
MIME-Version: 1.0
Date: Thu, 30 Jan 2014 14:03:18 -0500
X-Google-Sender-Auth: liCjExCZdcJf2XRG1R1RY1kOtLc
Message-ID: <CA+5PVA4Oj7XOZSEYqXGE7ZPVVK1oEHEc-w_DniCediWGVhrmhQ@mail.gmail.com>
Subject: kernfs oops with i915+i2c_core in 3.14 merge window
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, Wolfram Sang <wsa@the-dreams.de>,
        Tejun Heo <tj@kernel.org>
Cc: intel-gfx@lists.freedesktop.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm seeing the oops below on my MacBookPro 10,2 machine using i915
graphics.  It's after the DRM merge for 3.14 ( v3.13-10094-g9b0cd30) ,
but we seem to have one report[1] of this happening well before that,
in v3.13-3260-g03d11a0 as well.  Does anyone have a clue what is going
on here?

https://bugzilla.redhat.com/show_bug.cgi?id=1055105

josh

[    6.058198] INFO: trying to register non-static key.
[    6.058203] the code is fine but needs lockdep annotation.
[    6.058206] turning off the locking correctness validator.
[    6.058210] CPU: 2 PID: 225 Comm: systemd-udevd Not tainted
3.14.0-0.rc0.git17.1.fc21.x86_64 #1
[    6.058214] Hardware name: Apple Inc.
MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS
MBP102.88Z.0106.B03.1211161133 11/16/2012
[    6.058219]  0000000000000000 000000008b5190d0 ffff88025cc67460
ffffffff817cdb1f
[    6.058225]  0000000000000002 ffff88025cc67470 ffffffff817c8aa9
ffff88025cc67550
[    6.058230]  ffffffff810fa886 0000000000000002 ffff88025cc66000
ffff88025cc67500
[    6.058236] Call Trace:
[    6.058242]  [<ffffffff817cdb1f>] dump_stack+0x4d/0x66
[    6.058247]  [<ffffffff817c8aa9>] register_lock_class.part.26+0x38/0x3c
[    6.058253]  [<ffffffff810fa886>] __lock_acquire+0x1776/0x1c40
[    6.058258]  [<ffffffff810f8b09>] ? mark_held_locks+0xb9/0x140
[    6.058262]  [<ffffffff810feb91>] ? __raw_spin_lock_init+0x21/0x60
[    6.058267]  [<ffffffff810f626c>] ? lockdep_init_map+0xac/0x4a0
[    6.058271]  [<ffffffff810fb542>] lock_acquire+0xa2/0x1d0
[    6.058275]  [<ffffffff812beeb8>] ? kernfs_addrm_finish+0x38/0x60
[    6.058279]  [<ffffffff812be0de>] kernfs_deactivate+0x13e/0x1a0
[    6.058283]  [<ffffffff812beeb8>] ? kernfs_addrm_finish+0x38/0x60
[    6.058287]  [<ffffffff810f8b09>] ? mark_held_locks+0xb9/0x140
[    6.058291]  [<ffffffff810f8b09>] ? mark_held_locks+0xb9/0x140
[    6.058295]  [<ffffffff812beeb8>] kernfs_addrm_finish+0x38/0x60
[    6.058299]  [<ffffffff812bf150>] kernfs_remove_by_name_ns+0x60/0xc0
[    6.058304]  [<ffffffff812bcc81>] remove_files.isra.1+0x41/0x80
[    6.058308]  [<ffffffff812bcf77>] sysfs_remove_group+0x47/0xa0
[    6.058312]  [<ffffffff812bd0a3>] sysfs_remove_groups+0x33/0x50
[    6.058318]  [<ffffffff814f391e>] device_remove_attrs+0x5e/0x80
[    6.058322]  [<ffffffff814f455e>] device_del+0x12e/0x1d0
[    6.058325]  [<ffffffff814f461e>] device_unregister+0x1e/0x60
[    6.058331]  [<ffffffffa000d407>] i2c_del_adapter+0x267/0x3b0 [i2c_core]
[    6.058354]  [<ffffffffa00df8de>] intel_sdvo_init+0x20e/0x8c0 [i915]
[    6.058359]  [<ffffffff810f8c95>] ? trace_hardirqs_on_caller+0x105/0x1d0
[    6.058363]  [<ffffffff810f8d6d>] ? trace_hardirqs_on+0xd/0x10
[    6.058381]  [<ffffffffa00fb952>] ? gen6_read32+0x52/0x1c0 [i915]
[    6.058398]  [<ffffffffa00c7922>] intel_modeset_init+0xb62/0xff0 [i915]
[    6.058414]  [<ffffffffa00ea6b8>] ?
intel_power_domains_init_hw+0xa8/0x110 [i915]
[    6.058429]  [<ffffffffa008b38c>] i915_driver_load+0xccc/0xec0 [i915]
[    6.058440]  [<ffffffffa00264cd>] ? drm_get_minor+0x1ad/0x200 [drm]
[    6.058447]  [<ffffffffa002659d>] drm_dev_register+0x7d/0x180 [drm]
[    6.058455]  [<ffffffffa0028d10>] drm_get_pci_dev+0xa0/0x220 [drm]
[    6.058468]  [<ffffffffa008770b>] i915_pci_probe+0x3b/0x60 [i915]
[    6.058473]  [<ffffffff8140c605>] local_pci_probe+0x45/0xa0
[    6.058477]  [<ffffffff8140d8b5>] ? pci_match_device+0xc5/0xd0
[    6.058481]  [<ffffffff8140d9f9>] pci_device_probe+0xf9/0x150
[    6.058486]  [<ffffffff814f8b95>] driver_probe_device+0x125/0x3a0
[    6.058490]  [<ffffffff814f8ee3>] __driver_attach+0x93/0xa0
[    6.058494]  [<ffffffff814f8e50>] ? __device_attach+0x40/0x40
[    6.058498]  [<ffffffff814f68d3>] bus_for_each_dev+0x73/0xc0
[    6.058502]  [<ffffffff814f851e>] driver_attach+0x1e/0x20
[    6.058505]  [<ffffffff814f80c8>] bus_add_driver+0x188/0x260
[    6.058509]  [<ffffffffa0154000>] ? 0xffffffffa0153fff
[    6.058513]  [<ffffffff814f9584>] driver_register+0x64/0xf0
[    6.058516]  [<ffffffffa0154000>] ? 0xffffffffa0153fff
[    6.058520]  [<ffffffff8140bfa0>] __pci_register_driver+0x60/0x70
[    6.058527]  [<ffffffffa0028faa>] drm_pci_init+0x11a/0x130 [drm]
[    6.058531]  [<ffffffffa0154000>] ? 0xffffffffa0153fff
[    6.058543]  [<ffffffffa015406a>] i915_init+0x6a/0x6c [i915]
[    6.058548]  [<ffffffff8100214a>] do_one_initcall+0xfa/0x1b0
[    6.058552]  [<ffffffff810640a3>] ? set_memory_nx+0x43/0x50
[    6.058557]  [<ffffffff81131d63>] load_module+0x1eb3/0x26e0
[    6.058560]  [<ffffffff8112cc70>] ? store_uevent+0x70/0x70
[    6.058565]  [<ffffffff81238710>] ? kernel_read+0x50/0x80
[    6.058569]  [<ffffffff81132766>] SyS_finit_module+0xa6/0xd0
[    6.058574]  [<ffffffff817e19a9>] system_call_fastpath+0x16/0x1b
