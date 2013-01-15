Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002Ab3AOXnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:43:25 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48392 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686Ab3AOXnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 18:43:20 -0500
MIME-Version: 1.0
In-Reply-To: <3209605.7vX7Iug6cS@vostro.rjw.lan>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
	<1908840.G1WFmde11m@vostro.rjw.lan>
	<CAE9FiQUb7d2Sud6gGkqW+aJ-rVi2nUF=nGK6_Afzf8VE7K-dDw@mail.gmail.com>
	<3209605.7vX7Iug6cS@vostro.rjw.lan>
Date: Tue, 15 Jan 2013 15:43:17 -0800
X-Google-Sender-Auth: Tlkw3mI57DIOquPrZZo29r76XY0
Message-ID: <CAE9FiQW-efB2s1gdmVTy8k9NLSayAxfkTFvtzQhzL6MFBFSoWQ@mail.gmail.com>
Subject: Re: [PATCH v8 14/22] ACPI: update ej_event interface to take acpi_device
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 3:26 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, January 14, 2013 10:55:49 PM Yinghai Lu wrote:
>> On Sat, Jan 12, 2013 at 3:40 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Friday, January 11, 2013 02:40:41 PM Yinghai Lu wrote:
>> >> Should use acpi_device pointer directly instead of use handle and
>> >> get the device pointer again later.
>> >
>> > Looks good.
>> >
>> > I can take this one right now if you want.
>>
>> yes, in acpi-scan branch?
>>
>> othewise i can not base on pci/next again.
>
> OK
>
> So I think there will be more patches in acpi-scan you'll need anyway, so
> I'll put this one on that branch too.

after updating pci root bus hotplug patches against your linux-next,
got panic during removal:

