Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759776Ab3CGUVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:21:17 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:37877 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab3CGUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:21:14 -0500
Message-ID: <5138F6B6.8050208@googlemail.com>
Date: Thu, 07 Mar 2013 20:21:10 +0000
From: Chris Clayton <chris2553@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130220 Thunderbird/17.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Yijing Wang <wangyijing@huawei.com>,
        Yijing Wang <wangyijing0307@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com> <510189B1.606@fold.natur.cuni.cz> <5104427D.2050002@googlemail.com> <510494D6.1010000@gmail.com> <51050D43.2050703@googlemail.com> <51051B1B.3080105@gmail.com> <51052DB2.4090702@googlemail.com> <51053917.6060400@fold.natur.cuni.cz> <5105491E.9050907@googlemail.com> <510558CE.9000600@fold.natur.cuni.cz> <5105AFDB.9000200@googlemail.com> <5105E51D.2020606@huawei.com> <51064F1A.1020909@googlemail.com> <51065FA6.4070208@googlemail.com> <51066B46.10409@fold.natur.cuni.cz> <5106CD6C.4070009@googlemail.com> <5106E770.9070602@fold.natur.cuni.cz> <510A5F0E.6010100@googlemail.com> <CAErSpo4x8pb7J8MnokXiFTE=01-TffCk6CKC0VS7CEf3X1bSBw@mail.gmail.com> <5138C03C.8080600@googlemail.com> <CAErSpo4nyRgUf8hsbNKBTzW+eqzyNTrLFYFaJ6v=sSVQg7CBPw@mail.gmail.com>
In-Reply-To: <CAErSpo4nyRgUf8hsbNKBTzW+eqzyNTrLFYFaJ6v=sSVQg7CBPw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080407000009070606020706"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080407000009070606020706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



On 03/07/13 17:30, Bjorn Helgaas wrote:
> On Thu, Mar 7, 2013 at 9:28 AM, Chris Clayton <chris2553@googlemail.com> wrote:
>>
>>
>> On 03/06/13 23:45, Bjorn Helgaas wrote:
>>>
>>> On Thu, Jan 31, 2013 at 5:09 AM, Chris Clayton <chris2553@googlemail.com>
>>> wrote:
>>>
>>>> My usb3 expresscard device has arrived and I get an oops with that too,
>>>> if I
>>>> remove it without unloading the driver first. I guess it shouldn't be a
>>>> surprise that the driver isn't expecting the device to disappear.
>>>>
>>>> As I mentioned, I have some trouble with the WinTV-HVR-1400 card, which
>>>> sometimes pops out again, if I push it into the slot too hard (but I'm
>>>> geeting better at that with practice). So what I've done (with the usb3
>>>> card
>>>> too) to avoid the oopsen is blacklist the driver in
>>>> /etc/modprobe.d/blacklist.conf and then load them when I'm sure the card
>>>> is
>>>> properly inserted. Not exactly hotplug, but at least I don't have to
>>>> reboot
>>>> because of an oops- and it's not something I'm doing several times an
>>>> hour.
>>>
>>>
>>> Hi Chris,
>>>
>>> What's the current state of this?  It sounds to me like it still
>>> doesn't work out of the box.  Having to blacklist the driver and load
>>> it manually is a completely unacceptable user experience.  If you have
>>> to manually choose acpiphp over pciehp, that is also unacceptable.
>>>
>>> So if you're still limping along with hacky workarounds like this, I'd
>>> like to pursue this more and see if we can't figure out a better
>>> solution.
>>>
>>> Bjorn
>>>
>> Hi Bjorn,
>>
>> If I unblacklist the driver, insert the HVR-1400 card and then remove it, I
>> still get the oops. This is with kernel 3.8.2. I no longer get the oops with
>> the USB3 card, but I don't know how or when that was fixed.
>>
>> I stopped working on it when, after finding the workaround to the oops and
>> then spending many many hours figuring out a fix so that scandvb would find
>> some channels, no one on the linux-media list seemed interested in the fix.
>> On top of that, even though scanning now finds all the available channels,
>> the quality of the TV picture and sound is very poor indeed. I didn't want
>> to bang my head against the linux-media wall again, so I abandoned the card
>> and now use a USB TV stick, which gives is much better results than the
>> card. It's a pity because the card also supports an analog signal which
>> means I can watch the RF output from my satellite box, which I have piped
>> around the house. Anyway, the linux-media folks are not your problem and if
>> I want to watch satellite TV on my laptop, I can make one of my rare visits
>> to Windows (where the picture and sound are good).
>>
>> Having said (ranted?) all that, I would be more than happy to help fix the
>> oops. After I first reported it, I realised that I didn't have a hotplug
>> driver loaded. With help from Yijing Wang, we eventually managed to get the
>> card recognised and drivers loaded when it is inserted. That doesn't help
>> with the oops, though. I now have the pciehp driver compiled statically onto
>> the kernel (and pass pcie_ports=native to the kernel), but removing the card
>> with the cx23885 driver loaded always results in an oops. I originally
>> reported this to the linux-media list because functions from the cx23885
>> driver are at the top of the call trace, but only Martin responded with some
>> hotplug-related suggestions, which is what swung discussion the way of the
>> linux-pci list.
>
> OK.  There are several potential problems here.
>
> 1) The change to make scandvb find some channels.  This is probably a
> cx23885 or linux-media issue, and I can't help with that.
>
> 2) TV picture/sound quality problem.  Again, probably a cx23885 driver
> issue, and I can't help with that.
>

I'm not going to use the card and I don't have the time (or patience) to 
submit the change again.

> 3) HVR-1400 not being recognized when inserted.  This is a PCI hotplug
> issue, and I *can* help with this.  I don't know what your hardware
> is, but in general, pciehp should take care of this.  If it doesn't,
> or if you have to use an argument like "pcie_ports=native", we should
> fix this.
>
> 4) Oops when removing HVR-1400 ExpressCard.  From the backtrace, I
> assume the cx23885 driver is still bound to the device when you remove
> the card.  It'd be nice if the driver could handle the device going
> away, but I'm not surprised that it doesn't.
>

Nor am I, but it's hardly plug and play, is it. With Windows I can plug 
and unplug the card at will without crashing the system.

> If you unbind the driver before removing the card, the oops should not
> happen.  You should be able to do this manually with something like
> this (with the address of your device, of course):
>
>      # echo 0000:05:00.0 > /sys/bus/pci/drivers/cx23885/unbind
>
> It would also be nice if there were a good user interface for doing
> this, e.g., something like "Safely remove hardware" on Windows.  But I
> don't know what it is on Linux.
>

Thanks, I'll look into that and see if I can write a little panel applet 
to provide a UI.

> So 3) is the thing I might be able to help with.  If there's still a
> problem here (and even having to boot with an argument is a problem),
> let's start by collecting complete dmesg logs, with and without your
> "pcie_ports" option.  Boot without the card installed, then insert it
> and remove it.  If you can use something like v3.9-rc1 with
> CONFIG_HOTPLUG_PCI_PCIE=y, that would be ideal.
>

OK, I've gathered these logs using a kernel built from a pull of Linus' 
tree this afternoon (v3.9-rc1-108-g9f22578). Also, the cx23885 driver is 
still blacklisted to avoid unnecessary noise and the chance of an oops 
if the card springs out again when I insert it. The driver does load if 
it's not blacklisted (and the pcie_ports=native option is present).

