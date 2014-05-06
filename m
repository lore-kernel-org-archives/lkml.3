Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaEFUaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:30:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50064 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaEFUaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:30:06 -0400
Date: Tue, 6 May 2014 15:29:51 -0500
From: Felipe Balbi <balbi@ti.com>
To: <airlied@linux.ie>, <bskeggs@redhat.com>, <imirkin@alum.mit.edu>,
        <airlied@redhat.com>
CC: <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: possible deadlock on nouveau
Message-ID: <20140506202951.GA5769@saruman.home>
Reply-To: <balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+g7M9IMkV8truYOl
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Just caught this with v3.14-rc4 running with

	01:00.0 VGA compatible controller: NVIDIA Corporation GK107 [GeForce GTX 6=
50] (rev a1)

full dmesg attached

[  239.589213] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  239.589214] [ INFO: possible circular locking dependency detected ]
[  239.589216] 3.15.0-rc4-fb+ #5 Not tainted
[  239.589217] -------------------------------------------------------
[  239.589218] swapper/1/0 is trying to acquire lock:
[  239.589219]  (&(&priv->lock)->rlock#2){-.....}, at: [<ffffffff814a6b98>]=
 nouveau_therm_update+0x48/0x310
[  239.589228]=20
[  239.589228] but task is already holding lock:
[  239.589230]  (&(&priv->sensor.alarm_program_lock)->rlock){-.....}, at: [=
<ffffffff814a85a4>] alarm_timer_callback+0x54/0xe0
[  239.589234]=20
[  239.589234] which lock already depends on the new lock.
[  239.589234]=20
[  239.589236]=20
[  239.589236] the existing dependency chain (in reverse order) is:
[  239.589237]=20
[  239.589237] -> #1 (&(&priv->sensor.alarm_program_lock)->rlock){-.....}:
[  239.589240]        [<ffffffff810952e5>] lock_acquire+0xb5/0x160
[  239.589243]        [<ffffffff818ac6c6>] _raw_spin_lock_irqsave+0x56/0x90
[  239.589247]        [<ffffffff814a85a4>] alarm_timer_callback+0x54/0xe0
[  239.589249]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589252]        [<ffffffff814aa61e>] nv04_timer_alarm+0x7e/0xe0
[  239.589255]        [<ffffffff814a6dbd>] nouveau_therm_update+0x26d/0x310
[  239.589257]        [<ffffffff814a6e7a>] nouveau_therm_alarm+0x1a/0x20
[  239.589259]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589261]        [<ffffffff814aa6eb>] nv04_timer_intr+0x6b/0x90
[  239.589263]        [<ffffffff814a4451>] nouveau_mc_intr+0x141/0x1a0
[  239.589265]        [<ffffffff810a7777>] handle_irq_event_percpu+0x47/0x1=
d0
[  239.589268]        [<ffffffff810a793d>] handle_irq_event+0x3d/0x60
[  239.589270]        [<ffffffff810aa347>] handle_edge_irq+0x77/0x130
[  239.589272]        [<ffffffff8100488f>] handle_irq+0xbf/0x150
[  239.589275]        [<ffffffff818b75bf>] do_IRQ+0x4f/0xf0
[  239.589277]        [<ffffffff818acbb2>] ret_from_intr+0x0/0x1a
[  239.589279]        [<ffffffff8160d147>] cpuidle_enter+0x17/0x20
[  239.589283]        [<ffffffff8108ced2>] cpu_startup_entry+0x242/0x470
[  239.589287]        [<ffffffff81897876>] rest_init+0xc6/0xd0
[  239.589290]        [<ffffffff8210de95>] start_kernel+0x386/0x391
[  239.589293]        [<ffffffff8210d5ca>] x86_64_start_reservations+0x2a/0=
x2c
[  239.589296]        [<ffffffff8210d70a>] x86_64_start_kernel+0x13e/0x14d
[  239.589297]=20
[  239.589297] -> #0 (&(&priv->lock)->rlock#2){-.....}:
[  239.589300]        [<ffffffff81094b65>] __lock_acquire+0x1565/0x1c30
[  239.589302]        [<ffffffff810952e5>] lock_acquire+0xb5/0x160
[  239.589304]        [<ffffffff818ac6c6>] _raw_spin_lock_irqsave+0x56/0x90
[  239.589306]        [<ffffffff814a6b98>] nouveau_therm_update+0x48/0x310
[  239.589308]        [<ffffffff814a6e7a>] nouveau_therm_alarm+0x1a/0x20
[  239.589310]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589312]        [<ffffffff814aa61e>] nv04_timer_alarm+0x7e/0xe0
[  239.589315]        [<ffffffff814a862d>] alarm_timer_callback+0xdd/0xe0
[  239.589317]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589319]        [<ffffffff814aa6eb>] nv04_timer_intr+0x6b/0x90
[  239.589321]        [<ffffffff814a4451>] nouveau_mc_intr+0x141/0x1a0
[  239.589323]        [<ffffffff810a7777>] handle_irq_event_percpu+0x47/0x1=
d0
[  239.589325]        [<ffffffff810a793d>] handle_irq_event+0x3d/0x60
[  239.589327]        [<ffffffff810aa347>] handle_edge_irq+0x77/0x130
[  239.589329]        [<ffffffff8100488f>] handle_irq+0xbf/0x150
[  239.589330]        [<ffffffff818b75bf>] do_IRQ+0x4f/0xf0
[  239.589332]        [<ffffffff818acbb2>] ret_from_intr+0x0/0x1a
[  239.589334]        [<ffffffff8160d147>] cpuidle_enter+0x17/0x20
[  239.589336]        [<ffffffff8108ced2>] cpu_startup_entry+0x242/0x470
[  239.589338]        [<ffffffff810300b8>] start_secondary+0x1a8/0x210
[  239.589343]=20
[  239.589343] other info that might help us debug this:
[  239.589343]=20
[  239.589344]  Possible unsafe locking scenario:
[  239.589344]=20
[  239.589345]        CPU0                    CPU1
[  239.589346]        ----                    ----
[  239.589347]   lock(&(&priv->sensor.alarm_program_lock)->rlock);
[  239.589349]                                lock(&(&priv->lock)->rlock#2);
[  239.589351]                                lock(&(&priv->sensor.alarm_pr=
ogram_lock)->rlock);
[  239.589353]   lock(&(&priv->lock)->rlock#2);
[  239.589355]=20
[  239.589355]  *** DEADLOCK ***
[  239.589355]=20
[  239.589357] 1 lock held by swapper/1/0:
[  239.589358]  #0:  (&(&priv->sensor.alarm_program_lock)->rlock){-.....}, =
at: [<ffffffff814a85a4>] alarm_timer_callback+0x54/0xe0
[  239.589362]=20
[  239.589362] stack backtrace:
[  239.589364] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.15.0-rc4-fb+ #5
[  239.589366] Hardware name: LENOVO 10120/ , BIOS I1KT15AUS 03/28/2013
[  239.589367]  ffffffff826667d0 ffff880330803b30 ffffffff818a1afc ffffffff=
826667d0
[  239.589370]  ffff880330803b70 ffffffff8189caa9 ffff880330803bc0 ffff8803=
2e70c778
[  239.589372]  0000000000000001 0000000000000001 ffff88032e70bf30 ffff8803=
2e70c778
[  239.589375] Call Trace:
[  239.589376]  <IRQ>  [<ffffffff818a1afc>] dump_stack+0x4d/0x66
[  239.589382]  [<ffffffff8189caa9>] print_circular_bug+0x200/0x20e
[  239.589384]  [<ffffffff81094b65>] __lock_acquire+0x1565/0x1c30
[  239.589386]  [<ffffffff810939b3>] ? __lock_acquire+0x3b3/0x1c30
[  239.589388]  [<ffffffff810952e5>] lock_acquire+0xb5/0x160
[  239.589391]  [<ffffffff814a6b98>] ? nouveau_therm_update+0x48/0x310
[  239.589393]  [<ffffffff818ac6c6>] _raw_spin_lock_irqsave+0x56/0x90
[  239.589395]  [<ffffffff814a6b98>] ? nouveau_therm_update+0x48/0x310
[  239.589398]  [<ffffffff814a6b98>] nouveau_therm_update+0x48/0x310
[  239.589400]  [<ffffffff814a6e7a>] nouveau_therm_alarm+0x1a/0x20
[  239.589402]  [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0x170
[  239.589405]  [<ffffffff814aa61e>] nv04_timer_alarm+0x7e/0xe0
[  239.589407]  [<ffffffff814a862d>] alarm_timer_callback+0xdd/0xe0
[  239.589410]  [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0x170
[  239.589412]  [<ffffffff814aa6eb>] nv04_timer_intr+0x6b/0x90
[  239.589414]  [<ffffffff814a4451>] nouveau_mc_intr+0x141/0x1a0
[  239.589416]  [<ffffffff810a7777>] handle_irq_event_percpu+0x47/0x1d0
[  239.589419]  [<ffffffff810a793d>] handle_irq_event+0x3d/0x60
[  239.589421]  [<ffffffff810aa347>] handle_edge_irq+0x77/0x130
[  239.589423]  [<ffffffff8100488f>] handle_irq+0xbf/0x150
[  239.589425]  [<ffffffff818b0bb6>] ? atomic_notifier_call_chain+0x16/0x20
[  239.589427]  [<ffffffff818b75bf>] do_IRQ+0x4f/0xf0
[  239.589430]  [<ffffffff818acbb2>] common_interrupt+0x72/0x72
[  239.589431]  <EOI>  [<ffffffff8160d097>] ? cpuidle_enter_state+0x57/0xd0
[  239.589436]  [<ffffffff8160d090>] ? cpuidle_enter_state+0x50/0xd0
[  239.589438]  [<ffffffff8160d147>] cpuidle_enter+0x17/0x20
[  239.589440]  [<ffffffff8108ced2>] cpu_startup_entry+0x242/0x470
[  239.589443]  [<ffffffff810300b8>] start_secondary+0x1a8/0x210

--=20
balbi

--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.txt"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-rc4-fb+ (balbi@saruman) (gcc version 4.=
8.2 (Debian 4.8.2-19) ) #5 SMP Tue May 6 15:09:17 CDT 2014
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.15.0-rc4-fb+ root=
=3D/dev/sda1 ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ac83cfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ac83d000-0x00000000ac843fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000ac844000-0x00000000ad08bfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000ad08c000-0x00000000ad2e1fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ad2e2000-0x00000000bcfe1fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000bcfe2000-0x00000000bd1e7fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000bd1e8000-0x00000000bd1fbfff] ACPI =
data
[    0.000000] BIOS-e820: [mem 0x00000000bd1fc000-0x00000000bdb86fff] ACPI =
NVS
[    0.000000] BIOS-e820: [mem 0x00000000bdb87000-0x00000000bdffefff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000bdfff000-0x00000000bdffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed00000-0x00000000fed03fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000033dffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 10120/ , BIOS I1KT15AUS 03/28/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0x33e000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask 7E00000000 write-back
[    0.000000]   1 base 0200000000 mask 7F00000000 write-back
[    0.000000]   2 base 0300000000 mask 7FE0000000 write-back
[    0.000000]   3 base 0320000000 mask 7FF0000000 write-back
[    0.000000]   4 base 0330000000 mask 7FF8000000 write-back
[    0.000000]   5 base 0338000000 mask 7FFC000000 write-back
[    0.000000]   6 base 033C000000 mask 7FFE000000 write-back
[    0.000000]   7 base 00C0000000 mask 7FC0000000 uncachable
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] e820: update [mem 0xc0000000-0xffffffff] usable =3D=3D> rese=
rved
[    0.000000] e820: last_pfn =3D 0xbe000 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd7f0-0x000fd7ff] mapped at =
[ffff8800000fd7f0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02c22000, 0x02c22fff] PGTABLE
[    0.000000] BRK [0x02c23000, 0x02c23fff] PGTABLE
[    0.000000] BRK [0x02c24000, 0x02c24fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x33de00000-0x33dffffff]
[    0.000000]  [mem 0x33de00000-0x33dffffff] page 2M
[    0.000000] BRK [0x02c25000, 0x02c25fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x33c000000-0x33ddfffff]
[    0.000000]  [mem 0x33c000000-0x33ddfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x300000000-0x33bffffff]
[    0.000000]  [mem 0x300000000-0x33bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xac83cfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0xac7fffff] page 2M
[    0.000000]  [mem 0xac800000-0xac83cfff] page 4k
[    0.000000] init_memory_mapping: [mem 0xac844000-0xad08bfff]
[    0.000000]  [mem 0xac844000-0xac9fffff] page 4k
[    0.000000]  [mem 0xaca00000-0xacffffff] page 2M
[    0.000000]  [mem 0xad000000-0xad08bfff] page 4k
[    0.000000] BRK [0x02c26000, 0x02c26fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xad2e2000-0xbcfe1fff]
[    0.000000]  [mem 0xad2e2000-0xad3fffff] page 4k
[    0.000000]  [mem 0xad400000-0xbcdfffff] page 2M
[    0.000000]  [mem 0xbce00000-0xbcfe1fff] page 4k
[    0.000000] BRK [0x02c27000, 0x02c27fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xbdfff000-0xbdffffff]
[    0.000000]  [mem 0xbdfff000-0xbdffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x2ffffffff]
[    0.000000]  [mem 0x100000000-0x2ffffffff] page 1G
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000BD1EC088 00008C (v01 LENOVO TC-03    00=
0010F0 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000BD1F67E0 00010C (v05 LENOVO TC-03    00=
0010F0 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000BD1EC1A0 00A63D (v02 LENOVO TC-03    00=
0010F0 INTL 20091112)
[    0.000000] ACPI: FACS 0x00000000BDB85080 000040
[    0.000000] ACPI: APIC 0x00000000BD1F68F0 000092 (v03 LENOVO TC-03    00=
0010F0 AMI  00010013)
[    0.000000] ACPI: FPDT 0x00000000BD1F6988 000044 (v01 LENOVO TC-03    00=
0010F0 AMI  00010013)
[    0.000000] ACPI: MSDM 0x00000000BD1F69D0 000055 (v03 LENOVO TC-03    00=
0010F0 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000BD1F6A28 000539 (v01 LENOVO TC-03    00=
0010F0 INTL 20051117)
[    0.000000] ACPI: SSDT 0x00000000BD1F6F68 000AD8 (v01 LENOVO TC-03    00=
0010F0 INTL 20051117)
[    0.000000] ACPI: MCFG 0x00000000BD1F7A40 00003C (v01 LENOVO TC-03    00=
0010F0 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000BD1F7A80 000038 (v01 LENOVO TC-03    00=
0010F0 AMI. 00000005)
[    0.000000] ACPI: SSDT 0x00000000BD1F7AB8 00036D (v01 LENOVO TC-03    00=
0010F0 INTL 20091112)
[    0.000000] ACPI: SSDT 0x00000000BD1F7E28 00327D (v01 LENOVO TC-03    00=
0010F0 INTL 20091112)
[    0.000000] ACPI: ASF! 0x00000000BD1FB0A8 0000A5 (v32 LENOVO TC-03    00=
0010F0 TFSM 000F4240)
[    0.000000] ACPI: DMAR 0x00000000BD1FB150 000080 (v01 LENOVO TC-03    00=
0010F0 INTL 00000001)
[    0.000000] ACPI: BGRT 0x00000000BD1FB1D0 000038 (v00 LENOVO TC-03    00=
0010F0 AMI  00010013)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000033dffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x33dffffff]
[    0.000000]   NODE_DATA [mem 0x33dff7000-0x33dffbfff]
[    0.000000]  [ffffea0000000000-ffffea000cffffff] PMD -> [ffff88033160000=
0-ffff88033d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x33dffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xac83cfff]
[    0.000000]   node   0: [mem 0xac844000-0xad08bfff]
[    0.000000]   node   0: [mem 0xad2e2000-0xbcfe1fff]
[    0.000000]   node   0: [mem 0xbdfff000-0xbdffffff]
[    0.000000]   node   0: [mem 0x100000000-0x33dffffff]
[    0.000000] On node 0 totalpages: 3124514
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12023 pages used for memmap
[    0.000000]   DMA32 zone: 769414 pages, LIFO batch:31
[    0.000000]   Normal zone: 36736 pages used for memmap
[    0.000000]   Normal zone: 2351104 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xac83d000-0xac843fff]
[    0.000000] PM: Registered nosave memory: [mem 0xad08c000-0xad2e1fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbcfe2000-0xbd1e7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd1e8000-0xbd1fbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xbd1fc000-0xbdb86fff]
[    0.000000] PM: Registered nosave memory: [mem 0xbdb87000-0xbdffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbe000000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfecfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed00000-0xfed03fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xbe000000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:8 nr_=
node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff880330600000 s1919744 r8=
192 d21760 u2097152
[    0.000000] pcpu-alloc: s1919744 r8192 d21760 u2097152 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [0] 6 [0] 7=
=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 3075670
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=3D/boot/vmlinuz-3.15.0-rc4-f=
b+ root=3D/dev/sda1 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 12190544K/12498056K available (8935K kernel code, 12=
43K rwdata, 3860K rodata, 3132K init, 10060K bss, 307512K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D8, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D64 to nr_cpu_ids=3D8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_ids=
=3D8
[    0.000000] NR_IRQS:4352 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3392.263 MHz processor
[    0.000002] Calibrating delay loop (skipped), value calculated using tim=
er frequency.. 6784.52 BogoMIPS (lpj=3D3392263)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.000010] ACPI: Core revision 20140214
[    0.014962] ACPI: All ACPI Tables successfully acquired
[    0.018730] Security Framework initialized
[    0.018733] SELinux:  Initializing.
[    0.018759] SELinux:  Starting in permissive mode
[    0.020613] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.023332] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.024254] Mount-cache hash table entries: 32768 (order: 6, 262144 byte=
s)
[    0.024284] Mountpoint-cache hash table entries: 32768 (order: 6, 262144=
 bytes)
[    0.024796] Initializing cgroup subsys freezer
[    0.024826] CPU: Physical Processor ID: 0
[    0.024827] CPU: Processor Core ID: 0
[    0.024830] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.024830] ENERGY_PERF_BIAS: View and update with x86_energy_perf_polic=
y(8)
[    0.025544] mce: CPU supports 9 MCE banks
[    0.025554] CPU0: Thermal monitoring enabled (TM1)
[    0.025566] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
[    0.025566] Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.025566] tlb_flushall_shift: 6
[    0.025695] Freeing SMP alternatives memory: 24K (ffffffff82247000 - fff=
fffff8224d000)
[    0.026271] ftrace: allocating 31819 entries in 125 pages
[    0.034781] dmar: Host address width 39
[    0.034783] dmar: DRHD base: 0x000000fed90000 flags: 0x1
[    0.034795] dmar: IOMMU 0: reg_base_addr fed90000 ver 1:0 cap d2008c2066=
0462 ecap f010da
[    0.034797] dmar: RMRR base: 0x000000bd16f000 end: 0x000000bd17bfff
[    0.034864] IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
[    0.034865] HPET id 0 under DRHD base 0xfed90000
[    0.034925] Enabled IRQ remapping in xapic mode
[    0.035405] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.045411] smpboot: CPU0: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (fam:=
 06, model: 3c, stepping: 03)
