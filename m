Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3HDXGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 19:06:38 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:61847 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab3HDXGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 19:06:36 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130731162252.GC4724@pd.tnic>
References: <20130731162252.GC4724@pd.tnic>
Date: Mon, 5 Aug 2013 01:06:35 +0200
X-Google-Sender-Auth: 83r7aDlp6c62PaO9pk6wWetF8Yo
Message-ID: <CAKMK7uFNpvSHxMXu6uzHbTwv4W=k_QZ2-g9X4hAK6wwniisrvQ@mail.gmail.com>
Subject: Re: i915 INFO: trying to register non-static key.
From: Daniel Vetter <daniel@ffwll.ch>
To: Borislav Petkov <bp@alien8.de>
Cc: intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 6:22 PM, Borislav Petkov <bp@alien8.de> wrote:
> Dudes,
>
> has anyone already reported this (happens on Linus of today +
> tip/master):

I think this should be fixed with

commit e1b4d3036c07ff137955fb1c0197ab62534f46ec
Author: Ben Widawsky <ben@bwidawsk.net>
Date:   Tue Jul 30 16:27:57 2013 -0700

    drm/i915: fix missed hunk after GT access breakage

which is now in upstream git and -rc4.
-Daniel



>
> [    0.608465] Linux agpgart interface v0.103
> [    0.608615] [drm] Initialized drm 1.1.0 20060810
> [    0.612050] [drm] Memory usable by graphics device = 2048M
> [    0.612212] i915 0000:00:02.0: setting latency timer to 64
> [    0.674824] INFO: trying to register non-static key.
> [    0.674904] the code is fine but needs lockdep annotation.
> [    0.674983] turning off the locking correctness validator.
> [    0.675063] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.11.0-rc3+ #1
> [    0.675146] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
> [    0.675244]  0000000000000002 ffff880213c9d708 ffffffff815bc9d4 0000000000000000
> [    0.675539]  ffffffff82608750 ffff880213c9d808 ffffffff810aa864 ffff88021d283fc0
> [    0.675828]  ffffffff82654e60 0000000000000000 ffffffff00000000 ffff880200000000
> [    0.676116] Call Trace:
> [    0.676194]  [<ffffffff815bc9d4>] dump_stack+0x4f/0x84
> [    0.676281]  [<ffffffff810aa864>] __lock_acquire+0x1774/0x1d80
> [    0.676366]  [<ffffffff81010d6f>] ? save_stack_trace+0x2f/0x50
> [    0.676451]  [<ffffffff810a6d7f>] ? save_trace+0x3f/0xc0
> [    0.676535]  [<ffffffff810aa36d>] ? __lock_acquire+0x127d/0x1d80
> [    0.676621]  [<ffffffff810ab445>] lock_acquire+0x85/0x130
> [    0.676705]  [<ffffffff810682f5>] ? flush_work+0x5/0x280
> [    0.676787]  [<ffffffff8106833c>] flush_work+0x4c/0x280
> [    0.676870]  [<ffffffff810682f5>] ? flush_work+0x5/0x280
> [    0.676954]  [<ffffffff810abd8e>] ? mark_held_locks+0xae/0x120
> [    0.677039]  [<ffffffff8106a961>] ? __cancel_work_timer+0x71/0x110
> [    0.677125]  [<ffffffff8106a96d>] __cancel_work_timer+0x7d/0x110
> [    0.677207]  [<ffffffff8106aa13>] cancel_delayed_work_sync+0x13/0x20
> [    0.677292]  [<ffffffff813c1e15>] intel_disable_gt_powersave+0x65/0x410
> [    0.677379]  [<ffffffff813c3b39>] intel_gt_sanitize+0x49/0xb0
> [    0.677463]  [<ffffffff81372541>] i915_driver_load+0x611/0xe90
> [    0.677550]  [<ffffffff8135acce>] drm_get_pci_dev+0x17e/0x2a0
> [    0.677632]  [<ffffffff8136ddec>] i915_pci_probe+0x2c/0x70
> [    0.677716]  [<ffffffff812b27fb>] local_pci_probe+0x4b/0x80
> [    0.677798]  [<ffffffff812b2a61>] pci_device_probe+0x111/0x120
> [    0.677885]  [<ffffffff813dc06b>] driver_probe_device+0x7b/0x240
> [    0.677971]  [<ffffffff813dc2db>] __driver_attach+0xab/0xb0
> [    0.678053]  [<ffffffff813dc230>] ? driver_probe_device+0x240/0x240
> [    0.678138]  [<ffffffff813da0ed>] bus_for_each_dev+0x5d/0xa0
> [    0.678222]  [<ffffffff813dbb2e>] driver_attach+0x1e/0x20
> [    0.678304]  [<ffffffff813db64f>] bus_add_driver+0x10f/0x270
> [    0.678390]  [<ffffffff813dc9ba>] driver_register+0x7a/0x170
> [    0.678471]  [<ffffffff812b1874>] __pci_register_driver+0x64/0x70
> [    0.678558]  [<ffffffff81b2b68a>] ? ftrace_define_fields_drm_vblank_event+0x6d/0x6d
> [    0.678660]  [<ffffffff8135af05>] drm_pci_init+0x115/0x130
> [    0.678740]  [<ffffffff81b2b68a>] ? ftrace_define_fields_drm_vblank_event+0x6d/0x6d
> [    0.678843]  [<ffffffff81b2b6f0>] i915_init+0x66/0x68
> [    0.678927]  [<ffffffff8100031a>] do_one_initcall+0x11a/0x170
> [    0.679012]  [<ffffffff8106f800>] ? parse_args+0xa0/0x360
> [    0.679096]  [<ffffffff81af2f92>] kernel_init_freeable+0x108/0x197
> [    0.679182]  [<ffffffff81af283f>] ? do_early_param+0x8c/0x8c
> [    0.679266]  [<ffffffff815b3350>] ? rest_init+0xd0/0xd0
> [    0.679349]  [<ffffffff815b335e>] kernel_init+0xe/0xf0
> [    0.679427]  [<ffffffff815cca5c>] ret_from_fork+0x7c/0xb0
> [    0.679509]  [<ffffffff815b3350>] ? rest_init+0xd0/0xd0
> [    0.680182] i915 0000:00:02.0: irq 42 for MSI/MSI-X
> [    0.680278] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
