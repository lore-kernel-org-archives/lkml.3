Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab3EUWDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 18:03:11 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49070 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab3EUWDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 18:03:07 -0400
Message-ID: <519BEF18.3070706@candelatech.com>
Date: Tue, 21 May 2013 15:03:04 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: soft lockup in 3.9.3 (with local patches)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We see this on a system we just upgraded to 3.9.3+.  It did not show problems on
3.9.2, but could have just been luck.  Also, this kernel has a fair bit of
patches applied to it, so problem could be mine.

But, just in case this looks familiar to someone, please let me know...

Thanks,
Ben


BUG: soft lockup - CPU#0 stuck for 22s! [migration/0:8]
Modules linked in: iptable_mangle iptable_nat nf_nat_ipv4 nf_nat 8021q mrp garp stp llc macvlan wanlink(O) pktgen fuse sunrpc ipv6 uinput ath9k mac80211 
coretemp snd_hda_codec_realtek hwmon snd_hda_intel mperf snd_hda_codec ath9k_common ath9k_hw intel_powerclamp snd_hwdep snd_seq ath kvm snd_seq_device cfg80211 
snd_pcm e1000e gpio_ich iTCO_wdt snd_timer iTCO_vendor_support ppdev pcspkr snd microcode serio_raw ptp parport_pc i2c_i801 mei parport soundcore lpc_ich 
pps_core snd_page_alloc i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: iptable_raw]
CPU 0
Pid: 8, comm: migration/0 Tainted: G         C O 3.9.3+ #44 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
RIP: 0010:[<ffffffff8109d6ae>]  [<ffffffff8109d6ae>] tasklet_action+0x58/0xcc
RSP: 0018:ffff88022bc03ec8  EFLAGS: 00000282
RAX: ffff88022bc0e080 RBX: ffffffff81cd3240 RCX: ffffffff81a90f06
RDX: ffff880220f3afa8 RSI: 0000000000000000 RDI: ffffffff81a050b0
RBP: ffff88022bc03ed8 R08: 000000000000000e R09: ffffea00079333c0
R10: ffff8802181ba1c0 R11: ffff88022bc03778 R12: ffff88022bc03e38
R13: ffffffff815d135d R14: ffff88022bc03ed8 R15: ffff880220f3afb0
FS:  0000000000000000(0000) GS:ffff88022bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000042da00 CR3: 0000000001a0c000 CR4: 00000000000007f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process migration/0 (pid: 8, threadinfo ffff880222144000, task ffff88022213aee0)
Stack:
  ffffffff81a050b0 ffff880222144000 ffff88022bc03f68 ffffffff8109db1f
  ffff88022bc03f38 ffff880222144010 ffff880222145fd8 0420804000020002
  0000000100054e0d 0000000021d90300 ffff880222144000 0000000000000030
Call Trace:
  <IRQ>
  [<ffffffff8109db1f>] __do_softirq+0x107/0x23c
  [<ffffffff815c9f3d>] ? _raw_spin_unlock+0x24/0x2f
  [<ffffffff810f9801>] ? queue_stop_cpus_work+0x58/0xdc
  [<ffffffff8109dce6>] irq_exit+0x4b/0xa8
  [<ffffffff815d23dd>] do_IRQ+0x9d/0xb4
  [<ffffffff815ca4ad>] common_interrupt+0x6d/0x6d
  <EOI>
  [<ffffffff810f991c>] ? stop_machine_cpu_stop+0x67/0xd0
  [<ffffffff810f98fb>] ? stop_machine_cpu_stop+0x46/0xd0
  [<ffffffff810f98b5>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f961c>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c8f85>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d06ac>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Code: 00 00 00 65 48 03 04 25 d8 da 00 00 65 48 89 04 25 88 e0 00 00 fb 66 66 90 66 66 90 eb 77 48 8b 1a 4c 8d 62 08 f0 0f ba 6a 08 01 <19> c0 85 c0 75 2d 8b 42 
10 85 c0 75 20 f0 41 0f ba 34 24 00 19
Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
Pid: 23, comm: migration/2 Tainted: G         C O 3.9.3+ #44
Call Trace:
  <NMI>  [<ffffffff815c784e>] panic+0xc4/0x1e0
  [<ffffffff81103a72>] watchdog_overflow_callback+0x81/0xa6
  [<ffffffff8113346b>] __perf_event_overflow+0x137/0x1cb
  [<ffffffff8101db3f>] ? x86_perf_event_set_period+0x107/0x113
  [<ffffffff811339ba>] perf_event_overflow+0x14/0x16
  [<ffffffff810230dc>] intel_pmu_handle_irq+0x2b0/0x32d
  [<ffffffff815cbb51>] perf_event_nmi_handler+0x19/0x1b
  [<ffffffff815cb3ca>] nmi_handle+0x55/0x7e
  [<ffffffff810f9800>] ? queue_stop_cpus_work+0x57/0xdc
  [<ffffffff815cb49b>] do_nmi+0xa8/0x2db
  [<ffffffff815cab31>] end_repeat_nmi+0x1e/0x2e
  [<ffffffff810f9800>] ? queue_stop_cpus_work+0x57/0xdc
  [<ffffffff810f991a>] ? stop_machine_cpu_stop+0x65/0xd0
  [<ffffffff810f991a>] ? stop_machine_cpu_stop+0x65/0xd0
  [<ffffffff810f991a>] ? stop_machine_cpu_stop+0x65/0xd0
  <<EOE>>  [<ffffffff810f98b5>] ? stop_one_cpu_nowait+0x30/0x30
  [<ffffffff810f961c>] cpu_stopper_thread+0xbd/0x176
  [<ffffffff815c8f85>] ? __schedule+0x59f/0x5e7
  [<ffffffff810bb434>] smpboot_thread_fn+0x217/0x21f
  [<ffffffff810bb21d>] ? test_ti_thread_flag.clone.0+0x11/0x11
  [<ffffffff810b4a09>] kthread+0xb5/0xbd
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d06ac>] ret_from_fork+0x7c/0xb0
  [<ffffffff810b4954>] ? kthread_freezable_should_stop+0x60/0x60
Shutting down cpus with NMI
drm_kms_helper: panic occurred, switching back to text console
Rebooting in 10 seconds..
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

