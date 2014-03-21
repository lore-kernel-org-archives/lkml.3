Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbaCUKxd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:53:33 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:60097 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760395AbaCUKxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:53:31 -0400
Date: Fri, 21 Mar 2014 13:49:39 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [linux-next] WARNING at drm_mode_connector_list_update
Message-ID: <20140321104939.GB376@swordfish.minsk.epam.com>
References: <20140321103704.GA376@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321103704.GA376@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/21/14 13:37), Sergey Senozhatsky wrote:
> [   18.707077] WARNING: CPU: 2 PID: 175 at drivers/gpu/drm/drm_modes.c:1030 drm_mode_connector_list_update+0x2f/0xe8 [drm]()
>


[   18.704470] WARNING: CPU: 2 PID: 175 at drivers/gpu/drm/drm_modes.c:119 drm_mode_probed_add+0x2b/0x48 [drm]()
[   18.704479] Modules linked in: crc32c_intel microcode radeon(+) broadcom i2c_algo_bit psmouse drm_kms_helper tg3 ttm drm evdev wmi button battery processor ac lpc_ich i2c_i801 ipv6 ehci_pci ehci_hcd usbcore sr_mod cdrom sd_mod ahci
[   18.704480] CPU: 2 PID: 175 Comm: systemd-udevd Tainted: G        W     3.14.0-rc7-next-20140321-dbg-dirty #189
[   18.704481] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[   18.704482]  0000000000000000 ffff88015217f830 ffffffff813ba2d7 0000000000000000
[   18.704484]  ffff88015217f868 ffffffff8103a3af ffffffffa0157186 ffff880037475400
[   18.704485]  ffff8801521e2000 ffffffffa01669d0 0000000000000008 ffff88015217f878
[   18.704485] Call Trace:
[   18.704487]  [<ffffffff813ba2d7>] dump_stack+0x4e/0x7a
[   18.704489]  [<ffffffff8103a3af>] warn_slowpath_common+0x75/0x8e
[   18.704499]  [<ffffffffa0157186>] ? drm_mode_probed_add+0x2b/0x48 [drm]
[   18.704501]  [<ffffffff8103a467>] warn_slowpath_null+0x15/0x17
[   18.704511]  [<ffffffffa0157186>] drm_mode_probed_add+0x2b/0x48 [drm]
[   18.704521]  [<ffffffffa015a20f>] drm_add_edid_modes+0x270/0xc8d [drm]
[   18.704548]  [<ffffffffa01c2afb>] radeon_ddc_get_modes+0xdd/0xf0 [radeon]
[   18.704573]  [<ffffffffa01bee65>] radeon_vga_get_modes+0x9/0xb [radeon]
[   18.704576]  [<ffffffffa00de574>] drm_helper_probe_single_connector_modes+0x137/0x2d1 [drm_kms_helper]
[   18.704580]  [<ffffffffa00df3a5>] drm_fb_helper_probe_connector_modes+0x41/0x54 [drm_kms_helper]
[   18.704583]  [<ffffffffa00e0894>] drm_fb_helper_initial_config+0x1ab/0x43c [drm_kms_helper]
[   18.704585]  [<ffffffff8103a3be>] ? warn_slowpath_common+0x84/0x8e
[   18.704588]  [<ffffffffa00dd355>] ? drm_helper_crtc_in_use+0x2c/0x71 [drm_kms_helper]
[   18.704589]  [<ffffffff8103a467>] ? warn_slowpath_null+0x15/0x17
[   18.704616]  [<ffffffffa01c7eaa>] radeon_fbdev_init+0xb8/0xca [radeon]
[   18.704645]  [<ffffffffa01c3b31>] radeon_modeset_init+0x75e/0x930 [radeon]
[   18.704668]  [<ffffffffa01a70ec>] radeon_driver_load_kms+0xc0/0x16c [radeon]
[   18.704675]  [<ffffffffa014e49d>] drm_dev_register+0x79/0xef [drm]
[   18.704684]  [<ffffffffa014fe0c>] drm_get_pci_dev+0xfa/0x1c5 [drm]
[   18.704685]  [<ffffffff810d720f>] ? kfree+0xc8/0x123
[   18.704707]  [<ffffffffa01a4327>] ? radeon_pci_probe+0x91/0xaa [radeon]
[   18.704728]  [<ffffffffa01a4339>] radeon_pci_probe+0xa3/0xaa [radeon]
[   18.704730]  [<ffffffff81224570>] pci_device_probe+0x6e/0xcf
[   18.704732]  [<ffffffff8129a516>] driver_probe_device+0x98/0x1c2
[   18.704733]  [<ffffffff8129a6d0>] __driver_attach+0x58/0x7a
[   18.704735]  [<ffffffff8129a678>] ? __device_attach+0x38/0x38
[   18.704736]  [<ffffffff81298ca1>] bus_for_each_dev+0x76/0x80
[   18.704738]  [<ffffffff8129a0a9>] driver_attach+0x19/0x1b
[   18.704739]  [<ffffffff81299d71>] bus_add_driver+0x101/0x1cb
[   18.704741]  [<ffffffff8129ac29>] driver_register+0x89/0xc5
[   18.704742]  [<ffffffffa02c2000>] ? 0xffffffffa02c1fff
[   18.704744]  [<ffffffff81223bcd>] __pci_register_driver+0x46/0x48
[   18.704752]  [<ffffffffa014ff40>] drm_pci_init+0x69/0xea [drm]
[   18.704753]  [<ffffffffa02c2000>] ? 0xffffffffa02c1fff
[   18.704772]  [<ffffffffa02c2097>] radeon_init+0x97/0x1000 [radeon]
[   18.704774]  [<ffffffff810002a3>] do_one_initcall+0x7f/0x105
[   18.704776]  [<ffffffff8102f528>] ? set_memory_nx+0x3b/0x3d
[   18.704778]  [<ffffffff8108c99c>] load_module+0x15a1/0x1ba9
[   18.704780]  [<ffffffff8108a0e5>] ? store_uevent+0x35/0x35
[   18.704782]  [<ffffffff810cd2e0>] ? map_vm_area+0x29/0x3b
[   18.704783]  [<ffffffff810ce0ce>] ? __vmalloc_node_range+0x143/0x1a5
[   18.704785]  [<ffffffff8108d044>] SyS_init_module+0xa0/0xaf
[   18.704787]  [<ffffffff813bfd61>] tracesys+0xd4/0xd9
[   18.704788] ---[ end trace e3f98afba7245f4f ]---


	-ss
