Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3EGMFt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 08:05:49 -0400
Received: from mail-ph.de-nserver.de ([85.158.179.214]:56532 "EHLO
	mail-ph.de-nserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab3EGMFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 08:05:47 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2013 08:05:47 EDT
X-Fcrdns: No
X-HELO: [192.168.1.148]
Message-ID: <5188EC86.4050106@profihost.ag>
Date: Tue, 07 May 2013 13:59:02 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Avi Kivity <avi@redhat.com>, mtosatti@redhat.com,
        xiaoguangrong@linux.vnet.ibm.com, mst@redhat.com,
        alex.williamson@redhat.com,
        "p.her >> Philipp Herz - Profihost AG" <p.herz@profihost.ag>
Subject: kernel 3.8.9 call trace kvm Watchdog detected hard LOCKUP
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by hostmaster@profihost.com through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello list,

today i kvm host crashed running vanilla kernel 3.8.9.

The call trace looks like this:
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 18
Pid: 29053, comm: kvm Tainted: G O 3.8.9+16-ph #1
Call Trace:
<NMI> [<ffffffff8150a86b>] panic+0xbf/0x1df
[<ffffffff8100ae73>] ? native_sched_clock+0x13/0x80
[<ffffffff810b40c1>] watchdog_overflow_callback+0xb1/0xc0
[<ffffffff810e103c>] __perf_event_overflow+0x9c/0x220
[<ffffffff81013878>] ? x86_perf_event_set_period+0xd8/0x160
[<ffffffff810e18e4>] perf_event_overflow+0x14/0x20
[<ffffffff81019a9c>] intel_pmu_handle_irq+0x1bc/0x330
[<ffffffff8131feac>] ? ghes_read_estatus+0xac/0x170
[<ffffffff81012991>] perf_event_nmi_handler+0x21/0x30
[<ffffffff810061ca>] nmi_handle+0x5a/0x80
[<ffffffff81006333>] default_do_nmi+0x63/0x200
[<ffffffff81006560>] do_nmi+0x90/0xd0
[<ffffffff8150dff1>] end_repeat_nmi+0x1e/0x2e
[<ffffffff8150d765>] ? _raw_spin_lock+0x25/0x30
[<ffffffff8150d765>] ? _raw_spin_lock+0x25/0x30
[<ffffffff8150d765>] ? _raw_spin_lock+0x25/0x30
<<EOE>> [<ffffffffa015b22f>] kvm_guest_time_update+0x5f/0x310 [kvm]
[<ffffffffa023c03d>] ? vmx_set_cr3+0x9d/0x130 [kvm_intel]
[<ffffffffa023a7ca>] ? vmx_save_host_state+0xea/0x1a0 [kvm_intel]
[<ffffffffa015b92f>] vcpu_enter_guest+0x13f/0x770 [kvm]
[<ffffffffa015c100>] __vcpu_run+0x1a0/0x320 [kvm]
[<ffffffffa015c311>] kvm_arch_vcpu_ioctl_run+0x91/0x1f0 [kvm]
[<ffffffffa0147efe>] kvm_vcpu_ioctl+0x38e/0x550 [kvm]
[<ffffffff810987e0>] ? futex_wake+0x110/0x120
[<ffffffff81153d9b>] do_vfs_ioctl+0x7b/0x380
[<ffffffff8109a6c6>] ? sys_futex+0x76/0x170
[<ffffffff811540f2>] sys_ioctl+0x52/0x80
[<ffffffff810603b1>] ? do_sigpending+0xa1/0xc0
[<ffffffff8150e229>] system_call_fastpath+0x16/0x1b

Shutting down cpus with NMI

Has anybody seen this and know a fix?

Thanks!
Stefan
