Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705Ab3IHCRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 22:17:31 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:48183 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3IHCRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 22:17:30 -0400
MIME-Version: 1.0
In-Reply-To: <20130903132933.GA24955@gmail.com>
References: <20130903132933.GA24955@gmail.com>
Date: Sat, 7 Sep 2013 19:17:28 -0700
X-Google-Sender-Auth: KqlZchGQUEo-fI-fXHY8edjb8vw
Message-ID: <CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.12
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is new for me, but I suspect it is more related to the new
Haswell CPU I have than necessarily the 3.12 perf pull request.

Regardless, nothing bad happened, but my dmesg has this in it:

   Unexpected number of pebs records 10

when I was profiling some git workloads. Full trace appended.

                Linus

---
 perf samples too long (2749 > 2500), lowering
kernel.perf_event_max_sample_rate to 50000
 perf samples too long (5200 > 5000), lowering
kernel.perf_event_max_sample_rate to 25000
 .. many seconds pass ..
 ------------[ cut here ]------------
 WARNING: CPU: 1 PID: 3270 at
arch/x86/kernel/cpu/perf_event_intel_ds.c:1003
intel_pmu_drain_pebs_hsw+0x91/0xa0()
 Unexpected number of pebs records 10
 Modules linked in: fuse ip6t_REJECT nf_conntrack_ipv4
nf_conntrack_ipv6 nf_defrag_ipv4 nf_defrag_ipv6 xt_conntrack
ip6table_filter nf_conntrack ip6_tables snd_hda_codec_realtek
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm e1000e serio_raw snd_page_alloc snd_timer ptp
lpc_ich snd i2c_i801 pps_core mfd_core soundcore uinput nfsd
auth_rpcgss nfs_acl lockd sunrpc binfmt_misc hid_logitech_dj i915
i2c_algo_bit drm_kms_helper drm i2c_core video
 CPU: 1 PID: 3270 Comm: git Not tainted 3.11.0-07749-ge7d33bb5ea82-dirty #4
 Hardware name:                  /DH87RL, BIOS
RLH8710H.86A.0317.2013.0426.1724 04/26/2013
  0000000000000009 ffff88041fa46ca0 ffffffff815fc637 ffff88041fa46ce8
  ffff88041fa46cd8 ffffffff81051e78 ffff88040f42f000 ffff88040f42f780
  ffff88041fa46ef8 ffffffff81c15860 0000000000000002 ffff88041fa46d38
 Call Trace:
  <NMI>  [<ffffffff815fc637>] dump_stack+0x45/0x56
  [<ffffffff81051e78>] warn_slowpath_common+0x78/0xa0
  [<ffffffff81051ee7>] warn_slowpath_fmt+0x47/0x50
  [<ffffffff8101b051>] intel_pmu_drain_pebs_hsw+0x91/0xa0
  [<ffffffff8101c5d0>] intel_pmu_handle_irq+0x210/0x390
  [<ffffffff81604deb>] perf_event_nmi_handler+0x2b/0x50
  [<ffffffff81604670>] nmi_handle.isra.3+0x80/0x180
  [<ffffffff81604840>] do_nmi+0xd0/0x310
  [<ffffffff81603d37>] end_repeat_nmi+0x1e/0x2e
  <<EOE>>  [<ffffffff810167df>] perf_events_lapic_init+0x2f/0x40
  [<ffffffff81016a50>] x86_pmu_enable+0x260/0x310
  [<ffffffff81111d87>] perf_pmu_enable+0x27/0x30
  [<ffffffff81112140>] perf_event_context_sched_in+0x80/0xc0
  [<ffffffff811127eb>] __perf_event_task_sched_in+0x16b/0x180
  [<ffffffff8107c300>] finish_task_switch+0x70/0xa0
  [<ffffffff81600f48>] __schedule+0x368/0x7c0
  [<ffffffff816013c4>] schedule+0x24/0x70
  [<ffffffff816038a4>] retint_careful+0xd/0x21
 ---[ end trace 52dad7a9d8d96b5f ]---
