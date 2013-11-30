Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab3K3IC2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 03:02:28 -0500
Received: from smtp3.Stanford.EDU ([171.67.219.83]:49696 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750955Ab3K3ICY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 03:02:24 -0500
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Nov 2013 03:02:24 EST
Message-ID: <52999A44.7060103@localhost>
Date: Fri, 29 Nov 2013 23:56:52 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-rt-users <linux-rt-users@vger.kernel.org>
CC: nando@ccrma.Stanford.EDU, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: 3.10.20-rt17, BUG and Oops
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Just got this on 3.10.20-rt17, ThinkPad T510 running Fedora 19 (I think 
it has happened a few times before). The machine is not completely dead, 
the mouse pointer moves around but otherwise display updates and 
keyboard response are nil.

-- Fernando


--------
Nov 29 23:17:52 localhost kernel: [50532.638944] BUG: unable to handle 
kernel NULL pointer dereference at 00000000000002c7
Nov 29 23:17:52 localhost kernel: [50532.638951] IP: 
[<ffffffff81361e9a>] advance_transaction+0x60/0x121
Nov 29 23:17:52 localhost kernel: [50532.638953] PGD 1db141067 PUD 
228703067 PMD 0
Nov 29 23:17:52 localhost kernel: [50532.638955] Oops: 0000 [#1] PREEMPT 
SMP
Nov 29 23:17:52 localhost kernel: [50532.638983] Modules linked in: 
snd_hrtimer snd_seq_midi snd_seq_midi_event snd_seq_dummy snd_hdsp 
snd_rawmidi fuse xt_CHECKSUM tun nf_conntrack_netbios_ns 
nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack 
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables 
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 
ip6table_mangle ip6table_security ip6table_raw ip6table_filter 
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_mangle iptable_security rfcomm iptable_raw 
bnep iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi acpi_cpufreq mperf 
coretemp kvm_intel kvm crc32_pclmul uvcvideo crc32c_intel 
ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core 
microcode videodev media serio_raw snd_hda_codec_conexant intel_ips 
btusb i2c_i801 bluetooth arc4 iwldvm mac80211 snd_hda_intel 
snd_hda_codec iwlwifi snd_hwdep sdhci_pci snd_seq sdhci snd_seq_device 
cfg80211 mmc_core snd_pcm lpc_ich mfd_core e1000e snd_page_alloc ptp 
mei_me snd_timer pps_core mei thinkpad_acpi snd soundcore rfkill shpchp 
uinput nouveau i2c_algo_bit firewire_ohci drm_kms_helper firewire_core 
crc_itu_t ttm drm i2c_core mxm_wmi video wmi
Nov 29 23:17:52 localhost kernel: [50532.639006] CPU: 0 PID: 45 Comm: 
irq/9-acpi Not tainted 3.10.20-200.rt17.1.fc19.ccrma.x86_64.rt #1
Nov 29 23:17:52 localhost kernel: [50532.639007] Hardware name: LENOVO 
4313CTO/4313CTO, BIOS 6MET64WW (1.27 ) 07/15/2010
Nov 29 23:17:52 localhost kernel: [50532.639008] task: ffff880229bc8000 
ti: ffff880229bac000 task.ti: ffff880229bac000
Nov 29 23:17:52 localhost kernel: [50532.639011] RIP: 
0010:[<ffffffff81361e9a>]  [<ffffffff81361e9a>] 
advance_transaction+0x60/0x121
Nov 29 23:17:52 localhost kernel: [50532.639012] RSP: 
0018:ffff880229badd50  EFLAGS: 00010246
Nov 29 23:17:52 localhost kernel: [50532.639013] RAX: 0000000000000081 
RBX: ffff88011339f990 RCX: 0000000000000082
Nov 29 23:17:52 localhost kernel: [50532.639013] RDX: 0000000000000246 
RSI: 0000000000000001 RDI: ffff880229b78eb0
Nov 29 23:17:52 localhost kernel: [50532.639014] RBP: ffff880229badd70 
R08: 0000000000000000 R09: 0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.639015] R10: 0000000000000001 
R11: 000000000000102a R12: ffff880229b78e00
Nov 29 23:17:52 localhost kernel: [50532.639016] R13: 0000000000000001 
R14: ffff880229b78eb0 R15: ffff880229b78d36
Nov 29 23:17:52 localhost kernel: [50532.639017] FS: 
0000000000000000(0000) GS:ffff88023bc00000(0000) knlGS:0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.639018] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Nov 29 23:17:52 localhost kernel: [50532.639019] CR2: 00000000000002c7 
CR3: 00000001e8198000 CR4: 00000000000007f0
Nov 29 23:17:52 localhost kernel: [50532.639020] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.639021] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 29 23:17:52 localhost kernel: [50532.639021] Stack:
Nov 29 23:17:52 localhost kernel: [50532.639024]  ffff880229b78e00 
0000000000000001 ffff88022983b000 0000000000000001
Nov 29 23:17:52 localhost kernel: [50532.639026]  ffff880229badd90 
ffffffff8136258e ffff880229bc0198 0000000000000011
Nov 29 23:17:52 localhost kernel: [50532.639028]  ffff880229baddb8 
ffffffff8136c3a3 ffff880229b8a660 0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.639028] Call Trace:
Nov 29 23:17:52 localhost kernel: [50532.639032]  [<ffffffff8136258e>] 
acpi_ec_gpe_handler+0x48/0xc9
Nov 29 23:17:52 localhost kernel: [50532.639036]  [<ffffffff8136c3a3>] 
acpi_ev_gpe_dispatch+0xb6/0x126
Nov 29 23:17:52 localhost kernel: [50532.639037]  [<ffffffff8136c4d3>] 
acpi_ev_gpe_detect+0xc0/0x111
Nov 29 23:17:52 localhost kernel: [50532.639043]  [<ffffffff810f46b0>] ? 
irq_thread_fn+0x50/0x50
Nov 29 23:17:52 localhost kernel: [50532.639044]  [<ffffffff8136e3cf>] 
acpi_ev_sci_xrupt_handler+0x1f/0x25
Nov 29 23:17:52 localhost kernel: [50532.639048]  [<ffffffff8135b12f>] 
acpi_irq+0x16/0x31
Nov 29 23:17:52 localhost kernel: [50532.639050]  [<ffffffff810f46d3>] 
irq_forced_thread_fn+0x23/0x70
Nov 29 23:17:52 localhost kernel: [50532.639051]  [<ffffffff810f4c7f>] 
irq_thread+0x10f/0x150
Nov 29 23:17:52 localhost kernel: [50532.639053]  [<ffffffff810f4770>] ? 
wake_threads_waitq+0x50/0x50
Nov 29 23:17:52 localhost kernel: [50532.639054]  [<ffffffff810f4b70>] ? 
irq_thread_check_affinity+0x90/0x90
Nov 29 23:17:52 localhost kernel: [50532.639058]  [<ffffffff810865e2>] 
kthread+0xb2/0xc0
Nov 29 23:17:52 localhost kernel: [50532.639059]  [<ffffffff81086530>] ? 
kthread_worker_fn+0x180/0x180
Nov 29 23:17:52 localhost kernel: [50532.639063]  [<ffffffff816628ec>] 
ret_from_fork+0x7c/0xb0
Nov 29 23:17:52 localhost kernel: [50532.639064]  [<ffffffff81086530>] ? 
kthread_worker_fn+0x180/0x180
Nov 29 23:17:52 localhost kernel: [50532.639076] Code: 0f 84 d0 00 00 00 
0f b6 43 13 8a 4b 15 38 c1 76 44 41 f6 c5 02 0f 85 9c 00 00 00 8d 48 01 
48 8b 13 88 4b 13 f6 05 98 2a 98 00 04 <8a> 1c 02 74 18 0f b6 d3 48 c7 
c6 bf aa a2 81 48 c7 c7 10 49 ce
Nov 29 23:17:52 localhost kernel: [50532.639078] RIP 
[<ffffffff81361e9a>] advance_transaction+0x60/0x121
Nov 29 23:17:52 localhost kernel: [50532.639079]  RSP <ffff880229badd50>
Nov 29 23:17:52 localhost kernel: [50532.639079] CR2: 00000000000002c7
Nov 29 23:17:52 localhost kernel: [50532.652572] ---[ end trace 
0000000000000002 ]---
Nov 29 23:17:52 localhost kernel: [50532.652622] BUG: unable to handle 
kernel paging request at ffffffffffffffd8
Nov 29 23:17:52 localhost kernel: [50532.652635] IP: 
[<ffffffff81086900>] kthread_data+0x10/0x20
Nov 29 23:17:52 localhost kernel: [50532.652637] PGD 1c12067 PUD 1c14067 
PMD 0
Nov 29 23:17:52 localhost kernel: [50532.652640] Oops: 0000 [#2] PREEMPT 
SMP
Nov 29 23:17:52 localhost kernel: [50532.652680] Modules linked in: 
snd_hrtimer snd_seq_midi snd_seq_midi_event snd_seq_dummy snd_hdsp 
snd_rawmidi fuse xt_CHECKSUM tun nf_conntrack_netbios_ns 
nf_conntrack_broadcast ipt_MASQUERADE ip6t_REJECT xt_conntrack 
ebtable_nat ebtable_broute bridge stp llc ebtable_filter ebtables 
ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 
ip6table_mangle ip6table_security ip6table_raw ip6table_filter 
ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 
nf_nat nf_conntrack iptable_mangle iptable_security rfcomm iptable_raw 
bnep iTCO_wdt iTCO_vendor_support snd_hda_codec_hdmi acpi_cpufreq mperf 
coretemp kvm_intel kvm crc32_pclmul uvcvideo crc32c_intel 
ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops videobuf2_core 
microcode videodev media serio_raw snd_hda_codec_conexant intel_ips 
btusb i2c_i801 bluetooth arc4 iwldvm mac80211 snd_hda_intel 
snd_hda_codec iwlwifi snd_hwdep sdhci_pci snd_seq sdhci snd_seq_device 
cfg80211 mmc_core snd_pcm lpc_ich mfd_core e1000e snd_page_alloc ptp 
mei_me snd_timer pps_core mei thinkpad_acpi snd soundcore rfkill shpchp 
uinput nouveau i2c_algo_bit firewire_ohci drm_kms_helper firewire_core 
crc_itu_t ttm drm i2c_core mxm_wmi video wmi
Nov 29 23:17:52 localhost kernel: [50532.652706] CPU: 0 PID: 45 Comm: 
irq/9-acpi Tainted: G      D      3.10.20-200.rt17.1.fc19.ccrma.x86_64.rt #1
Nov 29 23:17:52 localhost kernel: [50532.652707] Hardware name: LENOVO 
4313CTO/4313CTO, BIOS 6MET64WW (1.27 ) 07/15/2010
Nov 29 23:17:52 localhost kernel: [50532.652708] task: ffff880229bc8000 
ti: ffff880229bac000 task.ti: ffff880229bac000
Nov 29 23:17:52 localhost kernel: [50532.652713] RIP: 
0010:[<ffffffff81086900>]  [<ffffffff81086900>] kthread_data+0x10/0x20
Nov 29 23:17:52 localhost kernel: [50532.652713] RSP: 
0018:ffff880229bad9e8  EFLAGS: 00010202
Nov 29 23:17:52 localhost kernel: [50532.652714] RAX: 0000000000000000 
RBX: 0000000000000000 RCX: 0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.652715] RDX: ffff880229bade90 
RSI: 0000000000000000 RDI: ffff880229bc8000
Nov 29 23:17:52 localhost kernel: [50532.652716] RBP: ffff880229bad9e8 
R08: 0000000000000000 R09: 0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.652717] R10: 0000000040000004 
R11: 0000000000000000 R12: ffff880229bc8000
Nov 29 23:17:52 localhost kernel: [50532.652718] R13: ffff880229bc85a8 
R14: ffff880229bc8000 R15: ffff880229bc8000
Nov 29 23:17:52 localhost kernel: [50532.652720] FS: 
0000000000000000(0000) GS:ffff88023bc00000(0000) knlGS:0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.652720] CS:  0010 DS: 0000 ES: 
0000 CR0: 000000008005003b
Nov 29 23:17:52 localhost kernel: [50532.652721] CR2: ffffffffffffffd8 
CR3: 00000001e8198000 CR4: 00000000000007f0
Nov 29 23:17:52 localhost kernel: [50532.652723] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.652723] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 29 23:17:52 localhost kernel: [50532.652724] Stack:
Nov 29 23:17:52 localhost kernel: [50532.652727]  ffff880229bada10 
ffffffff810f4799 0000000000000070 0000000000000000
Nov 29 23:17:52 localhost kernel: [50532.652729]  ffffffff81f441a0 
ffff880229bada40 ffffffff81082c0f 0000000000000001
Nov 29 23:17:52 localhost kernel: [50532.652731]  000000000000002d 
0000000000000246 0000000000000000 ffff880229badac8
Nov 29 23:17:52 localhost kernel: [50532.652732] Call Trace:
Nov 29 23:17:52 localhost kernel: [50532.652741]  [<ffffffff810f4799>] 
irq_thread_dtor+0x29/0xc0
Nov 29 23:17:52 localhost kernel: [50532.652749]  [<ffffffff81082c0f>] 
task_work_run+0x9f/0xe0
Nov 29 23:17:52 localhost kernel: [50532.652753]  [<ffffffff810656f6>] 
do_exit+0x2c6/0xad0
Nov 29 23:17:52 localhost kernel: [50532.652759]  [<ffffffff81650935>] ? 
printk+0x67/0x69
Nov 29 23:17:52 localhost kernel: [50532.652766]  [<ffffffff81062dc1>] ? 
kmsg_dump+0xc1/0xd0
Nov 29 23:17:52 localhost kernel: [50532.652771]  [<ffffffff8165c1e1>] 
oops_end+0xa1/0xe0
Nov 29 23:17:52 localhost kernel: [50532.652775]  [<ffffffff8165026a>] 
no_context+0x263/0x270
Nov 29 23:17:52 localhost kernel: [50532.652779]  [<ffffffff816502ea>] 
__bad_area_nosemaphore+0x73/0x1cc
Nov 29 23:17:52 localhost kernel: [50532.652781]  [<ffffffff81650456>] 
bad_area_nosemaphore+0x13/0x15
Nov 29 23:17:52 localhost kernel: [50532.652786]  [<ffffffff8165e5c4>] 
__do_page_fault+0xf4/0x5c0
Nov 29 23:17:52 localhost kernel: [50532.652793]  [<ffffffff810135ae>] ? 
__switch_to+0x13e/0x4f0
Nov 29 23:17:52 localhost kernel: [50532.652800]  [<ffffffff81091569>] ? 
finish_task_switch+0x49/0xf0
Nov 29 23:17:52 localhost kernel: [50532.652804]  [<ffffffff81659368>] ? 
__schedule+0x2e8/0x700
Nov 29 23:17:52 localhost kernel: [50532.652809]  [<ffffffff8165ea9e>] 
do_page_fault+0xe/0x10
Nov 29 23:17:52 localhost kernel: [50532.652814]  [<ffffffff8165b658>] 
page_fault+0x28/0x30
Nov 29 23:17:52 localhost kernel: [50532.652819]  [<ffffffff81361e9a>] ? 
advance_transaction+0x60/0x121
Nov 29 23:17:52 localhost kernel: [50532.652821]  [<ffffffff8136258e>] 
acpi_ec_gpe_handler+0x48/0xc9
Nov 29 23:17:52 localhost kernel: [50532.652826]  [<ffffffff8136c3a3>] 
acpi_ev_gpe_dispatch+0xb6/0x126
Nov 29 23:17:52 localhost kernel: [50532.652828]  [<ffffffff8136c4d3>] 
acpi_ev_gpe_detect+0xc0/0x111
Nov 29 23:17:52 localhost kernel: [50532.652830]  [<ffffffff810f46b0>] ? 
irq_thread_fn+0x50/0x50
Nov 29 23:17:52 localhost kernel: [50532.652832]  [<ffffffff8136e3cf>] 
acpi_ev_sci_xrupt_handler+0x1f/0x25
Nov 29 23:17:52 localhost kernel: [50532.652835]  [<ffffffff8135b12f>] 
acpi_irq+0x16/0x31
Nov 29 23:17:52 localhost kernel: [50532.652837]  [<ffffffff810f46d3>] 
irq_forced_thread_fn+0x23/0x70
Nov 29 23:17:52 localhost kernel: [50532.652840]  [<ffffffff810f4c7f>] 
irq_thread+0x10f/0x150
Nov 29 23:17:52 localhost kernel: [50532.652842]  [<ffffffff810f4770>] ? 
wake_threads_waitq+0x50/0x50
Nov 29 23:17:52 localhost kernel: [50532.652844]  [<ffffffff810f4b70>] ? 
irq_thread_check_affinity+0x90/0x90
Nov 29 23:17:52 localhost kernel: [50532.652846]  [<ffffffff810865e2>] 
kthread+0xb2/0xc0
Nov 29 23:17:52 localhost kernel: [50532.652848]  [<ffffffff81086530>] ? 
kthread_worker_fn+0x180/0x180
Nov 29 23:17:52 localhost kernel: [50532.652852]  [<ffffffff816628ec>] 
ret_from_fork+0x7c/0xb0
Nov 29 23:17:52 localhost kernel: [50532.652854]  [<ffffffff81086530>] ? 
kthread_worker_fn+0x180/0x180
Nov 29 23:17:52 localhost kernel: [50532.652871] Code: 00 48 89 e5 5d 48 
8b 40 c8 48 c1 e8 02 83 e0 01 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 
66 90 48 8b 87 d8 02 00 00 55 48 89 e5 <48> 8b 40 d8 5d c3 66 2e 0f 1f 
84 00 00 00 00 00 66 66 66 66 90
Nov 29 23:17:52 localhost kernel: [50532.652873] RIP 
[<ffffffff81086900>] kthread_data+0x10/0x20
Nov 29 23:17:52 localhost kernel: [50532.652874]  RSP <ffff880229bad9e8>
Nov 29 23:17:52 localhost kernel: [50532.652875] CR2: ffffffffffffffd8
Nov 29 23:17:52 localhost kernel: [50532.746096] ---[ end trace 
0000000000000003 ]---
Nov 29 23:17:52 localhost kernel: [50532.746098] Fixing recursive fault 
but reboot is needed!
--------
