Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbaCULpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:45:21 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:42865 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaCULpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:45:18 -0400
Date: Fri, 21 Mar 2014 14:41:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-next] WARNING at drm_mode_connector_list_update
Message-ID: <20140321114126.GA406@swordfish.minsk.epam.com>
References: <20140321103704.GA376@swordfish.minsk.epam.com>
 <20140321104939.GB376@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321104939.GB376@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/21/14 13:49), Sergey Senozhatsky wrote:
> On (03/21/14 13:37), Sergey Senozhatsky wrote:
> > [   18.707077] WARNING: CPU: 2 PID: 175 at drivers/gpu/drm/drm_modes.c:1030 drm_mode_connector_list_update+0x2f/0xe8 [drm]()
> >
> [   18.704470] WARNING: CPU: 2 PID: 175 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x2b/0x48 [drm]()
>


[   14.747677] WARNING: CPU: 2 PID: 189 at drivers/gpu/drm/drm_crtc_helper.c:256 drm_helper_crtc_in_use+0x2c/0x71 [drm_kms_helper]()
[   14.748164] Modules linked in: radeon(+) i2c_algo_bit drm_kms_helper ttm crc32c_intel drm broadcom microcode psmouse evdev lpc_ich tg3 battery i2c_i801 button processor ac wmi ipv6 ehci_pci ehci_hcd usbcore sr_mod cdrom sd_mod ahci
[   14.750668] CPU: 2 PID: 189 Comm: systemd-udevd Tainted: G        W     3.14.0-rc7-next-20140321-dbg-dirty #192
[   14.751152] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[   14.751655]  0000000000000000 ffff8801523cba08 ffffffff813ba2d7 0000000000000000
[   14.752424]  ffff8801523cba40 ffffffff8103a3af ffffffffa0145355 ffff880098fbf000
[   14.753183]  ffff88015277e800 ffff880098fbf000 0000000000000000 ffff8801523cba50
[   14.753945] Call Trace:
[   14.754237]  [<ffffffff813ba2d7>] dump_stack+0x4e/0x7a
[   14.754537]  [<ffffffff8103a3af>] warn_slowpath_common+0x75/0x8e
[   14.754836]  [<ffffffffa0145355>] ? drm_helper_crtc_in_use+0x2c/0x71 [drm_kms_helper]
[   14.755346]  [<ffffffff8103a467>] warn_slowpath_null+0x15/0x17
[   14.755648]  [<ffffffffa0145355>] drm_helper_crtc_in_use+0x2c/0x71 [drm_kms_helper]
[   14.756148]  [<ffffffffa014545b>] drm_helper_disable_unused_functions+0xc1/0xfd [drm_kms_helper]
[   14.756707]  [<ffffffffa01b4e9f>] radeon_fbdev_init+0xad/0xca [radeon]
[   14.757056]  [<ffffffffa01b0b31>] radeon_modeset_init+0x75e/0x930 [radeon]
[   14.757402]  [<ffffffffa01940ec>] radeon_driver_load_kms+0xc0/0x16c [radeon]
[   14.757721]  [<ffffffffa015d49d>] drm_dev_register+0x79/0xef [drm]
[   14.758033]  [<ffffffffa015ee0c>] drm_get_pci_dev+0xfa/0x1c5 [drm]
[   14.758333]  [<ffffffff810d720f>] ? kfree+0xc8/0x123
[   14.758687]  [<ffffffffa0191327>] ? radeon_pci_probe+0x91/0xaa [radeon]
[   14.759029]  [<ffffffffa0191339>] radeon_pci_probe+0xa3/0xaa [radeon]
[   14.759336]  [<ffffffff81224570>] pci_device_probe+0x6e/0xcf
[   14.759634]  [<ffffffff8129a516>] driver_probe_device+0x98/0x1c2
[   14.759934]  [<ffffffff8129a6d0>] __driver_attach+0x58/0x7a
[   14.760232]  [<ffffffff8129a678>] ? __device_attach+0x38/0x38
[   14.760530]  [<ffffffff81298ca1>] bus_for_each_dev+0x76/0x80
[   14.760829]  [<ffffffff8129a0a9>] driver_attach+0x19/0x1b
[   14.761123]  [<ffffffff81299d71>] bus_add_driver+0x101/0x1cb
[   14.761422]  [<ffffffff8129ac29>] driver_register+0x89/0xc5
[   14.761718]  [<ffffffffa02af000>] ? 0xffffffffa02aefff
[   14.762016]  [<ffffffff81223bcd>] __pci_register_driver+0x46/0x48
[   14.762330]  [<ffffffffa015ef40>] drm_pci_init+0x69/0xea [drm]
[   14.762624]  [<ffffffffa02af000>] ? 0xffffffffa02aefff
[   14.762960]  [<ffffffffa02af097>] radeon_init+0x97/0x1000 [radeon]
[   14.763263]  [<ffffffff810002a3>] do_one_initcall+0x7f/0x105
[   14.763573]  [<ffffffff8102f528>] ? set_memory_nx+0x3b/0x3d
[   14.763870]  [<ffffffff8108c99c>] load_module+0x15a1/0x1ba9
[   14.764168]  [<ffffffff8108a0e5>] ? store_uevent+0x35/0x35
[   14.764469]  [<ffffffff810cd2e0>] ? map_vm_area+0x29/0x3b
[   14.764767]  [<ffffffff810ce0ce>] ? __vmalloc_node_range+0x143/0x1a5
[   14.765065]  [<ffffffff8108d044>] SyS_init_module+0xa0/0xaf
[   14.765365]  [<ffffffff813bfd61>] tracesys+0xd4/0xd9
[   14.765661] ---[ end trace f5ac5b2194c7ea98 ]---
[   15.267565] ------------[ cut here ]------------


