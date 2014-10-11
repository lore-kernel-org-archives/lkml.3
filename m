Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaJKFUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 01:20:11 -0400
Received: from plane.gmane.org ([80.91.229.3]:38982 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaJKFUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 01:20:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?utf-8?b?U8O2cmVu?= Brinkmann <soeren.brinkmann@gmail.com>
Subject: Re: Linux 3.17
Date: Sat, 11 Oct 2014 05:14:09 +0000 (UTC)
Message-ID: <loom.20141011T071011-134@post.gmane.org>
References: <alpine.LRH.2.11.1410072337230.7472@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 108.224.137.38 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.101 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Meelis Roos <mroos <at> ut.ee> writes:
> 
> > Anyway, back to 3.17. Nothing major happened during the last week, as
> > you can see from the appended shortlog. Mostly drivers (i915, nouveau,
> > ethernet, scsi, sound) and some networking fixes.  With some misc
> > noise all over.
> > 
> > Go out and test,
> 
> Unfortunately my computer still livelocks with watchdog timeouts. The
> previous reports are here: https://lkml.org/lkml/2014/9/28/40 and
> https://lkml.org/lkml/2014/9/30/217 and this time the dmesg is like that 

Just as another data point. I think I run into the same issue on my laptop:

------------[ cut here ]------------
WARNING: CPU: 2 PID: 491 at /home/soeren/dev/linux.git/kernel/watchdog.c:267 
watchdog_overflow_callback+0x94/0xc0()
Watchdog detected hard LOCKUP on cpu 2
Modules linked in:
 ctr ccm bnep dm_crypt algif_skcipher af_alg snd_hda_codec_hdmi joydev 
iTCO_wdt iTCO_vendor_support ppdev btusb qcserial usb_wwan bluetooth 
usbserial uvcvideo xpad ff_memless videobuf2_vmalloc videobuf2_memops 
videobuf2_core v4l2_common videodev coretemp kvm_intel kvm f2fs 
ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd lrw gf128mul 
glue_helper microcode snd_hda_codec_conexant snd_hda_codec_generic arc4 
nouveau iwldvm psmouse mac80211 serio_raw mxm_wmi cfbfillrect iwlwifi 
cfbimgblt cfbcopyarea ttm i2c_algo_bit i2c_i801 cfg80211 drm_kms_helper 
intel_ips drm snd_hda_intel snd_hda_controller snd_hda_codec thinkpad_acpi 
snd_hwdep nvram snd_pcm e1000e snd_timer tpm_tis snd ptp mei_me pps_core 
parport_pc mei wmi lpc_ich parport shpchp soundcore evdev video fbcon bitblit 
softcursor
 fb fbdev font autofs4 mmc_block firewire_ohci sdhci_pci sdhci firewire_core 
crc_itu_t
CPU: 2 PID: 491 Comm: Xorg.bin Not tainted 3.17.0-dbg2-00002-g05ac16d8db78 
#66
Hardware name: LENOVO 43494JG/43494JG, BIOS 6MET92WW (1.52 ) 09/26/2012
 0000000000000000 000000006a190ef8 ffff88023bd06c18 ffffffff886b89ea
 ffff88023bd06c60 ffff88023bd06c50 ffffffff8804a043 ffff8800a0b87000
 0000000000000000 ffff88023bd06d88 0000000000000000 ffff88023bd06ef8
Call Trace:
 <NMI>  [<ffffffff886b89ea>] dump_stack+0x4d/0x66
 [<ffffffff8804a043>] warn_slowpath_common+0x73/0x90
 [<ffffffff8804a0b7>] warn_slowpath_fmt+0x57/0x70
 [<ffffffff880dc814>] watchdog_overflow_callback+0x94/0xc0
 [<ffffffff880efc9c>] __perf_event_overflow+0x9c/0x320
 [<ffffffff880ee823>] ? perf_event_update_userpage+0x103/0x180
 [<ffffffff880ee720>] ? perf_event_task_disable+0xa0/0xa0
 [<ffffffff880f0694>] perf_event_overflow+0x14/0x20
 [<ffffffff8801bbd6>] intel_pmu_handle_irq+0x1f6/0x3f0
 [<ffffffff880154ab>] perf_event_nmi_handler+0x2b/0x50
 [<ffffffff88007a33>] nmi_handle+0xa3/0x130
 [<ffffffff88007990>] ? unregister_nmi_handler+0x110/0x110
 [<ffffffff88007bb3>] do_nmi+0xf3/0x380
 [<ffffffff886c2b2a>] end_repeat_nmi+0x1e/0x2e
 [<ffffffff880a2090>] ? lock_hrtimer_base.isra.31+0x20/0x50
 [<ffffffff8808774d>] ? __lock_acquire+0x26d/0x1b30
 [<ffffffff8808774d>] ? __lock_acquire+0x26d/0x1b30
 [<ffffffff8808774d>] ? __lock_acquire+0x26d/0x1b30
 <<EOE>>  <IRQ>  [<ffffffff880897cf>] lock_acquire+0x5f/0x80
 [<ffffffff880a2090>] ? lock_hrtimer_base.isra.31+0x20/0x50
 [<ffffffff886c04ff>] _raw_spin_lock_irqsave+0x3f/0x60
 [<ffffffff880a2090>] ? lock_hrtimer_base.isra.31+0x20/0x50
 [<ffffffff880a2090>] lock_hrtimer_base.isra.31+0x20/0x50
 [<ffffffff880a2630>] hrtimer_try_to_cancel+0x30/0xa0
 [<ffffffff880a26ba>] hrtimer_cancel+0x1a/0x30
 [<ffffffff880b17f2>] tick_nohz_restart+0x12/0x80
 [<ffffffff880b1fd4>] __tick_nohz_full_check+0xa4/0xb0
 [<ffffffff880b1fe9>] nohz_full_kick_work_func+0x9/0x10
 [<ffffffff880e56a4>] irq_work_run_list+0x44/0x70
 [<ffffffff880b1780>] ? tick_sched_do_timer+0x60/0x60
 [<ffffffff880e56e9>] irq_work_run+0x19/0x40
 [<ffffffff880a1ba6>] update_process_times+0x56/0x70
 [<ffffffff880b1520>] tick_sched_handle.isra.22+0x20/0x60
 [<ffffffff880b17b9>] tick_sched_timer+0x39/0x60
 [<ffffffff880a2571>] __run_hrtimer.isra.34+0x41/0xd0
 [<ffffffff880a293f>] hrtimer_interrupt+0xef/0x250
 [<ffffffff8802c675>] local_apic_timer_interrupt+0x35/0x60
 [<ffffffff8802cc8a>] smp_apic_timer_interrupt+0x3a/0x50
 [<ffffffff886c1f4f>] apic_timer_interrupt+0x6f/0x80
 <EOI>  [<ffffffff886c1cc9>] ? retint_swapgs+0xe/0x13
---[ end trace 7fcac8511d685a7b ]---
INFO: rcu_sched detected stalls on CPUs/tasks: { 2} (detected by 0, t=15002 
jiffies, g=834495, c=834494, q=0)
Task dump for CPU 2:
Xorg.bin        R  running task        0   491    476 0x0008000c
 ffff8800b9a8b6a0 ffffffff8808719d ffff8800b9a8b780 0000000000000246
 ffff88023bff6108 0000000000000001 0000000000000000 ffff88023bff6100
 ffff88022c450000 0000000000000002 0000000000000000 0000000000000002
Call Trace:
 [<ffffffff8808719d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff880ffc6d>] ? __alloc_pages_nodemask+0x1fd/0xc60
 [<ffffffff880fd90f>] ? free_pages_prepare+0x1af/0x1d0
 [<ffffffff880870ed>] ? trace_hardirqs_on_caller+0x15d/0x200
 [<ffffffff880fe59e>] ? free_hot_cold_page+0x13e/0x1f0
 [<ffffffff8808787c>] ? __lock_acquire+0x39c/0x1b30
 [<ffffffff881471fd>] ? __slab_free.isra.69+0x7d/0x2c0
 [<ffffffff881471fd>] ? __slab_free.isra.69+0x7d/0x2c0
 [<ffffffff88086f65>] ? mark_held_locks+0x75/0xa0
 [<ffffffff886bd675>] ? __mutex_unlock_slowpath+0xa5/0x170
 [<ffffffff880870ed>] ? trace_hardirqs_on_caller+0x15d/0x200
 [<ffffffff8808719d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff886bd749>] ? mutex_unlock+0x9/0x10
 [<ffffffff8865f081>] ? unix_stream_recvmsg+0x3d1/0x910
 [<ffffffff885a96e5>] ? sock_recvmsg+0xa5/0xe0
 [<ffffffff8808787c>] ? __lock_acquire+0x39c/0x1b30
 [<ffffffff880846ed>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff880e0806>] ? __acct_update_integrals+0x86/0x120
 [<ffffffff880e0cf7>] ? acct_account_cputime+0x17/0x20
 [<ffffffff880f498e>] ? context_tracking_user_enter+0x6e/0xd0
 [<ffffffff886c1cc9>] ? retint_swapgs+0xe/0x13
 [<ffffffff880870ed>] ? trace_hardirqs_on_caller+0x15d/0x200
 [<ffffffff88386a9b>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff886c1cc9>] ? retint_swapgs+0xe/0x13
NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s! [AudioThread:874]
Modules linked in: ctr ccm bnep dm_crypt algif_skcipher af_alg 
snd_hda_codec_hdmi joydev iTCO_wdt iTCO_vendor_support ppdev btusb qcserial 
usb_wwan bluetooth usbserial uvcvideo xpad ff_memless videobuf2_vmalloc 
videobuf2_memops videobuf2_core v4l2_common videodev coretemp kvm_intel kvm 
f2fs ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper cryptd lrw 
gf128mul glue_helper microcode snd_hda_codec_conexant snd_hda_codec_generic 
arc4 nouveau iwldvm psmouse mac80211 serio_raw mxm_wmi cfbfillrect iwlwifi 
cfbimgblt cfbcopyarea ttm i2c_algo_bit i2c_i801 cfg80211 drm_kms_helper 
intel_ips drm snd_hda_intel snd_hda_controller snd_hda_codec thinkpad_acpi 
snd_hwdep nvram snd_pcm e1000e snd_timer tpm_tis snd ptp mei_me pps_core 
parport_pc mei wmi lpc_ich parport shpchp soundcore evdev video fbcon
 bitblit softcursor fb fbdev font autofs4 mmc_block firewire_ohci sdhci_pci 
sdhci firewire_core crc_itu_t
irq event stamp: 23403750
hardirqs last  enabled at (23403749): [<ffffffff886c1cdc>] 
restore_args+0x0/0x30
hardirqs last disabled at (23403750): [<ffffffff886c1f4a>] 
apic_timer_interrupt+0x6a/0x80
softirqs last  enabled at (23403748): [<ffffffff8804df3a>] 
__do_softirq+0x22a/0x2d0
softirqs last disabled at (23403743): [<ffffffff8804e20d>] 
irq_exit+0x10d/0x120
CPU: 0 PID: 874 Comm: AudioThread Tainted: G        W      3.17.0-dbg2-00002-
g05ac16d8db78 #66
Hardware name: LENOVO 43494JG/43494JG, BIOS 6MET92WW (1.52 ) 09/26/2012
task: ffff88021b28a260 ti: ffff88021450c000 task.ti: ffff88021450c000
RIP: 0010:[<ffffffff880b6c32>]  [<ffffffff880b6c32>] 
smp_call_function_many+0x252/0x270
RSP: 0018:ffff88021450fd18  EFLAGS: 00000202
RAX: ffff88023bd15f38 RBX: ffffffff886c1cdc RCX: 0000000000000002
RDX: ffff88023bd15f38 RSI: 0000000000000008 RDI: 0000000000000000
RBP: ffff88021450fd50 R08: ffff88023bc13708 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff88021450fc88
R13: 0000000000000000 R14: ffff88021450c000 R15: ffff88021b28a260
FS:  00007f68e4258700(0000) GS:ffff88023bc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f68d15b5db8 CR3: 000000021aad6000 CR4: 00000000000007f0
Stack:
 000000011450fde8 ffffffff8857c790 00000000ffffffff 0000000000000000
 0000000077359400 0000000000000000 0000000000000000 ffff88021450fd60
 ffffffff880b6c75 ffff88021450fd70 ffffffff8857c897 ffff88021450fda8
Call Trace:
 [<ffffffff8857c790>] ? acpi_cpufreq_cpu_init+0x5b0/0x5b0
 [<ffffffff880b6c75>] smp_call_function+0x25/0x40
 [<ffffffff8857c897>] cpuidle_latency_notify+0x17/0x20
 [<ffffffff8806879d>] notifier_call_chain+0x4d/0x70
 [<ffffffff88068a48>] __blocking_notifier_call_chain+0x48/0x70
 [<ffffffff88068a81>] blocking_notifier_call_chain+0x11/0x20
 [<ffffffff8808d324>] pm_qos_update_target+0xc4/0x1b0
 [<ffffffff8808d6ee>] pm_qos_remove_request+0x3e/0x70
 [<ffffffffc05569a8>] snd_pcm_release_substream.part.29+0x88/0x90 [snd_pcm]
 [<ffffffffc0556a88>] snd_pcm_release+0xa8/0xb0 [snd_pcm]
 [<ffffffff88161ffa>] __fput+0xea/0x200
 [<ffffffff88162149>] ____fput+0x9/0x10
 [<ffffffff88065f04>] task_work_run+0xa4/0xd0
 [<ffffffff88003b12>] do_notify_resume+0x82/0xa0
 [<ffffffff886c13da>] int_signal+0x12/0x17
Code: bf 00 89 c1 0f 8d 38 fe ff ff 48 98 48 8b 13 48 03 14 c5 c0 45 cb 88 f6 
42 18 01 48 89 d0 74 c9 66 0f 1f 84 00 00 00 00 00 f3 90 <f6> 40 18 01 75 f8 
eb b6 48 8b 15 a7 a9 75 00 4c 89 e6 89 c7 e8


        Thanks,
        Sören