[    0.045418] TSC deadline timer enabled
[    0.045431] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events,=
 full-width counters, Intel PMU driver.
[    0.045439] ... version:                3
[    0.045440] ... bit width:              48
[    0.045441] ... generic registers:      4
[    0.045441] ... value mask:             0000ffffffffffff
[    0.045442] ... max period:             0000ffffffffffff
[    0.045443] ... fixed-purpose events:   3
[    0.045443] ... event mask:             000000070000000f
[    0.046364] x86: Booting SMP configuration:
[    0.046366] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.144086] x86: Booted up 1 node, 8 CPUs
[    0.144089] smpboot: Total of 8 processors activated (54276.20 BogoMIPS)
[    0.150704] devtmpfs: initialized
[    0.151038] PM: Registering ACPI NVS region [mem 0xac83d000-0xac843fff] =
(28672 bytes)
[    0.151039] PM: Registering ACPI NVS region [mem 0xbd1fc000-0xbdb86fff] =
(10006528 bytes)
[    0.151445] kworker/u16:0 (42) used greatest stack depth: 5152 bytes left
[    0.152031] xor: automatically using best checksumming function:
[    0.161267]    avx       : 32472.000 MB/sec
[    0.161269] pinctrl core: initialized pinctrl subsystem
[    0.161373] RTC time: 20:11:11, date: 05/06/14
[    0.161475] NET: Registered protocol family 16
[    0.161700] cpuidle: using governor ladder
[    0.161701] cpuidle: using governor menu
[    0.161736] ACPI FADT declares the system doesn't support PCIe ASPM, so =
disable it
[    0.161742] ACPI: bus type PCI registered
[    0.161764] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000=
-0xfbffffff] (base 0xf8000000)
[    0.161765] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.167875] PCI: Using configuration type 1 for base access
[    0.168239] mtrr: your CPUs had inconsistent fixed MTRR settings
[    0.168240] mtrr: probably your BIOS does not setup all CPUs.
[    0.168241] mtrr: corrected configuration.
[    0.189340] raid6: sse2x1   11730 MB/s
[    0.206381] raid6: sse2x2   14738 MB/s
[    0.223419] raid6: sse2x4   17214 MB/s
[    0.240455] raid6: avx2x1   22851 MB/s
[    0.257490] raid6: avx2x2   26339 MB/s
[    0.274528] raid6: avx2x4   30796 MB/s
[    0.274529] raid6: using algorithm avx2x4 (30796 MB/s)
[    0.274530] raid6: using avx2x2 recovery algorithm
[    0.274599] ACPI: Added _OSI(Module Device)
[    0.274601] ACPI: Added _OSI(Processor Device)
[    0.274602] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.274603] ACPI: Added _OSI(Processor Aggregator Device)
[    0.287151] ACPI: Executed 1 blocks of module-level executable AML code
[    0.292099] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.296708] ACPI: SSDT 0x00000000BD1DDC18 0003D3 (v01 PmRef  Cpu0Cst  00=
003001 INTL 20051117)
[    0.298347] ACPI: Dynamic OEM Table Load:
[    0.298348] ACPI: SSDT 0x0000000000000000 0003D3 (v01 PmRef  Cpu0Cst  00=
003001 INTL 20051117)
[    0.303940] ACPI: SSDT 0x00000000BD1DD618 0005AA (v01 PmRef  ApIst    00=
003000 INTL 20051117)
[    0.305789] ACPI: Dynamic OEM Table Load:
[    0.305791] ACPI: SSDT 0x0000000000000000 0005AA (v01 PmRef  ApIst    00=
003000 INTL 20051117)
[    0.310793] ACPI: SSDT 0x00000000BD1DCD98 000119 (v01 PmRef  ApCst    00=
003000 INTL 20051117)
[    0.312472] ACPI: Dynamic OEM Table Load:
[    0.312473] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00=
003000 INTL 20051117)
[    0.318483] ACPI: Interpreter enabled
[    0.318488] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20140214/hwxface-580)
[    0.318491] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20140214/hwxface-580)
[    0.318515] ACPI: (supports S0 S3 S4 S5)
[    0.318516] ACPI: Using IOAPIC for interrupt routing
[    0.318550] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.334374] ACPI: Power Resource [FN00] (off)
[    0.334564] ACPI: Power Resource [FN01] (off)
[    0.334718] ACPI: Power Resource [FN02] (off)
[    0.334879] ACPI: Power Resource [FN03] (off)
[    0.335032] ACPI: Power Resource [FN04] (off)
[    0.336944] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.336948] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM Cloc=
kPM Segments MSI]
[    0.337254] acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplu=
g PME]
[    0.337445] acpi PNP0A08:00: _OSC: OS now controls [AER PCIeCapability]
[    0.338146] PCI host bridge to bus 0000:00
[    0.338148] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.338149] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.338150] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.338152] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.338152] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3ff=
f]
[    0.338153] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7ff=
f]
[    0.338154] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbff=
f]
[    0.338155] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dfff=
f]
[    0.338156] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3ff=
f]
[    0.338157] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7ff=
f]
[    0.338158] pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfeaffff=
f]
[    0.338178] pci 0000:00:00.0: [8086:0c00] type 00 class 0x060000
[    0.338367] pci 0000:00:01.0: [8086:0c01] type 01 class 0x060400
[    0.338417] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.338544] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.338675] pci 0000:00:14.0: [8086:8c31] type 00 class 0x0c0330
[    0.338711] pci 0000:00:14.0: reg 0x10: [mem 0xf3300000-0xf330ffff 64bit]
[    0.338832] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.338913] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.338998] pci 0000:00:16.0: [8086:8c3a] type 00 class 0x078000
[    0.339032] pci 0000:00:16.0: reg 0x10: [mem 0xf331b000-0xf331b00f 64bit]
[    0.339148] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.339322] pci 0000:00:1a.0: [8086:8c2d] type 00 class 0x0c0320
[    0.339352] pci 0000:00:1a.0: reg 0x10: [mem 0xf3318000-0xf33183ff]
[    0.339493] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.339592] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.339681] pci 0000:00:1b.0: [8086:8c20] type 00 class 0x040300
[    0.339708] pci 0000:00:1b.0: reg 0x10: [mem 0xf3310000-0xf3313fff 64bit]
[    0.339843] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.339925] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.340006] pci 0000:00:1c.0: [8086:8c10] type 01 class 0x060400
[    0.340139] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.340225] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.340314] pci 0000:00:1c.5: [8086:8c1a] type 01 class 0x060400
[    0.340444] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.340529] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.340612] pci 0000:00:1c.7: [8086:8c1e] type 01 class 0x060400
[    0.340743] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.340834] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.340921] pci 0000:00:1d.0: [8086:8c26] type 00 class 0x0c0320
[    0.340953] pci 0000:00:1d.0: reg 0x10: [mem 0xf3317000-0xf33173ff]
[    0.341093] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.341190] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.341274] pci 0000:00:1f.0: [8086:8c50] type 00 class 0x060100
[    0.341566] pci 0000:00:1f.2: [8086:8c02] type 00 class 0x010601
[    0.341597] pci 0000:00:1f.2: reg 0x10: [io  0xf070-0xf077]
[    0.341609] pci 0000:00:1f.2: reg 0x14: [io  0xf060-0xf063]
[    0.341620] pci 0000:00:1f.2: reg 0x18: [io  0xf050-0xf057]
[    0.341633] pci 0000:00:1f.2: reg 0x1c: [io  0xf040-0xf043]
[    0.341646] pci 0000:00:1f.2: reg 0x20: [io  0xf020-0xf03f]
[    0.341659] pci 0000:00:1f.2: reg 0x24: [mem 0xf3316000-0xf33167ff]
[    0.341736] pci 0000:00:1f.2: PME# supported from D3hot
[    0.341892] pci 0000:00:1f.3: [8086:8c22] type 00 class 0x0c0500
[    0.341918] pci 0000:00:1f.3: reg 0x10: [mem 0xf3315000-0xf33150ff 64bit]
[    0.341955] pci 0000:00:1f.3: reg 0x20: [io  0xf000-0xf01f]
[    0.342197] pci 0000:01:00.0: [10de:0fc6] type 00 class 0x030000
[    0.342213] pci 0000:01:00.0: reg 0x10: [mem 0xf2000000-0xf2ffffff]
[    0.342230] pci 0000:01:00.0: reg 0x14: [mem 0xe0000000-0xefffffff 64bit=
 pref]
