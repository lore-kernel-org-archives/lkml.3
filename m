Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab3LQICv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 03:02:51 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:46312 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab3LQICs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 03:02:48 -0500
Message-ID: <52B00547.8030904@gmail.com>
Date: Tue, 17 Dec 2013 09:03:19 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: micky <micky_ching@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <20131117195358.GO27323@pd.tnic> <4523614.I5MBhorHFt@vostro.rjw.lan> <5292FF5D.1050304@gmail.com> <1821758.2MoNI3h1Mv@vostro.rjw.lan> <52985041.5050000@gmail.com> <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de> <529D92D6.8050409@gmail.com> <20131209221721.GB8612@zurbaran> <52A670E4.5050501@realsil.com.cn> <52A674E0.2080407@realsil.com.cn>
In-Reply-To: <52A674E0.2080407@realsil.com.cn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/10/2013 02:56 AM, micky wrote:
> Hi Francis:
> On 12/10/2013 09:39 AM, wwang wrote:
>> which is based on Thomas' patch. 
> 
> Can you help us test this patch, we disable irq while suspend here.

This patch doesn't seem to help, it still oops:

[   29.843910] ------------[ cut here ]------------
[   29.843917] WARNING: CPU: 0 PID: 53 at lib/debugobjects.c:260
debug_print_object+0x83/0xa0()
[   29.843921] ODEBUG: free active (active state 0) object type:
timer_list hint: delayed_work_timer_fn+0x0/0x20
[   29.843972] Modules linked in: x86_pkg_temp_thermal intel_powerclamp
coretemp kvm_intel kvm rtsx_pci_ms i915 i2c_algo_bit intel_agp intel_gtt
memstick iTCO_wdt drm_kms_helper crc32c_intel video drm r8169 mei_me mii
thermal agpgart mei wmi iTCO_vendor_support ac i2c_i801 i2c_core battery
evdev button shpchp lpc_ich mperf processor serio_raw microcode ext4
crc16 mbcache jbd2 sr_mod cdrom sd_mod usb_storage rtsx_pci_sdmmc
mmc_core ahci libahci libata scsi_mod ehci_pci xhci_hcd ehci_hcd
rtsx_pci usbcore usb_common
[   29.844004] CPU: 0 PID: 53 Comm: kworker/0:1 Not tainted
3.11.0-rc2-ARCH #66
[   29.844006] Hardware name: CLEVO CO.                        W55xEU
                       /W55xEU                          , BIOS 4.6.5
