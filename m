Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaAFCVh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 21:21:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:45915 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbaAFCVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 21:21:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,609,1384329600"; 
   d="scan'208";a="454040218"
Date: Mon, 6 Jan 2014 10:21:28 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
Message-ID: <20140106022128.GA22936@localhost>
References: <20140102053101.GA29352@localhost>
 <CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
 <20140105094639.GA7423@localhost>
 <CAFR8uefqY95-_unXGOTj6Q5FKV0ZvHh48YxM73WeN-aeNC4o_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <CAFR8uefqY95-_unXGOTj6Q5FKV0ZvHh48YxM73WeN-aeNC4o_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 05, 2014 at 08:28:57AM -0800, Muthu Kumar wrote:
> Fengguang,
> Instead of rebooting, can you trigger a crash dump when this happens
> and send us the backtrace (to start with)?

Muthu, good point! Attached is the full dmesg with backtrace:

[ 1398.988324] SysRq : Show Blocked State
[ 1398.992007]   task                        PC stack   pid father
[ 1398.992007] mount           D 0000000000000002     0  2875   2870 0x00000000
[ 1398.992007]  ffff88007f859a70 0000000000000082 ffff88007f859fd8 ffff8803d21c6c10
[ 1398.992007]  0000000000012fc0 ffff8803d21c6c10 0000000000000000 0000000000000000
[ 1398.992007]  ffff8803d2d22068 0000000000000008 ffff88007f859a18 ffffffff814c2b62
[ 1398.992007] Call Trace:
[ 1398.992007]  [<ffffffff814c2b62>] ? submit_bio+0x106/0x159
[ 1398.992007]  [<ffffffff81431c6a>] ? __do_readpage+0x4b9/0x50e
[ 1398.992007]  [<ffffffff81064a03>] ? kvm_clock_read+0x27/0x31
[ 1398.992007]  [<ffffffff81064a16>] ? kvm_clock_get_cycles+0x9/0xb
[ 1398.992007]  [<ffffffff811651a1>] ? filemap_fdatawait+0x23/0x23
[ 1398.992007]  [<ffffffff819ff356>] schedule+0x6f/0x71
[ 1398.992007]  [<ffffffff819ff59b>] io_schedule+0x8f/0xd6
[ 1398.992007]  [<ffffffff811651af>] sleep_on_page+0xe/0x12
[ 1398.992007]  [<ffffffff819ff861>] __wait_on_bit+0x48/0x7b
[ 1398.992007]  [<ffffffff81165002>] wait_on_page_bit+0x7a/0x7c
[ 1398.992007]  [<ffffffff810f7ee3>] ? autoremove_wake_function+0x34/0x34
[ 1398.992007]  [<ffffffff81433eee>] read_extent_buffer_pages+0x1ae/0x23b
[ 1398.992007]  [<ffffffff81410da7>] ? free_root_pointers+0x5b/0x5b
[ 1398.992007]  [<ffffffff814123e5>] btree_read_extent_buffer_pages.constprop.48+0x66/0x100
[ 1398.992007]  [<ffffffff814129d1>] read_tree_block+0x2f/0x47
[ 1398.992007]  [<ffffffff814163e6>] open_ctree+0x1271/0x1adf
[ 1398.992007]  [<ffffffff813f4243>] btrfs_mount+0x47b/0x771
[ 1398.992007]  [<ffffffff814e1f8c>] ? get_from_free_list+0x41/0x4b
[ 1398.992007]  [<ffffffff811c40bf>] mount_fs+0x15/0xae
[ 1398.992007]  [<ffffffff811d9a52>] vfs_kern_mount+0x64/0xf6
[ 1398.992007]  [<ffffffff811dbff6>] do_mount+0x781/0x878
[ 1398.992007]  [<ffffffff8117d6c2>] ? strndup_user+0x3a/0xd6
[ 1398.992007]  [<ffffffff811dc317>] SyS_mount+0x85/0xbe
[ 1398.992007]  [<ffffffff81a09529>] system_call_fastpath+0x16/0x1b
[ 1398.992007] Sched Debug Version: v0.11, 3.13.0-rc6-00148-gc05f7ce #1

> Kent,
> Did you do any btrfs test with your changes?

Just try simple dd writes.

Thanks,
Fengguang


> Regards,
> Muthu
> 
> On Sun, Jan 5, 2014 at 1:46 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Hi Muthu,
> >
> > On Fri, Jan 03, 2014 at 11:51:31AM -0800, Muthu Kumar wrote:
> >> Looks like Kent missed the btrfs endio in the original commit. How
> >> about this patch:
> >>
> >> ---------
> >>
> >> In btrfs_end_bio, call bio_endio_nodec on the restored bio so the
> >> bi_remaining is accounted for correctly.
> >>
> >> Reported-by: fengguang.wu@intel.com
> >> Cc: Kent Overstreet <kmo@daterainc.com>
> >> CC: Jens Axboe <axboe@kernel.dk>
> >> Signed-off-by: Muthukumar Ratty <muthur@gmail.com>
> >> --------
> >>
> >>  fs/btrfs/volumes.c |    6 +++++-
> >>  1 files changed, 5 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >> index f2130de..edfed52 100644
> >> --- a/fs/btrfs/volumes.c
> >> +++ b/fs/btrfs/volumes.c
> >> @@ -5316,7 +5316,11 @@ static void btrfs_end_bio(struct bio *bio, int err)
> >>                 }
> >>                 kfree(bbio);
> >>
> >> -               bio_endio(bio, err);
> >> +                /*
> >> +                 * Call endio_nodec on the restored bio so the bi_remaining is
> >> +                 * accounted for correctly
> >> +                 */
> >> +               bio_endio_nodec(bio, err);
> >>         } else if (!is_orig_bio) {
> >>                 bio_put(bio);
> >>         }
> >
> > Interestingly, the BUG message disappeared but it blocks the test run.
> > In the end, the test watchdog reboots the machine with SysRq:
> >
> >         2014-01-04 23:13:02 mount -t btrfs /dev/vda /fs/vda
> >         [   20.184264] btrfs: device fsid f0e06999-0518-47e0-a622-21b8749438be devid 1 transid 4 /dev/vda
> >         [   20.186552] btrfs: disk space caching is enabled
> >         [  131.360457] random: nonblocking pool is initialized
> > ==>     [ 1465.069342] SysRq : Emergency Sync
> > ==>     [ 1475.071055] SysRq : Resetting
> >
> > Attached is the full dmesg for a good run (v3.13-rc7) and a bad run
> > (this patch).
> >
> > Thanks,
> > Fengguang

--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-bio_endio_nodec-w
Content-Transfer-Encoding: quoted-printable

