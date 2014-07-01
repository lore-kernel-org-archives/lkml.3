Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbaGAJSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:18:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:8522 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbaGAJSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:18:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,580,1400050800"; 
   d="scan'208";a="537036041"
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: drm: i915: "plane B assertion failure, should be off on pipe B but is still active"
In-Reply-To: <1404140703.2978.13.camel@x41>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1404140703.2978.13.camel@x41>
User-Agent: Notmuch/0.18+25~gfdc3e52 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 01 Jul 2014 12:17:56 +0300
Message-ID: <87egy5h1yz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jun 2014, Paul Bolle <pebolle@tiscali.nl> wrote:
> Kernels v3.16-rc2 and v3.16-rc3 trigger a new (for me) warning. (I never
> booted v3.16-rc1). Machine is a, rather outdated, ThinkPad X41 (ie,
> single core i686).
>
> WARNING: CPU: 0 PID: 221 at drivers/gpu/drm/i915/intel_display.c:1274 assert_planes_disabled+0xf9/0x100 [i915]()
> plane B assertion failure, should be off on pipe B but is still active
> Modules linked in: tg3 i915(+) i2c_algo_bit drm_kms_helper ptp drm ata_generic pata_acpi yenta_socket i2c_core pps_core video
> CPU: 0 PID: 221 Comm: systemd-udevd Not tainted 3.16.0-0.rc3.1.local0.fc20.i686 #1
> Hardware name: IBM 2525FAG/2525FAG, BIOS 74ET64WW (2.09 ) 12/14/2006
>  c0c87907 add7c490 00000000 f652b9ac c09fdab7 f652b9ec f652b9dc c045008e
>  f830c6cc f652ba0c 000000dd f830c634 000004fa f82b4d59 f82b4d59 f6728000
>  00000001 f65a8c00 f652b9f8 c04500ee 00000009 f652b9ec f830c6cc f652ba0c
> Call Trace:
>  [<c09fdab7>] dump_stack+0x41/0x52
>  [<c045008e>] warn_slowpath_common+0x7e/0xa0
>  [<f82b4d59>] ? assert_planes_disabled+0xf9/0x100 [i915]
>  [<f82b4d59>] ? assert_planes_disabled+0xf9/0x100 [i915]
>  [<c04500ee>] warn_slowpath_fmt+0x3e/0x60
>  [<f82b4d59>] assert_planes_disabled+0xf9/0x100 [i915]
>  [<f82bd8d6>] intel_disable_pipe+0x26/0xb0 [i915]
>  [<f82aec40>] ? gen4_read8+0xc0/0xc0 [i915]
>  [<f82c25d3>] i9xx_crtc_disable+0x93/0x3d0 [i915]
>  [<f82c91bc>] intel_modeset_setup_hw_state+0x7ac/0xbc0 [i915]
>  [<f82aec40>] ? gen4_read8+0xc0/0xc0 [i915]
>  [<f815bc7c>] ? drm_modeset_lock_all_crtcs+0x3c/0x50 [drm]
>  [<f82c9d04>] intel_modeset_init+0x734/0x1220 [i915]
>  [<f82a2edb>] ? i915_enable_pipestat+0xab/0x120 [i915]
>  [<f82a34c4>] ? i915_irq_postinstall+0x104/0x110 [i915]
>  [<f8146ba9>] ? drm_irq_install+0xa9/0x170 [drm]
>  [<f82f4016>] i915_driver_load+0xa76/0xe70 [i915]
>  [<f82f13d0>] ? i915_switcheroo_set_state+0x90/0x90 [i915]
>  [<c06b5880>] ? cleanup_uevent_env+0x10/0x10
>  [<c05d8243>] ? sysfs_add_file+0x23/0x30
>  [<c07a4034>] ? get_device+0x14/0x30
>  [<c07a8e52>] ? klist_class_dev_get+0x12/0x20
>  [<c09f73ce>] ? klist_node_init+0x2e/0x50
>  [<c09f7487>] ? klist_add_tail+0x27/0x30
>  [<c07a5506>] ? device_add+0x1d6/0x5a0
>  [<f814ca8a>] ? drm_sysfs_device_add+0xba/0x100 [drm]
>  [<f81496ee>] drm_dev_register+0x8e/0xe0 [drm]
>  [<f814bca9>] drm_get_pci_dev+0x79/0x1c0 [drm]
>  [<f8274415>] i915_pci_probe+0x35/0x60 [i915]
>  [<c06f0baf>] pci_device_probe+0x6f/0xc0
>  [<c05d8625>] ? sysfs_create_link+0x25/0x40
>  [<c07a8093>] driver_probe_device+0x93/0x3a0
>  [<c05d8357>] ? sysfs_create_dir_ns+0x37/0x80
>  [<c06f0af1>] ? pci_match_device+0xc1/0xe0
>  [<c07a8451>] __driver_attach+0x71/0x80
>  [<c07a83e0>] ? __device_attach+0x40/0x40
>  [<c07a64c7>] bus_for_each_dev+0x57/0xa0
>  [<c07a7bbe>] driver_attach+0x1e/0x20
>  [<c07a83e0>] ? __device_attach+0x40/0x40
>  [<c07a7807>] bus_add_driver+0x157/0x230
>  [<f7fc8000>] ? 0xf7fc7fff
>  [<f7fc8000>] ? 0xf7fc7fff
>  [<c07a8b39>] driver_register+0x59/0xe0
>  [<c0564f56>] ? __kmalloc_track_caller+0x46/0x1f0
>  [<c06ef722>] __pci_register_driver+0x32/0x40
>  [<f814bed5>] drm_pci_init+0xe5/0x110 [drm]
>  [<f7fc8000>] ? 0xf7fc7fff
>  [<f7fc8088>] i915_init+0x88/0x8a [i915]
>  [<f7fc8000>] ? 0xf7fc7fff
>  [<c0400492>] do_one_initcall+0xc2/0x1f0
>  [<f7fc8000>] ? 0xf7fc7fff
>  [<c05624dd>] ? kfree+0xdd/0x120
>  [<c05524ef>] ? __vunmap+0x8f/0xe0
>  [<c05524ef>] ? __vunmap+0x8f/0xe0
>  [<c05524ef>] ? __vunmap+0x8f/0xe0
>  [<c04bee92>] load_module+0x1a92/0x23b0
>  [<c04bbd69>] ? copy_module_from_fd.isra.46+0x109/0x1a0
>  [<c04bf94d>] SyS_finit_module+0x8d/0xd0
>  [<c0538f43>] ? vm_mmap_pgoff+0x93/0xb0
>  [<c0a045df>] sysenter_do_call+0x12/0x16
>
> Feel free to prod me for further details.

This does not ring any bells to me (but that doesn't prove anything). A
bisect result would be awesome.

BR,
Jani.




-- 
Jani Nikula, Intel Open Source Technology Center