[    0.342247] pci 0000:01:00.0: reg 0x1c: [mem 0xf0000000-0xf1ffffff 64bit=
 pref]
[    0.342258] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.342269] pci 0000:01:00.0: reg 0x30: [mem 0xf3000000-0xf307ffff pref]
[    0.342371] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.342457] pci 0000:01:00.1: [10de:0e1b] type 00 class 0x040300
[    0.342472] pci 0000:01:00.1: reg 0x10: [mem 0xf3080000-0xf3083fff]
[    0.343857] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.343860] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.343862] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf30fffff]
[    0.343981] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.344129] pci 0000:03:00.0: [10ec:8168] type 00 class 0x020000
[    0.344152] pci 0000:03:00.0: reg 0x10: [io  0xd000-0xd0ff]
[    0.344192] pci 0000:03:00.0: reg 0x18: [mem 0xf3204000-0xf3204fff 64bit=
 pref]
[    0.344217] pci 0000:03:00.0: reg 0x20: [mem 0xf3200000-0xf3203fff 64bit=
 pref]
[    0.344347] pci 0000:03:00.0: supports D1 D2
[    0.344348] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.344395] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.345864] pci 0000:00:1c.5: PCI bridge to [bus 03]
[    0.345869] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.345874] pci 0000:00:1c.5:   bridge window [mem 0xf3200000-0xf32fffff]
[    0.346024] pci 0000:04:00.0: [10ec:8179] type 00 class 0x028000
[    0.346048] pci 0000:04:00.0: reg 0x10: [io  0xc000-0xc0ff]
[    0.346091] pci 0000:04:00.0: reg 0x18: [mem 0xf3100000-0xf3103fff 64bit]
[    0.346242] pci 0000:04:00.0: supports D1 D2
[    0.346243] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.346286] pci 0000:04:00.0: System wakeup disabled by ACPI
[    0.347900] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.347905] pci 0000:00:1c.7:   bridge window [io  0xc000-0xcfff]
[    0.347910] pci 0000:00:1c.7:   bridge window [mem 0xf3100000-0xf31fffff]
[    0.347961] acpi PNP0A08:00: Disabling ASPM (FADT indicates it is unsupp=
orted)
[    0.348816] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.348895] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    0.348965] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *10 11 12 14 1=
5)
[    0.349037] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 1=
5)
[    0.349105] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15=
) *0, disabled.
[    0.349173] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15=
) *0, disabled.
[    0.349241] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 *4 5 6 10 11 12 14 1=
5)
[    0.349309] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 14 1=
5)
[    0.349627] ACPI: Enabled 4 GPEs in block 00 to 3F
[    0.349907] vgaarb: device added: PCI:0000:01:00.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.349910] vgaarb: loaded
[    0.349911] vgaarb: bridge control possible 0000:01:00.0
[    0.349987] SCSI subsystem initialized
[    0.350017] libata version 3.00 loaded.
[    0.350070] ACPI: bus type USB registered
[    0.350102] usbcore: registered new interface driver usbfs
[    0.350121] usbcore: registered new interface driver hub
[    0.350166] usbcore: registered new device driver usb
[    0.350200] pps_core: LinuxPPS API ver. 1 registered
[    0.350201] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.350207] PTP clock support registered
[    0.350276] wmi: Mapper loaded
[    0.350350] Advanced Linux Sound Architecture Driver Initialized.
[    0.350351] PCI: Using ACPI for IRQ routing
[    0.351814] PCI: pci_cache_line_size set to 64 bytes
[    0.351878] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.351881] e820: reserve RAM buffer [mem 0xac83d000-0xafffffff]
[    0.351883] e820: reserve RAM buffer [mem 0xad08c000-0xafffffff]
[    0.351884] e820: reserve RAM buffer [mem 0xbcfe2000-0xbfffffff]
[    0.351885] e820: reserve RAM buffer [mem 0xbe000000-0xbfffffff]
[    0.351887] e820: reserve RAM buffer [mem 0x33e000000-0x33fffffff]
[    0.352331] NetLabel: Initializing
[    0.352333] NetLabel:  domain hash size =3D 128
[    0.352334] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.352335] cfg80211: Calling CRDA to update world regulatory domain
[    0.352397] NetLabel:  unlabeled traffic allowed by default
[    0.352517] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.352521] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.354578] Switched to clocksource hpet
[    0.386377] pnp: PnP ACPI init
[    0.386413] ACPI: bus type PNP registered
[    0.386576] system 00:00: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.386614] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.386628] pnp 00:01: [dma 4]
[    0.386669] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.386716] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    0.386832] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.386990] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.386994] system 00:04: [io  0xffff] has been reserved
[    0.386996] system 00:04: [io  0xffff] has been reserved
[    0.386997] system 00:04: [io  0xffff] has been reserved
[    0.386998] system 00:04: [io  0x1c00-0x1cfe] has been reserved
[    0.387000] system 00:04: [io  0x1d00-0x1dfe] has been reserved
[    0.387001] system 00:04: [io  0x1e00-0x1efe] has been reserved
[    0.387003] system 00:04: [io  0x1f00-0x1ffe] has been reserved
[    0.387004] system 00:04: [io  0x1800-0x18fe] could not be reserved
[    0.387006] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.387009] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.387071] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.387158] system 00:06: [io  0x1854-0x1857] has been reserved
[    0.387161] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02=
 (active)