early console in setup code
Probing EDD (edd=3Doff to disable)... ok
early console in decompress_kernel

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc6-00148-gc05f7ce (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Jan 5 10:49:41 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx-5/vali=
date_dd-write-4HDD-JBOD-cfq-btrfs-100dd-x86_64-lkp-c05f7cec62c6134b710d634b=
0cc456e9e0f480a2-3.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/c05f7=
cec62c6134b710d634b0cc456e9e0f480a2/vmlinuz-3.13.0-rc6-00148-gc05f7ce kconf=
ig=3Dx86_64-lkp commit=3Dc05f7cec62c6134b710d634b0cc456e9e0f480a2 modules_i=
nitrd=3D/kernel/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a2/modules=
=2Ecgz max_uptime=3D1200 RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4=
HDD-JBOD-cfq-btrfs-100dd/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a=
2/4 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::=
kbuildx-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug =
sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x420000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000]  [mem 0x41fe00000-0x41fffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000]  [mem 0x41c000000-0x41fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x743aa000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fffffff]
[    0.000000]   NODE_DATA [mem 0x41ffed000-0x41fff1fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040f60000=
0-ffff88041f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x41fffffff]
[    0.000000] On node 0 totalpages: 4194204
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 51200 pages used for memmap
[    0.000000]   Normal zone: 3276800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 41fc0d040
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4128647
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx=
-5/validate_dd-write-4HDD-JBOD-cfq-btrfs-100dd-x86_64-lkp-c05f7cec62c6134b7=
10d634b0cc456e9e0f480a2-3.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lk=
p/c05f7cec62c6134b710d634b0cc456e9e0f480a2/vmlinuz-3.13.0-rc6-00148-gc05f7c=
e kconfig=3Dx86_64-lkp commit=3Dc05f7cec62c6134b710d634b0cc456e9e0f480a2 mo=
dules_initrd=3D/kernel/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a2/=
modules.cgz max_uptime=3D1200 RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-wr=
ite/4HDD-JBOD-cfq-btrfs-100dd/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0=
f480a2/4 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=
=3D::::kbuildx-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16231972K/16776816K available (10298K kernel code, 1=
234K rwdata, 4140K rodata, 1428K init, 1736K bss, 544844K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.13.0-rc6-00148-gc05f7ce (kbuild@xian) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Sun Jan 5 10:49:41 CST 2014
[    0.000000] Command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx-5/vali=
date_dd-write-4HDD-JBOD-cfq-btrfs-100dd-x86_64-lkp-c05f7cec62c6134b710d634b=
0cc456e9e0f480a2-3.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lkp/c05f7=
cec62c6134b710d634b0cc456e9e0f480a2/vmlinuz-3.13.0-rc6-00148-gc05f7ce kconf=
ig=3Dx86_64-lkp commit=3Dc05f7cec62c6134b710d634b0cc456e9e0f480a2 modules_i=
nitrd=3D/kernel/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a2/modules=
=2Ecgz max_uptime=3D1200 RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4=
HDD-JBOD-cfq-btrfs-100dd/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a=
2/4 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=3D::::=
kbuildx-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=3Ddebug =
sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D0 console=
=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dfffdfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dfffe000-0x00000000dfffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn =3D 0x420000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] e820: last_pfn =3D 0xdfffe max_arch_pfn =3D 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fda90-0x000fda9f] mapped at =
[ffff8800000fda90]
[    0.000000]   mpc: fdaa0-fdbe4
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x0265a000, 0x0265afff] PGTABLE
[    0.000000] BRK [0x0265b000, 0x0265bfff] PGTABLE
[    0.000000] BRK [0x0265c000, 0x0265cfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fe00000-0x41fffffff]
[    0.000000]  [mem 0x41fe00000-0x41fffffff] page 2M
[    0.000000] BRK [0x0265d000, 0x0265dfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fdfffff]
[    0.000000]  [mem 0x41c000000-0x41fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xdfffdfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xdfdfffff] page 2M
[    0.000000]  [mem 0xdfe00000-0xdfffdfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] BRK [0x0265e000, 0x0265efff] PGTABLE
[    0.000000] BRK [0x0265f000, 0x0265ffff] PGTABLE
[    0.000000] RAMDISK: [mem 0x743aa000-0x7fffffff]
[    0.000000] ACPI: RSDP 00000000000fd880 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000dfffe380 000034 (v01 BOCHS  BXPCRSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000dfffff80 000074 (v01 BOCHS  BXPCFACP 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000dfffe3c0 0011A9 (v01   BXPC   BXDSDT 0000=
0001 INTL 20100528)
[    0.000000] ACPI: FACS 00000000dfffff40 000040
[    0.000000] ACPI: SSDT 00000000dffff6e0 000858 (v01 BOCHS  BXPCSSDT 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000dffff5b0 000090 (v01 BOCHS  BXPCAPIC 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000dffff570 000038 (v01 BOCHS  BXPCHPET 0000=
0001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fffffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fffffff]
[    0.000000]   NODE_DATA [mem 0x41ffed000-0x41fff1fff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, boot clock
[    0.000000]  [ffffea0000000000-ffffea00107fffff] PMD -> [ffff88040f60000=
0-ffff88041f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0xdfffdfff]
[    0.000000]   node   0: [mem 0x100000000-0x41fffffff]
[    0.000000] On node 0 totalpages: 4194204
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14272 pages used for memmap
[    0.000000]   DMA32 zone: 913406 pages, LIFO batch:31
[    0.000000]   Normal zone: 51200 pages used for memmap
[    0.000000]   Normal zone: 3276800 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f3000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f2000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfffe000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xfeffbfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfeffc000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xfffbffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfffc0000-0xffffffff]
[    0.000000] e820: [mem 0xe0000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 n=
r_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041fc00000 s81024 r8192=
 d21376 u524288
[    0.000000] pcpu-alloc: s81024 r8192 d21376 u524288 alloc=3D1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] kvm-clock: cpu 0, msr 4:1ffe5001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr 41fc0d040
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 4128647
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: user=3Dlkp job=3D/lkp/scheduled/kbuildx=
-5/validate_dd-write-4HDD-JBOD-cfq-btrfs-100dd-x86_64-lkp-c05f7cec62c6134b7=
10d634b0cc456e9e0f480a2-3.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/kernel/x86_64-lk=
p/c05f7cec62c6134b710d634b0cc456e9e0f480a2/vmlinuz-3.13.0-rc6-00148-gc05f7c=
e kconfig=3Dx86_64-lkp commit=3Dc05f7cec62c6134b710d634b0cc456e9e0f480a2 mo=
dules_initrd=3D/kernel/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a2/=
modules.cgz max_uptime=3D1200 RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-wr=
ite/4HDD-JBOD-cfq-btrfs-100dd/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0=
f480a2/4 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/dev/ram0 ip=
=3D::::kbuildx-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 debug apic=
=3Ddebug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_ramdisk=3D=
0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 16231972K/16776816K available (10298K kernel code, 1=
234K rwdata, 4140K rodata, 1428K init, 1736K bss, 544844K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D4, N=
odes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] bootconsole [earlyser0] disabled
[    0.000000] console [ttyS0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2693.544 MHz processor
[    0.008000] Calibrating delay loop (skipped) preset value.. 5387.08 Bogo=
MIPS (lpj=3D10774176)
[    0.008000] pid_max: default: 32768 minimum: 301
[    0.008000] Dentry cache hash table entries: 2097152 (order: 12, 1677721=
6 bytes)
[    0.020683] Inode-cache hash table entries: 1048576 (order: 11, 8388608 =
bytes)
[    0.027838] Mount-cache hash table entries: 256
[    0.028290] Initializing cgroup subsys memory
[    0.029094] Initializing cgroup subsys devices
[    0.029897] Initializing cgroup subsys freezer
[    0.030700] Initializing cgroup subsys blkio
[    0.032005] Initializing cgroup subsys perf_event
[    0.032845] Initializing cgroup subsys hugetlb
[    0.033707] mce: CPU supports 10 MCE banks
[    0.034512] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034512] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.034512] tlb_flushall_shift: 6
[    0.036080] Freeing SMP alternatives memory: 44K (ffffffff8249b000 - fff=
fffff824a6000)
[    0.042679] ACPI: Core revision 20131115
[    0.044122] ACPI: All ACPI Tables successfully acquired
[    0.045144] ftrace: allocating 39650 entries in 155 pages
[    0.056115] Getting VERSION: 50014
[    0.056823] Getting VERSION: 50014
[    0.057517] Getting ID: 0
[    0.058133] Getting ID: ff000000
[    0.060009] Getting LVT0: 8700
[    0.060676] Getting LVT1: 8400
[    0.061382] enabled ExtINT on CPU#0
[    0.062758] ENABLING IO-APIC IRQs
[    0.063442] init IO_APIC IRQs
[    0.064004]  apic 0 pin 0 not connected
[    0.064752] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.066218] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.068016] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.069464] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.070934] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.072014] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.073474] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.074901] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.076014] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.077432] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.078875] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.080014] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.081447] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.084014] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.085471] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.086920]  apic 0 pin 16 not connected
[    0.087658]  apic 0 pin 17 not connected
[    0.088002]  apic 0 pin 18 not connected
[    0.088743]  apic 0 pin 19 not connected
[    0.089480]  apic 0 pin 20 not connected
[    0.090217]  apic 0 pin 21 not connected
[    0.090946]  apic 0 pin 22 not connected
[    0.092002]  apic 0 pin 23 not connected
[    0.092874] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.093947] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.096002] Using local APIC timer interrupts.
[    0.096002] calibrating APIC timer ...
[    0.100000] ... lapic delta =3D 6245076
[    0.100000] ... PM-Timer delta =3D 357672
[    0.100000] ... PM-Timer result ok
[    0.100000] ..... delta 6245076
[    0.100000] ..... mult: 268223971
[    0.100000] ..... calibration result: 3996848
[    0.100000] ..... CPU clock speed is 2691.0269 MHz.
[    0.100000] ..... host bus clock speed is 999.0848 MHz.
[    0.100044] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.103351] x86: Booting SMP configuration:
[    0.104002] .... node  #0, CPUs:      #1
[    0.008000] kvm-clock: cpu 1, msr 4:1ffe5041, secondary cpu clock
[    0.008000] masked ExtINT on CPU#1
[    0.120018] KVM setup async PF for cpu 1
 #2
[    0.121333] kvm-stealtime: cpu 1, msr 41fc8d040
[    0.008000] kvm-clock: cpu 2, msr 4:1ffe5081, secondary cpu clock
[    0.008000] masked ExtINT on CPU#2
[    0.136018] KVM setup async PF for cpu 2
 #3
[    0.137056] kvm-stealtime: cpu 2, msr 41fd0d040
[    0.008000] kvm-clock: cpu 3, msr 4:1ffe50c1, secondary cpu clock
[    0.008000] masked ExtINT on CPU#3