The two logs are attached. As you will see, nothing at all happens when 
the pcie_ports=native option is absent. The nf_conntrack message is 
normally the last one from a normal boot.

Chris

> Bjorn
>

--------------080407000009070606020706
Content-Type: text/plain; charset=us-ascii;
 name="dmesg-with-arg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-with-arg"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1+ (chris@laptop) (gcc version 4.7.3 20130302 (prerelease) (GCC) ) #34 SMP PREEMPT Thu Mar 7 19:33:03 GMT 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dab0efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dab0f000-0x00000000dad4efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dad4f000-0x00000000dad6efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dad6f000-0x00000000daf1efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000daf1f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: FUJITSU LIFEBOOK AH531/FJNBB0F, BIOS 1.30 05/28/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x21fe00 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21FE00000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x01628000, 0x01628fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x34000000-0x379fffff]
[    0.000000]  [mem 0x34000000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] ACPI: RSDP 000f00e0 00024 (v02 FUJ   )
[    0.000000] ACPI: XSDT daffe120 00084 (v01 FUJ    PC       00000001 FUJ  00000001)
[    0.000000] ACPI: FACP daff0000 000F4 (v03 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: DSDT daff3000 0794A (v02 FUJ    FJNBB0F  00000000 INTL 20061109)
[    0.000000] ACPI: FACS daf3d000 00040
[    0.000000] ACPI: SLIC daffd000 00176 (v01 FUJ    PC       00000001 FUJ  00000001)
[    0.000000] ACPI: SSDT daffb000 01068 (v01 FUJ    PtidDevc 00001000 INTL 20061109)
[    0.000000] ACPI: ASF! daff2000 000A5 (v32 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: HPET dafef000 00038 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: APIC dafee000 00098 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: MCFG dafed000 0003C (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: SSDT dafec000 007C2 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT dafeb000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI dafea000 0003E (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: UEFI dafe9000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI dafe8000 00242 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 7810MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x01629000, 0x01629fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x1fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xdab0efff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x00000000-0x1fdfffff]
[    0.000000] On node 0 totalpages: 2074796
[    0.000000] free_area_init_node: node 0, pgdat c1569140, node_mem_map f37fe020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 15621 pages used for memmap
[    0.000000]   HighMem zone: 1846546 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: 8 Processors exceeds NR_CPUS limit of 4
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f37bc000 s26496 r0 d22656 u49152
[    0.000000] pcpu-alloc: s26496 r0 d22656 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2073012
[    0.000000] Kernel command line: root=/dev/sda5 pcie_ports=native ro resume=/dev/sda6
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00037bfe:0021fe00)
[    0.000000] Memory: 8221536k/8910848k available (4096k kernel code, 77644k reserved, 1466k data, 376k init, 7386180k highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
      .init : 0xc156f000 - 0xc15cd000   ( 376 kB)
      .data : 0xc1400258 - 0xc156eb80   (1466 kB)
      .text : 0xc1000000 - 0xc1400258   (4096 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f3008000 soft=f300a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.004000] tsc: Detected 2494.124 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.24 BogoMIPS (lpj=9976496)
[    0.000117] pid_max: default: 32768 minimum: 301
[    0.000198] Mount-cache hash table entries: 512
[    0.000430] Disabled fast string operations
[    0.000485] CPU: Physical Processor ID: 0
[    0.000539] CPU: Processor Core ID: 0
[    0.000596] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000674] mce: CPU supports 7 MCE banks
[    0.000736] CPU0: Thermal monitoring enabled (TM1)
[    0.000800] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
[    0.001003] Freeing SMP alternatives: 16k freed
[    0.001062] ACPI: Core revision 20130117
[    0.005472] ACPI: All ACPI Tables successfully acquired
[    0.005924] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.006395] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.046178] smpboot: CPU0: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz (fam: 06, model: 2a, stepping: 07)
[    0.046373] TSC deadline timer enabled
[    0.046381] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.046613] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.046674] ... version:                3
[    0.046728] ... bit width:              48
[    0.046783] ... generic registers:      4
[    0.046838] ... value mask:             0000ffffffffffff
[    0.046895] ... max period:             000000007fffffff
[    0.046951] ... fixed-purpose events:   3
[    0.047006] ... event mask:             000000070000000f
[    0.062595] CPU 1 irqstacks, hard=f30b2000 soft=f30b4000
[    0.072953] Initializing CPU#1
[    0.073724] Disabled fast string operations
[    0.062595] smpboot: Booting Node   0, Processors  #1
[    0.075909] CPU 2 irqstacks, hard=f30d2000 soft=f30d4000
[    0.086360] Initializing CPU#2
[    0.087149] Disabled fast string operations
[    0.076068]  #2
[    0.089325] CPU 3 irqstacks, hard=f30de000 soft=f30e8000
[    0.089485]  #3 OK
[    0.099786] Initializing CPU#3
[    0.100576] Disabled fast string operations
[    0.102692] Brought up 4 CPUs
[    0.102856] smpboot: Total of 4 processors activated (19952.99 BogoMIPS)
[    0.105542] devtmpfs: initialized
[    0.105801] PM: Registering ACPI NVS region [mem 0xdad4f000-0xdad6efff] (131072 bytes)
[    0.105865] PM: Registering ACPI NVS region [mem 0xdaf1f000-0xdaf9efff] (524288 bytes)
[    0.105992] NET: Registered protocol family 16
[    0.106176] ACPI: bus type pci registered
[    0.106270] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.106346] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.106405] PCI: Using MMCONFIG for extended config space
[    0.106462] PCI: Using configuration type 1 for base access
[    0.107558] bio: create slab <bio-0> at 0
[    0.107658] ACPI: Added _OSI(Module Device)
[    0.107714] ACPI: Added _OSI(Processor Device)
[    0.107769] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.107826] ACPI: Added _OSI(Processor Aggregator Device)
[    0.109096] ACPI: EC: Look up EC in DSDT
[    0.110340] ACPI: Executed 1 blocks of module-level executable AML code
[    0.122765] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.123178] ACPI: SSDT dad4d718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.123630] ACPI: Dynamic OEM Table Load:
[    0.123764] ACPI: SSDT   (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.134969] ACPI: SSDT daf0fa98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.135448] ACPI: Dynamic OEM Table Load:
[    0.135581] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.146869] ACPI: SSDT dad4cd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.147313] ACPI: Dynamic OEM Table Load:
[    0.147446] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.159408] ACPI: Interpreter enabled
[    0.159467] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.159667] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.159823]  S3 S4 S5)
[    0.159999] ACPI: Using IOAPIC for interrupt routing
[    0.160078] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.164578] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.164666] \_SB_.PCI0:_OSC invalid UUID
[    0.164666] _OSC request data:1 8 1f 
[    0.164693] \_SB_.PCI0:_OSC invalid UUID
[    0.164694] _OSC request data:1 f 1f 
[    0.164696] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.164759] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.165277] PCI host bridge to bus 0000:00
[    0.165334] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.165391] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.165450] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.166053] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.166113] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.166173] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.166239] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.166311] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.166320] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.166326] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.166330] pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
[    0.166417] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.166441] pci 0000:00:16.0: reg 10: [mem 0xf1605000-0xf160500f 64bit]
[    0.166502] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.166577] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.166598] pci 0000:00:1a.0: reg 10: [mem 0xf160a000-0xf160a3ff]
[    0.166670] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.166705] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.166794] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.166813] pci 0000:00:1b.0: reg 10: [mem 0xf1600000-0xf1603fff 64bit]
[    0.166867] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.166917] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.167014] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.167078] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.167177] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.167216] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.167301] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    0.167362] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.167393] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.167482] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.167503] pci 0000:00:1d.0: reg 10: [mem 0xf1609000-0xf16093ff]
[    0.167576] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.167607] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.167694] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    0.167827] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.167845] pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
[    0.167853] pci 0000:00:1f.2: reg 14: [io  0x4094-0x4097]
[    0.167861] pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
[    0.167868] pci 0000:00:1f.2: reg 1c: [io  0x4090-0x4093]
[    0.167876] pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
[    0.167884] pci 0000:00:1f.2: reg 24: [mem 0xf1608000-0xf16087ff]
[    0.167916] pci 0000:00:1f.2: PME# supported from D3hot
[    0.167968] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.167982] pci 0000:00:1f.3: reg 10: [mem 0xf1604000-0xf16040ff 64bit]
[    0.168003] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.168298] pci 0000:01:00.0: [8086:008a] type 00 class 0x028000
[    0.168462] pci 0000:01:00.0: reg 10: [mem 0xf1500000-0xf1501fff 64bit]
[    0.169019] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.169145] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.174954] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.175018] pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.175107] pci 0000:00:1c.3: PCI bridge to [bus 02-06]
[    0.175168] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.175173] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.175181] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.175256] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.175277] pci 0000:07:00.0: reg 10: [io  0x2000-0x20ff]
[    0.175311] pci 0000:07:00.0: reg 18: [mem 0xf0c04000-0xf0c04fff 64bit pref]
[    0.175332] pci 0000:07:00.0: reg 20: [mem 0xf0c00000-0xf0c03fff 64bit pref]
[    0.175392] pci 0000:07:00.0: supports D1 D2
[    0.175393] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.175433] pci 0000:07:00.0: System wakeup disabled by ACPI
[    0.182860] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.182947] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.182955] pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.182976] pci_bus 0000:00: on NUMA node 0
[    0.182977] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.183351] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.183929] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.184504] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.185080] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.185657] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.186312] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.186970] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.187544] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.188302] ACPI: Enabled 6 GPEs in block 00 to 3F
[    0.188441] acpi root: \_SB_.PCI0 notify handler is installed
[    0.188483] Found 1 acpi root devices
[    0.188511] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.188674] ACPI: No dock devices found.
[    0.188763] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.188826] vgaarb: loaded
[    0.188878] vgaarb: bridge control possible 0000:00:02.0
[    0.188985] SCSI subsystem initialized
[    0.189040] ACPI: bus type scsi registered
[    0.189106] libata version 3.00 loaded.
[    0.189109] ACPI: bus type usb registered
[    0.189178] usbcore: registered new interface driver usbfs
[    0.189244] usbcore: registered new interface driver hub
[    0.189321] usbcore: registered new device driver usb
[    0.189390] Linux video capture interface: v2.00
[    0.189473] Advanced Linux Sound Architecture Driver Initialized.
[    0.189532] PCI: Using ACPI for IRQ routing
[    0.191220] PCI: pci_cache_line_size set to 64 bytes
[    0.191311] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.191312] e820: reserve RAM buffer [mem 0xdab0f000-0xdbffffff]
[    0.191314] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.191315] e820: reserve RAM buffer [mem 0x21fe00000-0x21fffffff]
[    0.191442] Switching to clocksource hpet
[    0.191538] pnp: PnP ACPI init
[    0.191594] ACPI: bus type pnp registered
[    0.191669] pnp 00:00: [dma 4]
[    0.191683] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.191699] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    0.191767] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.191789] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.191819] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.191878] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.191937] system 00:04: [io  0xffff] has been reserved
[    0.191996] system 00:04: [io  0xffff] has been reserved
[    0.192054] system 00:04: [io  0x0400-0x0453] has been reserved
[    0.192112] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.192171] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.192229] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.192289] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.192307] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.192341] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.192401] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.192420] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.192438] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.192544] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.192604] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.192664] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.192724] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.192784] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.192844] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.192907] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.192967] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.193027] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    0.193088] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.193148] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.193312] system 00:0a: [mem 0x20000000-0x201fffff] could not be reserved
[    0.193373] system 00:0a: [mem 0x40000000-0x401fffff] could not be reserved
[    0.193441] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.193476] pnp: PnP ACPI: found 11 devices
[    0.193531] ACPI: ACPI bus type pnp unregistered
[    0.229464] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.229528] pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.229598] pci 0000:00:1c.3: PCI bridge to [bus 02-06]
[    0.229657] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.229721] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.229785] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.229852] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.229909] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.229973] pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.230160] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.230162] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.230163] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.230165] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
[    0.230166] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.230168] pci_bus 0000:01: resource 1 [mem 0xf1500000-0xf15fffff]
[    0.230169] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.230170] pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.230172] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.230173] pci_bus 0000:07: resource 0 [io  0x2000-0x2fff]
[    0.230174] pci_bus 0000:07: resource 2 [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.230197] NET: Registered protocol family 2
[    0.230369] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.230441] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.230510] TCP: Hash tables configured (established 8192 bind 8192)
[    0.230580] TCP: reno registered
[    0.230634] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.230695] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.230790] NET: Registered protocol family 1
[    0.230854] pci 0000:00:02.0: Boot video device
[    0.231072] PCI: CLS 64 bytes, default 64
[    0.231650] bounce pool size: 64 pages
[    0.232791] fuse init (API version 7.21)
[    0.232906] msgmni has been set to 1631
[    0.233235] io scheduler noop registered
[    0.233328] io scheduler cfq registered (default)
[    0.233627] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.233717] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 1c16 ss_vid 10cf ss_did 1610
[    0.233823] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    0.233829] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.233898] intel_idle: MWAIT substates: 0x21120
[    0.233898] intel_idle: v0.4 model 0x2A
[    0.233899] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.234023] ACPI: AC Adapter [ACAD] (on-line)
[    0.234195] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.234259] ACPI: Power Button [PWRB]
[    0.234340] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.234414] ACPI: Lid Switch [LID]
[    0.234493] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.234555] ACPI: Power Button [PWRF]
[    0.234661] ACPI: Requesting acpi_cpufreq
[    0.236490] thermal LNXTHERM:00: registered as thermal_zone0
[    0.236549] ACPI: Thermal Zone [THRM] (55 C)
[    0.236616] isapnp: Scanning for PnP cards...
[    0.237081] ACPI: Battery Slot [BAT1] (battery present)
[    0.590974] isapnp: No Plug & Play device found
[    0.595844] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.596230] Real Time Clock Driver v1.12b
[    0.596286] Linux agpgart interface v0.103
[    0.596363] [drm] Initialized drm 1.1.0 20060810
[    0.596722] [drm] Memory usable by graphics device = 2048M
[    0.596783] i915 0000:00:02.0: setting latency timer to 64
[    0.596937] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.596996] [drm] Driver supports precise vblank timestamp query.
[    0.597106] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.618321] [drm] Wrong MCH_SSKPD value: 0x16040307
[    0.618380] [drm] This can cause pipe underruns and display issues.
[    0.618439] [drm] Please upgrade your BIOS to fix this.
[    0.634607] fbcon: inteldrmfb (fb0) is primary device
[    1.228700] tsc: Refined TSC clocksource calibration: 2494.333 MHz
[    1.228702] Switching to clocksource tsc
[    1.774903] Console: switching to colour frame buffer device 170x48
[    1.777714] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.777736] i915 0000:00:02.0: registered panic notifier
[    1.797990] acpi device:31: registered as cooling_device4
[    1.798123] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.798175] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.798220] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.798312] ahci 0000:00:1f.2: version 3.0
[    1.813379] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x9 impl SATA mode
[    1.813412] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    1.813445] ahci 0000:00:1f.2: setting latency timer to 64
[    1.821518] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    1.821603] scsi0 : ahci
[    1.821655] scsi1 : ahci
[    1.821699] scsi2 : ahci
[    1.821742] scsi3 : ahci
[    1.821784] scsi4 : ahci
[    1.821827] scsi5 : ahci
[    1.821858] ata1: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608100 irq 19
[    1.821885] ata2: DUMMY
[    1.821893] ata3: DUMMY
[    1.821902] ata4: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608280 irq 19
[    1.821928] ata5: DUMMY
[    1.822364] ata6: DUMMY
[    1.822830] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.823322] ehci-pci: EHCI PCI platform driver
[    1.823862] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    1.823865] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.824365] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.824895] ehci-pci 0000:00:1a.0: debug port 2
[    1.829343] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.829348] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf160a000
[    1.841396] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.841955] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.842524] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.843106] usb usb1: Product: EHCI Host Controller
[    1.843696] usb usb1: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    1.844302] usb usb1: SerialNumber: 0000:00:1a.0
[    1.844991] hub 1-0:1.0: USB hub found
[    1.845624] hub 1-0:1.0: 2 ports detected
[    1.846344] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    1.846347] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.846996] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.847674] ehci-pci 0000:00:1d.0: debug port 2
[    1.852258] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.852274] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf1609000
[    1.861417] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.862121] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.862837] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.863568] usb usb2: Product: EHCI Host Controller
[    1.864308] usb usb2: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    1.865052] usb usb2: SerialNumber: 0000:00:1d.0
[    1.865845] hub 2-0:1.0: USB hub found
[    1.866563] hub 2-0:1.0: 2 ports detected
[    1.867308] uhci_hcd: USB Universal Host Controller Interface driver
[    1.868035] Initializing USB Mass Storage driver...
[    1.868761] usbcore: registered new interface driver usb-storage
[    1.869489] USB Mass Storage support registered.
[    1.870209] usbcore: registered new interface driver ums-realtek
[    1.870934] usbcore: registered new interface driver usbserial
[    1.871647] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.878311] i8042: Detected active multiplexing controller, rev 1.1
[    1.881830] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.882521] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.883200] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.883877] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.884555] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.885280] mousedev: PS/2 mouse device common for all mice
[    1.886065] i2c /dev entries driver
[    1.886944] ACPI Warning: 0x0000efa0-0x0000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130117/utaddress-251)
[    1.887685] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.888453] IR NEC protocol handler initialized
[    1.889208] IR RC5(x) protocol handler initialized
[    1.889955] IR RC6 protocol handler initialized
[    1.890686] IR JVC protocol handler initialized
[    1.891420] IR Sony protocol handler initialized
[    1.892143] IR RC5 (streamzap) protocol handler initialized
[    1.892866] IR SANYO protocol handler initialized
[    1.893601] IR MCE Keyboard/mouse protocol handler initialized
[    1.894406] cpuidle: using governor ladder
[    1.895223] cpuidle: using governor menu
[    1.896092] usbcore: registered new interface driver usbhid
[    1.896827] usbhid: USB HID core driver
[    1.897673] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.898406] TCP: cubic registered
[    1.899119] NET: Registered protocol family 17
[    1.899850] NET: Registered protocol family 15
[    1.900674] Using IPI No-Shortcut mode
[    1.911206] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.141805] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.146477] ata4.00: ATAPI: TSSTcorp CDDVDW SN-208AB, FC01, max UDMA/100
[    2.153811] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.156341] ata4.00: configured for UDMA/100
[    2.157814] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.183143] ata1.00: ATA-8: TOSHIBA MK7575GSX, GT001A, max UDMA/100
[    2.183943] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.185730] ata1.00: configured for UDMA/100
[    2.186639] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK7575GS GT00 PQ: 0 ANSI: 5
[    2.187534] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    2.188338] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.189271] sd 0:0:0:0: [sda] Write Protect is off
[    2.189899] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SN-208AB  FC01 PQ: 0 ANSI: 5
[    2.190960] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.190979] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.192676] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.193544] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.194519] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.290393] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.291271] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.292451] hub 1-1:1.0: USB hub found
[    2.293388] hub 1-1:1.0: 6 ports detected
[    2.323324]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    2.324903] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.337580] registered taskstats version 1
[    2.338758] ALSA device list:
[    2.339597]   No soundcards found.
[    2.374699] kjournald starting.  Commit interval 5 seconds
[    2.374742] EXT3-fs (sda5): mounted filesystem with writeback data mode
[    2.374748] VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
[    2.395479] devtmpfs: mounted
[    2.396349] Freeing unused kernel memory: 376k freed
[    2.406091] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    2.538672] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    2.539530] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.540739] hub 2-1:1.0: USB hub found
[    2.541679] hub 2-1:1.0: 6 ports detected
[    2.614518] usb 1-1.3: new high-speed USB device number 3 using ehci-pci
[    2.740474] usb 1-1.3: New USB device found, idVendor=04f2, idProduct=b213
[    2.741363] usb 1-1.3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.742209] usb 1-1.3: Product: FJ Camera
[    2.743061] usb 1-1.3: Manufacturer: Sonix Technology Co., Ltd.
[    2.743902] usb 1-1.3: SerialNumber: SN0001
[    2.818738] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
[    2.914543] usb 2-1.3: New USB device found, idVendor=0461, idProduct=4d20
[    2.915461] usb 2-1.3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    2.916328] usb 2-1.3: Product: USB Optical Mouse
[    2.919617] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input5
[    2.920710] hid-generic 0003:0461:4D20.0001: input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1.3/input0
[    3.776409] EXT3-fs (sda5): using internal journal
[    4.537417] udevd[95]: starting version 182
[    4.967153] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x26
[    4.996034] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x26
[    4.997305] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x26
[    4.998668] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x26
[    4.999984] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.084795] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.086430] r8169 0000:07:00.0 eth0: RTL8168e/8111e at 0xf8974000, 5c:9a:d8:5c:63:31, XID 0c200000 IRQ 17
[    5.087775] r8169 0000:07:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.139085] hda_codec: ALC269VB: SKU not ready 0x90970130
[    6.404279] uvcvideo: Found UVC 1.00 device FJ Camera (04f2:b213)
[    6.417104] usbcore: registered new interface driver uvcvideo
[    6.420253] USB Video Class driver (1.1.1)
[    6.807006] r8169 0000:07:00.0 eth0: link down
[    6.807024] r8169 0000:07:00.0 eth0: link down
[    7.981607] kjournald starting.  Commit interval 5 seconds
[    7.981691] EXT3-fs (sda8): warning: maximal mount count reached, running e2fsck is recommended
[    7.981901] EXT3-fs (sda8): using internal journal
[    7.981904] EXT3-fs (sda8): mounted filesystem with writeback data mode
[    8.011190] kjournald starting.  Commit interval 5 seconds
[    8.011278] EXT3-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
[    8.011484] EXT3-fs (sda9): using internal journal
[    8.011486] EXT3-fs (sda9): mounted filesystem with writeback data mode
[    8.037953] kjournald starting.  Commit interval 5 seconds
[    8.038327] EXT3-fs (sda10): using internal journal
[    8.038330] EXT3-fs (sda10): mounted filesystem with writeback data mode
[    8.136132] Adding 8191996k swap on /dev/sda6.  Priority:-1 extents:1 across:8191996k 
[    8.340605] r8169 0000:07:00.0 eth0: link up
[   20.014352] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[  173.939823] pciehp 0000:00:1c.3:pcie04: Card present on Slot(3)
[  174.042170] pci 0000:02:00.0: [14f1:8852] type 00 class 0x040000
[  174.042232] pci 0000:02:00.0: reg 10: [mem 0x00000000-0x001fffff 64bit]
[  174.042430] pci 0000:02:00.0: supports D1 D2
[  174.042434] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot
[  174.042547] pci 0000:02:00.0: System wakeup disabled by ACPI
[  174.042727] pci 0000:02:00.0: BAR 0: assigned [mem 0xf0e00000-0xf0ffffff 64bit]
[  174.042758] pcieport 0000:00:1c.3: PCI bridge to [bus 02-06]
[  174.042765] pcieport 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[  174.042776] pcieport 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[  174.042786] pcieport 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[  174.042942] pci 0000:02:00.0: no hotplug settings from platform
[  225.523708] pciehp 0000:00:1c.3:pcie04: Card not present on Slot(3)