[    0.387322] system 00:07: [io  0x0a00-0x0a1f] has been reserved
[    0.387323] system 00:07: [io  0x0a30-0x0a3f] has been reserved
[    0.387325] system 00:07: [io  0x0a20-0x0a2f] has been reserved
[    0.387327] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.387613] pnp 00:08: [dma 0 disabled]
[    0.387689] pnp 00:08: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.387777] system 00:09: [io  0x04d0-0x04d1] has been reserved
[    0.387780] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.387836] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.388447] system 00:0b: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.388449] system 00:0b: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.388450] system 00:0b: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.388452] system 00:0b: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.388453] system 00:0b: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.388455] system 00:0b: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.388457] system 00:0b: [mem 0xfed90000-0xfed93fff] could not be reser=
ved
[    0.388458] system 00:0b: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.388459] system 00:0b: [mem 0xff000000-0xffffffff] has been reserved
[    0.388461] system 00:0b: [mem 0xfee00000-0xfeefffff] could not be reser=
ved
[    0.388463] system 00:0b: [mem 0xf7fef000-0xf7feffff] has been reserved
[    0.388464] system 00:0b: [mem 0xf7ff0000-0xf7ff0fff] has been reserved
[    0.388467] system 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.388835] pnp: PnP ACPI: found 12 devices
[    0.388836] ACPI: bus type PNP unregistered
[    0.397768] pci 0000:00:1c.0: bridge window [io  0x1000-0x0fff] to [bus =
02] add_size 1000
[    0.397771] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff 6=
4bit pref] to [bus 02] add_size 200000
[    0.397772] pci 0000:00:1c.0: bridge window [mem 0x00100000-0x000fffff] =
to [bus 02] add_size 200000
[    0.397796] pci 0000:00:1c.0: res[8]=3D[mem 0x00100000-0x000fffff] get_r=
es_add_size add_size 200000
[    0.397798] pci 0000:00:1c.0: res[9]=3D[mem 0x00100000-0x000fffff 64bit =
pref] get_res_add_size add_size 200000
[    0.397799] pci 0000:00:1c.0: res[7]=3D[io  0x1000-0x0fff] get_res_add_s=
ize add_size 1000
[    0.397803] pci 0000:00:1c.0: BAR 8: assigned [mem 0xc0000000-0xc01fffff]
[    0.397809] pci 0000:00:1c.0: BAR 9: assigned [mem 0xc0200000-0xc03fffff=
 64bit pref]
[    0.397811] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    0.397813] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.397815] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.397818] pci 0000:00:01.0:   bridge window [mem 0xe0000000-0xf30fffff]
[    0.397823] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.397825] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.397831] pci 0000:00:1c.0:   bridge window [mem 0xc0000000-0xc01fffff]
[    0.397836] pci 0000:00:1c.0:   bridge window [mem 0xc0200000-0xc03fffff=
 64bit pref]
[    0.397844] pci 0000:00:1c.5: PCI bridge to [bus 03]
[    0.397847] pci 0000:00:1c.5:   bridge window [io  0xd000-0xdfff]
[    0.397853] pci 0000:00:1c.5:   bridge window [mem 0xf3200000-0xf32fffff]
[    0.397865] pci 0000:00:1c.7: PCI bridge to [bus 04]
[    0.397868] pci 0000:00:1c.7:   bridge window [io  0xc000-0xcfff]
[    0.397874] pci 0000:00:1c.7:   bridge window [mem 0xf3100000-0xf31fffff]
[    0.397885] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.397886] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.397887] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.397888] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    0.397889] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    0.397890] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    0.397891] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    0.397892] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    0.397893] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    0.397894] pci_bus 0000:00: resource 13 [mem 0xc0000000-0xfeafffff]
[    0.397895] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.397896] pci_bus 0000:01: resource 1 [mem 0xe0000000-0xf30fffff]
[    0.397897] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
[    0.397898] pci_bus 0000:02: resource 1 [mem 0xc0000000-0xc01fffff]
[    0.397899] pci_bus 0000:02: resource 2 [mem 0xc0200000-0xc03fffff 64bit=
 pref]
[    0.397900] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.397901] pci_bus 0000:03: resource 1 [mem 0xf3200000-0xf32fffff]
[    0.397902] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.397903] pci_bus 0000:04: resource 1 [mem 0xf3100000-0xf31fffff]
[    0.397940] NET: Registered protocol family 2
[    0.398314] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.398988] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    0.401411] TCP: Hash tables configured (established 131072 bind 65536)
[    0.401434] TCP: reno registered
[    0.401614] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
[    0.402395] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
[    0.403173] NET: Registered protocol family 1
[    0.403334] RPC: Registered named UNIX socket transport module.
[    0.403335] RPC: Registered udp transport module.
[    0.403336] RPC: Registered tcp transport module.
[    0.403337] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.435793] pci 0000:01:00.0: Boot video device
[    0.435812] PCI: CLS 64 bytes, default 64
[    0.435904] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.435906] software IO TLB [mem 0xb8fe2000-0xbcfe2000] (64MB) mapped at=
 [ffff8800b8fe2000-ffff8800bcfe1fff]