[    0.148029] x86: Booted up 1 node, 4 CPUs
[    0.148017] KVM setup async PF for cpu 3
[    0.148018] kvm-stealtime: cpu 3, msr 41fd8d040
[    0.152003] smpboot: Total of 4 processors activated (21548.35 BogoMIPS)
[    0.156294] devtmpfs: initialized
[    0.161728] xor: measuring software checksum speed
[    0.204007]    prefetch64-sse:   193.000 MB/sec
[    0.244017]    generic_sse:   190.000 MB/sec
[    0.244788] xor: using function: prefetch64-sse (193.000 MB/sec)
[    0.245717] atomic64 test passed for x86-64 platform with CX8 and with S=
SE
[    0.246773] NET: Registered protocol family 16
[    0.248174] cpuidle: using governor ladder
[    0.248843] cpuidle: using governor menu
[    0.249906] ACPI: bus type PCI registered
[    0.252003] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.253009] PCI: Using configuration type 1 for base access
[    0.332203] bio: create slab <bio-0> at 0
[    0.403697] raid6: sse2x1    6639 MB/s
[    0.471689] raid6: sse2x2    8475 MB/s
[    0.539691] raid6: sse2x4   10012 MB/s
[    0.540003] raid6: using algorithm sse2x4 (10012 MB/s)
[    0.541113] raid6: using intx1 recovery algorithm
[    0.542209] ACPI: Added _OSI(Module Device)
[    0.543208] ACPI: Added _OSI(Processor Device)
[    0.544015] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.545062] ACPI: Added _OSI(Processor Aggregator Device)
[    0.549133] ACPI: Interpreter enabled
[    0.550075] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S1_] (20131115/hwxface-580)
[    0.552030] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [=
\_S2_] (20131115/hwxface-580)
[    0.554209] ACPI: (supports S0 S3 S4 S5)
[    0.555164] ACPI: Using IOAPIC for interrupt routing
[    0.556065] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.558430] ACPI: No dock devices found.
[    0.572108] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.573688] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MS=
I]
[    0.575348] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.576240] acpi PNP0A03:00: fail to add MMCONFIG information, can't acc=
ess extended PCI configuration space under this bridge.
[    0.580328] acpiphp: Slot [3] registered
[    0.581134] acpiphp: Slot [4] registered
[    0.584009] acpiphp: Slot [5] registered
[    0.584102] acpiphp: Slot [6] registered
[    0.585097] acpiphp: Slot [7] registered
[    0.588010] acpiphp: Slot [8] registered
[    0.588084] acpiphp: Slot [9] registered
[    0.589090] acpiphp: Slot [10] registered
[    0.592005] acpiphp: Slot [11] registered
[    0.592106] acpiphp: Slot [12] registered
[    0.593133] acpiphp: Slot [13] registered
[    0.596086] acpiphp: Slot [14] registered
[    0.596086] acpiphp: Slot [15] registered
[    0.597112] acpiphp: Slot [16] registered
[    0.600087] acpiphp: Slot [17] registered
[    0.601120] acpiphp: Slot [18] registered
[    0.601127] acpiphp: Slot [19] registered
[    0.604204] acpiphp: Slot [20] registered
[    0.605137] acpiphp: Slot [21] registered
[    0.605150] acpiphp: Slot [22] registered
[    0.608086] acpiphp: Slot [23] registered
[    0.609172] acpiphp: Slot [24] registered
[    0.609174] acpiphp: Slot [25] registered
[    0.612101] acpiphp: Slot [26] registered
[    0.613189] acpiphp: Slot [27] registered
[    0.616082] acpiphp: Slot [28] registered
[    0.617191] acpiphp: Slot [29] registered
[    0.617191] acpiphp: Slot [30] registered
[    0.620121] acpiphp: Slot [31] registered
[    0.621123] PCI host bridge to bus 0000:00
[    0.622229] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.624006] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.625420] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.626781] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.628004] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.629375] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.630914] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.632513] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.638169] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.640767] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.641650] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.644053] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.645564] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.660046] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.662954] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.672039] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.673807] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.680005] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.685179] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.694301] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.696080] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.698526] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.700614] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.708316] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.710552] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.713182] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.720316] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.722542] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.725173] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.732907] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.734539] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.737187] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.745517] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.748018] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.750350] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.758059] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.760612] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.762958] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.770054] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.772332] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.777367] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.778282] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.781027] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.782676] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.784747] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.786420] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.786420] ACPI: \_SB_.PCI0: notify handler is installed
[    0.788033] Found 1 acpi root devices
[    0.789007] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.792025] vgaarb: loaded
[    0.796007] vgaarb: bridge control possible 0000:00:02.0
[    0.800101] SCSI subsystem initialized
[    0.801175] libata version 3.00 loaded.
[    0.804076] ACPI: bus type USB registered
[    0.804076] usbcore: registered new interface driver usbfs
[    0.805203] usbcore: registered new interface driver hub
[    0.808010] usbcore: registered new device driver usb
[    0.808066] pps_core: LinuxPPS API ver. 1 registered
[    0.809103] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.812057] PTP clock support registered
[    0.813069] EDAC MC: Ver: 3.0.0
[    0.816049] PCI: Using ACPI for IRQ routing
[    0.816049] PCI: pci_cache_line_size set to 64 bytes
[    0.817384] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.818698] e820: reserve RAM buffer [mem 0xdfffe000-0xdfffffff]
[    0.820637] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    0.822006] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.824818] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.832208] Switched to clocksource kvm-clock
[    0.850140] pnp: PnP ACPI init
[    0.851086] ACPI: bus type PNP registered
[    0.852124] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:15)
[    0.854423] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.855768] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:15)
[    0.858120] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.859435] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:15)
[    0.861850] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.863171] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:15)
[    0.865060] pnp 00:03: [dma 2]
[    0.866343] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.867688] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:15)
[    0.870050] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.871398] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:15)
[    0.873587] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.875453] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.876916] pnp: PnP ACPI: found 7 devices
[    0.877896] ACPI: bus type PNP unregistered
[    0.905040] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.906532] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.908027] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.909608] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    0.910960] NET: Registered protocol family 2
[    0.912266] TCP established hash table entries: 131072 (order: 8, 104857=
6 bytes)
[    0.914862] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.917041] TCP: Hash tables configured (established 131072 bind 65536)
[    0.918447] TCP: reno registered
[    0.919338] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.920831] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.922467] NET: Registered protocol family 1
[    0.923775] RPC: Registered named UNIX socket transport module.
[    0.925004] RPC: Registered udp transport module.
[    0.926041] RPC: Registered tcp transport module.
[    0.927081] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.928358] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.929572] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.930783] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.932045] pci 0000:00:02.0: Boot video device
[    0.933132] PCI: CLS 0 bytes, default 64
[    0.934150] Trying to unpack rootfs image as initramfs...
[    4.426248] Freeing initrd memory: 192856K (ffff8800743aa000 - ffff88008=
0000000)
[    4.427733] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.428780] software IO TLB [mem 0xdbffe000-0xdfffe000] (64MB) mapped at=
 [ffff8800dbffe000-ffff8800dfffdfff]