[   15.267887] WARNING: CPU: 0 PID: 189 at drivers/gpu/drm/drm_crtc_helper.c:131 drm_helper_probe_single_connector_modes+0x40/0x2d1 [drm_kms_helper]()
[   15.268361] Modules linked in: radeon(+) i2c_algo_bit drm_kms_helper ttm crc32c_intel drm broadcom microcode psmouse evdev lpc_ich tg3 battery i2c_i801 button processor ac wmi ipv6 ehci_pci ehci_hcd usbcore sr_mod cdrom sd_mod ahci
[   15.270769] CPU: 0 PID: 189 Comm: systemd-udevd Tainted: G        W     3.14.0-rc7-next-20140321-dbg-dirty #192
[   15.271235] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[   15.271710]  0000000000000000 ffff8801523cb930 ffffffff813ba2d7 0000000000000000
[   15.272430]  ffff8801523cb968 ffffffff8103a3af ffffffffa014647d ffff8801527a2400
[   15.273143]  0000000000000000 ffff88015277e800 0000000000002000 ffff8801523cb978
[   15.273857] Call Trace:
[   15.274122]  [<ffffffff813ba2d7>] dump_stack+0x4e/0x7a
[   15.274390]  [<ffffffff8103a3af>] warn_slowpath_common+0x75/0x8e
[   15.274659]  [<ffffffffa014647d>] ? drm_helper_probe_single_connector_modes+0x40/0x2d1 [drm_kms_helper]
[   15.275122]  [<ffffffff8103a467>] warn_slowpath_null+0x15/0x17
[   15.275391]  [<ffffffffa014647d>] drm_helper_probe_single_connector_modes+0x40/0x2d1 [drm_kms_helper]
[   15.275868]  [<ffffffffa01473a5>] drm_fb_helper_probe_connector_modes+0x41/0x54 [drm_kms_helper]
[   15.276340]  [<ffffffffa0148894>] drm_fb_helper_initial_config+0x1ab/0x43c [drm_kms_helper]
[   15.276803]  [<ffffffff8103a3be>] ? warn_slowpath_common+0x84/0x8e
[   15.277071]  [<ffffffffa0145355>] ? drm_helper_crtc_in_use+0x2c/0x71 [drm_kms_helper]
[   15.277531]  [<ffffffff8103a467>] ? warn_slowpath_null+0x15/0x17
[   15.277833]  [<ffffffffa01b4eaa>] radeon_fbdev_init+0xb8/0xca [radeon]
[   15.278128]  [<ffffffffa01b0b31>] radeon_modeset_init+0x75e/0x930 [radeon]
[   15.278417]  [<ffffffffa01940ec>] radeon_driver_load_kms+0xc0/0x16c [radeon]
[   15.278696]  [<ffffffffa015d49d>] drm_dev_register+0x79/0xef [drm]
[   15.284786]  [<ffffffffa015ee0c>] drm_get_pci_dev+0xfa/0x1c5 [drm]
[   15.285063]  [<ffffffff810d720f>] ? kfree+0xc8/0x123
[   15.285352]  [<ffffffffa0191327>] ? radeon_pci_probe+0x91/0xaa [radeon]
[   15.285638]  [<ffffffffa0191339>] radeon_pci_probe+0xa3/0xaa [radeon]
[   15.285912]  [<ffffffff81224570>] pci_device_probe+0x6e/0xcf
[   15.286181]  [<ffffffff8129a516>] driver_probe_device+0x98/0x1c2
[   15.286449]  [<ffffffff8129a6d0>] __driver_attach+0x58/0x7a
[   15.286717]  [<ffffffff8129a678>] ? __device_attach+0x38/0x38
[   15.286985]  [<ffffffff81298ca1>] bus_for_each_dev+0x76/0x80
[   15.287249]  [<ffffffff8129a0a9>] driver_attach+0x19/0x1b
[   15.287526]  [<ffffffff81299d71>] bus_add_driver+0x101/0x1cb
[   15.287797]  [<ffffffff8129ac29>] driver_register+0x89/0xc5
[   15.288067]  [<ffffffffa02af000>] ? 0xffffffffa02aefff
[   15.288335]  [<ffffffff81223bcd>] __pci_register_driver+0x46/0x48
[   15.288611]  [<ffffffffa015ef40>] drm_pci_init+0x69/0xea [drm]
[   15.288874]  [<ffffffffa02af000>] ? 0xffffffffa02aefff
[   15.289158]  [<ffffffffa02af097>] radeon_init+0x97/0x1000 [radeon]
[   15.289428]  [<ffffffff810002a3>] do_one_initcall+0x7f/0x105
[   15.289697]  [<ffffffff8102f528>] ? set_memory_nx+0x3b/0x3d
[   15.289964]  [<ffffffff8108c99c>] load_module+0x15a1/0x1ba9
[   15.290230]  [<ffffffff8108a0e5>] ? store_uevent+0x35/0x35
[   15.290496]  [<ffffffff810cd2e0>] ? map_vm_area+0x29/0x3b
[   15.290763]  [<ffffffff810ce0ce>] ? __vmalloc_node_range+0x143/0x1a5
[   15.291030]  [<ffffffff8108d044>] SyS_init_module+0xa0/0xaf
[   15.291298]  [<ffffffff813bfd61>] tracesys+0xd4/0xd9
[   15.291573] ---[ end trace f5ac5b2194c7ea99 ]---
[   15.294242] ------------[ cut here ]------------


	-ss