[    0.436645] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 J=
oules, 4 fixed counters 655360 ms ovfl timer
[    0.436757] microcode: CPU0 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436770] microcode: CPU1 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436780] microcode: CPU2 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436791] microcode: CPU3 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436802] microcode: CPU4 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436814] microcode: CPU5 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436823] microcode: CPU6 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436833] microcode: CPU7 sig=3D0x306c3, pf=3D0x2, revision=3D0x8
[    0.436928] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    0.438151] Scanning for low memory corruption every 60 seconds
[    0.438753] futex hash table entries: 2048 (order: 6, 262144 bytes)
[    0.438837] Initialise system trusted keyring
[    0.438877] audit: initializing netlink subsys (disabled)
[    0.438899] audit: type=3D2000 audit(1399407071.413:1): initialized
[    0.456329] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.460553] VFS: Disk quotas dquot_6.5.2
[    0.460641] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.461221] NFS: Registering the id_resolver key type
[    0.461232] Key type id_resolver registered
[    0.461233] Key type id_legacy registered
[    0.461307] msgmni has been set to 23809
[    0.461443] SELinux:  Registering netfilter hooks
[    0.462096] Key type asymmetric registered
[    0.462104] Asymmetric key parser 'x509' registered
[    0.462121] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    0.462128] io scheduler noop registered
[    0.462129] io scheduler deadline registered
[    0.462196] io scheduler cfq registered (default)
[    0.462905] pcieport 0000:00:01.0: irq 41 for MSI/MSI-X
[    0.463666] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.463776] intel_idle: MWAIT substates: 0x42120
[    0.463777] intel_idle: v0.4 model 0x3C
[    0.463778] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.464722] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
C0C:00/input/input0
[    0.464739] ACPI: Power Button [PWRB]
[    0.464826] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input1
[    0.464828] ACPI: Power Button [PWRF]
[    0.464965] ACPI: Fan [FAN0] (off)
[    0.465025] ACPI: Fan [FAN1] (off)
[    0.465080] ACPI: Fan [FAN2] (off)
[    0.465134] ACPI: Fan [FAN3] (off)
[    0.465190] ACPI: Fan [FAN4] (off)
[    0.466424] thermal LNXTHERM:00: registered as thermal_zone0
[    0.466425] ACPI: Thermal Zone [TZ00] (28 C)
[    0.466870] thermal LNXTHERM:01: registered as thermal_zone1
[    0.466871] ACPI: Thermal Zone [TZ01] (30 C)
[    0.466979] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.487683] 00:08: ttyS1 at I/O 0x2f8 (irq =3D 3, base_baud =3D 115200) =
is a 16550A
[    0.488773] Non-volatile memory driver v1.3
[    0.488775] Linux agpgart interface v0.103
[    0.488824] [drm] Initialized drm 1.1.0 20060810
[    0.489524] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0e7060a2
[    0.489526] nouveau  [  DEVICE][0000:01:00.0] Chipset: GK107 (NVE7)
[    0.489527] nouveau  [  DEVICE][0000:01:00.0] Family : NVE0
[    0.491235] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image.=
=2E.
[    0.491240] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    0.491241] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[    0.529035] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    0.529036] nouveau  [   VBIOS][0000:01:00.0] using image from PROM
[    0.529099] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    0.529101] nouveau  [   VBIOS][0000:01:00.0] version 80.07.58.00.22
[    0.529730] nouveau 0000:01:00.0: irq 42 for MSI/MSI-X
[    0.529740] nouveau  [     PMC][0000:01:00.0] MSI interrupts enabled
[    0.529801] nouveau  [     PFB][0000:01:00.0] RAM type: GDDR5
[    0.529802] nouveau  [     PFB][0000:01:00.0] RAM size: 2048 MiB
[    0.529803] nouveau  [     PFB][0000:01:00.0]    ZCOMP: 0 tags
[    1.177944] nouveau  [  PTHERM][0000:01:00.0] FAN control: PWM
[    1.177959] nouveau  [  PTHERM][0000:01:00.0] fan management: automatic
[    1.178025] nouveau  [  PTHERM][0000:01:00.0] internal sensor: yes
[    1.178070] nouveau  [     CLK][0000:01:00.0] 07: core 324 MHz memory 64=
8 MHz=20
[    1.178076] nouveau  [     CLK][0000:01:00.0] 0a: core 540 MHz memory 16=
20 MHz=20
[    1.178080] nouveau  [     CLK][0000:01:00.0] 0f: core 1058 MHz memory 5=
000 MHz=20
[    1.178218] nouveau  [     CLK][0000:01:00.0] --: core 324 MHz memory 64=
8 MHz=20
[    1.211303] [TTM] Zone  kernel: Available graphics memory: 6095284 kiB
[    1.211304] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    1.211305] [TTM] Initializing pool allocator
[    1.211316] [TTM] Initializing DMA pool allocator
[    1.211355] nouveau  [     DRM] VRAM: 2048 MiB
[    1.211355] nouveau  [     DRM] GART: 1048576 MiB
[    1.211358] nouveau  [     DRM] TMDS table version 2.0
[    1.211359] nouveau  [     DRM] DCB version 4.0
[    1.211360] nouveau  [     DRM] DCB outp 00: 02000f00 00000000
[    1.211361] nouveau  [     DRM] DCB outp 01: 01000f02 00020030
[    1.211362] nouveau  [     DRM] DCB outp 02: 08011f82 00020030
[    1.211363] nouveau  [     DRM] DCB outp 03: 02022f62 00020010
[    1.211364] nouveau  [     DRM] DCB conn 00: 00001030
[    1.211365] nouveau  [     DRM] DCB conn 01: 00002131
[    1.211366] nouveau  [     DRM] DCB conn 02: 00010263
[    1.212929] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    1.212939] [drm] Driver supports precise vblank timestamp query.
[    1.219234] nouveau  [     DRM] MM: using COPY for buffer copies
[    1.354060] nouveau  [     DRM] allocated 1920x1080 fb: 0x80000, bo ffff=
88032def8000
[    1.354336] fbcon: nouveaufb (fb0) is primary device
[    1.438076] tsc: Refined TSC clocksource calibration: 3392.145 MHz
[    1.489839] Console: switching to colour frame buffer device 240x67
[    1.492913] nouveau 0000:01:00.0: fb0: nouveaufb frame buffer device
[    1.492914] nouveau 0000:01:00.0: registered panic notifier
[    1.492924] [drm] Initialized nouveau 1.1.1 20120801 for 0000:01:00.0 on=
 minor 0
[    1.494866] loop: module loaded
[    1.495203]  nullb0: unknown partition table
[    1.495504]  nullb1: unknown partition table
[    1.495644] null: module loaded
[    1.495798] ahci 0000:00:1f.2: version 3.0
[    1.495989] ahci 0000:00:1f.2: irq 43 for MSI/MSI-X
[    1.496064] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x=
15 impl SATA mode
[    1.496076] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part=
 ems apst=20
[    1.502800] scsi0 : ahci
[    1.503210] scsi1 : ahci
[    1.503469] scsi2 : ahci
[    1.503694] scsi3 : ahci
[    1.503873] scsi4 : ahci
[    1.504048] scsi5 : ahci
[    1.504173] ata1: SATA max UDMA/133 abar m2048@0xf3316000 port 0xf331610=
0 irq 43
[    1.504174] ata2: DUMMY
[    1.504176] ata3: SATA max UDMA/133 abar m2048@0xf3316000 port 0xf331620=
0 irq 43
[    1.504177] ata4: DUMMY
[    1.504179] ata5: SATA max UDMA/133 abar m2048@0xf3316000 port 0xf331630=
0 irq 43
[    1.504180] ata6: DUMMY
[    1.504259] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    1.504268] r8169 0000:03:00.0: can't disable ASPM; OS doesn't have ASPM=
 control
[    1.504546] r8169 0000:03:00.0: irq 44 for MSI/MSI-X
[    1.504822] r8169 0000:03:00.0 eth0: RTL8168f/8111f at 0xffffc900063be00=
0, d4:3d:7e:aa:a9:73, XID 08000800 IRQ 44
[    1.504824] r8169 0000:03:00.0 eth0: jumbo features [frames: 9200 bytes,=
 tx checksumming: ko]