[    4.430889] kvm: no hardware support
[    4.434171] Scanning for low memory corruption every 60 seconds
[    4.438366] camellia-x86_64: performance on this CPU would be suboptimal=
: disabling camellia-x86_64.
[    4.441490] blowfish-x86_64: performance on this CPU would be suboptimal=
: disabling blowfish-x86_64.
[    4.444308] twofish-x86_64-3way: performance on this CPU would be subopt=
imal: disabling twofish-x86_64-3way.
[    4.449283] sha1_ssse3: Neither AVX nor SSSE3 is available/usable.
[    4.450783] PCLMULQDQ-NI instructions are not detected.
[    4.452097] AVX or AES-NI instructions are not detected.
[    4.453410] AVX instructions are not detected.
[    4.454586] AVX instructions are not detected.
[    4.455772] AVX instructions are not detected.
[    4.456974] AVX instructions are not detected.
[    4.496969] bounce pool size: 64 pages
[    4.498141] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.519337] VFS: Disk quotas dquot_6.5.2
[    4.521547] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.529964] NFS: Registering the id_resolver key type
[    4.531598] Key type id_resolver registered
[    4.533072] Key type id_legacy registered
[    4.534498] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    4.536431] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    4.539568] ROMFS MTD (C) 2007 Red Hat, Inc.
[    4.541252] fuse init (API version 7.22)
[    4.545065] SGI XFS with ACLs, security attributes, realtime, large bloc=
k/inode numbers, no debug enabled
[    4.552065] bio: create slab <bio-1> at 1
[    4.554010] Btrfs loaded
[    4.554629] msgmni has been set to 32079
[    4.568385] NET: Registered protocol family 38
[    4.570704] Key type asymmetric registered
[    4.573352] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 250)
[    4.577432] io scheduler noop registered
[    4.579420] io scheduler deadline registered
[    4.580602] io scheduler cfq registered (default)
[    4.583363] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.585417] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    4.587376] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    4.589209] ACPI: Power Button [PWRF]
[    4.591382] GHES: HEST is not enabled!
[    4.593256] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    4.594663] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:15)
[    4.598987] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    4.600321] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:15)
[    4.604244] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    4.607717] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    4.618268] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.641320] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    4.646586] Non-volatile memory driver v1.3
[    4.653978] brd: module loaded
[    4.658388] loop: module loaded
[    4.659729] virtio-pci 0000:00:04.0: irq 40 for MSI/MSI-X
[    4.661058] virtio-pci 0000:00:04.0: irq 41 for MSI/MSI-X
[    4.662582] blk-mq: CPU -> queue map
[    4.663607]   CPU 0 -> Queue 0
[    4.664569]   CPU 1 -> Queue 0
[    4.665509]   CPU 2 -> Queue 0
[    4.666449]   CPU 3 -> Queue 0
[    4.668834]  vda: unknown partition table
[    4.675829] virtio-pci 0000:00:05.0: irq 42 for MSI/MSI-X
[    4.678562] virtio-pci 0000:00:05.0: irq 43 for MSI/MSI-X
[    4.680638] blk-mq: CPU -> queue map
[    4.681581]   CPU 0 -> Queue 0
[    4.682457]   CPU 1 -> Queue 0
[    4.683328]   CPU 2 -> Queue 0
[    4.684228]   CPU 3 -> Queue 0
[    4.686669]  vdb: unknown partition table
[    4.691845] virtio-pci 0000:00:06.0: irq 44 for MSI/MSI-X
[    4.699666] virtio-pci 0000:00:06.0: irq 45 for MSI/MSI-X
[    4.701054] blk-mq: CPU -> queue map
[    4.701997]   CPU 0 -> Queue 0
[    4.702867]   CPU 1 -> Queue 0
[    4.703735]   CPU 2 -> Queue 0
[    4.704628]   CPU 3 -> Queue 0
[    4.706970]  vdc: unknown partition table
[    4.711211] virtio-pci 0000:00:07.0: irq 46 for MSI/MSI-X
[    4.712425] virtio-pci 0000:00:07.0: irq 47 for MSI/MSI-X
[    4.713750] blk-mq: CPU -> queue map
[    4.714674]   CPU 0 -> Queue 0
[    4.715514]   CPU 1 -> Queue 0
[    4.716373]   CPU 2 -> Queue 0
[    4.717224]   CPU 3 -> Queue 0
[    4.719057]  vdd: unknown partition table
[    4.725626] virtio-pci 0000:00:08.0: irq 48 for MSI/MSI-X
[    4.728398] virtio-pci 0000:00:08.0: irq 49 for MSI/MSI-X
[    4.730485] blk-mq: CPU -> queue map
[    4.731433]   CPU 0 -> Queue 0
[    4.732337]   CPU 1 -> Queue 0
[    4.733210]   CPU 2 -> Queue 0
[    4.734082]   CPU 3 -> Queue 0
[    4.736320]  vde: unknown partition table
[    4.741272] virtio-pci 0000:00:09.0: irq 50 for MSI/MSI-X
[    4.742570] virtio-pci 0000:00:09.0: irq 51 for MSI/MSI-X
[    4.744060] blk-mq: CPU -> queue map
[    4.745098]   CPU 0 -> Queue 0
[    4.746039]   CPU 1 -> Queue 0
[    4.746976]   CPU 2 -> Queue 0
[    4.747922]   CPU 3 -> Queue 0
[    4.750190]  vdf: unknown partition table
[    4.756099] lkdtm: No crash points registered, enable through debugfs
[    4.760791] Loading iSCSI transport class v2.0-870.
[    4.764641] Adaptec aacraid driver 1.2-0[30200]-ms
[    4.765926] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[    4.767621] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.06.00.08-k.
[    4.770149] megaraid cmm: 2.20.2.7 (Release Date: Sun Jul 16 00:01:03 ES=
T 2006)
[    4.772465] megaraid: 2.20.5.1 (Release Date: Thu Nov 16 15:32:35 EST 20=
06)
[    4.774310] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    4.776389] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    4.778130] RocketRAID 3xxx/4xxx Controller driver v1.8
[    4.781161] ata_piix 0000:00:01.1: version 2.13
[    4.786611] scsi0 : ata_piix
[    4.788403] scsi1 : ata_piix
[    4.789797] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc1c0 irq 14
[    4.791371] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc1c8 irq 15
[    4.795701] tun: Universal TUN/TAP device driver, 1.6
[    4.797094] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.799546] pcnet32: pcnet32.c:v1.35 21.Apr.2008 tsbogend@alpha.franken.=
de
[    4.801663] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    4.803075] Copyright (c) 2007 Atheros Corporation.
[    4.805100] dmfe: Davicom DM9xxx net driver, version 1.36.4 (2002-01-17)
[    4.806894] v1.01-e (2.4 port) Sep-11-2006  Donald Becker <becker@scyld.=
com>
[    4.806894]   http://www.scyld.com/network/drivers.html
[    4.810436] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-2=
9)
[    4.812171] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.813415] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.814794] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[    4.816148] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    4.948524] ata2.01: NODEV after polling detection
[    4.949966] ata2.00: ATAPI: QEMU DVD-ROM, 1.6.0, max UDMA/100
[    4.951633] ata2.00: configured for MWDMA2
[    4.953298] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     1.=
6. PQ: 0 ANSI: 5
[    4.956303] scsi 1:0:0:0: Attached scsi generic sg0 type 5
[    5.150520] e1000 0000:00:03.0 eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:56
[    5.151874] e1000 0000:00:03.0 eth0: Intel(R) PRO/1000 Network Connection
[    5.153576] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    5.154785] e1000e: Copyright(c) 1999 - 2013 Intel Corporation.
[    5.156314] igb: Intel(R) Gigabit Ethernet Network Driver - version 5.0.=
5-k
[    5.157675] igb: Copyright (c) 2007-2013 Intel Corporation.
[    5.159269] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - vers=
ion 3.15.1-k
[    5.161288] ixgbe: Copyright (c) 1999-2013 Intel Corporation.
[    5.163028] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2=
-NAPI
[    5.164527] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    5.166678] sky2: driver version 1.30
[    5.170702] usbcore: registered new interface driver catc
[    5.172252] usbcore: registered new interface driver kaweth
[    5.173636] pegasus: v0.9.3 (2013/04/25), Pegasus/Pegasus II USB Etherne=
t driver
[    5.175875] usbcore: registered new interface driver pegasus
[    5.177516] usbcore: registered new interface driver rtl8150
[    5.179087] usbcore: registered new interface driver asix
[    5.180599] usbcore: registered new interface driver ax88179_178a
[    5.182098] usbcore: registered new interface driver cdc_ether
[    5.183548] usbcore: registered new interface driver r815x
[    5.185148] usbcore: registered new interface driver cdc_eem
[    5.186577] usbcore: registered new interface driver dm9601
[    5.188034] usbcore: registered new interface driver smsc75xx
[    5.189501] usbcore: registered new interface driver smsc95xx
[    5.191079] usbcore: registered new interface driver gl620a
[    5.192696] usbcore: registered new interface driver net1080
[    5.194339] usbcore: registered new interface driver plusb
[    5.195850] usbcore: registered new interface driver rndis_host
[    5.197501] usbcore: registered new interface driver cdc_subset
[    5.199069] usbcore: registered new interface driver zaurus
[    5.200783] usbcore: registered new interface driver MOSCHIP usb-etherne=
t driver
[    5.202961] usbcore: registered new interface driver int51x1
[    5.204505] usbcore: registered new interface driver ipheth
[    5.206059] usbcore: registered new interface driver sierra_net
[    5.207639] usbcore: registered new interface driver cdc_ncm
[    5.208998] Fusion MPT base driver 3.04.20
[    5.210066] Copyright (c) 1999-2008 LSI Corporation
[    5.211239] Fusion MPT SPI Host driver 3.04.20
[    5.212676] Fusion MPT FC Host driver 3.04.20
[    5.214095] Fusion MPT SAS Host driver 3.04.20
[    5.215482] Fusion MPT misc device (ioctl) driver 3.04.20
[    5.217141] mptctl: Registered with Fusion MPT base driver
[    5.218395] mptctl: /dev/mptctl @ (major,minor=3D10,220)
[    5.220672] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    5.223741] ehci-pci: EHCI PCI platform driver
[    5.226695] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.229724] ohci-pci: OHCI PCI platform driver
[    5.231238] uhci_hcd: USB Universal Host Controller Interface driver
[    5.233398] usbcore: registered new interface driver usb-storage
[    5.235100] usbcore: registered new interface driver ums-alauda
[    5.236858] usbcore: registered new interface driver ums-datafab
[    5.238604] usbcore: registered new interface driver ums-freecom
[    5.240527] usbcore: registered new interface driver ums-isd200
[    5.242563] usbcore: registered new interface driver ums-jumpshot
[    5.244799] usbcore: registered new interface driver ums-sddr09
[    5.246851] usbcore: registered new interface driver ums-sddr55
[    5.249011] usbcore: registered new interface driver ums-usbat
[    5.251066] usbcore: registered new interface driver usbtest
[    5.253696] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[    5.257894] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.259414] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.261680] mousedev: PS/2 mouse device common for all mice
[    5.267525] rtc_cmos 00:00: RTC can wake from S4
[    5.269925] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[    5.273252] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    5.275925] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet =
irqs
[    5.279839] i6300esb: Intel 6300ESB WatchDog Timer Driver v0.05
[    5.281563] i6300esb: initialized (0xffffc90001ac2000). heartbeat=3D30 s=
ec (nowayout=3D0)
[    5.283722] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.10
[    5.285247] iTCO_vendor_support: vendor-support=3D0
[    5.286437] watchdog: Software Watchdog: cannot register miscdev on mino=
r=3D130 (err=3D-16).
[    5.288463] watchdog: Software Watchdog: a legacy watchdog module is pro=
bably present.
[    5.290615] softdog: Software Watchdog Timer: 0.08 initialized. soft_nob=
oot=3D0 soft_margin=3D60 sec soft_panic=3D0 (nowayout=3D0)
[    5.292878] md: linear personality registered for level -1
[    5.294024] md: raid0 personality registered for level 0
[    5.295136] md: raid1 personality registered for level 1
[    5.296276] md: raid10 personality registered for level 10
[    5.297816] md: raid6 personality registered for level 6
[    5.298954] md: raid5 personality registered for level 5
[    5.300100] md: raid4 personality registered for level 4
[    5.301216] md: multipath personality registered for level -4
[    5.302395] md: faulty personality registered for level -5
[    5.305010] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[    5.307760] device-mapper: multipath: version 1.6.0 loaded
[    5.308934] device-mapper: multipath round-robin: version 1.0.0 loaded
[    5.310340] device-mapper: cache-policy-mq: version 1.1.0 loaded
[    5.311705] device-mapper: cache cleaner: version 1.0.0 loaded
[    5.314085] dcdbas dcdbas: Dell Systems Management Base Driver (version =
5.6.0-3.2)
[    5.320512] usbcore: registered new interface driver usbhid
[    5.321955] usbhid: USB HID core driver
[    5.323332] TCP: bic registered
[    5.324409] Initializing XFRM netlink socket
[    5.326402] NET: Registered protocol family 10
[    5.328039] sit: IPv6 over IPv4 tunneling driver
[    5.330151] NET: Registered protocol family 17
[    5.331222] 8021q: 802.1Q VLAN Support v1.8
[    5.333926] sctp: Hash tables configured (established 65536 bind 65536)
[    5.335791] Key type dns_resolver registered
[    5.338437]=20
[    5.338437] printing PIC contents
[    5.339938] ... PIC  IMR: ffff
[    5.340860] ... PIC  IRR: 9113
[    5.348550] ... PIC  ISR: 0000
[    5.349463] ... PIC ELCR: 0c00
[    5.350345] printing local APIC contents on CPU#0/0:
[    5.351421] ... APIC ID:      00000000 (0)
[    5.352399] ... APIC VERSION: 00050014
[    5.352530] ... APIC TASKPRI: 00000000 (00)
[    5.352530] ... APIC PROCPRI: 00000000
[    5.352530] ... APIC LDR: 01000000
[    5.352530] ... APIC DFR: ffffffff
[    5.352530] ... APIC SPIV: 000001ff
[    5.352530] ... APIC ISR field:
[    5.352530] 000000000000000000000000000000000000000000000000000000000000=
0000
[    5.352530] ... APIC TMR field:
[    5.352530] 000000000200000000000000000000000000000000000000000000000000=
0000
[    5.352530] ... APIC IRR field:
[    5.352530] 000000000000000000000000000000000000000000000000000000000000=
8000
[    5.352530] ... APIC ESR: 00000000
[    5.352530] ... APIC ICR: 000008fd
[    5.352530] ... APIC ICR2: 02000000
[    5.352530] ... APIC LVTT: 000000ef
[    5.352530] ... APIC LVTPC: 00010000
[    5.352530] ... APIC LVT0: 00010700
[    5.352530] ... APIC LVT1: 00000400
[    5.352530] ... APIC LVTERR: 000000fe
[    5.352530] ... APIC TMICT: 00034ddc
[    5.352530] ... APIC TMCCT: 00000000
[    5.352530] ... APIC TDCR: 00000003
[    5.352530]=20
[    5.377046] number of MP IRQ sources: 15.
[    5.377996] number of IO-APIC #0 registers: 24.
[    5.379011] testing the IO APIC.......................
[    5.380146] IO APIC #0......
[    5.380966] .... register #00: 00000000
[    5.381903] .......    : physical APIC id: 00
[    5.382898] .......    : Delivery Type: 0
[    5.383849] .......    : LTS          : 0
[    5.384821] .... register #01: 00170011
[    5.385746] .......     : max redirection entries: 17
[    5.386837] .......     : PRQ implemented: 0
[    5.387822] .......     : IO APIC version: 11
[    5.388833] .... register #02: 00000000
[    5.389771] .......     : arbitration: 00
[    5.390727] .... IRQ redirection table:
[    5.391668] 1    0    0   0   0    0    0    00
[    5.392705] 0    0    0   0   0    1    1    31
[    5.393729] 0    0    0   0   0    1    1    30
[    5.394752] 0    0    0   0   0    1    1    33
[    5.395784] 1    0    0   0   0    1    1    34
[    5.396826] 1    1    0   0   0    1    1    35
[    5.397855] 0    0    0   0   0    1    1    36
[    5.398879] 0    0    0   0   0    1    1    37
[    5.399909] 0    0    0   0   0    1    1    38
[    5.400953] 0    1    0   0   0    1    1    39
[    5.401980] 1    1    0   0   0    1    1    3A
[    5.403005] 1    1    0   0   0    1    1    3B
[    5.404043] 0    0    0   0   0    1    1    3C
[    5.405064] 0    0    0   0   0    1    1    3D
[    5.406084] 0    0    0   0   0    1    1    3E
[    5.407108] 0    0    0   0   0    1    1    3F
[    5.408139] 1    0    0   0   0    0    0    00
[    5.409159] 1    0    0   0   0    0    0    00
[    5.410190] 1    0    0   0   0    0    0    00
[    5.411212] 1    0    0   0   0    0    0    00
[    5.412247] 1    0    0   0   0    0    0    00
[    5.413278] 1    0    0   0   0    0    0    00
[    5.414302] 1    0    0   0   0    0    0    00
[    5.415326] 1    0    0   0   0    0    0    00
[    5.416358] IRQ to pin mappings:
[    5.417216] IRQ0 -> 0:2
[    5.418132] IRQ1 -> 0:1
[    5.419057] IRQ3 -> 0:3
[    5.419982] IRQ4 -> 0:4
[    5.420918] IRQ5 -> 0:5
[    5.421839] IRQ6 -> 0:6
[    5.422755] IRQ7 -> 0:7
[    5.423672] IRQ8 -> 0:8
[    5.424594] IRQ9 -> 0:9
[    5.425511] IRQ10 -> 0:10
[    5.426457] IRQ11 -> 0:11
[    5.427399] IRQ12 -> 0:12
[    5.428351] IRQ13 -> 0:13
[    5.429300] IRQ14 -> 0:14
[    5.430245] IRQ15 -> 0:15
[    5.431182] .................................... done.
[    5.432060] tsc: Refined TSC clocksource calibration: 2693.513 MHz
[    5.434288] registered taskstats version 1
[    5.436915] rtc_cmos 00:00: setting system clock to 2014-01-06 09:21:02 =
UTC (1389000062)
[    5.438769] BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
[    5.445465] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[    5.446672] 8021q: adding VLAN 0 to HW filter on device eth0
[    5.882471] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/=
i8042/serio1/input/input3
[    7.448708] e1000: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Contr=
ol: RX
[    7.452096] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[    7.468085] Sending DHCP requests ., OK
[    7.532094] IP-Config: Got DHCP answer from 10.0.2.2, my address is 10.0=
=2E2.15
[    7.535558] IP-Config: Complete:
[    7.537620]      device=3Deth0, hwaddr=3D52:54:00:12:34:56, ipaddr=3D10.=
0.2.15, mask=3D255.255.255.0, gw=3D10.0.2.2
[    7.540842]      host=3Dkbuildx-5, domain=3D, nis-domain=3D(none)
[    7.541996]      bootserver=3D10.0.2.2, rootserver=3D10.0.2.2, rootpath=
=3D
[    7.542846]      nameserver0=3D10.0.2.3
[    7.544333] PM: Hibernation image not present or could not be loaded.
[    7.547082] Freeing unused kernel memory: 1428K (ffffffff82336000 - ffff=
ffff8249b000)
[    7.548947] Write protecting the kernel read-only data: 18432k
[    7.555300] Freeing unused kernel memory: 1976K (ffff880001a12000 - ffff=
880001c00000)
[    7.561712] Freeing unused kernel memory: 2004K (ffff88000200b000 - ffff=
880002200000)
[    7.958040] microcode: CPU0 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.959932] platform microcode: Direct firmware load failed with error -2
[    7.962927] platform microcode: Falling back to user helper
[    7.998572] microcode: CPU1 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    7.999804] platform microcode: Direct firmware load failed with error -2
[    8.001201] platform microcode: Falling back to user helper
[    8.006224] microcode: CPU2 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.007853] platform microcode: Direct firmware load failed with error -2
[    8.009242] platform microcode: Falling back to user helper
[    8.016053] microcode: CPU3 sig=3D0xf61, pf=3D0x1, revision=3D0x1
[    8.017564] platform microcode: Direct firmware load failed with error -2
[    8.019251] platform microcode: Falling back to user helper
[    8.027954] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.f=
snet.co.uk>, Peter Oruba
[    8.716990] random: vgscan urandom read with 21 bits of entropy available

