Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3HENyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 09:54:51 -0400
Received: from bar.sig21.net ([80.81.252.164]:45880 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab3HENyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 09:54:50 -0400
Date: Mon, 5 Aug 2013 15:23:53 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Borislav Petkov <bp@alien8.de>
Cc: Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: i915 INFO: trying to register non-static key.
Message-ID: <20130805132353.GA4678@sig21.net>
References: <20130731162252.GC4724@pd.tnic>
 <CAKMK7uFNpvSHxMXu6uzHbTwv4W=k_QZ2-g9X4hAK6wwniisrvQ@mail.gmail.com>
 <20130805092612.GA23560@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805092612.GA23560@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

wrt to $Subject, I get this with 3.10.5:

[    4.342638] i915 0000:00:02.0: setting latency timer to 64
[    4.409045] INFO: trying to register non-static key.
[    4.409164] the code is fine but needs lockdep annotation.
[    4.409278] turning off the locking correctness validator.
[    4.409396] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.10.5 #1
[    4.409514] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET82WW (2.02 ) 09/11/2012
[    4.409690]  0000000000000001 ffff8802121559e0 ffffffff816b265c ffff880212155a50
[    4.410050]  ffffffff8109ba03 ffffffff822cd1c0 0000000000000000 0000000100000006
[    4.410408]  0000000000000000 0000000000000000 0000000000000000 ffff8802121587a8
[    4.410764] Call Trace:
[    4.410880]  [<ffffffff816b265c>] dump_stack+0x19/0x1b
[    4.411000]  [<ffffffff8109ba03>] __lock_acquire.isra.23+0x7f7/0xb9c
[    4.411120]  [<ffffffff8109be68>] lock_acquire+0xc0/0x142
[    4.411240]  [<ffffffff813999f4>] ? i915_write32+0x99/0x13a
[    4.411360]  [<ffffffff816b8c7f>] _raw_spin_lock_irqsave+0x57/0x8e
[    4.411481]  [<ffffffff813999f4>] ? i915_write32+0x99/0x13a
[    4.411599]  [<ffffffff813999f4>] i915_write32+0x99/0x13a
[    4.411718]  [<ffffffff813d9aa8>] intel_disable_gt_powersave+0x264/0x2e5
[    4.411839]  [<ffffffff813db00c>] intel_gt_sanitize+0x91/0x93
[    4.411956]  [<ffffffff8139ca1d>] i915_driver_load+0x6e7/0xca5
[    4.412080]  [<ffffffff81387e8d>] ? drm_get_minor+0x1d4/0x22e
[    4.412199]  [<ffffffff81389b1f>] drm_get_pci_dev+0x169/0x269
[    4.412319]  [<ffffffff816b8eac>] ? _raw_spin_unlock_irqrestore+0x5b/0x79
[    4.412440]  [<ffffffff81398f00>] i915_pci_probe+0x66/0x6f
[    4.412557]  [<ffffffff812d4597>] pci_device_probe+0x6e/0xb2
[    4.412679]  [<ffffffff813ef7ac>] driver_probe_device+0x11a/0x2e2
[    4.412799]  [<ffffffff813efa12>] __driver_attach+0x61/0x83
[    4.412918]  [<ffffffff813ef9b1>] ? __device_attach+0x3d/0x3d
[    4.413039]  [<ffffffff813edb2f>] bus_for_each_dev+0x7d/0x87
[    4.413158]  [<ffffffff813ef1e5>] driver_attach+0x1e/0x20
[    4.413278]  [<ffffffff813eedb5>] bus_add_driver+0x128/0x233
[    4.413397]  [<ffffffff813eff30>] driver_register+0x8c/0xfd
[    4.413515]  [<ffffffff812d4420>] __pci_register_driver+0x5d/0x60
[    4.413637]  [<ffffffff81f16c96>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9a/0x9a
[    4.413818]  [<ffffffff81389ca5>] drm_pci_init+0x86/0xea
[    4.413936]  [<ffffffff81f16c96>] ? ftrace_define_fields_drm_vblank_event_delivered+0x9a/0x9a
[    4.414117]  [<ffffffff81f16cfc>] i915_init+0x66/0x68
[    4.414235]  [<ffffffff8100028d>] do_one_initcall+0xa0/0x13f
[    4.414355]  [<ffffffff81edeeae>] kernel_init_freeable+0x115/0x196
[    4.414475]  [<ffffffff81ede738>] ? do_early_param+0x88/0x88
[    4.414594]  [<ffffffff8169e69e>] ? rest_init+0xc2/0xc2
[    4.414711]  [<ffffffff8169e6ac>] kernel_init+0xe/0xd6
[    4.414828]  [<ffffffff816ba5ac>] ret_from_fork+0x7c/0xb0
[    4.414946]  [<ffffffff8169e69e>] ? rest_init+0xc2/0xc2
[    4.422529] i915 0000:00:02.0: irq 40 for MSI/MSI-X

If you have a fix for it please send it to stable.

Thanks,
Johannes