echo "PCI0 3" > /sys/kernel/debug/acpi/sci_notify
[   55.223155] ACPI: ACPI device name is <PCI0>, event code is <3>
[   55.226746] ACPI: Notify event is queued
[   55.228648] _handle_hotplug_event_root: Device eject notify on \_SB_.PCI0
10:~ # [   55.340169] ACPI: Device 0000:00:03.0 -x-> \_SB_.PCI0.S03_
[   55.341040] ACPI: Device 0000:00:02.0 -x-> \_SB_.PCI0.VGA_
[   55.341711] i2c i2c-0: adapter [SMBus PIIX4 adapter at b100] unregistered
[   55.342585] i2c-dev: adapter [SMBus PIIX4 adapter at b100] unregistered
[   55.343522] ACPI: Device 0000:00:01.3 -x-> \_SB_.PCI0.PX13
[   55.344660] ata1.00: disabled
[   55.350377] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   55.352729] sd 0:0:0:0: [sda]
[   55.353405] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[   55.354010] sd 0:0:0:0: [sda] Stopping disk
[   55.358144] sd 0:0:0:0: [sda] START_STOP FAILED
[   55.358660] sd 0:0:0:0: [sda]
[   55.359026] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
[   55.361348] ata2.00: disabled
[   55.371548] ACPI: Device 0000:00:01.0 -x-> \_SB_.PCI0.ISA_
[   55.372268] ACPI: Device pci0000:00 -x-> \_SB_.PCI0
[   55.372747]   remove_bridge is called for \_SB_.PCI0 ffff8801964661e0
[   55.373581] acpiphp: Slot [31] unregistered
[   55.374110] pci_hotplug: pci_hp_deregister: Removed slot 31 from the list
[   55.374720] acpiphp: release_slot - physical_slot = 31
[   55.375195] pci_bus 0000:00: dev 1f, dec refcount to 0
[   55.375781] pci_bus 0000:00: dev 1f, released physical slot 31
[   55.376370] acpiphp: Slot [30] unregistered
[   55.376839] pci_hotplug: pci_hp_deregister: Removed slot 30 from the list
[   55.377512] acpiphp: release_slot - physical_slot = 30
[   55.377968] pci_bus 0000:00: dev 1e, dec refcount to 0
[   55.378432] pci_bus 0000:00: dev 1e, released physical slot 30
[   55.378976] acpiphp: Slot [29] unregistered
[   55.379375] pci_hotplug: pci_hp_deregister: Removed slot 29 from the list
[   55.379977] acpiphp: release_slot - physical_slot = 29
[   55.380479] pci_bus 0000:00: dev 1d, dec refcount to 0
[   55.380967] pci_bus 0000:00: dev 1d, released physical slot 29
[   55.381484] acpiphp: Slot [28] unregistered
[   55.381860] pci_hotplug: pci_hp_deregister: Removed slot 28 from the list
[   55.382485] acpiphp: release_slot - physical_slot = 28
[   55.383067] pci_bus 0000:00: dev 1c, dec refcount to 0
[   55.384426] pci_bus 0000:00: dev 1c, released physical slot 28
[   55.385830] acpiphp: Slot [27] unregistered
[   55.386852] pci_hotplug: pci_hp_deregister: Removed slot 27 from the list
[   55.388511] acpiphp: release_slot - physical_slot = 27
[   55.389750] pci_bus 0000:00: dev 1b, dec refcount to 0
[   55.390994] pci_bus 0000:00: dev 1b, released physical slot 27
[   55.392418] acpiphp: Slot [26] unregistered
[   55.393419] pci_hotplug: pci_hp_deregister: Removed slot 26 from the list
[   55.395034] acpiphp: release_slot - physical_slot = 26
[   55.396283] pci_bus 0000:00: dev 1a, dec refcount to 0
[   55.397514] pci_bus 0000:00: dev 1a, released physical slot 26
[   55.398901] acpiphp: Slot [25] unregistered
[   55.399927] pci_hotplug: pci_hp_deregister: Removed slot 25 from the list
[   55.401059] acpiphp: release_slot - physical_slot = 25
[   55.401761] pci_bus 0000:00: dev 19, dec refcount to 0
[   55.402715] pci_bus 0000:00: dev 19, released physical slot 25
[   55.403838] acpiphp: Slot [24] unregistered
[   55.404892] pci_hotplug: pci_hp_deregister: Removed slot 24 from the list
[   55.406501] acpiphp: release_slot - physical_slot = 24
[   55.407720] pci_bus 0000:00: dev 18, dec refcount to 0
[   55.409001] pci_bus 0000:00: dev 18, released physical slot 24
[   55.410220] acpiphp: Slot [23] unregistered
[   55.410951] pci_hotplug: pci_hp_deregister: Removed slot 23 from the list
[   55.412601] acpiphp: release_slot - physical_slot = 23
[   55.413840] pci_bus 0000:00: dev 17, dec refcount to 0
[   55.415092] pci_bus 0000:00: dev 17, released physical slot 23
[   55.416510] acpiphp: Slot [22] unregistered
[   55.417529] pci_hotplug: pci_hp_deregister: Removed slot 22 from the list
[   55.419153] acpiphp: release_slot - physical_slot = 22
[   55.420415] pci_bus 0000:00: dev 16, dec refcount to 0
[   55.421665] pci_bus 0000:00: dev 16, released physical slot 22
[   55.423069] acpiphp: Slot [21] unregistered
[   55.424110] pci_hotplug: pci_hp_deregister: Removed slot 21 from the list
[   55.425722] acpiphp: release_slot - physical_slot = 21
[   55.426952] pci_bus 0000:00: dev 15, dec refcount to 0
[   55.428209] pci_bus 0000:00: dev 15, released physical slot 21
[   55.429578] acpiphp: Slot [20] unregistered
[   55.430219] pci_hotplug: pci_hp_deregister: Removed slot 20 from the list
[   55.431123] acpiphp: release_slot - physical_slot = 20
[   55.431796] pci_bus 0000:00: dev 14, dec refcount to 0
[   55.432986] pci_bus 0000:00: dev 14, released physical slot 20
[   55.434392] acpiphp: Slot [19] unregistered
[   55.435411] pci_hotplug: pci_hp_deregister: Removed slot 19 from the list
[   55.437051] acpiphp: release_slot - physical_slot = 19
[   55.438309] pci_bus 0000:00: dev 13, dec refcount to 0
[   55.439556] pci_bus 0000:00: dev 13, released physical slot 19
[   55.440987] acpiphp: Slot [18] unregistered
[   55.441993] pci_hotplug: pci_hp_deregister: Removed slot 18 from the list
[   55.443511] acpiphp: release_slot - physical_slot = 18
[   55.444269] pci_bus 0000:00: dev 12, dec refcount to 0
[   55.445522] pci_bus 0000:00: dev 12, released physical slot 18
[   55.446949] acpiphp: Slot [17] unregistered
[   55.447961] pci_hotplug: pci_hp_deregister: Removed slot 17 from the list
[   55.449610] acpiphp: release_slot - physical_slot = 17
[   55.450839] pci_bus 0000:00: dev 11, dec refcount to 0
[   55.452097] pci_bus 0000:00: dev 11, released physical slot 17
[   55.453501] acpiphp: Slot [16] unregistered
[   55.454509] pci_hotplug: pci_hp_deregister: Removed slot 16 from the list
[   55.456151] acpiphp: release_slot - physical_slot = 16
[   55.457370] pci_bus 0000:00: dev 10, dec refcount to 0
[   55.458601] pci_bus 0000:00: dev 10, released physical slot 16
[   55.459775] acpiphp: Slot [15] unregistered
[   55.460444] pci_hotplug: pci_hp_deregister: Removed slot 15 from the list
[   55.461354] acpiphp: release_slot - physical_slot = 15
[   55.462059] pci_bus 0000:00: dev 0f, dec refcount to 0
[   55.462985] pci_bus 0000:00: dev 0f, released physical slot 15
[   55.464475] acpiphp: Slot [14] unregistered
[   55.465481] pci_hotplug: pci_hp_deregister: Removed slot 14 from the list
[   55.467089] acpiphp: release_slot - physical_slot = 14
[   55.468351] pci_bus 0000:00: dev 0e, dec refcount to 0
[   55.469597] pci_bus 0000:00: dev 0e, released physical slot 14
[   55.470994] acpiphp: Slot [13] unregistered
[   55.472033] pci_hotplug: pci_hp_deregister: Removed slot 13 from the list
[   55.473650] acpiphp: release_slot - physical_slot = 13
[   55.474878] pci_bus 0000:00: dev 0d, dec refcount to 0
[   55.476144] pci_bus 0000:00: dev 0d, released physical slot 13
[   55.477198] acpiphp: Slot [12] unregistered
[   55.477926] pci_hotplug: pci_hp_deregister: Removed slot 12 from the list
[   55.479561] acpiphp: release_slot - physical_slot = 12
[   55.480816] pci_bus 0000:00: dev 0c, dec refcount to 0
[   55.482073] pci_bus 0000:00: dev 0c, released physical slot 12
[   55.483475] acpiphp: Slot [11] unregistered
[   55.484515] pci_hotplug: pci_hp_deregister: Removed slot 11 from the list
[   55.486123] acpiphp: release_slot - physical_slot = 11
[   55.487338] pci_bus 0000:00: dev 0b, dec refcount to 0
[   55.488597] pci_bus 0000:00: dev 0b, released physical slot 11
[   55.489670] acpiphp: Slot [10] unregistered
[   55.490285] pci_hotplug: pci_hp_deregister: Removed slot 10 from the list
[   55.491700] acpiphp: release_slot - physical_slot = 10
[   55.492975] pci_bus 0000:00: dev 0a, dec refcount to 0
[   55.493800] pci_bus 0000:00: dev 0a, released physical slot 10
[   55.495103] acpiphp: Slot [9] unregistered
[   55.496121] pci_hotplug: pci_hp_deregister: Removed slot 9 from the list
[   55.497715] acpiphp: release_slot - physical_slot = 9
[   55.498929] pci_bus 0000:00: dev 09, dec refcount to 0
[   55.500206] pci_bus 0000:00: dev 09, released physical slot 9
[   55.501588] acpiphp: Slot [8] unregistered
[   55.502584] pci_hotplug: pci_hp_deregister: Removed slot 8 from the list
[   55.504196] acpiphp: release_slot - physical_slot = 8
[   55.505405] pci_bus 0000:00: dev 08, dec refcount to 0
[   55.506652] pci_bus 0000:00: dev 08, released physical slot 8
[   55.508057] acpiphp: Slot [7] unregistered
[   55.509060] pci_hotplug: pci_hp_deregister: Removed slot 7 from the list
[   55.510639] acpiphp: release_slot - physical_slot = 7
[   55.511838] pci_bus 0000:00: dev 07, dec refcount to 0
[   55.513117] pci_bus 0000:00: dev 07, released physical slot 7
[   55.514496] acpiphp: Slot [6] unregistered
[   55.515486] pci_hotplug: pci_hp_deregister: Removed slot 6 from the list
[   55.517099] acpiphp: release_slot - physical_slot = 6
[   55.518283] pci_bus 0000:00: dev 06, dec refcount to 0
[   55.519504] pci_bus 0000:00: dev 06, released physical slot 6
[   55.520365] acpiphp: Slot [5] unregistered
[   55.522045] pci_hotplug: pci_hp_deregister: Removed slot 5 from the list
[   55.523383] acpiphp: release_slot - physical_slot = 5
[   55.524627] pci_bus 0000:00: dev 05, dec refcount to 0
[   55.525887] pci_bus 0000:00: dev 05, released physical slot 5
[   55.527122] acpiphp: Slot [4] unregistered
[   55.527770] pci_hotplug: pci_hp_deregister: Removed slot 4 from the list
[   55.529417] acpiphp: release_slot - physical_slot = 4
[   55.530620] pci_bus 0000:00: dev 04, dec refcount to 0
[   55.531912] pci_bus 0000:00: dev 04, released physical slot 4
[   55.533325] acpiphp: Slot [3] unregistered
[   55.534327] pci_hotplug: pci_hp_deregister: Removed slot 3 from the list
[   55.535915] acpiphp: release_slot - physical_slot = 3
[   55.537147] pci_bus 0000:00: dev 03, dec refcount to 0
[   55.538388] pci_bus 0000:00: dev 03, released physical slot 3
[   55.539763]   acpi_pci_iommu_remove is called for \_SB_.PCI0 ffff8801964661e0
[   55.541569]   acpi_pci_ioapic_remove is called for \_SB_.PCI0
ffff8801964661e0
[   55.543356] ACPI: Delete PCI Interrupt Routing Table for 0000:00
[   55.544848] pci 0000:00:00.0: freeing pci_dev info
[   55.546002] pci 0000:00:01.0: freeing pci_dev info
[   55.547148] pci 0000:00:01.1: freeing pci_dev info
[   55.548304] pci 0000:00:01.3: freeing pci_dev info
[   55.549346] pci 0000:00:02.0: freeing pci_dev info
[   55.550058] pci 0000:00:03.0: freeing pci_dev info
[   55.550707] pci_bus 0000:00: busn_res: [bus 00-ff] is released
[   55.552535] pci_bus 0000:00: freeing pci_bus info
[   55.553424] pci_host_bridge pci0000:00: freeing pci_host_bridge info
[   55.555303] BUG: unable to handle kernel NULL pointer dereference
at           (null)
[   55.556269] IP: [<ffffffff8153bf9a>] acpi_power_resources_list_free+0x15/0x3f
[   55.556269] PGD 0
[   55.556269] Oops: 0000 [#1] SMP
[   55.556269] Modules linked in:
[   55.556269] CPU 0
[   55.556269] Pid: 1036, comm: kworker/0:1 Not tainted
3.8.0-rc3-yh-00703-gf602aca-dirty #1131 Bochs Bochs
[   55.556269] RIP: 0010:[<ffffffff8153bf9a>]  [<ffffffff8153bf9a>]
acpi_power_resources_list_free+0x15/0x3f
[   55.556269] RSP: 0018:ffff8801962479b8  EFLAGS: 00010292
[   55.556269] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000006
[   55.556269] RDX: 00000000000033a0 RSI: ffff8801960c2e18 RDI: ffff8801965db988
[   55.556269] RBP: ffff8801962479d8 R08: 0000000000000002 R09: 0000000000000000
[   55.556269] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[   55.556269] R13: ffff8801965db988 R14: ffff8801965db9e0 R15: ffff880196466528
[   55.556269] FS:  0000000000000000(0000) GS:ffff880199200000(0000)
knlGS:0000000000000000
[   55.556269] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   55.556269] CR2: 0000000000000000 CR3: 0000000002c13000 CR4: 00000000000006f0
[   55.556269] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   55.556269] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   55.556269] Process kworker/0:1 (pid: 1036, threadinfo
ffff880196246000, task ffff8801960c2500)
[   55.556269] Stack:
[   55.556269]  0000000000000000 ffff8801965db800 0000000000000000
ffff8801965db9d0
[   55.556269]  ffff880196247a08 ffffffff81536e2f ffffffff81536dff
ffff8801965db9e0
[   55.556269]  ffff8801965db9d0 ffff88019666de00 ffff880196247a38
ffffffff81710385
[   55.556269] Call Trace:
[   55.556269]  [<ffffffff81536e2f>] acpi_device_release+0x30/0x6a
[   55.556269]  [<ffffffff81536dff>] ? acpi_free_ids+0x50/0x50
[   55.556269]  [<ffffffff81710385>] device_release+0xa5/0x110
[   55.556269]  [<ffffffff814bda7f>] kobject_release+0x6f/0x90
[   55.556269]  [<ffffffff814bd93c>] kobject_put+0x4c/0x60
[   55.556269]  [<ffffffff81710087>] put_device+0x17/0x20
[   55.556269]  [<ffffffff8171133e>] device_unregister+0x1e/0x30
[   55.556269]  [<ffffffff815367ed>] acpi_device_unregister+0x162/0x177
[   55.556269]  [<ffffffff8153682d>] acpi_bus_remove+0x2b/0x2f
[   55.556269]  [<ffffffff815601c4>] acpi_ns_walk_namespace+0x114/0x250
[   55.556269]  [<ffffffff81536802>] ? acpi_device_unregister+0x177/0x177
[   55.556269]  [<ffffffff81536802>] ? acpi_device_unregister+0x177/0x177
[   55.556269]  [<ffffffff815607c5>] acpi_walk_namespace+0xee/0x137
[   55.556269]  [<ffffffff81536921>] acpi_bus_trim+0x64/0x7c
[   55.556269]  [<ffffffff815369b2>] acpi_bus_hot_remove_device+0x79/0x16d
[   55.556269]  [<ffffffff81196dc2>] ? kmem_cache_alloc_trace+0x42/0x150
[   55.556269]  [<ffffffff81539c18>] _handle_hotplug_event_root+0x108/0x149
[   55.556269]  [<ffffffff810a8b20>] ? process_one_work+0x270/0x560
[   55.556269]  [<ffffffff810a8b8d>] process_one_work+0x2dd/0x560
[   55.556269]  [<ffffffff810a8b20>] ? process_one_work+0x270/0x560
[   55.556269]  [<ffffffff810a9679>] ? worker_thread+0x59/0x3a0
[   55.556269]  [<ffffffff81539b10>] ? acpi_pci_find_root+0x3f/0x3f
[   55.556269]  [<ffffffff810a989a>] worker_thread+0x27a/0x3a0
[   55.556269]  [<ffffffff810e9f4d>] ? trace_hardirqs_on+0xd/0x10
[   55.556269]  [<ffffffff810a9620>] ? manage_workers+0x280/0x280
[   55.556269]  [<ffffffff810af088>] kthread+0xe8/0xf0
[   55.556269]  [<ffffffff810aefa0>] ? __init_kthread_worker+0x70/0x70
[   55.556269]  [<ffffffff8216d61c>] ret_from_fork+0x7c/0xb0
[   55.556269]  [<ffffffff810aefa0>] ? __init_kthread_worker+0x70/0x70
[   55.556269] Code: fe ff ff 48 8b 1b 4c 39 e3 75 ef 5b 5b 41 5c 44
89 e8 41 5d 5d c3 0f 1f 44 00 00 55 48 89 e5 41 55 49 89 fd 41 54 53
50 48 8b 1f <4c> 8b 23 eb 17 48 89 df e8 c9 34 f9 ff 48 89 df 4c 89 e3
e8 6e


looks like:

acpi_device_release+0x30
0xffffffff81536e2f is in acpi_device_release (drivers/acpi/scan.c:524).
519	static void acpi_free_power_resources_lists(struct acpi_device *device)
520	{
521		int i;
522	
523		acpi_power_resources_list_free(&device->wakeup.resources);
524		if (!device->flags.power_manageable)
525			return;
526	
527		for (i = ACPI_STATE_D0; i <= ACPI_STATE_D3_HOT; i++) {
528			struct acpi_device_power_state *ps = &device->power.states[i];

wakeup.resources has problem?

Thanks

Yinghai
