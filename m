Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965181AbaCUKk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:40:57 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:45787 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760643AbaCUKkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:40:55 -0400
Date: Fri, 21 Mar 2014 13:37:04 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [linux-next] WARNING at drm_mode_connector_list_update
Message-ID: <20140321103704.GA376@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[   18.707077] WARNING: CPU: 2 PID: 175 at drivers/gpu/drm/drm_modes.c:1030 drm_mode_connector_list_update+0x2f/0xe8 [drm]()
[   18.707086] Modules linked in: crc32c_intel microcode radeon(+) broadcom i2c_algo_bit psmouse drm_kms_helper tg3 ttm drm evdev wmi button battery processor ac lpc_ich i2c_i801 ipv6 ehci_pci ehci_hcd usbcore sr_mod cdrom sd_mod ahci
[   18.707087] CPU: 2 PID: 175 Comm: systemd-udevd Tainted: G        W     3.14.0-rc7-next-20140321-dbg-dirty #189
[   18.707088] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[   18.707090]  0000000000000000 ffff88015217f8f0 ffffffff813ba2d7 0000000000000000
[   18.707091]  ffff88015217f928 ffffffff8103a3af ffffffffa0157ca1 ffff8801521e2000
[   18.707093]  ffff8801521e2048 ffff88003747e000 ffff8801521e2000 ffff88015217f938
[   18.707093] Call Trace:
[   18.707095]  [<ffffffff813ba2d7>] dump_stack+0x4e/0x7a
[   18.707097]  [<ffffffff8103a3af>] warn_slowpath_common+0x75/0x8e
[   18.707107]  [<ffffffffa0157ca1>] ? drm_mode_connector_list_update+0x2f/0xe8 [drm]
[   18.707109]  [<ffffffff8103a467>] warn_slowpath_null+0x15/0x17
[   18.707119]  [<ffffffffa0157ca1>] drm_mode_connector_list_update+0x2f/0xe8 [drm]
[   18.707122]  [<ffffffffa00de5aa>] drm_helper_probe_single_connector_modes+0x16d/0x2d1 [drm_kms_helper]
[   18.707125]  [<ffffffffa00df3a5>] drm_fb_helper_probe_connector_modes+0x41/0x54 [drm_kms_helper]
[   18.707129]  [<ffffffffa00e0894>] drm_fb_helper_initial_config+0x1ab/0x43c [drm_kms_helper]
[   18.707131]  [<ffffffff8103a3be>] ? warn_slowpath_common+0x84/0x8e
[   18.707133]  [<ffffffffa00dd355>] ? drm_helper_crtc_in_use+0x2c/0x71 [drm_kms_helper]
[   18.707135]  [<ffffffff8103a467>] ? warn_slowpath_null+0x15/0x17
[   18.707162]  [<ffffffffa01c7eaa>] radeon_fbdev_init+0xb8/0xca [radeon]
[   18.707188]  [<ffffffffa01c3b31>] radeon_modeset_init+0x75e/0x930 [radeon]
[   18.707211]  [<ffffffffa01a70ec>] radeon_driver_load_kms+0xc0/0x16c [radeon]
[   18.707219]  [<ffffffffa014e49d>] drm_dev_register+0x79/0xef [drm]
[   18.707227]  [<ffffffffa014fe0c>] drm_get_pci_dev+0xfa/0x1c5 [drm]
[   18.707228]  [<ffffffff810d720f>] ? kfree+0xc8/0x123
[   18.707250]  [<ffffffffa01a4327>] ? radeon_pci_probe+0x91/0xaa [radeon]
[   18.707272]  [<ffffffffa01a4339>] radeon_pci_probe+0xa3/0xaa [radeon]
[   18.707274]  [<ffffffff81224570>] pci_device_probe+0x6e/0xcf
[   18.707275]  [<ffffffff8129a516>] driver_probe_device+0x98/0x1c2
[   18.707277]  [<ffffffff8129a6d0>] __driver_attach+0x58/0x7a
[   18.707278]  [<ffffffff8129a678>] ? __device_attach+0x38/0x38
[   18.707280]  [<ffffffff81298ca1>] bus_for_each_dev+0x76/0x80
[   18.707281]  [<ffffffff8129a0a9>] driver_attach+0x19/0x1b
[   18.707283]  [<ffffffff81299d71>] bus_add_driver+0x101/0x1cb
[   18.707284]  [<ffffffff8129ac29>] driver_register+0x89/0xc5
[   18.707286]  [<ffffffffa02c2000>] ? 0xffffffffa02c1fff
[   18.707287]  [<ffffffff81223bcd>] __pci_register_driver+0x46/0x48
[   18.707295]  [<ffffffffa014ff40>] drm_pci_init+0x69/0xea [drm]
[   18.707296]  [<ffffffffa02c2000>] ? 0xffffffffa02c1fff
[   18.707316]  [<ffffffffa02c2097>] radeon_init+0x97/0x1000 [radeon]
[   18.707318]  [<ffffffff810002a3>] do_one_initcall+0x7f/0x105
[   18.707319]  [<ffffffff8102f528>] ? set_memory_nx+0x3b/0x3d
[   18.707321]  [<ffffffff8108c99c>] load_module+0x15a1/0x1ba9
[   18.707322]  [<ffffffff8108a0e5>] ? store_uevent+0x35/0x35
[   18.707324]  [<ffffffff810cd2e0>] ? map_vm_area+0x29/0x3b
[   18.707326]  [<ffffffff810ce0ce>] ? __vmalloc_node_range+0x143/0x1a5
[   18.707328]  [<ffffffff8108d044>] SyS_init_module+0xa0/0xaf
[   18.707330]  [<ffffffff813bfd61>] tracesys+0xd4/0xd9
[   18.707331] ---[ end trace e3f98afba7245f57 ]---



	-ss