--------------080407000009070606020706
Content-Type: text/plain; charset=us-ascii;
 name="dmesg-without-arg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg-without-arg"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.9.0-rc1+ (chris@laptop) (gcc version 4.7.3 20130302 (prerelease) (GCC) ) #34 SMP PREEMPT Thu Mar 7 19:33:03 GMT 2013
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000dab0efff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dab0f000-0x00000000dad4efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dad4f000-0x00000000dad6efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dad6f000-0x00000000daf1efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000daf1f000-0x00000000daf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.6 present.
[    0.000000] DMI: FUJITSU LIFEBOOK AH531/FJNBB0F, BIOS 1.30 05/28/2012
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x21fe00 max_arch_pfn = 0x1000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0C0000000 mask FE0000000 write-back
[    0.000000]   4 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   5 base 0DB000000 mask FFF000000 uncachable
[    0.000000]   6 base 100000000 mask F00000000 write-back
[    0.000000]   7 base 200000000 mask FE0000000 write-back
[    0.000000]   8 base 21FE00000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] initial memory mapped: [mem 0x00000000-0x01bfffff]
[    0.000000] Base memory trampoline at [c0099000] 99000 size 16384
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x37a00000-0x37bfdfff]
[    0.000000]  [mem 0x37a00000-0x37bfdfff] page 4k
[    0.000000] BRK [0x01628000, 0x01628fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x34000000-0x379fffff]
[    0.000000]  [mem 0x34000000-0x379fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x33ffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x33ffffff] page 2M
[    0.000000] ACPI: RSDP 000f00e0 00024 (v02 FUJ   )
[    0.000000] ACPI: XSDT daffe120 00084 (v01 FUJ    PC       00000001 FUJ  00000001)
[    0.000000] ACPI: FACP daff0000 000F4 (v03 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: DSDT daff3000 0794A (v02 FUJ    FJNBB0F  00000000 INTL 20061109)
[    0.000000] ACPI: FACS daf3d000 00040
[    0.000000] ACPI: SLIC daffd000 00176 (v01 FUJ    PC       00000001 FUJ  00000001)
[    0.000000] ACPI: SSDT daffb000 01068 (v01 FUJ    PtidDevc 00001000 INTL 20061109)
[    0.000000] ACPI: ASF! daff2000 000A5 (v32 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: HPET dafef000 00038 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: APIC dafee000 00098 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: MCFG dafed000 0003C (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: SSDT dafec000 007C2 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
[    0.000000] ACPI: SSDT dafeb000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
[    0.000000] ACPI: UEFI dafea000 0003E (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: UEFI dafe9000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
[    0.000000] ACPI: UEFI dafe8000 00242 (v01 FUJ    PC       00000001 PTL  00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 7810MB HIGHMEM available.
[    0.000000] 891MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 37bfe000
[    0.000000]   low ram: 0 - 37bfe000
[    0.000000] BRK [0x01629000, 0x01629fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x37bfdfff]
[    0.000000]   HighMem  [mem 0x37bfe000-0x1fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xdab0efff]
[    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
[    0.000000]   node   0: [mem 0x00000000-0x1fdfffff]
[    0.000000] On node 0 totalpages: 2074796
[    0.000000] free_area_init_node: node 0, pgdat c1569140, node_mem_map f37fe020
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   Normal zone: 1752 pages used for memmap
[    0.000000]   Normal zone: 224254 pages, LIFO batch:31
[    0.000000]   HighMem zone: 15621 pages used for memmap
[    0.000000]   HighMem zone: 1846546 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: 8 Processors exceeds NR_CPUS limit of 4
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 12 pages/cpu @f37bc000 s26496 r0 d22656 u49152
[    0.000000] pcpu-alloc: s26496 r0 d22656 u49152 alloc=12*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2073012
[    0.000000] Kernel command line: root=/dev/sda5 ro resume=/dev/sda6
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Initializing HighMem for node 0 (00037bfe:0021fe00)
[    0.000000] Memory: 8221536k/8910848k available (4096k kernel code, 77644k reserved, 1466k data, 376k init, 7386180k highmem)
[    0.000000] virtual kernel memory layout:
    fixmap  : 0xfff67000 - 0xfffff000   ( 608 kB)
    pkmap   : 0xffc00000 - 0xffe00000   (2048 kB)
    vmalloc : 0xf83fe000 - 0xffbfe000   ( 120 MB)
    lowmem  : 0xc0000000 - 0xf7bfe000   ( 891 MB)
      .init : 0xc156f000 - 0xc15cd000   ( 376 kB)
      .data : 0xc1400258 - 0xc156eb80   (1466 kB)
      .text : 0xc1000000 - 0xc1400258   (4096 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] 	Dump stacks of tasks blocking RCU-preempt GP.
[    0.000000] NR_IRQS:2304 nr_irqs:712 16
[    0.000000] CPU 0 irqstacks, hard=f3008000 soft=f300a000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.012000] tsc: Unable to calibrate against PIT
[    0.012000] tsc: using HPET reference calibration
[    0.012000] tsc: Detected 2494.327 MHz processor
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 4988.65 BogoMIPS (lpj=9977308)
[    0.000116] pid_max: default: 32768 minimum: 301
[    0.000197] Mount-cache hash table entries: 512
[    0.000419] Disabled fast string operations
[    0.000475] CPU: Physical Processor ID: 0
[    0.000529] CPU: Processor Core ID: 0
[    0.000585] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.000665] mce: CPU supports 7 MCE banks
[    0.000730] CPU0: Thermal monitoring enabled (TM1)
[    0.000793] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
tlb_flushall_shift: 5
[    0.000998] Freeing SMP alternatives: 16k freed
[    0.001056] ACPI: Core revision 20130117
[    0.005706] ACPI: All ACPI Tables successfully acquired
[    0.006154] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.006629] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.046416] smpboot: CPU0: Intel(R) Core(TM) i5-2450M CPU @ 2.50GHz (fam: 06, model: 2a, stepping: 07)
[    0.046612] TSC deadline timer enabled
[    0.046620] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.046853] perf_event_intel: PEBS disabled due to CPU errata, please upgrade microcode
[    0.046915] ... version:                3
[    0.046970] ... bit width:              48
[    0.047025] ... generic registers:      4
[    0.047079] ... value mask:             0000ffffffffffff
[    0.047136] ... max period:             000000007fffffff
[    0.047192] ... fixed-purpose events:   3
[    0.047247] ... event mask:             000000070000000f
[    0.062836] CPU 1 irqstacks, hard=f30b2000 soft=f30b4000
[    0.073190] Initializing CPU#1
[    0.073965] Disabled fast string operations
[    0.062837] smpboot: Booting Node   0, Processors  #1
[    0.076147] CPU 2 irqstacks, hard=f30d2000 soft=f30d4000
[    0.086598] Initializing CPU#2
[    0.087388] Disabled fast string operations
[    0.076307]  #2
[    0.089565] CPU 3 irqstacks, hard=f30de000 soft=f30e8000
[    0.089725]  #3 OK
[    0.100027] Initializing CPU#3
[    0.100817] Disabled fast string operations
[    0.102933] Brought up 4 CPUs
[    0.103095] smpboot: Total of 4 processors activated (19954.61 BogoMIPS)
[    0.105769] devtmpfs: initialized
[    0.106013] PM: Registering ACPI NVS region [mem 0xdad4f000-0xdad6efff] (131072 bytes)
[    0.106076] PM: Registering ACPI NVS region [mem 0xdaf1f000-0xdaf9efff] (524288 bytes)
[    0.106204] NET: Registered protocol family 16
[    0.106373] ACPI: bus type pci registered
[    0.106467] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.106543] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.106602] PCI: Using MMCONFIG for extended config space
[    0.106659] PCI: Using configuration type 1 for base access
[    0.107748] bio: create slab <bio-0> at 0
[    0.107849] ACPI: Added _OSI(Module Device)
[    0.107905] ACPI: Added _OSI(Processor Device)
[    0.107961] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.108017] ACPI: Added _OSI(Processor Aggregator Device)
[    0.109289] ACPI: EC: Look up EC in DSDT
[    0.110533] ACPI: Executed 1 blocks of module-level executable AML code
[    0.127015] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.127427] ACPI: SSDT dad4d718 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.127877] ACPI: Dynamic OEM Table Load:
[    0.128011] ACPI: SSDT   (null) 0067C (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
[    0.139220] ACPI: SSDT daf0fa98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.139697] ACPI: Dynamic OEM Table Load:
[    0.139831] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
[    0.151121] ACPI: SSDT dad4cd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.151564] ACPI: Dynamic OEM Table Load:
[    0.151697] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
[    0.163655] ACPI: Interpreter enabled
[    0.163714] ACPI: (supports S0ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130117/hwxface-568)
[    0.163913] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
[    0.164068]  S3 S4 S5)
[    0.164244] ACPI: Using IOAPIC for interrupt routing
[    0.164322] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.168825] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.168912] \_SB_.PCI0:_OSC invalid UUID
[    0.168912] _OSC request data:1 8 1f 
[    0.168939] \_SB_.PCI0:_OSC invalid UUID
[    0.168939] _OSC request data:1 f 1f 
[    0.168942] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
[    0.169004] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
[    0.169522] PCI host bridge to bus 0000:00
[    0.169578] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.169635] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.170238] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.170297] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.170357] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.170417] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
[    0.170483] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
[    0.170555] pci 0000:00:02.0: [8086:0126] type 00 class 0x030000
[    0.170564] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.170570] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.170574] pci 0000:00:02.0: reg 20: [io  0x4000-0x403f]
[    0.170661] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.170685] pci 0000:00:16.0: reg 10: [mem 0xf1605000-0xf160500f 64bit]
[    0.170746] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.170820] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.170842] pci 0000:00:1a.0: reg 10: [mem 0xf160a000-0xf160a3ff]
[    0.170914] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.170949] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.171038] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
[    0.171058] pci 0000:00:1b.0: reg 10: [mem 0xf1600000-0xf1603fff 64bit]
[    0.171112] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.171162] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.171263] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.171327] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
[    0.171426] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.171464] pci 0000:00:1c.3: System wakeup disabled by ACPI
[    0.171549] pci 0000:00:1c.5: [8086:1c1a] type 01 class 0x060400
[    0.171610] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.171641] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.171730] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.171752] pci 0000:00:1d.0: reg 10: [mem 0xf1609000-0xf16093ff]
[    0.171825] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.171857] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.171943] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
[    0.172077] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
[    0.172095] pci 0000:00:1f.2: reg 10: [io  0x4088-0x408f]
[    0.172103] pci 0000:00:1f.2: reg 14: [io  0x4094-0x4097]
[    0.172111] pci 0000:00:1f.2: reg 18: [io  0x4080-0x4087]
[    0.172119] pci 0000:00:1f.2: reg 1c: [io  0x4090-0x4093]
[    0.172127] pci 0000:00:1f.2: reg 20: [io  0x4060-0x407f]
[    0.172135] pci 0000:00:1f.2: reg 24: [mem 0xf1608000-0xf16087ff]
[    0.172167] pci 0000:00:1f.2: PME# supported from D3hot
[    0.172219] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.172234] pci 0000:00:1f.3: reg 10: [mem 0xf1604000-0xf16040ff 64bit]
[    0.172255] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
[    0.172549] pci 0000:01:00.0: [8086:008a] type 00 class 0x028000
[    0.172697] pci 0000:01:00.0: reg 10: [mem 0xf1500000-0xf1501fff 64bit]
[    0.173253] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    0.173378] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.179208] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.179272] pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.179360] pci 0000:00:1c.3: PCI bridge to [bus 02-06]
[    0.179421] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.179426] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.179435] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.179509] pci 0000:07:00.0: [10ec:8168] type 00 class 0x020000
[    0.179530] pci 0000:07:00.0: reg 10: [io  0x2000-0x20ff]
[    0.179564] pci 0000:07:00.0: reg 18: [mem 0xf0c04000-0xf0c04fff 64bit pref]
[    0.179586] pci 0000:07:00.0: reg 20: [mem 0xf0c00000-0xf0c03fff 64bit pref]
[    0.179646] pci 0000:07:00.0: supports D1 D2
[    0.179647] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.179687] pci 0000:07:00.0: System wakeup disabled by ACPI
[    0.187116] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.187202] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.187210] pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.187231] pci_bus 0000:00: on NUMA node 0
[    0.187231] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.187606] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.188182] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.188756] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.189330] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 10 *11 12 14 15)
[    0.189905] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.190560] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.191215] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.191789] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 *10 11 12 14 15)
[    0.192545] ACPI: Enabled 6 GPEs in block 00 to 3F
[    0.192684] acpi root: \_SB_.PCI0 notify handler is installed
[    0.192726] Found 1 acpi root devices
[    0.192754] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.192917] ACPI: No dock devices found.
[    0.193006] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.193069] vgaarb: loaded
[    0.193121] vgaarb: bridge control possible 0000:00:02.0
[    0.193227] SCSI subsystem initialized
[    0.193283] ACPI: bus type scsi registered
[    0.193349] libata version 3.00 loaded.
[    0.193352] ACPI: bus type usb registered
[    0.193420] usbcore: registered new interface driver usbfs
[    0.193487] usbcore: registered new interface driver hub
[    0.193563] usbcore: registered new device driver usb
[    0.193632] Linux video capture interface: v2.00
[    0.193716] Advanced Linux Sound Architecture Driver Initialized.
[    0.193774] PCI: Using ACPI for IRQ routing
[    0.195462] PCI: pci_cache_line_size set to 64 bytes
[    0.195553] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.195554] e820: reserve RAM buffer [mem 0xdab0f000-0xdbffffff]
[    0.195555] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.195556] e820: reserve RAM buffer [mem 0x21fe00000-0x21fffffff]
[    0.195675] Switching to clocksource hpet
[    0.195771] pnp: PnP ACPI init
[    0.195827] ACPI: bus type pnp registered
[    0.195902] pnp 00:00: [dma 4]
[    0.195915] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.195931] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
[    0.195998] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.196020] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.196051] system 00:04: [io  0x0680-0x069f] has been reserved
[    0.196110] system 00:04: [io  0x1000-0x100f] has been reserved
[    0.196169] system 00:04: [io  0xffff] has been reserved
[    0.196228] system 00:04: [io  0xffff] has been reserved
[    0.196285] system 00:04: [io  0x0400-0x0453] has been reserved
[    0.196344] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.196403] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.196462] system 00:04: [io  0x164e-0x164f] has been reserved
[    0.196521] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.196539] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.196573] system 00:06: [io  0x0454-0x0457] has been reserved
[    0.196632] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.196651] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.196670] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.196775] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.196835] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.196895] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.196955] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.197014] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.197074] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.197137] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.197197] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.197256] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    0.197316] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    0.197376] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.197540] system 00:0a: [mem 0x20000000-0x201fffff] could not be reserved
[    0.197600] system 00:0a: [mem 0x40000000-0x401fffff] could not be reserved
[    0.197661] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.197692] pnp: PnP ACPI: found 11 devices
[    0.197747] ACPI: ACPI bus type pnp unregistered
[    0.233658] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.233721] pci 0000:00:1c.0:   bridge window [mem 0xf1500000-0xf15fffff]
[    0.233791] pci 0000:00:1c.3: PCI bridge to [bus 02-06]
[    0.233850] pci 0000:00:1c.3:   bridge window [io  0x3000-0x3fff]
[    0.233914] pci 0000:00:1c.3:   bridge window [mem 0xf0d00000-0xf14fffff]
[    0.233977] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.234045] pci 0000:00:1c.5: PCI bridge to [bus 07]
[    0.234102] pci 0000:00:1c.5:   bridge window [io  0x2000-0x2fff]
[    0.234166] pci 0000:00:1c.5:   bridge window [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.234353] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.234355] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.234356] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.234358] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
[    0.234359] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
[    0.234360] pci_bus 0000:01: resource 1 [mem 0xf1500000-0xf15fffff]
[    0.234362] pci_bus 0000:02: resource 0 [io  0x3000-0x3fff]
[    0.234363] pci_bus 0000:02: resource 1 [mem 0xf0d00000-0xf14fffff]
[    0.234364] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf0bfffff 64bit pref]
[    0.234366] pci_bus 0000:07: resource 0 [io  0x2000-0x2fff]
[    0.234367] pci_bus 0000:07: resource 2 [mem 0xf0c00000-0xf0cfffff 64bit pref]
[    0.234390] NET: Registered protocol family 2
[    0.234562] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.234634] TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
[    0.234703] TCP: Hash tables configured (established 8192 bind 8192)
[    0.234773] TCP: reno registered
[    0.234826] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.234887] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    0.234981] NET: Registered protocol family 1
[    0.235043] pci 0000:00:02.0: Boot video device
[    0.235262] PCI: CLS 64 bytes, default 64
[    0.235834] bounce pool size: 64 pages
[    0.236972] fuse init (API version 7.21)
[    0.237088] msgmni has been set to 1631
[    0.237415] io scheduler noop registered
[    0.237507] io scheduler cfq registered (default)
[    0.237768] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.237840] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.237909] intel_idle: MWAIT substates: 0x21120
[    0.237909] intel_idle: v0.4 model 0x2A
[    0.237910] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.238027] ACPI: AC Adapter [ACAD] (on-line)
[    0.238195] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.238258] ACPI: Power Button [PWRB]
[    0.238340] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.238414] ACPI: Lid Switch [LID]
[    0.238490] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.238553] ACPI: Power Button [PWRF]
[    0.238659] ACPI: Requesting acpi_cpufreq
[    0.240502] thermal LNXTHERM:00: registered as thermal_zone0
[    0.240561] ACPI: Thermal Zone [THRM] (55 C)
[    0.240628] isapnp: Scanning for PnP cards...
[    0.241093] ACPI: Battery Slot [BAT1] (battery present)
[    0.595042] isapnp: No Plug & Play device found
[    0.599949] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.600336] Real Time Clock Driver v1.12b
[    0.600392] Linux agpgart interface v0.103
[    0.600469] [drm] Initialized drm 1.1.0 20060810
[    0.600830] [drm] Memory usable by graphics device = 2048M
[    0.600891] i915 0000:00:02.0: setting latency timer to 64
[    0.601044] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    0.601103] [drm] Driver supports precise vblank timestamp query.
[    0.601215] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    0.622424] [drm] Wrong MCH_SSKPD value: 0x16040307
[    0.622483] [drm] This can cause pipe underruns and display issues.
[    0.622541] [drm] Please upgrade your BIOS to fix this.
[    0.638836] fbcon: inteldrmfb (fb0) is primary device
[    1.232933] tsc: Refined TSC clocksource calibration: 2494.333 MHz
[    1.232935] Switching to clocksource tsc
[    1.813739] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[    1.819197] Console: switching to colour frame buffer device 170x48
[    1.822032] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.822054] i915 0000:00:02.0: registered panic notifier
[    1.842276] acpi device:31: registered as cooling_device4
[    1.842409] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    1.842462] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    1.842508] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.842600] ahci 0000:00:1f.2: version 3.0
[    1.857654] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x9 impl SATA mode
[    1.857686] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    1.857719] ahci 0000:00:1f.2: setting latency timer to 64
[    1.865878] scsi0 : ahci
[    1.865930] scsi1 : ahci
[    1.865970] scsi2 : ahci
[    1.866010] scsi3 : ahci
[    1.866049] scsi4 : ahci
[    1.866089] scsi5 : ahci
[    1.866120] ata1: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608100 irq 19
[    1.866147] ata2: DUMMY
[    1.866154] ata3: DUMMY
[    1.866164] ata4: SATA max UDMA/133 abar m2048@0xf1608000 port 0xf1608280 irq 19
[    1.866190] ata5: DUMMY
[    1.866627] ata6: DUMMY
[    1.867091] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.867581] ehci-pci: EHCI PCI platform driver
[    1.868116] ehci-pci 0000:00:1a.0: setting latency timer to 64
[    1.868119] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    1.868616] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    1.869146] ehci-pci 0000:00:1a.0: debug port 2
[    1.873586] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    1.873591] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf160a000
[    1.885675] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    1.886234] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.886802] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.887383] usb usb1: Product: EHCI Host Controller
[    1.887972] usb usb1: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    1.888577] usb usb1: SerialNumber: 0000:00:1a.0
[    1.889260] hub 1-0:1.0: USB hub found
[    1.889888] hub 1-0:1.0: 2 ports detected
[    1.890603] ehci-pci 0000:00:1d.0: setting latency timer to 64
[    1.890606] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.891254] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.891931] ehci-pci 0000:00:1d.0: debug port 2
[    1.896501] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.896516] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf1609000
[    1.905697] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.906402] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    1.907118] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.907849] usb usb2: Product: EHCI Host Controller
[    1.908589] usb usb2: Manufacturer: Linux 3.9.0-rc1+ ehci_hcd
[    1.909333] usb usb2: SerialNumber: 0000:00:1d.0
[    1.910126] hub 2-0:1.0: USB hub found
[    1.910844] hub 2-0:1.0: 2 ports detected
[    1.911587] uhci_hcd: USB Universal Host Controller Interface driver
[    1.912312] Initializing USB Mass Storage driver...
[    1.913032] usbcore: registered new interface driver usb-storage
[    1.913752] USB Mass Storage support registered.
[    1.914474] usbcore: registered new interface driver ums-realtek
[    1.915209] usbcore: registered new interface driver usbserial
[    1.915932] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.922342] i8042: Detected active multiplexing controller, rev 1.1
[    1.925863] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.926562] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    1.927242] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    1.927920] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    1.928597] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    1.929318] mousedev: PS/2 mouse device common for all mice
[    1.930087] i2c /dev entries driver
[    1.930956] ACPI Warning: 0x0000efa0-0x0000efbf SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20130117/utaddress-251)
[    1.931697] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.932470] IR NEC protocol handler initialized
[    1.933222] IR RC5(x) protocol handler initialized
[    1.933972] IR RC6 protocol handler initialized
[    1.934709] IR JVC protocol handler initialized
[    1.935439] IR Sony protocol handler initialized
[    1.936163] IR RC5 (streamzap) protocol handler initialized
[    1.936895] IR SANYO protocol handler initialized
[    1.937619] IR MCE Keyboard/mouse protocol handler initialized
[    1.938430] cpuidle: using governor ladder
[    1.939250] cpuidle: using governor menu
[    1.940143] usbcore: registered new interface driver usbhid
[    1.940878] usbhid: USB HID core driver
[    1.941710] ip_tables: (C) 2000-2006 Netfilter Core Team
[    1.942447] TCP: cubic registered
[    1.943179] NET: Registered protocol family 17
[    1.943903] NET: Registered protocol family 15
[    1.944711] Using IPI No-Shortcut mode
[    1.953868] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    2.186080] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.192122] ata4.00: ATAPI: TSSTcorp CDDVDW SN-208AB, FC01, max UDMA/100
[    2.194084] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.201976] ata4.00: configured for UDMA/100
[    2.202054] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    2.243147] ata1.00: ATA-8: TOSHIBA MK7575GSX, GT001A, max UDMA/100
[    2.243948] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    2.245728] ata1.00: configured for UDMA/100
[    2.246715] scsi 0:0:0:0: Direct-Access     ATA      TOSHIBA MK7575GS GT00 PQ: 0 ANSI: 5
[    2.247608] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    2.248409] sd 0:0:0:0: [sda] 4096-byte physical blocks
[    2.249332] sd 0:0:0:0: [sda] Write Protect is off
[    2.249993] scsi 3:0:0:0: CD-ROM            TSSTcorp CDDVDW SN-208AB  FC01 PQ: 0 ANSI: 5
[    2.251016] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.251075] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.252772] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.253643] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.254651] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.334640] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    2.335513] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.336694] hub 1-1:1.0: USB hub found
[    2.337633] hub 1-1:1.0: 6 ports detected
[    2.383380]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 >
[    2.384914] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.397591] registered taskstats version 1
[    2.398781] ALSA device list:
[    2.399618]   No soundcards found.
[    2.434707] kjournald starting.  Commit interval 5 seconds
[    2.434748] EXT3-fs (sda5): mounted filesystem with writeback data mode
[    2.434753] VFS: Mounted root (ext3 filesystem) readonly on device 8:5.
[    2.450343] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    2.455498] devtmpfs: mounted
[    2.456352] Freeing unused kernel memory: 376k freed
[    2.582916] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    2.583776] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.584994] hub 2-1:1.0: USB hub found
[    2.585995] hub 2-1:1.0: 6 ports detected
[    2.658747] usb 1-1.3: new high-speed USB device number 3 using ehci-pci
[    2.784796] usb 1-1.3: New USB device found, idVendor=04f2, idProduct=b213
[    2.785674] usb 1-1.3: New USB device strings: Mfr=2, Product=1, SerialNumber=3
[    2.786522] usb 1-1.3: Product: FJ Camera
[    2.787377] usb 1-1.3: Manufacturer: Sonix Technology Co., Ltd.
[    2.788221] usb 1-1.3: SerialNumber: SN0001
[    2.863019] usb 2-1.3: new low-speed USB device number 3 using ehci-pci
[    2.958788] usb 2-1.3: New USB device found, idVendor=0461, idProduct=4d20
[    2.959708] usb 2-1.3: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[    2.960590] usb 2-1.3: Product: USB Optical Mouse
[    2.963929] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input5
[    2.964925] hid-generic 0003:0461:4D20.0001: input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1.3/input0
[    3.791616] EXT3-fs (sda5): using internal journal
[    4.564100] udevd[95]: starting version 182
[    4.971568] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x26
[    5.000453] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x26
[    5.001741] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x26
[    5.003104] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x26
[    5.004435] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    5.111472] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    5.112908] r8169 0000:07:00.0 eth0: RTL8168e/8111e at 0xf89dc000, 5c:9a:d8:5c:63:31, XID 0c200000 IRQ 17
[    5.114134] r8169 0000:07:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
[    5.165709] hda_codec: ALC269VB: SKU not ready 0x90970130
[    6.218516] r8169 0000:07:00.0 eth0: link down
[    6.219836] r8169 0000:07:00.0 eth0: link down
[    6.820272] uvcvideo: Found UVC 1.00 device FJ Camera (04f2:b213)
[    6.833017] usbcore: registered new interface driver uvcvideo
[    6.836051] USB Video Class driver (1.1.1)
[    7.754281] r8169 0000:07:00.0 eth0: link up
[    8.008218] kjournald starting.  Commit interval 5 seconds
[    8.008281] EXT3-fs (sda8): warning: maximal mount count reached, running e2fsck is recommended
[    8.013531] EXT3-fs (sda8): using internal journal
[    8.016138] EXT3-fs (sda8): mounted filesystem with writeback data mode
[    8.060072] kjournald starting.  Commit interval 5 seconds
[    8.060142] EXT3-fs (sda9): warning: maximal mount count reached, running e2fsck is recommended
[    8.065466] EXT3-fs (sda9): using internal journal
[    8.068132] EXT3-fs (sda9): mounted filesystem with writeback data mode
[    8.120214] kjournald starting.  Commit interval 5 seconds
[    8.123089] EXT3-fs (sda10): using internal journal
[    8.125830] EXT3-fs (sda10): mounted filesystem with writeback data mode
[    8.218360] Adding 8191996k swap on /dev/sda6.  Priority:-1 extents:1 across:8191996k 
[   20.641906] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

--------------080407000009070606020706--
