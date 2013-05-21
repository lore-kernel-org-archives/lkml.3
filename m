Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab3EUXKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:10:38 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49613 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab3EUXKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:10:36 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130521230108.GB12713@redhat.com>
References: <20130521230108.GB12713@redhat.com>
Date: Wed, 22 May 2013 01:10:36 +0200
X-Google-Sender-Auth: edYYg0ZHBdYOLbDW45g_A1xSPsE
Message-ID: <CAKMK7uFB2u1hO+fLk49vVsT_+A-MDbMDPhGDtPmcK+aUQMipZw@mail.gmail.com>
Subject: Re: [Intel-gfx] pipe_off wait timed out
From: Daniel Vetter <daniel@ffwll.ch>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 1:01 AM, Dave Jones <davej@redhat.com> wrote:
> This is new to me as of 3.10-rc2.

If this is an ironlake with a DP output it's a know issue which seems
to pop up every once in a while. Otherwise we need to take a look
here. If so can you please boot with drm.debug=0xe, reproduce the
issue and attach the complete dmesg?

Also does 3.10-rc1 work (since you mention -rc2 specifically and there
wasn't really a lot going into that for drm/i915).

Thanks, Daniel

>
>
> WARNING: at drivers/gpu/drm/i915/intel_display.c:997 intel_wait_for_pipe_off+0x194/0x1a0 [i915]()
> pipe_off wait timed out
> Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_LOG xt_limit ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter nf_conntrack_ipv4 nf_defrag_ipv4 ip6_tables xt_conntrack nf_conntrack microcode pcspkr r8169 mii nfsd auth_rpcgss nfs_acl lockd sunrpc i915 video backlight i2c_algo_bit drm_kms_helper drm
> CPU: 3 PID: 1414 Comm: kworker/3:1 Not tainted 3.10.0-rc2+ #3
> Hardware name:                  /D510MO, BIOS MOPNV10J.86A.0175.2010.0308.0620 03/08/2010
> Workqueue: events console_callback
>  ffffffffa00d1c08 ffff8800753c7988 ffffffff8151fd9f ffff8800753c79c8
>  ffffffff8103ca8b 00000000000008dd ffff880076738000 000000000000031f
>  0000000000001fff 0000000000071000 0000000100086e1b ffff8800753c7a28
> Call Trace:
>  [<ffffffff8151fd9f>] dump_stack+0x19/0x1b
>  [<ffffffff8103ca8b>] warn_slowpath_common+0x6b/0xa0
>  [<ffffffff8103cb61>] warn_slowpath_fmt+0x41/0x50
>  [<ffffffffa008d414>] intel_wait_for_pipe_off+0x194/0x1a0 [i915]
>  [<ffffffffa008d5a5>] intel_disable_pipe+0x185/0x210 [i915]
>  [<ffffffffa008dcef>] i9xx_crtc_disable+0xcf/0x230 [i915]
>  [<ffffffffa009245f>] intel_crtc_update_dpms+0x6f/0xa0 [i915]
>  [<ffffffffa0092515>] intel_encoder_dpms+0x15/0x30 [i915]
>  [<ffffffffa0097207>] intel_connector_dpms+0x37/0x70 [i915]
>  [<ffffffffa00520b0>] drm_fb_helper_dpms.isra.17+0xc0/0x110 [drm_kms_helper]
>  [<ffffffffa0052131>] drm_fb_helper_blank+0x31/0x80 [drm_kms_helper]
>  [<ffffffff812a6f51>] fb_blank+0x51/0xc0
>  [<ffffffff812b5c3b>] fbcon_blank+0x22b/0x2e0
>  [<ffffffff81526d95>] ? _raw_spin_unlock_irqrestore+0x65/0x80
>  [<ffffffff8109a475>] ? trace_hardirqs_on_caller+0x105/0x1d0
>  [<ffffffff8109a54d>] ? trace_hardirqs_on+0xd/0x10
>  [<ffffffff81526d6d>] ? _raw_spin_unlock_irqrestore+0x3d/0x80
>  [<ffffffff8104b3c6>] ? try_to_del_timer_sync+0x56/0x70
>  [<ffffffff8104b48a>] ? del_timer_sync+0xaa/0xd0
>  [<ffffffff8104b3e0>] ? try_to_del_timer_sync+0x70/0x70
>  [<ffffffff81324618>] do_blank_screen+0x1d8/0x280
>  [<ffffffff813269bf>] console_callback+0x5f/0x150
>  [<ffffffff8105a7f1>] process_one_work+0x1f1/0x490
>  [<ffffffff8105a78c>] ? process_one_work+0x18c/0x490
>  [<ffffffff8105aef3>] worker_thread+0x113/0x370
>  [<ffffffff8105ade0>] ? rescuer_thread+0x310/0x310
>  [<ffffffff81062798>] kthread+0xe8/0xf0
>  [<ffffffff81094732>] ? get_lock_stats+0x22/0x70
>  [<ffffffff810626b0>] ? kthread_create_on_node+0x150/0x150
>  [<ffffffff8152d02c>] ret_from_fork+0x7c/0xb0
>  [<ffffffff810626b0>] ? kthread_create_on_node+0x150/0x150
>
> _______________________________________________
> Intel-gfx mailing list
> Intel-gfx@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/intel-gfx



--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