=3D=3D> /tmp/run_log <=3D=3D
Kernel tests: Boot OK!
PATH=3D/sbin:/usr/sbin:/bin:/usr/bin

=3D=3D> /tmp/err_log <=3D=3D

=3D=3D> /tmp/run_log <=3D=3D
downloading latest lkp src code
Files /etc/init.d/nfsroot and /lkp/lkp/src/rootfs/addon/etc/init.d/nfsroot =
differ
find a new version of this script, reloading...
Kernel tests: Boot OK 2!
/lkp/lkp/src/bin/run-lkp
LKP_SRC_DIR=3D/lkp/lkp/src
Stopping watchdog keepalive daemon....
Starting watchdog daemon....
RESULT_ROOT=3D/lkp/result/kbuildx/micro/dd-write/4HDD-JBOD-cfq-btrfs-100dd/=
x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a2/4
job=3D/lkp/scheduled/kbuildx-5/validate_dd-write-4HDD-JBOD-cfq-btrfs-100dd-=
x86_64-lkp-c05f7cec62c6134b710d634b0cc456e9e0f480a2-3.yaml
2014-01-06 09:21:39 mount -t debugfs none /sys/kernel/debug
run-job /lkp/scheduled/kbuildx-5/validate_dd-write-4HDD-JBOD-cfq-btrfs-100d=
d-x86_64-lkp-c05f7cec62c6134b710d634b0cc456e9e0f480a2-3.yaml
run: /lkp/lkp/src/setup/disk
run: /lkp/lkp/src/setup/md
run: /lkp/lkp/src/setup/iosched
run: /lkp/lkp/src/setup/fs
2014-01-06 09:21:40 mkfs -t btrfs /dev/vdb
run: /lkp/lkp/src/monitors/wrapper perf-stat
run: /lkp/lkp/src/monitors/event/wait pre-test
2014-01-06 09:21:40 mkfs -t btrfs /dev/vdc
2014-01-06 09:21:40 mkfs -t btrfs /dev/vde
2014-01-06 09:21:40 mkfs -t btrfs /dev/vdd
run: /lkp/lkp/src/monitors/wrapper ftrace

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdd

