Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab3JIMdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 08:33:54 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36706 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245Ab3JIMdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 08:33:52 -0400
MIME-Version: 1.0
Date: Wed, 9 Oct 2013 18:03:51 +0530
Message-ID: <CAOaxAcbeCQ4aXW49bkb0Z7StjAxo_HOxyJ0rC4KJyHr7+D7K9w@mail.gmail.com>
Subject: Arbitrary host crash with kvm.git queue (8a3c1a33476f6bfebd07954e2277dbc88003bd37)
From: Kashyap Chamarthy <kashyap.cv@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heya,

I've seen this crash thrice so far on an Intel Haswell machine while
doing some nested virtualization tests (KVM on KVM). At this moment, I can't
pin-point an to exact trigger. On two occasions, it crashed when I tried to
reboot a guest hypervisor (as part of nested virtualization testing). Thought
I'll post the trace here, just in case someone wants to take a look.


Kernel info:
------------

I compiled & installed the Kernel from kvm.git queue.

    $ git branch -d test_nept1 origin/queue
    $ git describe
    for-linus-12017-g8a3c1a33
    $ git log | head -1
    commit 8a3c1a33476f6bfebd07954e2277dbc88003bd37


Crash: (found via conserver, serial console)
--------------------------------------------
[177558.023358] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:2:6155]
[177558.030845] Modules linked in: vhost_net vhost macvtap macvlan
kvm_intel kvm ebtable_nat xt_CHECKSUM tun nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6
ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables
ip6table_filter ip6_tables bridge stp llc snd_hda_codec_realtek
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_page_alloc iwlwifi snd_timer snd cfg80211
e1000e iTCO_wdt iTCO_vendor_support mei_me lpc_ich mfd_core soundcore
ptp mei pps_core serio_raw pcspkr rfkill i2c_i801 binfmt_misc i915
i2c_algo_bit drm_kms_helper drm i2c_core video
[177558.107179] CPU: 0 PID: 6155 Comm: kworker/0:2 Tainted: G      D W
   3.12.0-rc2+ #7
