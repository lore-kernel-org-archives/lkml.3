Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaCCUwy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 15:52:54 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:56981 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaCCUww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 15:52:52 -0500
Date: Mon, 3 Mar 2014 21:52:46 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [WARNING - 3.14-rc2] i915: pipe_off wait timed out
Message-ID: <20140303205246.GI17001@phenom.ffwll.local>
Mail-Followup-To: Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Jani Nikula <jani.nikula@linux.intel.com>
References: <20140214174101.7892a945@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214174101.7892a945@gandalf.local.home>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 05:41:01PM -0500, Steven Rostedt wrote:
> I get the following splat in my tests running 3.14-rc2:
> 
> [    3.955123] WARNING: CPU: 0 PID: 1 at /work/autotest/nobackup/linux-test.git/drivers/gpu/drm/i915/intel_display.c:857 intel_wait_for_pipe_off+0x17a/0x2d0()
> [    3.955124] pipe_off wait timed out
> [    3.955127] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc2-test+ #10
> [    3.955128] Hardware name:                  /DG965MQ, BIOS MQ96510J.86A.0372.2006.0605.1717 06/05/2006
> [    3.955133]  0000000000000359 ffff88007d075868 ffffffff828dff7d 0000000000000006
> [    3.955136]  ffff88007d0758b8 ffff88007d0758a8 ffffffff8106c015 0000000000001000^M
> [    3.955139]  ffff880078d58000 0000000000071008 00000000fffb7b90 0000000000001000
> [    3.955140] Call Trace:
> [    3.955144]  [<ffffffff828dff7d>] dump_stack+0x77/0x9e
> [    3.955147]  [<ffffffff8106c015>] warn_slowpath_common+0xa5/0xf0
> [    3.955150]  [<ffffffff8106c0f1>] warn_slowpath_fmt+0x51/0x60
> [    3.955153]  [<ffffffff81b74e02>] ? gen4_read32+0x52/0x70
> [    3.955156]  [<ffffffff81b1cd0a>] intel_wait_for_pipe_off+0x17a/0x2d0
> [    3.955158]  [<ffffffff81b1cf64>] intel_disable_pipe+0x104/0x110^M
> [    3.955161]  [<ffffffff81b1e1ae>] i9xx_crtc_disable+0x11e/0x4a0
> [    3.955163]  [<ffffffff81b28034>] intel_crtc_update_dpms+0x94/0xe0
> [    3.955166]  [<ffffffff81b31c38>] intel_modeset_setup_hw_state+0x9f8/0x1020
> [    3.955168]  [<ffffffff81b743c0>] ? gen4_write64+0x80/0x80
> [    3.955170]  [<ffffffff81b322c2>] intel_modeset_gem_init+0x62/0x80
> [    3.955173]  [<ffffffff81ae4f90>] i915_driver_load+0x15e0/0x1760
> [    3.955176]  [<ffffffff81cafafb>] ? device_add+0x31b/0xa20
> [    3.955180]  [<ffffffff8197c8a4>] drm_dev_register+0xb4/0x260
> [    3.955182]  [<ffffffff8197fb5e>] drm_get_pci_dev+0x15e/0x320
> [    3.955186]  [<ffffffff810d369d>] ? trace_hardirqs_on+0x1d/0x30
> [    3.955188]  [<ffffffff81adf36e>] i915_pci_probe+0x4e/0x80
> [    3.955191]  [<ffffffff8175524d>] pci_device_probe+0xdd/0x190
> [    3.955194]  [<ffffffff81cb5928>] driver_probe_device+0xc8/0x550
> [    3.955196]  [<ffffffff81cb5eab>] __driver_attach+0xfb/0x110
> [    3.955198]  [<ffffffff81cb5db0>] ? driver_probe_device+0x550/0x550
> [    3.955200]  [<ffffffff81cb2bce>] bus_for_each_dev+0x9e/0xf0
> [    3.955202]  [<ffffffff81cb5481>] driver_attach+0x21/0x30
> [    3.955204]  [<ffffffff81cb3aef>] bus_add_driver+0x16f/0x340
> [    3.955207]  [<ffffffff81cb68a7>] driver_register+0xa7/0x190
> [    3.955209]  [<ffffffff81754e7f>] __pci_register_driver+0x6f/0x80
> [    3.955211]  [<ffffffff8197fe79>] drm_pci_init+0x159/0x170
> [    3.955214]  [<ffffffff8356b260>] ? radeon_init+0xfb/0xfb^M
> [    3.955217]  [<ffffffff8356b305>] i915_init+0xa5/0xae
> [    3.955220]  [<ffffffff8351a5c5>] do_one_initcall+0xe1/0x1b2
> [    3.955223]  [<ffffffff8351a832>] kernel_init_freeable+0x19c/0x29d
> [    3.955225]  [<ffffffff8351996d>] ? loglevel+0x46/0x46
> [    3.955228]  [<ffffffff828d2c50>] ? rest_init+0x120/0x120
> [    3.955230]  [<ffffffff828d2c61>] kernel_init+0x11/0x1a0
> [    3.955233]  [<ffffffff82900a3c>] ret_from_fork+0x7c/0xb0
> [    3.955235]  [<ffffffff828d2c50>] ? rest_init+0x120/0x120^M
> [    3.955256] ---[ end trace 708152452bf03fad ]---
> 
> 
> Config attached.

If this is an ironlake it's https://bugs.freedesktop.org/show_bug.cgi?id=54687,
for sandybridge it's https://bugs.freedesktop.org/show_bug.cgi?id=67462.
Iirc we've stopped seing this on more recent platfroms (i.e. Ivybridge+).
It's an issue in our dp code where the dp port doesn't cleanly shut down,
but we haven't ever figured out what's really botched up. DP in general is
nasty in that way.

If there's no other bad side effects I don't think there's much we could
do :(
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