Btrfs v0.20-rc1-566-gd1570a0

WARNING! - Bdevid 1 transid 4 /dev/vdb
trfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before=20
[   23.563370] btrfs: device fsid 78d069c9-259b-43ae-915e-b725f42d07b6 using

fs created label (null) on /dev/vdb

Btrfs v0.20-rc1-566-gd1570a0

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vde

6 sectorsize 4096 size 256.00GiB
Btrfs v0.20-rc1-566-gd1570a0

WARNING! - Btrfs v0.20-rc1-566-gd1570a0 IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

fs created label (null) on /dev/vdc

Btrfs v0.20-rc1-566-gd1570a0
[   23.584347] btrfs: device fsid 74de7be7-6f7f-4c02-9bc8-90a7dd581724 devi=
d 1 transid 4 /dev/vdc
2014-01-06 09:21:40 mount -t btrfs /dev/vdb /fs/vdb
[   23.591575] btrfs: device fsid 495b43a7-1fbd-4091-8556-df9ecb7eb820 devi=
d 1 transid 4 /dev/vde
[   23.594184] btrfs: device fsid 6e5da97e-2209-465e-9e4d-b6605c23f626 devi=
d 1 transid 4 /dev/vdb
[   23.598320] btrfs: disk space caching is enabled
[  111.657131] random: nonblocking pool is initialized
[ 1398.988324] SysRq : Show Blocked State
[ 1398.992007]   task                        PC stack   pid father
[ 1398.992007] mount           D 0000000000000002     0  2875   2870 0x0000=
0000
[ 1398.992007]  ffff88007f859a70 0000000000000082 ffff88007f859fd8 ffff8803=
d21c6c10
[ 1398.992007]  0000000000012fc0 ffff8803d21c6c10 0000000000000000 00000000=
00000000
[ 1398.992007]  ffff8803d2d22068 0000000000000008 ffff88007f859a18 ffffffff=
814c2b62
[ 1398.992007] Call Trace:
[ 1398.992007]  [<ffffffff814c2b62>] ? submit_bio+0x106/0x159
[ 1398.992007]  [<ffffffff81431c6a>] ? __do_readpage+0x4b9/0x50e
[ 1398.992007]  [<ffffffff81064a03>] ? kvm_clock_read+0x27/0x31
[ 1398.992007]  [<ffffffff81064a16>] ? kvm_clock_get_cycles+0x9/0xb
[ 1398.992007]  [<ffffffff811651a1>] ? filemap_fdatawait+0x23/0x23
[ 1398.992007]  [<ffffffff819ff356>] schedule+0x6f/0x71
[ 1398.992007]  [<ffffffff819ff59b>] io_schedule+0x8f/0xd6
[ 1398.992007]  [<ffffffff811651af>] sleep_on_page+0xe/0x12
[ 1398.992007]  [<ffffffff819ff861>] __wait_on_bit+0x48/0x7b
[ 1398.992007]  [<ffffffff81165002>] wait_on_page_bit+0x7a/0x7c
[ 1398.992007]  [<ffffffff810f7ee3>] ? autoremove_wake_function+0x34/0x34
[ 1398.992007]  [<ffffffff81433eee>] read_extent_buffer_pages+0x1ae/0x23b
[ 1398.992007]  [<ffffffff81410da7>] ? free_root_pointers+0x5b/0x5b
[ 1398.992007]  [<ffffffff814123e5>] btree_read_extent_buffer_pages.constpr=
op.48+0x66/0x100
[ 1398.992007]  [<ffffffff814129d1>] read_tree_block+0x2f/0x47
[ 1398.992007]  [<ffffffff814163e6>] open_ctree+0x1271/0x1adf
[ 1398.992007]  [<ffffffff813f4243>] btrfs_mount+0x47b/0x771
[ 1398.992007]  [<ffffffff814e1f8c>] ? get_from_free_list+0x41/0x4b
[ 1398.992007]  [<ffffffff811c40bf>] mount_fs+0x15/0xae
[ 1398.992007]  [<ffffffff811d9a52>] vfs_kern_mount+0x64/0xf6
[ 1398.992007]  [<ffffffff811dbff6>] do_mount+0x781/0x878
[ 1398.992007]  [<ffffffff8117d6c2>] ? strndup_user+0x3a/0xd6
[ 1398.992007]  [<ffffffff811dc317>] SyS_mount+0x85/0xbe
[ 1398.992007]  [<ffffffff81a09529>] system_call_fastpath+0x16/0x1b
[ 1398.992007] Sched Debug Version: v0.11, 3.13.0-rc6-00148-gc05f7ce #1
[ 1398.992007] ktime                                   : 1399038.734310
[ 1398.992007] sched_clk                               : 1415438.510034
[ 1398.992007] cpu_clk                                 : 1398992.007974
[ 1398.992007] jiffies                                 : 4295242056
[ 1398.992007] sched_clock_stable                      : 0
[ 1398.992007]=20
[ 1398.992007] sysctl_sched
[ 1398.992007]   .sysctl_sched_latency                    : 18.000000
[ 1398.992007]   .sysctl_sched_min_granularity            : 2.250000
[ 1398.992007]   .sysctl_sched_wakeup_granularity         : 3.000000
[ 1398.992007]   .sysctl_sched_child_runs_first           : 0
[ 1398.992007]   .sysctl_sched_features                   : 77435
[ 1398.992007]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[ 1398.992007]=20
[ 1398.992007] cpu#0, 2693.544 MHz
[ 1398.992007]   .nr_running                    : 0
[ 1398.992007]   .load                          : 0
[ 1398.992007]   .nr_switches                   : 26313
[ 1398.992007]   .nr_load_updates               : 10592
[ 1398.992007]   .nr_uninterruptible            : 9
[ 1398.992007]   .next_balance                  : 4295.241854
[ 1398.992007]   .curr->pid                     : 0
[ 1398.992007]   .clock                         : 1398224.612707
[ 1398.992007]   .cpu_load[0]                   : 0
[ 1398.992007]   .cpu_load[1]                   : 0
[ 1398.992007]   .cpu_load[2]                   : 0
[ 1398.992007]   .cpu_load[3]                   : 0
[ 1398.992007]   .cpu_load[4]                   : 0
[ 1398.992007]=20
[ 1398.992007] cfs_rq[0]:/
[ 1398.992007]   .exec_clock                    : 0.000000
[ 1398.992007]   .MIN_vruntime                  : 0.000001
[ 1398.992007]   .min_vruntime                  : 7220.470714
[ 1398.992007]   .max_vruntime                  : 0.000001
[ 1398.992007]   .spread                        : 0.000000
[ 1398.992007]   .spread0                       : 0.000000
[ 1398.992007]   .nr_spread_over                : 0
[ 1398.992007]   .nr_running                    : 0
[ 1398.992007]   .load                          : 0
[ 1398.992007]   .runnable_load_avg             : 0
[ 1398.992007]   .blocked_load_avg              : 0
[ 1398.992007]   .tg_load_contrib               : 0
[ 1398.992007]   .tg_runnable_contrib           : 11
[ 1398.992007]   .tg_load_avg                   : 3
[ 1398.992007]   .tg->runnable_avg              : 17
[ 1398.992007]   .avg->runnable_avg_sum         : 545
[ 1398.992007]   .avg->runnable_avg_period      : 47871
[ 1398.992007]=20
[ 1398.992007] rt_rq[0]:
[ 1398.992007]   .rt_nr_running                 : 0
[ 1398.992007]   .rt_throttled                  : 0
[ 1398.992007]   .rt_time                       : 0.000000
[ 1398.992007]   .rt_runtime                    : 950.000000
[ 1398.992007]=20
[ 1398.992007] runnable tasks:
[ 1398.992007]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1398.992007] ------------------------------------------------------------=
----------------------------------------------
[ 1398.992007]             init     1      7210.538523      2902   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      ksoftirqd/0     3      7209.924457       694   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/0:0     4       384.878024        14   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]     kworker/0:0H     5      2402.961974         5   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           rcu_bh     8        59.831297         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      migration/0     9         0.000000       242     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]        kdevtmpfs    23      3784.446975       145   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]     kworker/u8:1    25      7210.947854       467   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/0:1   565      7220.470714      2057   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          kswapd0   692      2921.884993         3   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]             ksmd   693      2371.871474         3   125     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]       khugepaged   760      2378.642788         2   139     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           nfsiod   783      2390.792594         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          cifsiod   789      2396.845018         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]         xfsalloc   804      2402.896512         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]    xfs_mru_cache   805      2411.961884         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          xfslogd   806      2421.041906         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           bioset   814      2430.121241         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           crypto   821      2439.202633         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]         pencrypt   843      2639.146017         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]         pdecrypt   845      2648.199855         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]         kthrotld   879      2930.876460         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]        scsi_eh_1  1033      2932.964554        10   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]            udevd  1452      6610.074254        20   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          rpcbind  2364      7209.591141        67   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]        rpc.statd  2392      5793.027100        19   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]         startpar  2499      6242.211896        46   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      dbus-daemon  2578      6083.257503         1   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          nfsroot  2653      6277.510961        64   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]             tail  2672      6617.787886        32   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          run-lkp  2709      7163.802958        25   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          run-job  2750      6449.899187        13   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          run-job  2818      6455.874788         1   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]               fs  2793      6603.170477        17   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]   btrfs-submit-1  2882      7194.975646        19   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]    btrfs-endio-1  2885      7194.975047        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-endio-met  2886      7194.976839        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-endio-met  2889      7194.977112        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-freespace  2891      7194.975282        24   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-delayed-m  2892      7195.024679        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-qgroup-re  2896      7194.975180        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]             wait  2897      6667.066445         3   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]=20
[ 1398.992007] cpu#1, 2693.544 MHz
[ 1398.992007]   .nr_running                    : 1
[ 1398.992007]   .load                          : 1024
[ 1398.992007]   .nr_switches                   : 22799
[ 1398.992007]   .nr_load_updates               : 8882
[ 1398.992007]   .nr_uninterruptible            : 0
[ 1398.992007]   .next_balance                  : 4295.242144
[ 1398.992007]   .curr->pid                     : 2717
[ 1398.992007]   .clock                         : 1398988.147153
[ 1398.992007]   .cpu_load[0]                   : 3
[ 1398.992007]   .cpu_load[1]                   : 2
[ 1398.992007]   .cpu_load[2]                   : 1
[ 1398.992007]   .cpu_load[3]                   : 1
[ 1398.992007]   .cpu_load[4]                   : 1
[ 1398.992007]=20
[ 1398.992007] cfs_rq[1]:/
[ 1398.992007]   .exec_clock                    : 0.000000
[ 1398.992007]   .MIN_vruntime                  : 0.000001
[ 1398.992007]   .min_vruntime                  : 13443.903647
[ 1398.992007]   .max_vruntime                  : 0.000001
[ 1398.992007]   .spread                        : 0.000000
[ 1398.992007]   .spread0                       : 6223.432933
[ 1398.992007]   .nr_spread_over                : 0
[ 1398.992007]   .nr_running                    : 1
[ 1398.992007]   .load                          : 1024
[ 1398.992007]   .runnable_load_avg             : 0
[ 1398.992007]   .blocked_load_avg              : 3
[ 1398.992007]   .tg_load_contrib               : 3
[ 1398.992007]   .tg_runnable_contrib           : 6
[ 1398.992007]   .tg_load_avg                   : 3
[ 1398.992007]   .tg->runnable_avg              : 17
[ 1398.992007]   .avg->runnable_avg_sum         : 312
[ 1398.992007]   .avg->runnable_avg_period      : 47182
[ 1398.992007]=20
[ 1398.992007] rt_rq[1]:
[ 1398.992007]   .rt_nr_running                 : 0
[ 1398.992007]   .rt_throttled                  : 0
[ 1398.992007]   .rt_time                       : 0.000000
[ 1398.992007]   .rt_runtime                    : 950.000000
[ 1398.992007]=20
[ 1398.992007] runnable tasks:
[ 1398.992007]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1398.992007] ------------------------------------------------------------=
----------------------------------------------
[ 1398.992007]         kthreadd     2     13245.163772       148   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      migration/1    10         0.000000       327     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      ksoftirqd/1    11     13434.717200       426   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/1:0    12      4977.071818        14   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]     kworker/1:0H    13      6909.180580         6   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          khelper    22         7.536144         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]            netns    24        19.805280         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]        writeback   424      3551.001986         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           bioset   427      3569.001976         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          ata_sff   536      4725.153318         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]            khubd   547      4824.176583         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]               md   557      4914.184784         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/1:1   566     13437.748746      1115   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           rpciod   661      5825.444519         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]        kpsmoused  1144      8028.023386         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           bcache  1157      8107.382376         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]            udevd  1347     13259.267117       130   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007] R        run-lkp  2717     13435.153496        20   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]=20
[ 1398.992007] cpu#2, 2693.544 MHz
[ 1398.992007]   .nr_running                    : 0
[ 1398.992007]   .load                          : 0
[ 1398.992007]   .nr_switches                   : 28486
[ 1398.992007]   .nr_load_updates               : 14659
[ 1398.992007]   .nr_uninterruptible            : 2
[ 1398.992007]   .next_balance                  : 4295.242057
[ 1398.992007]   .curr->pid                     : 0
[ 1398.992007]   .clock                         : 1399308.075825
[ 1398.992007]   .cpu_load[0]                   : 0
[ 1398.992007]   .cpu_load[1]                   : 0
[ 1398.992007]   .cpu_load[2]                   : 0
[ 1398.992007]   .cpu_load[3]                   : 0
[ 1398.992007]   .cpu_load[4]                   : 0
[ 1398.992007]=20
[ 1398.992007] cfs_rq[2]:/
[ 1398.992007]   .exec_clock                    : 0.000000
[ 1398.992007]   .MIN_vruntime                  : 0.000001
[ 1398.992007]   .min_vruntime                  : 7336.821552
[ 1398.992007]   .max_vruntime                  : 0.000001
[ 1398.992007]   .spread                        : 0.000000
[ 1398.992007]   .spread0                       : 116.350838
[ 1398.992007]   .nr_spread_over                : 0
[ 1398.992007]   .nr_running                    : 0
[ 1398.992007]   .load                          : 0
[ 1398.992007]   .runnable_load_avg             : 0
[ 1398.992007]   .blocked_load_avg              : 0
[ 1398.992007]   .tg_load_contrib               : 0
[ 1398.992007]   .tg_runnable_contrib           : 0
[ 1398.992007]   .tg_load_avg                   : 3
[ 1398.992007]   .tg->runnable_avg              : 17
[ 1398.992007]   .avg->runnable_avg_sum         : 23
[ 1398.992007]   .avg->runnable_avg_period      : 46719
[ 1398.992007]=20
[ 1398.992007] rt_rq[2]:
[ 1398.992007]   .rt_nr_running                 : 0
[ 1398.992007]   .rt_throttled                  : 0
[ 1398.992007]   .rt_time                       : 0.320477
[ 1398.992007]   .rt_runtime                    : 950.000000
[ 1398.992007]=20
[ 1398.992007] runnable tasks:
[ 1398.992007]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1398.992007] ------------------------------------------------------------=
----------------------------------------------
[ 1398.992007]     kworker/u8:0     6      6834.725585      1894   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]        rcu_sched     7      7336.322751      7999   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      migration/2    14         0.000000       239     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      ksoftirqd/2    15      7336.821552      1517   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]     kworker/2:0H    17      1672.103268         6   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kintegrityd   426        36.018596         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          kblockd   429        45.020087         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      edac-poller   560        51.021049         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/2:1   567      7330.266410      1698   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]    fsnotify_mark   761      6584.517298        13   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]         iscsi_eh   997      2356.488797         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]        scsi_eh_0  1030      2757.419619         4   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/2:2  1146      2855.818484         6   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          raid5wq  1156      2812.946109         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]     bch_btree_io  1158      2822.059058         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]   dm_bufio_cache  1163      2831.204111         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          kmpathd  1164      2840.398434         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  kmpath_handlerd  1165      2849.442978         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          deferwq  1218      2858.651747         2   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]         watchdog  2732         0.000000      2761    98     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          run-job  2746      6447.411620        36   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          run-job  2794      6623.193781         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]            udevd  2804      6575.379915         9   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]             wait  2817      6506.775860        21   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]    cat-perf-stat  2837      6585.288443         6   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]            mount  2875      6791.163767        27   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]   btrfs-worker-1  2880      7327.807388        19   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-genwork-1  2881      7327.756089        18   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-delalloc-  2883      7327.754483        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]    btrfs-fixup-1  2884      7327.765662        20   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      btrfs-rmw-1  2887      7327.754647        24   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-endio-rai  2888      7327.754900        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-endio-wri  2890      7327.754852        24   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]    btrfs-cache-1  2893      7327.766080        24   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-readahead  2894      7327.754107        23   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]  btrfs-flush_del  2895      7327.754565        24   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]=20
[ 1398.992007] cpu#3, 2693.544 MHz
[ 1398.992007]   .nr_running                    : 0
[ 1398.992007]   .load                          : 0
[ 1398.992007]   .nr_switches                   : 6459
[ 1398.992007]   .nr_load_updates               : 2491
[ 1398.992007]   .nr_uninterruptible            : -10
[ 1398.992007]   .next_balance                  : 4295.242156
[ 1398.992007]   .curr->pid                     : 0
[ 1398.992007]   .clock                         : 1399432.071209
[ 1398.992007]   .cpu_load[0]                   : 0
[ 1398.992007]   .cpu_load[1]                   : 0
[ 1398.992007]   .cpu_load[2]                   : 0
[ 1398.992007]   .cpu_load[3]                   : 0
[ 1398.992007]   .cpu_load[4]                   : 0
[ 1398.992007]=20
[ 1398.992007] cfs_rq[3]:/
[ 1398.992007]   .exec_clock                    : 0.000000
[ 1398.992007]   .MIN_vruntime                  : 0.000001
[ 1398.992007]   .min_vruntime                  : 3904.603064
[ 1398.992007]   .max_vruntime                  : 0.000001
[ 1398.992007]   .spread                        : 0.000000
[ 1398.992007]   .spread0                       : -3315.867650
[ 1398.992007]   .nr_spread_over                : 0
[ 1398.992007]   .nr_running                    : 0
[ 1398.992007]   .load                          : 0
[ 1398.992007]   .runnable_load_avg             : 0
[ 1398.992007]   .blocked_load_avg              : 0
[ 1398.992007]   .tg_load_contrib               : 0
[ 1398.992007]   .tg_runnable_contrib           : 0
[ 1398.992007]   .tg_load_avg                   : 3
[ 1398.992007]   .tg->runnable_avg              : 6
[ 1398.992007]   .avg->runnable_avg_sum         : 30
[ 1398.992007]   .avg->runnable_avg_period      : 48225
[ 1398.992007]=20
[ 1398.992007] rt_rq[3]:
[ 1398.992007]   .rt_nr_running                 : 0
[ 1398.992007]   .rt_throttled                  : 0
[ 1398.992007]   .rt_time                       : 0.000000
[ 1398.992007]   .rt_runtime                    : 950.000000
[ 1398.992007]=20
[ 1398.992007] runnable tasks:
[ 1398.992007]             task   PID         tree-key  switches  prio     =
exec-runtime         sum-exec        sum-sleep
[ 1398.992007] ------------------------------------------------------------=
----------------------------------------------
[ 1398.992007]      migration/3    18         0.000000       263     0     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      ksoftirqd/3    19      3895.909348       366   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]     kworker/3:0H    21        73.896057         6   100     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/3:1   568      3898.695401       775   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]      kworker/3:2  1138       197.887914         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]               rc  2489      2912.842820        15   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]           mcelog  2543      3031.074097         3   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]             sshd  2608      3052.797647         2   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]          run-job  2752      3805.700414        18   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]              cmd  2870      3834.527978         9   120     =
          0               0               0.000000               0.000000  =
             0.000000 0 /