[    1.512699] rtl8188ee: Using firmware rtlwifi/rtl8188efw.bin
[    1.512761] rtl8188ee 0000:04:00.0: Direct firmware load failed with err=
or -2
[    1.512762] rtl8188ee 0000:04:00.0: Falling back to user helper
[    1.512946] rtl8188ee 0000:04:00.0: irq 45 for MSI/MSI-X
[    1.513417] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.515721] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.515739] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.516114] mousedev: PS/2 mouse device common for all mice
[    1.516615] rtc_cmos 00:05: RTC can wake from S4
[    1.516869] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    1.516900] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram=
, hpet irqs
[    1.517113] ACPI Warning: SystemIO range 0x000000000000f000-0x0000000000=
00f01f conflicts with OpRegion 0x000000000000f000-0x000000000000f00f (\_SB_=
=2EPCI0.SBUS.SMBI) (20140214/utaddress-258)
[    1.517117] ACPI: If an ACPI driver is available for this device, you sh=
ould use it instead of the native driver
[    1.517146] Intel P-state driver initializing.
[    1.517167] Intel pstate controlling: cpu 0
[    1.517251] Intel pstate controlling: cpu 1
[    1.517281] Intel pstate controlling: cpu 2
[    1.517311] Intel pstate controlling: cpu 3
[    1.517340] Intel pstate controlling: cpu 4
[    1.517371] Intel pstate controlling: cpu 5
[    1.517400] Intel pstate controlling: cpu 6
[    1.517430] Intel pstate controlling: cpu 7
[    1.517520] hidraw: raw HID events driver (C) Jiri Kosina
[    1.517820] usbcore: registered new interface driver usbhid
[    1.517821] usbhid: USB HID core driver
[    1.518972] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[    1.519146] snd_hda_intel 0000:01:00.1: Disabling MSI
[    1.519247] Netfilter messages via NETLINK v0.30.
[    1.519283] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    1.519525] ctnetlink v0.93: registering with nfnetlink.
[    1.519645] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.519679] TCP: cubic registered
[    1.519680] Initializing XFRM netlink socket
[    1.520000] NET: Registered protocol family 10
[    1.520549] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    1.520617] sit: IPv6 over IPv4 tunneling driver
[    1.520837] NET: Registered protocol family 17
[    1.520875] Key type dns_resolver registered
[    1.521805] Loading compiled-in X.509 certificates
[    1.522391] Loaded X.509 cert 'Magrathea: Glacier signing key: 7c01336ad=
3788355ed0bb359cf7ab8914de51bd9'
[    1.522410] registered taskstats version 1
[    1.523532] Btrfs loaded
[    1.524268]   Magic number: 14:182:194
[    1.524327] console [netcon0] enabled
[    1.524328] netconsole: network logging started
[    1.524479] PM: Hibernation image not present or could not be loaded.
[    1.524480] ALSA device list:
[    1.524481]   No soundcards found.
[    1.527690] sound hdaudioC0D0: autoconfig: line_outs=3D3 (0x14/0x15/0x16=
/0x0/0x0) type:line
[    1.527692] sound hdaudioC0D0:    speaker_outs=3D0 (0x0/0x0/0x0/0x0/0x0)
[    1.527693] sound hdaudioC0D0:    hp_outs=3D1 (0x1b/0x0/0x0/0x0/0x0)
[    1.527694] sound hdaudioC0D0:    mono: mono_out=3D0x0
[    1.527695] sound hdaudioC0D0:    dig-out=3D0x1e/0x0
[    1.527695] sound hdaudioC0D0:    inputs:
[    1.527698] sound hdaudioC0D0:      Front Mic=3D0x19
[    1.527700] sound hdaudioC0D0:      Rear Mic=3D0x18
[    1.527701] sound hdaudioC0D0:      Line=3D0x1a
[    1.676293] snd_hda_intel 0000:01:00.1: Too many HDMI devices
[    1.676295] snd_hda_intel 0000:01:00.1: Consider building the kernel wit=
h CONFIG_SND_DYNAMIC_MINORS=3Dy
[    1.809271] ata5: SATA link down (SStatus 0 SControl 300)
[    1.809299] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.809344] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.810588] ata1.00: ATA-8: ST2000DM001-1CH164, CC76, max UDMA/100
[    1.810591] ata1.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 31/3=
2), AA
[    1.811502] ata1.00: configured for UDMA/100
[    1.811897] scsi 0:0:0:0: Direct-Access     ATA      ST2000DM001-1CH1 CC=
76 PQ: 0 ANSI: 5
[    1.812536] sd 0:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[    1.812539] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    1.812712] sd 0:0:0:0: [sda] Write Protect is off
[    1.812714] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.812735] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.812777] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    1.824919] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0140214/psargs-359)
[    1.824929] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT2._GTF] (Node ffff88033006eb68), AE_NOT_FOUND (20140214/psparse-536)
[    1.824945] ata3.00: ATAPI: MATSHITA DVD-RAM SW820, 8.41, max UDMA/100
[    1.847347] ACPI Error: [DSSP] Namespace lookup failure, AE_NOT_FOUND (2=
0140214/psargs-359)
[    1.847362] ACPI Error: Method parse/execution failed [\_SB_.PCI0.SAT0.S=
PT2._GTF] (Node ffff88033006eb68), AE_NOT_FOUND (20140214/psparse-536)
[    1.847389] ata3.00: configured for UDMA/100
[    1.855856]  sda: sda1 sda2 < sda5 >
[    1.857501] scsi 2:0:0:0: CD-ROM            MATSHITA DVD-RAM SW820    8.=
41 PQ: 0 ANSI: 5
[    1.857641] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.894000] sr0: scsi3-mmc drive: 40x/40x writer dvd-ram cd/rw xa/form2 =
cdda tray
[    1.894006] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.894765] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    1.895037] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    1.971543] BTRFS: device fsid e52e795b-b5cf-4f23-8321-49824d04b90c devi=
d 1 transid 450262 /dev/root
[    1.974728] BTRFS info (device sda1): disk space caching is enabled
[    1.987081] input: HDA NVidia HDMI/DP,pcm=3D3 as /devices/pci0000:00/000=
0:00:01.0/0000:01:00.1/sound/card1/input3
[    1.988114] input: HDA NVidia HDMI/DP,pcm=3D7 as /devices/pci0000:00/000=
0:00:01.0/0000:01:00.1/sound/card1/input5
[    1.989002] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:01.=
0/0000:01:00.1/sound/card1/input7
[    2.356901] VFS: Mounted root (btrfs filesystem) readonly on device 0:16.
[    2.368537] devtmpfs: mounted
[    2.372374] Freeing unused kernel memory: 3132K (ffffffff81f38000 - ffff=
ffff82247000)
[    2.372381] Write protecting the kernel read-only data: 14336k
[    2.382193] Freeing unused kernel memory: 1292K (ffff8800018bd000 - ffff=
880001a00000)
[    2.383638] Freeing unused kernel memory: 236K (ffff880001dc5000 - ffff8=
80001e00000)
[    2.392499] random: nonblocking pool is initialized
[    2.439295] Switched to clocksource tsc
[    2.550258] input: HDA Intel PCH Front Mic as /devices/pci0000:00/0000:0=
0:1b.0/sound/card0/input8
[    2.550900] input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000:00=
:1b.0/sound/card0/input9
[    2.551634] input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:1b.=
0/sound/card0/input10
[    2.552332] input: HDA Intel PCH Line Out Front as /devices/pci0000:00/0=
000:00:1b.0/sound/card0/input11
[    2.552964] input: HDA Intel PCH Line Out Surround as /devices/pci0000:0=
0/0000:00:1b.0/sound/card0/input12
[    2.553701] input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00/00=
00:00:1b.0/sound/card0/input13
[    2.554403] input: HDA Intel PCH Front Headphone as /devices/pci0000:00/=
0000:00:1b.0/sound/card0/input14
[    3.240409] stty (1200) used greatest stack depth: 3480 bytes left
[    4.903751] systemd-udevd[1308]: starting version 204
[    6.180464] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.209298] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    6.214706] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 1
[    6.215210] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    6.215470] xhci_hcd 0000:00:14.0: irq 47 for MSI/MSI-X
[    6.217303] usb usb1: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    6.217314] usb usb1: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.217321] usb usb1: Product: xHCI Host Controller
[    6.217329] usb usb1: Manufacturer: Linux 3.15.0-rc4-fb+ xhci_hcd
[    6.217336] usb usb1: SerialNumber: 0000:00:14.0
[    6.239228] hub 1-0:1.0: USB hub found
[    6.239454] hub 1-0:1.0: 12 ports detected
[    6.294549] ehci-pci: EHCI PCI platform driver
[    6.335290] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    6.342968] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus =
number 2
[    6.343583] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0003
[    6.343596] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.343604] usb usb2: Product: xHCI Host Controller
[    6.343613] usb usb2: Manufacturer: Linux 3.15.0-rc4-fb+ xhci_hcd
[    6.343620] usb usb2: SerialNumber: 0000:00:14.0
[    6.373456] hub 2-0:1.0: USB hub found
[    6.373633] hub 2-0:1.0: 6 ports detected
[    6.424666] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    6.429697] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus =
number 3
[    6.429757] ehci-pci 0000:00:1a.0: debug port 2
[    6.431057] modprobe (1364) used greatest stack depth: 3472 bytes left
[    6.433807] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    6.433932] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf3318000
[    6.439198] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    6.439471] usb usb3: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    6.439482] usb usb3: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.439491] usb usb3: Product: EHCI Host Controller
[    6.439499] usb usb3: Manufacturer: Linux 3.15.0-rc4-fb+ ehci_hcd
[    6.439506] usb usb3: SerialNumber: 0000:00:1a.0
[    6.455224] hub 3-0:1.0: USB hub found
[    6.455306] hub 3-0:1.0: 2 ports detected
[    6.469936] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    6.471554] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus =
number 4
[    6.471617] ehci-pci 0000:00:1d.0: debug port 2
[    6.475584] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    6.475710] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf3317000
[    6.481205] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    6.481683] usb usb4: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[    6.481694] usb usb4: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[    6.481703] usb usb4: Product: EHCI Host Controller
[    6.481711] usb usb4: Manufacturer: Linux 3.15.0-rc4-fb+ ehci_hcd
[    6.481718] usb usb4: SerialNumber: 0000:00:1d.0
[    6.489885] hub 4-0:1.0: USB hub found
[    6.489936] hub 4-0:1.0: 2 ports detected
[    6.594940] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[    6.597385] rtlwifi: wireless switch is on
[    6.671431] usb 1-1: new low-speed USB device number 2 using xhci_hcd
[    6.710431] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    6.710557] iTCO_wdt: Found a Lynx Point TCO device (Version=3D2, TCOBAS=
E=3D0x1860)
[    6.712088] iTCO_wdt: initialized. heartbeat=3D30 sec (nowayout=3D0)
[    6.840079] usb 1-1: New USB device found, idVendor=3D17ef, idProduct=3D=
602e
[    6.840089] usb 1-1: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    6.840094] usb 1-1: Product: USB Optical Mouse
[    6.840099] usb 1-1: Manufacturer: PixArt
[    6.841198] usb 1-1: ep 0x81 - rounding interval to 64 microframes, ep d=
esc says 80 microframes
[    6.846681] input: PixArt USB Optical Mouse as /devices/pci0000:00/0000:=
00:14.0/usb1/1-1/1-1:1.0/0003:17EF:602E.0001/input/input15
[    6.849318] hid-generic 0003:17EF:602E.0001: input,hidraw0: USB HID v1.1=
1 Mouse [PixArt USB Optical Mouse] on usb-0000:00:14.0-1/input0
[    7.003567] usb 1-2: new high-speed USB device number 3 using xhci_hcd
[    7.170522] usb 1-2: New USB device found, idVendor=3D2109, idProduct=3D=
2812
[    7.170537] usb 1-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    7.170545] usb 1-2: Product: USB2.0 Hub            =20
[    7.170553] usb 1-2: Manufacturer: VIA Labs, Inc.        =20
[    7.172116] hub 1-2:1.0: USB hub found
[    7.172362] hub 1-2:1.0: 4 ports detected
[    7.334693] usb 1-5: new high-speed USB device number 4 using xhci_hcd
[    7.498836] usb 1-5: New USB device found, idVendor=3D0424, idProduct=3D=
2412
[    7.498845] usb 1-5: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    7.500264] hub 1-5:1.0: USB hub found
[    7.500351] hub 1-5:1.0: 2 ports detected
[    7.654876] usb 1-6: new low-speed USB device number 5 using xhci_hcd
[    7.833768] usb 1-6: New USB device found, idVendor=3D17ef, idProduct=3D=
602d
[    7.833778] usb 1-6: New USB device strings: Mfr=3D0, Product=3D2, Seria=
lNumber=3D0
[    7.833783] usb 1-6: Product: Lenovo Black Silk USB Keyboard
[    7.834538] usb 1-6: ep 0x81 - rounding interval to 64 microframes, ep d=
esc says 80 microframes
[    7.834560] usb 1-6: ep 0x82 - rounding interval to 64 microframes, ep d=
esc says 80 microframes
[    7.842853] input: Lenovo Black Silk USB Keyboard as /devices/pci0000:00=
/0000:00:14.0/usb1/1-6/1-6:1.0/0003:17EF:602D.0002/input/input16
[    7.844043] hid-generic 0003:17EF:602D.0002: input,hidraw1: USB HID v1.1=
1 Keyboard [Lenovo Black Silk USB Keyboard] on usb-0000:00:14.0-6/input0
[    7.852345] input: Lenovo Black Silk USB Keyboard as /devices/pci0000:00=
/0000:00:14.0/usb1/1-6/1-6:1.1/0003:17EF:602D.0003/input/input17
[    7.853456] hid-generic 0003:17EF:602D.0003: input,hidraw2: USB HID v1.1=
1 Device [Lenovo Black Silk USB Keyboard] on usb-0000:00:14.0-6/input1
[    8.007867] usb 1-10: new high-speed USB device number 6 using xhci_hcd
[    8.181833] usb 1-10: New USB device found, idVendor=3D0bda, idProduct=
=3D0184
[    8.181898] usb 1-10: New USB device strings: Mfr=3D1, Product=3D2, Seri=
alNumber=3D3
[    8.181907] usb 1-10: Product: USB2.0-CRW
[    8.181915] usb 1-10: Manufacturer: Generic
[    8.181923] usb 1-10: SerialNumber: 20100818841300000
[    8.291509] usb 2-2: new SuperSpeed USB device number 2 using xhci_hcd
[    8.538801] usb 2-2: New USB device found, idVendor=3D2109, idProduct=3D=
0812
[    8.538812] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D0
[    8.538817] usb 2-2: Product: USB3.0 Hub            =20
[    8.538822] usb 2-2: Manufacturer: VIA Labs, Inc.        =20
[    8.540946] hub 2-2:1.0: USB hub found
[    8.541119] hub 2-2:1.0: 4 ports detected
[    8.646656] usb 2-6: new SuperSpeed USB device number 3 using xhci_hcd
[    8.658187] usb 2-6: New USB device found, idVendor=3D1679, idProduct=3D=
2001
[    8.658197] usb 2-6: New USB device strings: Mfr=3D1, Product=3D2, Seria=
lNumber=3D3
[    8.658203] usb 2-6: Product: Beagle USB 5000 SuperSpeed Protocol Analyz=
er
[    8.658208] usb 2-6: Manufacturer: Total Phase, Inc.
[    8.658212] usb 2-6: SerialNumber: TP1142-485697
[    8.741058] usb-storage 1-10:1.0: USB Mass Storage device detected
[    8.741707] scsi6 : usb-storage 1-10:1.0
[    8.745975] usbcore: registered new interface driver usb-storage
[    8.763229] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    8.797901] usbcore: registered new interface driver uas
[    8.877949] usb 3-1: New USB device found, idVendor=3D8087, idProduct=3D=
8008
[    8.877958] usb 3-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    8.879470] hub 3-1:1.0: USB hub found
[    8.879668] hub 3-1:1.0: 6 ports detected
[    8.986324] usb 4-1: new high-speed USB device number 2 using ehci-pci
[    9.100902] usb 4-1: New USB device found, idVendor=3D8087, idProduct=3D=
8000
[    9.100916] usb 4-1: New USB device strings: Mfr=3D0, Product=3D0, Seria=
lNumber=3D0
[    9.102442] hub 4-1:1.0: USB hub found
[    9.102685] hub 4-1:1.0: 6 ports detected
[    9.183533] usb 1-2.1: new high-speed USB device number 7 using xhci_hcd
[    9.272627] usb 1-2.1: New USB device found, idVendor=3D2109, idProduct=
=3D2812
[    9.272637] usb 1-2.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    9.272643] usb 1-2.1: Product: USB2.0 Hub            =20
[    9.272647] usb 1-2.1: Manufacturer: VIA Labs, Inc.        =20
[    9.275059] hub 1-2.1:1.0: USB hub found
[    9.275299] hub 1-2.1:1.0: 4 ports detected
[    9.358522] usb 1-5.1: new high-speed USB device number 8 using xhci_hcd
[    9.444437] usb 1-5.1: New USB device found, idVendor=3D05e3, idProduct=
=3D0610
[    9.444448] usb 1-5.1: New USB device strings: Mfr=3D0, Product=3D1, Ser=
ialNumber=3D0
[    9.444453] usb 1-5.1: Product: USB2.0 Hub
[    9.446505] hub 1-5.1:1.0: USB hub found
[    9.446903] hub 1-5.1:1.0: 4 ports detected
[    9.525517] usb 1-5.2: new high-speed USB device number 9 using xhci_hcd
[    9.609869] usb 1-5.2: New USB device found, idVendor=3D0424, idProduct=
=3D2412
[    9.609884] usb 1-5.2: New USB device strings: Mfr=3D0, Product=3D0, Ser=
ialNumber=3D0
[    9.612785] hub 1-5.2:1.0: USB hub found
[    9.612895] hub 1-5.2:1.0: 2 ports detected
[    9.678733] usb 2-2.1: new SuperSpeed USB device number 4 using xhci_hcd
[    9.751939] scsi 6:0:0:0: Direct-Access     Generic- Compact Flash    1.=
00 PQ: 0 ANSI: 0 CCS
[    9.754110] scsi 6:0:0:1: Direct-Access     Generic- Multi-Card       1.=
00 PQ: 0 ANSI: 0 CCS
[    9.758787] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    9.764549] sd 6:0:0:1: Attached scsi generic sg3 type 0
[    9.768177] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[    9.774220] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[    9.925765] usb 2-2.1: New USB device found, idVendor=3D2109, idProduct=
=3D0812
[    9.925776] usb 2-2.1: New USB device strings: Mfr=3D1, Product=3D2, Ser=
ialNumber=3D0
[    9.925782] usb 2-2.1: Product: USB3.0 Hub            =20
[    9.925786] usb 2-2.1: Manufacturer: VIA Labs, Inc.        =20
[    9.928225] hub 2-2.1:1.0: USB hub found
[    9.928497] hub 2-2.1:1.0: 4 ports detected
[   10.008005] usb 1-5.1.1: new high-speed USB device number 10 using xhci_=
hcd
[   10.070104] Adding 24995836k swap on /dev/sda5.  Priority:-1 extents:1 a=
cross:24995836k=20
[   10.083231] usb 1-5.1.1: New USB device found, idVendor=3D05e3, idProduc=
t=3D0610
[   10.083245] usb 1-5.1.1: New USB device strings: Mfr=3D0, Product=3D1, S=
erialNumber=3D0
[   10.083255] usb 1-5.1.1: Product: USB2.0 Hub
[   10.085726] hub 1-5.1.1:1.0: USB hub found
[   10.086041] hub 1-5.1.1:1.0: 4 ports detected
[   10.165049] usb 1-5.1.3: new high-speed USB device number 11 using xhci_=
hcd
[   10.220632] BTRFS info (device sda1): disk space caching is enabled
[   10.249365] usb 1-5.1.3: New USB device found, idVendor=3D0403, idProduc=
t=3D6010
[   10.249376] usb 1-5.1.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[   10.249381] usb 1-5.1.3: Product: Dual RS232-HS
[   10.249386] usb 1-5.1.3: Manufacturer: FTDI
[   10.317913] usb 2-2.1.1: new SuperSpeed USB device number 5 using xhci_h=
cd
[   10.329092] usb 2-2.1.1: LPM exit latency is zeroed, disabling LPM.
[   10.329586] usb 2-2.1.1: New USB device found, idVendor=3D0411, idProduc=
t=3D01de
[   10.329600] usb 2-2.1.1: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D3
[   10.329609] usb 2-2.1.1: Product: HD-PCTU3
[   10.329618] usb 2-2.1.1: Manufacturer: BUFFALO
[   10.329626] usb 2-2.1.1: SerialNumber: B2C1304066
[   10.332022] usb-storage 2-2.1.1:1.0: USB Mass Storage device detected
[   10.332916] scsi7 : usb-storage 2-2.1.1:1.0
[   11.337130] scsi 7:0:0:0: Direct-Access     BUFFALO  HD-PCTU3         00=
01 PQ: 0 ANSI: 6
[   11.339433] sd 7:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 =
TB/931 GiB)
[   11.339989] sd 7:0:0:0: [sdd] Write Protect is off
[   11.339999] sd 7:0:0:0: [sdd] Mode Sense: 1f 00 00 08
[   11.340349] sd 7:0:0:0: Attached scsi generic sg4 type 0
[   11.340531] sd 7:0:0:0: [sdd] No Caching mode page found
[   11.340559] sd 7:0:0:0: [sdd] Assuming drive cache: write through
[   11.668923]  sdd: unknown partition table
[   11.671766] sd 7:0:0:0: [sdd] Attached SCSI disk
[   11.854092] BTRFS: device label btrfs1 devid 1 transid 6484 /dev/sdd
[   13.629106] r8169 0000:03:00.0 eth0: link down
[   13.629162] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   13.629209] r8169 0000:03:00.0 eth0: link down
[   13.629374] ip (2587) used greatest stack depth: 2192 bytes left
[   15.981546] r8169 0000:03:00.0 eth0: link up
[   15.981576] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  239.589208]=20
[  239.589213] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
[  239.589214] [ INFO: possible circular locking dependency detected ]
[  239.589216] 3.15.0-rc4-fb+ #5 Not tainted
[  239.589217] -------------------------------------------------------
[  239.589218] swapper/1/0 is trying to acquire lock:
[  239.589219]  (&(&priv->lock)->rlock#2){-.....}, at: [<ffffffff814a6b98>]=
 nouveau_therm_update+0x48/0x310
[  239.589228]=20
[  239.589228] but task is already holding lock:
[  239.589230]  (&(&priv->sensor.alarm_program_lock)->rlock){-.....}, at: [=
<ffffffff814a85a4>] alarm_timer_callback+0x54/0xe0
[  239.589234]=20
[  239.589234] which lock already depends on the new lock.
[  239.589234]=20
[  239.589236]=20
[  239.589236] the existing dependency chain (in reverse order) is:
[  239.589237]=20
[  239.589237] -> #1 (&(&priv->sensor.alarm_program_lock)->rlock){-.....}:
[  239.589240]        [<ffffffff810952e5>] lock_acquire+0xb5/0x160
[  239.589243]        [<ffffffff818ac6c6>] _raw_spin_lock_irqsave+0x56/0x90
[  239.589247]        [<ffffffff814a85a4>] alarm_timer_callback+0x54/0xe0
[  239.589249]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589252]        [<ffffffff814aa61e>] nv04_timer_alarm+0x7e/0xe0
[  239.589255]        [<ffffffff814a6dbd>] nouveau_therm_update+0x26d/0x310
[  239.589257]        [<ffffffff814a6e7a>] nouveau_therm_alarm+0x1a/0x20
[  239.589259]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589261]        [<ffffffff814aa6eb>] nv04_timer_intr+0x6b/0x90
[  239.589263]        [<ffffffff814a4451>] nouveau_mc_intr+0x141/0x1a0
[  239.589265]        [<ffffffff810a7777>] handle_irq_event_percpu+0x47/0x1=
d0
[  239.589268]        [<ffffffff810a793d>] handle_irq_event+0x3d/0x60
[  239.589270]        [<ffffffff810aa347>] handle_edge_irq+0x77/0x130
[  239.589272]        [<ffffffff8100488f>] handle_irq+0xbf/0x150
[  239.589275]        [<ffffffff818b75bf>] do_IRQ+0x4f/0xf0
[  239.589277]        [<ffffffff818acbb2>] ret_from_intr+0x0/0x1a
[  239.589279]        [<ffffffff8160d147>] cpuidle_enter+0x17/0x20
[  239.589283]        [<ffffffff8108ced2>] cpu_startup_entry+0x242/0x470
[  239.589287]        [<ffffffff81897876>] rest_init+0xc6/0xd0
[  239.589290]        [<ffffffff8210de95>] start_kernel+0x386/0x391
[  239.589293]        [<ffffffff8210d5ca>] x86_64_start_reservations+0x2a/0=
x2c
[  239.589296]        [<ffffffff8210d70a>] x86_64_start_kernel+0x13e/0x14d
[  239.589297]=20
[  239.589297] -> #0 (&(&priv->lock)->rlock#2){-.....}:
[  239.589300]        [<ffffffff81094b65>] __lock_acquire+0x1565/0x1c30
[  239.589302]        [<ffffffff810952e5>] lock_acquire+0xb5/0x160
[  239.589304]        [<ffffffff818ac6c6>] _raw_spin_lock_irqsave+0x56/0x90
[  239.589306]        [<ffffffff814a6b98>] nouveau_therm_update+0x48/0x310
[  239.589308]        [<ffffffff814a6e7a>] nouveau_therm_alarm+0x1a/0x20
[  239.589310]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589312]        [<ffffffff814aa61e>] nv04_timer_alarm+0x7e/0xe0
[  239.589315]        [<ffffffff814a862d>] alarm_timer_callback+0xdd/0xe0
[  239.589317]        [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0=
x170
[  239.589319]        [<ffffffff814aa6eb>] nv04_timer_intr+0x6b/0x90
[  239.589321]        [<ffffffff814a4451>] nouveau_mc_intr+0x141/0x1a0
[  239.589323]        [<ffffffff810a7777>] handle_irq_event_percpu+0x47/0x1=
d0
[  239.589325]        [<ffffffff810a793d>] handle_irq_event+0x3d/0x60
[  239.589327]        [<ffffffff810aa347>] handle_edge_irq+0x77/0x130
[  239.589329]        [<ffffffff8100488f>] handle_irq+0xbf/0x150
[  239.589330]        [<ffffffff818b75bf>] do_IRQ+0x4f/0xf0
[  239.589332]        [<ffffffff818acbb2>] ret_from_intr+0x0/0x1a
[  239.589334]        [<ffffffff8160d147>] cpuidle_enter+0x17/0x20
[  239.589336]        [<ffffffff8108ced2>] cpu_startup_entry+0x242/0x470
[  239.589338]        [<ffffffff810300b8>] start_secondary+0x1a8/0x210
[  239.589343]=20
[  239.589343] other info that might help us debug this:
[  239.589343]=20
[  239.589344]  Possible unsafe locking scenario:
[  239.589344]=20
[  239.589345]        CPU0                    CPU1
[  239.589346]        ----                    ----
[  239.589347]   lock(&(&priv->sensor.alarm_program_lock)->rlock);
[  239.589349]                                lock(&(&priv->lock)->rlock#2);
[  239.589351]                                lock(&(&priv->sensor.alarm_pr=
ogram_lock)->rlock);
[  239.589353]   lock(&(&priv->lock)->rlock#2);
[  239.589355]=20
[  239.589355]  *** DEADLOCK ***
[  239.589355]=20
[  239.589357] 1 lock held by swapper/1/0:
[  239.589358]  #0:  (&(&priv->sensor.alarm_program_lock)->rlock){-.....}, =
at: [<ffffffff814a85a4>] alarm_timer_callback+0x54/0xe0
[  239.589362]=20
[  239.589362] stack backtrace:
[  239.589364] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.15.0-rc4-fb+ #5
[  239.589366] Hardware name: LENOVO 10120/ , BIOS I1KT15AUS 03/28/2013
[  239.589367]  ffffffff826667d0 ffff880330803b30 ffffffff818a1afc ffffffff=
826667d0
[  239.589370]  ffff880330803b70 ffffffff8189caa9 ffff880330803bc0 ffff8803=
2e70c778
[  239.589372]  0000000000000001 0000000000000001 ffff88032e70bf30 ffff8803=
2e70c778
[  239.589375] Call Trace:
[  239.589376]  <IRQ>  [<ffffffff818a1afc>] dump_stack+0x4d/0x66
[  239.589382]  [<ffffffff8189caa9>] print_circular_bug+0x200/0x20e
[  239.589384]  [<ffffffff81094b65>] __lock_acquire+0x1565/0x1c30
[  239.589386]  [<ffffffff810939b3>] ? __lock_acquire+0x3b3/0x1c30
[  239.589388]  [<ffffffff810952e5>] lock_acquire+0xb5/0x160
[  239.589391]  [<ffffffff814a6b98>] ? nouveau_therm_update+0x48/0x310
[  239.589393]  [<ffffffff818ac6c6>] _raw_spin_lock_irqsave+0x56/0x90
[  239.589395]  [<ffffffff814a6b98>] ? nouveau_therm_update+0x48/0x310
[  239.589398]  [<ffffffff814a6b98>] nouveau_therm_update+0x48/0x310
[  239.589400]  [<ffffffff814a6e7a>] nouveau_therm_alarm+0x1a/0x20
[  239.589402]  [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0x170
[  239.589405]  [<ffffffff814aa61e>] nv04_timer_alarm+0x7e/0xe0
[  239.589407]  [<ffffffff814a862d>] alarm_timer_callback+0xdd/0xe0
[  239.589410]  [<ffffffff814aa55e>] nv04_timer_alarm_trigger+0x12e/0x170
[  239.589412]  [<ffffffff814aa6eb>] nv04_timer_intr+0x6b/0x90
[  239.589414]  [<ffffffff814a4451>] nouveau_mc_intr+0x141/0x1a0
[  239.589416]  [<ffffffff810a7777>] handle_irq_event_percpu+0x47/0x1d0
[  239.589419]  [<ffffffff810a793d>] handle_irq_event+0x3d/0x60
[  239.589421]  [<ffffffff810aa347>] handle_edge_irq+0x77/0x130
[  239.589423]  [<ffffffff8100488f>] handle_irq+0xbf/0x150
[  239.589425]  [<ffffffff818b0bb6>] ? atomic_notifier_call_chain+0x16/0x20
[  239.589427]  [<ffffffff818b75bf>] do_IRQ+0x4f/0xf0
[  239.589430]  [<ffffffff818acbb2>] common_interrupt+0x72/0x72
[  239.589431]  <EOI>  [<ffffffff8160d097>] ? cpuidle_enter_state+0x57/0xd0
[  239.589436]  [<ffffffff8160d090>] ? cpuidle_enter_state+0x50/0xd0
[  239.589438]  [<ffffffff8160d147>] cpuidle_enter+0x17/0x20
[  239.589440]  [<ffffffff8108ced2>] cpu_startup_entry+0x242/0x470
[  239.589443]  [<ffffffff810300b8>] start_secondary+0x1a8/0x210
[  414.578776] usb 1-5.1.3: USB disconnect, device number 11
[  896.595431] usb 1-5.1.3: new high-speed USB device number 12 using xhci_=
hcd
[  896.679563] usb 1-5.1.3: New USB device found, idVendor=3D0403, idProduc=
t=3D6010
[  896.679575] usb 1-5.1.3: New USB device strings: Mfr=3D1, Product=3D2, S=
erialNumber=3D0
[  896.679581] usb 1-5.1.3: Product: Dual RS232-HS
[  896.679585] usb 1-5.1.3: Manufacturer: FTDI
[  897.295369] usbcore: registered new interface driver usbserial
[  897.295484] usbcore: registered new interface driver usbserial_generic
[  897.295556] usbserial: USB Serial support registered for generic
[  897.301287] usbcore: registered new interface driver ftdi_sio
[  897.301400] usbserial: USB Serial support registered for FTDI USB Serial=
 Device
[  897.301913] ftdi_sio 1-5.1.3:1.0: FTDI USB Serial Device converter detec=
ted
[  897.302263] usb 1-5.1.3: Detected FT2232H
[  897.302267] usb 1-5.1.3: Number of endpoints 2
[  897.302272] usb 1-5.1.3: Endpoint 1 MaxPacketSize 512
[  897.302275] usb 1-5.1.3: Endpoint 2 MaxPacketSize 512
[  897.302279] usb 1-5.1.3: Setting MaxPacketSize 512
[  897.302711] usb 1-5.1.3: FTDI USB Serial Device converter now attached t=
o ttyUSB0
[  897.302775] ftdi_sio 1-5.1.3:1.1: FTDI USB Serial Device converter detec=
ted
[  897.302868] usb 1-5.1.3: Detected FT2232H
[  897.302872] usb 1-5.1.3: Number of endpoints 2
[  897.302876] usb 1-5.1.3: Endpoint 1 MaxPacketSize 512
[  897.302879] usb 1-5.1.3: Endpoint 2 MaxPacketSize 512
[  897.302883] usb 1-5.1.3: Setting MaxPacketSize 512
[  897.303100] usb 1-5.1.3: FTDI USB Serial Device converter now attached t=
o ttyUSB1
[  910.402360] usb 1-5.1.3: USB disconnect, device number 12
[  910.403079] ftdi_sio ttyUSB0: FTDI USB Serial Device converter now disco=
nnected from ttyUSB0
[  910.403129] ftdi_sio 1-5.1.3:1.0: device disconnected
[  910.403752] ftdi_sio ttyUSB1: FTDI USB Serial Device converter now disco=
nnected from ttyUSB1
[  910.403811] ftdi_sio 1-5.1.3:1.1: device disconnected

--pf9I7BMVVzbSWLtt--

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTaUY+AAoJEIaOsuA1yqREqO4QALWnII6X5lO31XmJdV/zyptg
XVPabnMCO8oNSxugC7HpNRpOUHc3pKtU4AC8aOfdupdIiOpUpmAaW7bgZH7DcQCH
+WNNpFPL5NWiMJUZg59HeI+YGvJvlgkRVclCcIbkatDzp5q8Z/f49IHxcZYml5zt
7Yh0TYza7vwS/zaCip40m6sMavIjCR8wNKHc4huC0SVMHLdQ2oi9Wh57zRmNPSrw
g0vwc2ov2wMmh2I3vOxgKVWgY15Zf1OBdwFUmk6AwEyAAKSZ6WiYCfrQTRhpdXBY
/c6xNU6uWlr5ety2guQkJF/h6W4CGkPTbbivnDJvZKexAL+xdrzLKTVaTFaiartP
TQXSyr+1v5Er3oEYF67jFQ/thIckRkLxNgbPomA87wCidKKw5K9bxAQCPorY//hY
IcVan4dlzvFxTHR+w9VLAwUvF0ovhNuIYMrD5Qjgvrrxbv02Bvh/5ZcvNGyLHnQx
pDQTxSB9LKHWuZI/wMTzv2X+6KotZIUvkxjPJQtTDUwofmEsayDVSHZlRvC3DOhP
AxPCWlYwEoRmqQE3bCRs9KKO2r3WnQ/QKfWfciOdShNbQzzIwJfwF0IPYco94Uku
Rd/yFwtrFALSoQrVdC6h/JKbr/wVnKljPrnujkZzZxBoNIolIor5JKHCwLm8mdZF
vP9J+mXfLiFoW95mcm4X
=kHGq
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