03/05/2013
[   29.844010] Workqueue: kacpi_hotplug hotplug_event_work
[   29.844012]  0000000000000009 ffff880407a95a18 ffffffff81459fe9
ffff880407a95a60
[   29.844014]  ffff880407a95a50 ffffffff8104dc7d ffff880406b896b8
ffffffff81836fc0
[   29.844017]  ffffffff81701358 ffffffff81b2f9b0 0000000000000003
ffff880407a95ab0
[   29.844019] Call Trace:
[   29.844024]  [<ffffffff81459fe9>] dump_stack+0x54/0x8d
[   29.844027]  [<ffffffff8104dc7d>] warn_slowpath_common+0x7d/0xa0
[   29.844029]  [<ffffffff8104dcec>] warn_slowpath_fmt+0x4c/0x50
[   29.844032]  [<ffffffff81261433>] debug_print_object+0x83/0xa0
[   29.844034]  [<ffffffff8106b820>] ? queue_work_on+0x50/0x50
[   29.844037]  [<ffffffff81261c2b>] __debug_check_no_obj_freed+0x1fb/0x240
[   29.844044]  [<ffffffffa00d8989>] ? rtsx_pci_remove+0x119/0x1d0
[rtsx_pci]
[   29.844046]  [<ffffffff81262619>] debug_check_no_obj_freed+0x19/0x20
[   29.844049]  [<ffffffff8116f861>] kfree+0x191/0x210
[   29.844054]  [<ffffffff813819e0>] ? pcibios_disable_device+0x20/0x30
[   29.844066]  [<ffffffffa00d8989>] ? rtsx_pci_remove+0x119/0x1d0
[rtsx_pci]
[   29.844071]  [<ffffffffa00d8989>] rtsx_pci_remove+0x119/0x1d0 [rtsx_pci]
[   29.844075]  [<ffffffff8128004b>] pci_device_remove+0x3b/0xb0
[   29.844079]  [<ffffffff8132c92f>] __device_release_driver+0x7f/0xf0
[   29.844082]  [<ffffffff8132c9c3>] device_release_driver+0x23/0x30
[   29.844084]  [<ffffffff8132c194>] bus_remove_device+0xf4/0x170
[   29.844087]  [<ffffffff81328c55>] device_del+0x135/0x1d0
[   29.844089]  [<ffffffff8127ae24>] pci_stop_bus_device+0x94/0xa0
[   29.844091]  [<ffffffff8127af32>]
pci_stop_and_remove_bus_device+0x12/0x20
[   29.844094]  [<ffffffff81297466>] disable_slot+0x76/0xd0
[   29.844096]  [<ffffffff81297568>] acpiphp_check_bridge+0xa8/0xd0
[   29.844099]  [<ffffffff81297c8a>] hotplug_event+0xfa/0x210
[   29.844101]  [<ffffffff81297dc7>] hotplug_event_work+0x27/0x60
[   29.844104]  [<ffffffff8106c178>] process_one_work+0x178/0x470
[   29.844106]  [<ffffffff8106cb91>] worker_thread+0x121/0x3a0
[   29.844109]  [<ffffffff8106ca70>] ? manage_workers.isra.21+0x2b0/0x2b0
[   29.844111]  [<ffffffff81073a50>] kthread+0xc0/0xd0
[   29.844114]  [<ffffffff81073990>] ? kthread_create_on_node+0x120/0x120
[   29.844117]  [<ffffffff814688ec>] ret_from_fork+0x7c/0xb0
[   29.844119]  [<ffffffff81073990>] ? kthread_create_on_node+0x120/0x120
[   29.844120] ---[ end trace ed9751fe6c0cd9e3 ]---
[   29.844137] kobject: '0000:03:00.0' (ffff880407a010a8):
kobject_uevent_env
[   29.844150] kobject: '0000:03:00.0' (ffff880407a010a8):
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1c.3/0000:03:00.0'
[   29.844162] kobject: '0000:03:00.0' (ffff880407a010a8): kobject_cleanup
[   29.844164] kobject: '0000:03:00.0' (ffff880407a010a8): calling ktype
release
[   29.844166] kobject: '0000:03:00.0': free name
[   29.844367] kobject: 'rx-0' (ffff8804067ae010): kobject_cleanup
[   29.844370] kobject: 'rx-0' (ffff8804067ae010): auto cleanup 'remove'
event
[   29.844371] kobject: 'rx-0' (ffff8804067ae010): kobject_uevent_env
[   29.844374] kobject: 'rx-0' (ffff8804067ae010): fill_kobj_path: path
= '/devices/pci0000:00/0000:00:1c.3/0000:03:00.2/net/enp3s0f2/queues/rx-0'
[   29.844379] kobject: 'rx-0' (ffff8804067ae010): auto cleanup kobject_del
[   29.844383] kobject: 'rx-0' (ffff8804067ae010): calling ktype release
[   29.844384] kobject: 'rx-0': free name
[   29.844389] kobject: 'tx-0' (ffff880407205e18): kobject_cleanup
[   29.844390] kobject: 'tx-0' (ffff880407205e18): auto cleanup 'remove'
event
[   29.844391] kobject: 'tx-0' (ffff880407205e18): kobject_uevent_env
[   29.844393] kobject: 'tx-0' (ffff880407205e18): fill_kobj_path: path
= '/devices/pci0000:00/0000:00:1c.3/0000:03:00.2/net/enp3s0f2/queues/tx-0'
[   29.844396] kobject: 'tx-0' (ffff880407205e18): auto cleanup kobject_del
[   29.844398] kobject: 'tx-0' (ffff880407205e18): calling ktype release
[   29.844399] kobject: 'tx-0': free name
[   29.844400] kobject: 'queues' (ffff880406216c78): kobject_cleanup
[   29.844401] kobject: 'queues' (ffff880406216c78): auto cleanup
kobject_del
[   29.844403] kobject: 'queues' (ffff880406216c78): calling ktype release
[   29.844404] kobject: 'queues' (ffff880406216c78): kset_release
[   29.844405] kobject: 'queues': free name
[   29.844438] kobject: 'enp3s0f2' (ffff880406be2410): kobject_uevent_env
[   29.844440] kobject: 'enp3s0f2' (ffff880406be2410): fill_kobj_path:
path = '/devices/pci0000:00/0000:00:1c.3/0000:03:00.2/net/enp3s0f2'
[   29.844445] kobject: 'net' (ffff880406216cc0): kobject_cleanup
[   29.844446] kobject: 'net' (ffff880406216cc0): auto cleanup kobject_del
[   29.844447] kobject: 'net' (ffff880406216cc0): calling ktype release
[   29.844448] kobject: 'net': free name
[   29.890009] kobject: '44' (ffff880407327408): kobject_cleanup
[   29.890014] kobject: '44' (ffff880407327408): calling ktype release
[   29.890015] kobject: '44': free name
[   29.890018] kobject: 'msi_irqs' (ffff880406216d38): kobject_cleanup
[   29.890019] kobject: 'msi_irqs' (ffff880406216d38): auto cleanup
kobject_del
[   29.890022] kobject: 'msi_irqs' (ffff880406216d38): calling ktype release
[   29.890024] kobject: 'msi_irqs' (ffff880406216d38): kset_release
[   29.890026] kobject: 'msi_irqs': free name
[   29.890121] kobject: 'enp3s0f2' (ffff880406be2410): kobject_cleanup
[   29.890123] kobject: 'enp3s0f2' (ffff880406be2410): calling ktype release
[   29.890127] kobject: 'enp3s0f2': free name
[   29.899887] kobject: '0000:03:00.2' (ffff880407a020a8):
kobject_uevent_env
[   29.899892] kobject: '0000:03:00.2' (ffff880407a020a8):
fill_kobj_path: path = '/devices/pci0000:00/0000:00:1c.3/0000:03:00.2'
[   29.899914] kobject: '0000:03:00.2' (ffff880407a020a8): kobject_cleanup
[   29.899915] kobject: '0000:03:00.2' (ffff880407a020a8): calling ktype
release
[   29.899918] kobject: '0000:03:00.2': free name
[   29.899966] kobject: 'device:10' (ffff8804079731f0): kobject_uevent_env
[   29.899969] kobject: 'device:10' (ffff8804079731f0): fill_kobj_path:
path = '/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0f/device:10'
[   29.899976] ACPI: Device does not support D3cold
[   29.899978] kobject: 'device:10' (ffff8804079731f0): kobject_cleanup
[   29.899979] kobject: 'device:10' (ffff8804079731f0): calling ktype
release
[   29.899982] kobject: 'device:10': free name
[   29.900025] kobject: 'device:11' (ffff8804079739f0): kobject_uevent_env
[   29.900028] kobject: 'device:11' (ffff8804079739f0): fill_kobj_path:
path = '/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0f/device:11'
[   29.900033] ACPI: Device does not support D3cold
[   29.900035] kobject: 'device:11' (ffff8804079739f0): kobject_cleanup
[   29.900036] kobject: 'device:11' (ffff8804079739f0): calling ktype
release
[   29.900038] kobject: 'device:11': free name
[   29.900105] kobject: 'device:12' (ffff8804079741f0): kobject_uevent_env
[   29.900106] kobject: 'device:12' (ffff8804079741f0): fill_kobj_path:
path = '/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0f/device:12'
[   29.900112] ACPI: Device does not support D3cold
[   29.900114] kobject: 'device:12' (ffff8804079741f0): kobject_cleanup
[   29.900114] kobject: 'device:12' (ffff8804079741f0): calling ktype
release
[   29.900117] kobject: 'device:12': free name
[   29.900163] kobject: 'device:14' (ffff8804079751f0): kobject_uevent_env
[   29.900164] kobject: 'device:14' (ffff8804079751f0): fill_kobj_path:
path = '/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:13/device:14'
[   29.900171] ACPI: Device does not support D3cold
[   29.900174] kobject: 'device:14' (ffff8804079751f0): kobject_cleanup
[   29.900175] kobject: 'device:14' (ffff8804079751f0): calling ktype
release
[   29.900178] kobject: 'device:14': free name
[   30.404233] irq 16: nobody cared (try booting with the "irqpoll" option)
[   30.404272] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W
3.11.0-rc2-ARCH #66
[   30.404274] Hardware name: CLEVO CO.                        W55xEU
                       /W55xEU                          , BIOS 4.6.5