[177558.116045] Hardware name: Intel Corporation Shark Bay Client
platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0131.R03.1307262359
07/26/2013
[177558.130323] Workqueue: events jump_label_update_timeout
[177558.136344] task: ffff8804379d5dc0 ti: ffff88007c8a8000 task.ti:
ffff88007c8a8000
[177558.144913] RIP: 0010:[<ffffffff810cdf5e>]  [<ffffffff810cdf5e>]
smp_call_function_many+0x25e/0x2c0
[177558.155263] RSP: 0018:ffff88007c8a9c68  EFLAGS: 00000202
[177558.161374] RAX: 0000000000000003 RBX: 0000000000000000 RCX:
ffff88044e2d73e8
[177558.169550] RDX: 0000000000000003 RSI: 0000000000000080 RDI:
0000000000000000
[177558.177726] RBP: ffff88007c8a9cc8 R08: ffff88044e214c88 R09:
0000000000000002
[177558.185902] R10: ffff88044e214c88 R11: 0000000000001f17 R12:
000000000000dd50
[177558.194077] R13: 000000fc00000000 R14: 0000000000000286 R15:
0000000000000286
[177558.202254] FS:  0000000000000000(0000) GS:ffff88044e200000(0000)
knlGS:0000000000000000
[177558.211514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[177558.218115] CR2: 00007fd4757f6000 CR3: 0000000001c0c000 CR4:
00000000001427e0
[177558.226291] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[177558.234467] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[177558.242642] Stack:
[177558.245012]  ffff88044e214c98 0000000181050e73 0000000000014c40
0000000000000000
[177558.253524]  ffffffff81018be0 ffff88044e2d4c40 0000000000000202
ffffffffa040e705
[177558.262032]  ffffffff81018be0 0000000000000000 ffffffffa040e706
ffffffffa042d560
[177558.270542] Call Trace:
[177558.273406]  [<ffffffff81018be0>] ? setup_data_read+0x90/0x90
[177558.280014]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177558.287895]  [<ffffffff81018be0>] ? setup_data_read+0x90/0x90
[177558.294501]  [<ffffffffa040e706>] ? apic_has_pending_timer+0x16/0x90 [kvm]
[177558.302384]  [<ffffffff810ce0fd>] on_each_cpu+0x2d/0x60
[177558.308398]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177558.316280]  [<ffffffff8101938b>] text_poke_bp+0x5b/0xc0
[177558.322393]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177558.330274]  [<ffffffff81016912>] __jump_label_transform.isra.0+0x112/0x140
[177558.338255]  [<ffffffff81016977>] arch_jump_label_transform+0x37/0x50
[177558.345646]  [<ffffffff8113c2bf>] __jump_label_update+0x5f/0x80
[177558.352446]  [<ffffffff8113c37d>] jump_label_update+0x9d/0xb0
[177558.359049]  [<ffffffff8113c58d>] __static_key_slow_dec+0x4d/0xb0
[177558.366044]  [<ffffffff8113c646>] jump_label_update_timeout+0x16/0x20
[177558.373436]  [<ffffffff81082185>] process_one_work+0x175/0x430
[177558.380137]  [<ffffffff81082dab>] worker_thread+0x11b/0x3a0
[177558.386544]  [<ffffffff81082c90>] ? rescuer_thread+0x340/0x340
[177558.393245]  [<ffffffff810897a0>] kthread+0xc0/0xd0
[177558.398866]  [<ffffffff810896e0>] ? insert_kthread_work+0x40/0x40
[177558.405862]  [<ffffffff816662bc>] ret_from_fork+0x7c/0xb0
[177558.412070]  [<ffffffff810896e0>] ? insert_kthread_work+0x40/0x40
[177558.419066] Code: 3b 05 af 44 c2 00 89 c2 0f 8d 35 fe ff ff 48 98
49 8b 4d 00 48 03 0c c5 e0 fb ce 81 f6 41 20 01 74 cb 0f 1f 00 f3 90
f6 41 20 01 <75> f8 eb be 0f b6 4d ac 48 8b 55 b8 44 89 ef 48 8b 75 c0
e8 fa
[177586.007771] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/0:2:6155]
[177586.015259] Modules linked in: vhost_net vhost macvtap macvlan
kvm_intel kvm ebtable_nat xt_CHECKSUM tun nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6
ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables
ip6table_filter ip6_tables bridge stp llc snd_hda_codec_realtek
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_page_alloc iwlwifi snd_timer snd cfg80211
e1000e iTCO_wdt iTCO_vendor_support mei_me lpc_ich mfd_core soundcore
ptp mei pps_core serio_raw pcspkr rfkill i2c_i801 binfmt_misc i915
i2c_algo_bit drm_kms_helper drm i2c_core video
[177586.091590] CPU: 0 PID: 6155 Comm: kworker/0:2 Tainted: G      D W
   3.12.0-rc2+ #7