[ 1398.992007]=20
[ 1399.510929] SysRq : Emergency Sync
[ 1409.513383] SysRq : Resetting

BUG: kernel test crashed
Elapsed time: 1425
numactl --preferred=3D0 --physcpubind=3D20-23 qemu-system-x86_64 -cpu kvm64=
 -enable-kvm -kernel /kernel/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f=
480a2/vmlinuz-3.13.0-rc6-00148-gc05f7ce -append 'user=3Dlkp job=3D/lkp/sche=
duled/kbuildx-5/validate_dd-write-4HDD-JBOD-cfq-btrfs-100dd-x86_64-lkp-c05f=
7cec62c6134b710d634b0cc456e9e0f480a2-3.yaml ARCH=3Dx86_64 BOOT_IMAGE=3D/ker=
nel/x86_64-lkp/c05f7cec62c6134b710d634b0cc456e9e0f480a2/vmlinuz-3.13.0-rc6-=
00148-gc05f7ce kconfig=3Dx86_64-lkp commit=3Dc05f7cec62c6134b710d634b0cc456=
e9e0f480a2 modules_initrd=3D/kernel/x86_64-lkp/c05f7cec62c6134b710d634b0cc4=
56e9e0f480a2/modules.cgz max_uptime=3D1200 RESULT_ROOT=3D/lkp/result/kbuild=
x/micro/dd-write/4HDD-JBOD-cfq-btrfs-100dd/x86_64-lkp/c05f7cec62c6134b710d6=
34b0cc456e9e0f480a2/4 initrd=3D/kernel-tests/initrd/lkp-rootfs.cgz root=3D/=
dev/ram0 ip=3D::::kbuildx-5::dhcp oops=3Dpanic earlyprintk=3DttyS0,115200 d=
ebug apic=3Ddebug sysrq_always_enabled panic=3D10 load_ramdisk=3D2 prompt_r=
amdisk=3D0 console=3DttyS0,115200 console=3Dtty0 vga=3Dnormal'  -initrd /fs=
/sdf1/initrd-kbuildx-5 -m 16G -smp 4 -net nic,vlan=3D1,model=3De1000 -net u=
ser,vlan=3D1,hostfwd=3Dtcp::10096-:22 -boot order=3Dnc -no-reboot -watchdog=
 i6300esb -rtc base=3Dlocaltime -drive file=3D/fs/sdf1/disk0-kbuildx-5,medi=
a=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1/disk1-kbuildx-5,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/sdf1/disk2-kbuildx-5,media=3Ddisk,if=3Dvirtio -=
drive file=3D/fs/sdf1/disk3-kbuildx-5,media=3Ddisk,if=3Dvirtio -drive file=
=3D/fs/sdf1/disk4-kbuildx-5,media=3Ddisk,if=3Dvirtio -drive file=3D/fs/sdf1=
/disk5-kbuildx-5,media=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-kbuil=
dx-5 -serial file:/dev/shm/kboot/serial-kbuildx-5 -daemonize -display none =
-monitor null=20

--VS++wcV0S1rZb1Fb--