03/05/2013
[   30.404275]  ffff8804078bd38c ffff88041e203e48 ffffffff81459fe9
ffff8804078bd300
[   30.404278]  ffff88041e203e70 ffffffff810d8632 ffff8804078bd300
0000000000000010
[   30.404280]  0000000000000000 ffff88041e203eb0 ffffffff810d8a58
ffffffff8136a882
[   30.404282] Call Trace:
[   30.404284]  <IRQ>  [<ffffffff81459fe9>] dump_stack+0x54/0x8d
[   30.404293]  [<ffffffff810d8632>] __report_bad_irq+0x32/0xd0
[   30.404296]  [<ffffffff810d8a58>] note_interrupt+0x138/0x1f0
[   30.404299]  [<ffffffff8136a882>] ? cpuidle_enter_state+0x52/0xc0
[   30.404302]  [<ffffffff810d6439>] handle_irq_event_percpu+0xf9/0x250
[   30.404304]  [<ffffffff810d65cd>] handle_irq_event+0x3d/0x60
[   30.404306]  [<ffffffff810d95ca>] handle_fasteoi_irq+0x5a/0x100
[   30.404309]  [<ffffffff81004a6e>] handle_irq+0x1e/0x30
[   30.404312]  [<ffffffff8146aafd>] do_IRQ+0x4d/0xc0
[   30.404314]  [<ffffffff8146116d>] common_interrupt+0x6d/0x6d
[   30.404315]  <EOI>  [<ffffffff8136a882>] ? cpuidle_enter_state+0x52/0xc0
[   30.404319]  [<ffffffff8136a878>] ? cpuidle_enter_state+0x48/0xc0
[   30.404321]  [<ffffffff8136a9b9>] cpuidle_idle_call+0xc9/0x280
[   30.404325]  [<ffffffff8100bf6e>] arch_cpu_idle+0xe/0x30
[   30.404328]  [<ffffffff810a1287>] cpu_startup_entry+0x257/0x2d0
[   30.404330]  [<ffffffff8144d404>] rest_init+0x84/0x90
[   30.404333]  [<ffffffff818d9ee1>] start_kernel+0x414/0x420
[   30.404335]  [<ffffffff818d98d6>] ? repair_env_string+0x5c/0x5c
[   30.404337]  [<ffffffff818d9120>] ? early_idt_handlers+0x120/0x120
[   30.404339]  [<ffffffff818d95be>] x86_64_start_reservations+0x2a/0x2c
[   30.404342]  [<ffffffff818d96c8>] x86_64_start_kernel+0x108/0x117
[   30.404343] handlers:
[   30.404363] [<ffffffffa00168f0>] usb_hcd_irq [usbcore]
[   30.404383] Disabling IRQ #16