[177586.100456] Hardware name: Intel Corporation Shark Bay Client
platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0131.R03.1307262359
07/26/2013
[177586.114733] Workqueue: events jump_label_update_timeout
[177586.120755] task: ffff8804379d5dc0 ti: ffff88007c8a8000 task.ti:
ffff88007c8a8000
[177586.129325] RIP: 0010:[<ffffffff810cdf5e>]  [<ffffffff810cdf5e>]
smp_call_function_many+0x25e/0x2c0
[177586.139678] RSP: 0018:ffff88007c8a9c68  EFLAGS: 00000202
[177586.145789] RAX: 0000000000000003 RBX: 0000000000000000 RCX:
ffff88044e2d73e8
[177586.153965] RDX: 0000000000000003 RSI: 0000000000000080 RDI:
0000000000000000
[177586.162140] RBP: ffff88007c8a9cc8 R08: ffff88044e214c88 R09:
0000000000000002
[177586.170317] R10: ffff88044e214c88 R11: 0000000000001f17 R12:
000000000000dd50
[177586.178492] R13: 000000fc00000000 R14: 0000000000000286 R15:
0000000000000286
[177586.186669] FS:  0000000000000000(0000) GS:ffff88044e200000(0000)
knlGS:0000000000000000
[177586.195926] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[177586.202527] CR2: 00007fd4757f6000 CR3: 0000000001c0c000 CR4:
00000000001427e0
[177586.210703] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[177586.218879] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[177586.227054] Stack:
[177586.229425]  ffff88044e214c98 0000000181050e73 0000000000014c40
0000000000000000
[177586.237932]  ffffffff81018be0 ffff88044e2d4c40 0000000000000202
ffffffffa040e705
[177586.246440]  ffffffff81018be0 0000000000000000 ffffffffa040e706
ffffffffa042d560
[177586.254950] Call Trace:
[177586.257813]  [<ffffffff81018be0>] ? setup_data_read+0x90/0x90
[177586.264420]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177586.272301]  [<ffffffff81018be0>] ? setup_data_read+0x90/0x90
[177586.278909]  [<ffffffffa040e706>] ? apic_has_pending_timer+0x16/0x90 [kvm]
[177586.286790]  [<ffffffff810ce0fd>] on_each_cpu+0x2d/0x60
[177586.292804]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177586.300686]  [<ffffffff8101938b>] text_poke_bp+0x5b/0xc0
[177586.306800]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177586.314682]  [<ffffffff81016912>] __jump_label_transform.isra.0+0x112/0x140
[177586.322661]  [<ffffffff81016977>] arch_jump_label_transform+0x37/0x50
[177586.330052]  [<ffffffff8113c2bf>] __jump_label_update+0x5f/0x80
[177586.336852]  [<ffffffff8113c37d>] jump_label_update+0x9d/0xb0
[177586.343454]  [<ffffffff8113c58d>] __static_key_slow_dec+0x4d/0xb0
[177586.350450]  [<ffffffff8113c646>] jump_label_update_timeout+0x16/0x20
[177586.357839]  [<ffffffff81082185>] process_one_work+0x175/0x430
[177586.364540]  [<ffffffff81082dab>] worker_thread+0x11b/0x3a0
[177586.370947]  [<ffffffff81082c90>] ? rescuer_thread+0x340/0x340
[177586.377649]  [<ffffffff810897a0>] kthread+0xc0/0xd0
[177586.383269]  [<ffffffff810896e0>] ? insert_kthread_work+0x40/0x40
[177586.390265]  [<ffffffff816662bc>] ret_from_fork+0x7c/0xb0
[177586.396475]  [<ffffffff810896e0>] ? insert_kthread_work+0x40/0x40
[177586.403469] Code: 3b 05 af 44 c2 00 89 c2 0f 8d 35 fe ff ff 48 98
49 8b 4d 00 48 03 0c c5 e0 fb ce 81 f6 41 20 01 74 cb 0f 1f 00 f3 90
f6 41 20 01 <75> f8 eb be 0f b6 4d ac 48 8b 55 b8 44 89 ef 48 8b 75 c0
e8 fa
[177611.874722] ------------[ cut here ]------------
[177611.880048] WARNING: CPU: 0 PID: 6155 at kernel/watchdog.c:245
watchdog_overflow_callback+0x9c/0xd0()
[177611.890586] Watchdog detected hard LOCKUP on cpu 0
[177611.895909] Modules linked in: vhost_net vhost macvtap macvlan
kvm_intel kvm ebtable_nat xt_CHECKSUM tun nf_conntrack_netbios_ns
nf_conntrack_broadcast ipt_MASQUERADE ip6table_nat nf_nat_ipv6
ip6table_mangle ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6
iptable_nat nf_nat_ipv4 nf_nat iptable_mangle nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables
ip6table_filter ip6_tables bridge stp llc snd_hda_codec_realtek
snd_hda_codec_hdmi snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device snd_pcm snd_page_alloc iwlwifi snd_timer snd cfg80211
e1000e iTCO_wdt iTCO_vendor_support mei_me lpc_ich mfd_core soundcore
ptp mei pps_core serio_raw pcspkr rfkill i2c_i801 binfmt_misc i915
i2c_algo_bit drm_kms_helper drm i2c_core video
[177611.972448] CPU: 0 PID: 6155 Comm: kworker/0:2 Tainted: G      D W
   3.12.0-rc2+ #7
[177611.981312] Hardware name: Intel Corporation Shark Bay Client
platform/Flathead Creek Crb, BIOS HSWLPTU1.86C.0131.R03.1307262359
07/26/2013
[177611.995589] Workqueue: events jump_label_update_timeout
[177612.001609]  0000000000000009 ffff88044e206c28 ffffffff816573b5
ffff88044e206c70
[177612.010120]  ffff88044e206c60 ffffffff810680ad ffff88043d822000
0000000000000000
[177612.018622]  ffff88044e206d90 0000000000000000 ffff88044e206ef8
ffff88044e206cc0
[177612.027134] Call Trace:
[177612.029997]  <NMI>  [<ffffffff816573b5>] dump_stack+0x45/0x56
[177612.036620]  [<ffffffff810680ad>] warn_slowpath_common+0x7d/0xa0
[177612.043519]  [<ffffffff8106811c>] warn_slowpath_fmt+0x4c/0x50
[177612.050122]  [<ffffffff81016b6b>] ? arch_irq_work_raise+0x3b/0x40
[177612.057117]  [<ffffffff810fc660>] ?
watchdog_enable_all_cpus.part.2+0x40/0x40
[177612.065292]  [<ffffffff810fc6fc>] watchdog_overflow_callback+0x9c/0xd0
[177612.072781]  [<ffffffff8113470e>] __perf_event_overflow+0x8e/0x220
[177612.079875]  [<ffffffff81135284>] perf_event_overflow+0x14/0x20
[177612.086676]  [<ffffffff8102de2d>] intel_pmu_handle_irq+0x1bd/0x3c0
[177612.093772]  [<ffffffff8165f9db>] perf_event_nmi_handler+0x2b/0x50
[177612.100866]  [<ffffffff8165f228>] nmi_handle.isra.3+0x88/0x180
[177612.107567]  [<ffffffff8165f3f0>] do_nmi+0xd0/0x310
[177612.113186]  [<ffffffff8165e841>] end_repeat_nmi+0x1e/0x2e
[177612.119494]  [<ffffffff81548cb7>] ? kfree_skbmem+0x37/0x90
[177612.125801]  [<ffffffff810bfa10>] ? __getnstimeofday+0x80/0xc0
[177612.132502]  [<ffffffff810bfa10>] ? __getnstimeofday+0x80/0xc0
[177612.139204]  [<ffffffff810bfa10>] ? __getnstimeofday+0x80/0xc0
[177612.145903]  <<EOE>>  <IRQ>  [<ffffffff810bfa5e>] getnstimeofday+0xe/0x30
[177612.153713]  [<ffffffff810bfae6>] ktime_get_real+0x16/0x50
[177612.160022]  [<ffffffff81559e86>] netif_receive_skb+0x56/0xb0
[177612.166623]  [<ffffffff8155a840>] napi_gro_receive+0x80/0xb0
[177612.173134]  [<ffffffffa019d75f>] e1000_receive_skb+0x7f/0xe0 [e1000e]
[177612.180625]  [<ffffffffa019ecfa>] e1000_clean_rx_irq+0x24a/0x400 [e1000e]
[177612.188413]  [<ffffffffa01a688d>] e1000e_poll+0x6d/0x310 [e1000e]
[177612.195412]  [<ffffffff8155a1d9>] net_rx_action+0x149/0x240
[177612.201818]  [<ffffffff8106d3f7>] __do_softirq+0xf7/0x240
[177612.208029]  [<ffffffff8106d6d5>] irq_exit+0xb5/0xc0
[177612.213748]  [<ffffffff81668516>] do_IRQ+0x56/0xc0
[177612.219268]  [<ffffffff8165e1ed>] common_interrupt+0x6d/0x6d
[177612.225773]  <EOI>  [<ffffffff810cdf5e>] ?
smp_call_function_many+0x25e/0x2c0
[177612.233965]  [<ffffffff810cdf33>] ? smp_call_function_many+0x233/0x2c0
[177612.241453]  [<ffffffff81018be0>] ? setup_data_read+0x90/0x90
[177612.248060]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177612.255942]  [<ffffffff81018be0>] ? setup_data_read+0x90/0x90
[177612.262547]  [<ffffffffa040e706>] ? apic_has_pending_timer+0x16/0x90 [kvm]
[177612.270428]  [<ffffffff810ce0fd>] on_each_cpu+0x2d/0x60
[177612.276444]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177612.284326]  [<ffffffff8101938b>] text_poke_bp+0x5b/0xc0
[177612.290438]  [<ffffffffa040e705>] ? apic_has_pending_timer+0x15/0x90 [kvm]
[177612.298319]  [<ffffffff81016912>] __jump_label_transform.isra.0+0x112/0x140
[177612.306300]  [<ffffffff81016977>] arch_jump_label_transform+0x37/0x50
[177612.313691]  [<ffffffff8113c2bf>] __jump_label_update+0x5f/0x80
[177612.320491]  [<ffffffff8113c37d>] jump_label_update+0x9d/0xb0
[177612.327095]  [<ffffffff8113c58d>] __static_key_slow_dec+0x4d/0xb0
[177612.334090]  [<ffffffff8113c646>] jump_label_update_timeout+0x16/0x20
[177612.341480]  [<ffffffff81082185>] process_one_work+0x175/0x430
[177612.348181]  [<ffffffff81082dab>] worker_thread+0x11b/0x3a0
[177612.354587]  [<ffffffff81082c90>] ? rescuer_thread+0x340/0x340
[177612.361288]  [<ffffffff810897a0>] kthread+0xc0/0xd0
[177612.366908]  [<ffffffff810896e0>] ? insert_kthread_work+0x40/0x40
[177612.373903]  [<ffffffff816662bc>] ret_from_fork+0x7c/0xb0
[177612.380114]  [<ffffffff810896e0>] ? insert_kthread_work+0x40/0x40
[177612.387108] ---[ end trace a7ec0517b6c78b3a ]---
[177612.392434] INFO: NMI handler (perf_event_nmi_handler) took too
long to run: 517.710 msecs



KVM parameters:
---------------
    $ cat /sys/module/kvm_intel/parameters/nested
    Y
    $ cat /sys/module/kvm_intel/parameters/enable_shadow_vmcs
    Y
    $ cat /sys/module/kvm_intel/parameters/ept
    Y


Processor Info:
---------------

$ cat /proc/cpuinfo
processor   : 0
vendor_id   : GenuineIntel
cpu family  : 6
model       : 60
model name  : Intel(R) Core(TM) i5-4670T CPU @ 2.30GHz
stepping    : 3
microcode   : 0x12
cpu MHz     : 2300.000
cache size  : 6144 KB
physical id : 0
siblings    : 4
core id     : 0
cpu cores   : 4
apicid      : 0
initial apicid  : 0
fpu         : yes
fpu_exception   : yes
cpuid level : 13
wp          : yes
flags       : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall
nx p
dpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl
xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor
ds_cpl vmx sm
x est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe
popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida
arat epb xsaveo
pt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips    : 4589.67
clflush size: 64
cache_alignment : 64
address sizes   : 39 bits physical, 48 bits virtual
power management:
[...]

/kashyap
