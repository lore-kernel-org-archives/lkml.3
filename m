Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbbAFHLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 02:11:39 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:49171 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbbAFHLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 02:11:33 -0500
Message-ID: <54AB894C.9010001@huawei.com>
Date: Tue, 6 Jan 2015 15:05:48 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Olof Johansson" <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, <Charles.Garcia-Tobin@arm.com>,
        <phoenix.liyi@huawei.com>, Timur Tabi <timur@codeaurora.org>,
        <suravee.suthikulpanit@amd.com>, <linux-acpi@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v6 00/17] Introduce ACPI for ARM64 based on ACPI 5.1
References: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1420368918-5086-1-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.54AB8965.0092,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 9b98957fedfbf66f6cc0a9d5b4f49007
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/4 18:55, Hanjun Guo wrote:
> Hi,

Hello Hanjun,

We tested your v5 patch set (and added some GICv3 patches) on Hisilicon ARM64 SoC hardware,
from your change log for v6,  there is only one functional change to fix the NULL pointer, I think
the test result is still valid for v6, please refer to the test result below [1].

We can boot the system successfully using PSCI on our ARM64 hardware using this patch set, of course
we need to add some more patches (GICv3), but with this patch set:

You could add my Tested-by: Yijing Wang <wangyijing@huawei.com> if you want.

if you want me to test the new version of patch set, please let me know, thanks.

[1]:
fs0:\>start Image "initrd=fs.cpio.gz console=ttyS0,115200 acpi=force earlycon=uart8250,mmio32,0x60300000"
Loading driver at 0x0003652F000 EntryPoint=0x00036BF1760
EFI stub: Booting Linux Kernel...
Initializing cgroup subsys cpu
Linux version 3.18.0+ (wkf@linux) (gcc version 4.8.3 20140401 (prerelease) (crosstool-NG linaro-1.13.1-4.8-2014.04 - Linaro GCC
4.8-2014.04) ) #126 SMP PREEMPT Mon Dec 15 20:33:16 CST 2014
CPU: AArch64 Processor [411fd071] revision 1
Detected PIPT I-cache on CPU0
Early serial console at MMIO32 0x60300000 (options '')
bootconsole [uart0] enabled
efi: Getting EFI parameters from FDT:
EFI v2.40 by ARM Versatile Express EFI Dec 17 2014 10:32:11
efi:  SMBIOS=0x3bce8000  ACPI=0x36d08000  ACPI 2.0=0x36d08014
Ignoring memory block 0x0 - 0x1000
Ignoring memory block 0x1000 - 0x2000
Ignoring memory range 0x2000 - 0x200000
cma: Reserved 16 MiB at 0x0000000038400000
ACPI: Early table checksum verification disabled
ACPI: RSDP 0x0000000036D08014 000024 (v02 ARMLTD)
ACPI: XSDT 0x0000000036D070E8 00005C (v01 ARMLTD ARMPV660 20140727      01000013)
ACPI: FACP 0x0000000036D05000 00010C (v05 ARMLTD ARMPV660 20140727 HISI 00000099)
ACPI: DSDT 0x0000000036CFE000 000298 (v01 ARMLTD ARM-JUNO 20140727 INTL 20140828)
ACPI: GTDT 0x0000000036D04000 000060 (v01 ARMLTD ARMPV660 20140727 HISI 00000099)
ACPI: APIC 0x0000000036D02000 0005C0 (v01 ARMLTD ARMPV660 20140727 HISI 00000099)
ACPI: MCFG 0x0000000036D01000 00003C (v01 ARMLTD ARMPV660 20140727 HISI 00000099)
psci: probing for conduit method from ACPI.
psci: Using standard PSCI v0.2 function IDs
ACPI: GICC (acpi_id[0x0000] address[00000000fe000000] MPDIR[0x20000] enabled)
ACPI: GICC (acpi_id[0x0001] address[00000000fe000000] MPDIR[0x20001] enabled)
ACPI: GICC (acpi_id[0x0002] address[00000000fe000000] MPDIR[0x20002] enabled)
ACPI: GICC (acpi_id[0x0003] address[00000000fe000000] MPDIR[0x20003] enabled)
ACPI: GICC (acpi_id[0x0004] address[00000000fe000000] MPDIR[0x20100] enabled)
ACPI: GICC (acpi_id[0x0005] address[00000000fe000000] MPDIR[0x20101] enabled)
ACPI: GICC (acpi_id[0x0006] address[00000000fe000000] MPDIR[0x20102] enabled)
ACPI: GICC (acpi_id[0x0007] address[00000000fe000000] MPDIR[0x20103] enabled)
ACPI: GICC (acpi_id[0x0008] address[00000000fe000000] MPDIR[0x20200] enabled)
ACPI: GICC (acpi_id[0x0009] address[00000000fe000000] MPDIR[0x20201] enabled)
ACPI: GICC (acpi_id[0x000a] address[00000000fe000000] MPDIR[0x20202] enabled)
ACPI: GICC (acpi_id[0x000b] address[00000000fe000000] MPDIR[0x20203] enabled)
ACPI: GICC (acpi_id[0x000c] address[00000000fe000000] MPDIR[0x20300] enabled)
ACPI: GICC (acpi_id[0x000d] address[00000000fe000000] MPDIR[0x20301] enabled)
ACPI: GICC (acpi_id[0x000e] address[00000000fe000000] MPDIR[0x20302] enabled)
ACPI: GICC (acpi_id[0x000f] address[00000000fe000000] MPDIR[0x20303] enabled)
ACPI: 16 CPUs enabled, 16 CPUs total
PERCPU: Embedded 13 pages/cpu @ffffffc038130000 s14208 r8192 d30848 u53248
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 241895
Policy zone: DMA
Kernel command line: initrd=hulk-image-fat.cpio.gz console=ttyS0,115200 acpi=force  earlycon=uart8250,mmio32,0x60300000
log_buf_len individual max cpu contribution: 4096 bytes
log_buf_len total cpu_extra contributions: 61440 bytes
log_buf_len min size: 16384 bytes
log_buf_len: 131072 bytes
early log buf free: 9968(60%)
PID hash table entries: 4096 (order: 3, 32768 bytes)
Memory: 889320K/980992K available (5006K kernel code, 358K rwdata, 1892K rodata, 268K init, 236K bss, 91672K reserved)
Virtual kernel memory layout:
    vmalloc : 0xffffff8000000000 - 0xffffffbdffff0000   (   247 GB)
    vmemmap : 0xffffffbe00000000 - 0xffffffbfc0000000   (     7 GB maximum)
              0xffffffbe00007000 - 0xffffffbe00d20000   (    13 MB actual)
    PCI I/O : 0xffffffbffa000000 - 0xffffffbffb000000   (    16 MB)
    fixed   : 0xffffffbffbdfe000 - 0xffffffbffbdff000   (     4 KB)
    modules : 0xffffffbffc000000 - 0xffffffc000000000   (    64 MB)
    memory  : 0xffffffc000000000 - 0xffffffc03be00000   (   958 MB)
      .init : 0xffffffc00073e000 - 0xffffffc000781000   (   268 KB)
      .text : 0xffffffc000080000 - 0xffffffc00073d0b4   (  6901 KB)
      .data : 0xffffffc000781000 - 0xffffffc0007daa00   (   359 KB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=16, Nodes=1
Preemptible hierarchical RCU implementation.
        RCU restricting CPUs from NR_CPUS=32 to nr_cpu_ids=16.
RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=16
NR_IRQS:64 nr_irqs:64 0
ITS: ID: 0x0
ITS: allocated 512 Devices @3700e000 (psz 4K, shr 1)
ITS: allocated 512 Virtual CPUs @3700f000 (psz 4K, shr 1)
ITS: allocated 512 Interrupt Collections @37020000 (psz 4K, shr 1)
ITS: ID: 0x1
ITS: allocated 512 Devices @37021000 (psz 4K, shr 1)
ITS: allocated 512 Virtual CPUs @37022000 (psz 4K, shr 1)
ITS: allocated 512 Interrupt Collections @37023000 (psz 4K, shr 1)
ITS: ID: 0x2
ITS: allocated 512 Devices @37024000 (psz 4K, shr 1)
ITS: allocated 512 Virtual CPUs @37025000 (psz 4K, shr 1)
ITS: allocated 512 Interrupt Collections @37026000 (psz 4K, shr 1)
ITS: ID: 0x3
ITS: allocated 512 Devices @37028000 (psz 4K, shr 1)
ITS: allocated 512 Virtual CPUs @37029000 (psz 4K, shr 1)
ITS: allocated 512 Interrupt Collections @3702a000 (psz 4K, shr 1)
ITS: ID: 0x4
ITS: allocated 512 Devices @3702b000 (psz 4K, shr 1)
ITS: allocated 512 Virtual CPUs @3702c000 (psz 4K, shr 1)
ITS: allocated 512 Interrupt Collections @3702d000 (psz 4K, shr 1)
GIC: using LPI property table @37070000
ITS: Allocated 1792 chunks for LPIs
CPU0: found redistributor 20000 region 0:6d100000
CPU0: using LPI pending table @37080000
ACPI: 1 GICD entry detected
clocksource_of_init: no matching clocksources found
Architected cp15 timer(s) running at 50.00MHz (phys).
sched_clock: 56 bits at 50MHz, resolution 20ns, wraps every 2748779069440ns
Console: colour dummy device 80x25
allocated 4194304 bytes of page_cgroup
please try 'cgroup_disable=memory' option if you don't want memory cgroups
Calibrating delay loop (skipped), value calculated using timer frequency.. 100.00 BogoMIPS (lpj=500000)
pid_max: default: 32768 minimum: 301
ACPI: Core revision 20140926
ACPI: All ACPI Tables successfully acquired
Security Framework initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
Initializing cgroup subsys memory
Initializing cgroup subsys hugetlb
No CPU information found in DT
hw perfevents: enabled with arm/armv8-pmuv3 PMU driver, 7 counters available
Remapping and enabling EFI services.
Freed 0x2a8f000 bytes of EFI boot services memory
CPU1: Booted secondary processor
Detected PIPT I-cache on CPU1
CPU1: found redistributor 20001 region 0:6d130000
CPU1: using LPI pending table @37360000
CPU2: Booted secondary processor
Detected PIPT I-cache on CPU2
CPU2: found redistributor 20002 region 0:6d160000
CPU2: using LPI pending table @373a0000
CPU3: Booted secondary processor
Detected PIPT I-cache on CPU3
CPU3: found redistributor 20003 region 0:6d190000
CPU3: using LPI pending table @373d0000
CPU4: Booted secondary processor
Detected PIPT I-cache on CPU4
CPU4: found redistributor 20100 region 0:6d1c0000
CPU4: using LPI pending table @3b410000
CPU5: Booted secondary processor
Detected PIPT I-cache on CPU5
CPU5: found redistributor 20101 region 0:6d1f0000
CPU5: using LPI pending table @3b440000
CPU6: Booted secondary processor
Detected PIPT I-cache on CPU6
CPU6: found redistributor 20102 region 0:6d220000
CPU6: using LPI pending table @3b470000
CPU7: Booted secondary processor
Detected PIPT I-cache on CPU7
CPU7: found redistributor 20103 region 0:6d250000
CPU7: using LPI pending table @3b4b0000
CPU8: Booted secondary processor
Detected PIPT I-cache on CPU8
CPU8: found redistributor 20200 region 0:6d280000
CPU8: using LPI pending table @3b4e0000
CPU9: Booted secondary processor
Detected PIPT I-cache on CPU9
CPU9: found redistributor 20201 region 0:6d2b0000
CPU9: using LPI pending table @3b520000
CPU10: Booted secondary processor
Detected PIPT I-cache on CPU10
CPU10: found redistributor 20202 region 0:6d2e0000
CPU10: using LPI pending table @3b550000
CPU11: Booted secondary processor
Detected PIPT I-cache on CPU11
CPU11: found redistributor 20203 region 0:6d310000
CPU11: using LPI pending table @3b590000
CPU12: Booted secondary processor
Detected PIPT I-cache on CPU12
CPU12: found redistributor 20300 region 0:6d340000
CPU12: using LPI pending table @3b5c0000
CPU13: Booted secondary processor
Detected PIPT I-cache on CPU13
CPU13: found redistributor 20301 region 0:6d370000
CPU13: using LPI pending table @3b600000
CPU14: Booted secondary processor
Detected PIPT I-cache on CPU14
CPU14: found redistributor 20302 region 0:6d3a0000
CPU14: using LPI pending table @3b630000
CPU15: Booted secondary processor
Detected PIPT I-cache on CPU15
CPU15: found redistributor 20303 region 0:6d3d0000
CPU15: using LPI pending table @3b670000
Brought up 16 CPUs
SMP: Total of 16 processors activated.
devtmpfs: initialized
regulator-dummy: no parameters
NET: Registered protocol family 16
cpuidle: using governor ladder
cpuidle: using governor menu
vdso: 2 pages (1 code @ ffffffc000789000, 1 data @ ffffffc000788000)
hw-breakpoint: found 6 breakpoint and 4 watchpoint registers.
software IO TLB [mem 0x3b000000-0x3b400000] (4MB) mapped at [ffffffc03ae00000-ffffffc03b1fffff]
DMA: preallocated 256 KiB pool for atomic allocations
ACPI: bus type PCI registered
Serial: AMBA PL011 UART driver
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
ACPI: Interpreter enabled
ACPI: Using GIC for interrupt routing
PCI: no memory for MCFG
entries
vgaarb: loaded
SCSI subsystem initialized
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
Switched to clocksource arch_sys_counter
pnp: PnP ACPI init
pnp: PnP ACPI: found 0 devices
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
Unpacking initramfs...
Freeing initrd memory: 8212K (ffffffc01f5fb000 - ffffffc01fe00000)
futex hash table entries: 4096 (order: 6, 262144 bytes)
audit: initializing netlink subsys (disabled)
audit: type=2000 audit(1.150:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
fuse init (API version 7.23)
9p: Installing v9fs 9p2000 file system support
msgmni has been set to 1870
io scheduler noop registered
io scheduler cfq registered (default)
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
console [ttyS0] disabled
dw-apb-uart ARMH0011:00: ttyS0 at MMIO 0x60300000 (irq = 3, base_baud = 12500000) is a 16550A
console [ttyS0] enabled
console [ttyS0] enabled
bootconsole [uart0] disabled
bootconsole [uart0] disabled
loop: module loaded
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
ehci-pci: EHCI PCI platform driver
ehci-platform: EHCI generic platform driver
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci-pci: OHCI PCI platform driver
ohci-platform: OHCI generic platform driver
usbcore: registered new interface driver usb-storage
mousedev: PS/2 mouse device common for all mice
rtc_efi: EFI year < 1998, invalid date
rtc-efi rtc-efi: rtc core: registered rtc-efi as rtc0
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci-pltfm: SDHCI platform and OF driver helper
usbcore: registered new interface driver usbhid
usbhid: USB HID core driver
TCP: cubic registered
NET: Registered protocol family 17
9pnet: Installing 9P2000 support
registered taskstats version
1
rtc_efi: EFI year < 1998, invalid date
rtc-efi rtc-efi: hctosys: unable to read the hardware clock
ttyS0 - failed to request DMA
Freeing unused kernel memory: 268K (ffffffc00073e000 - ffffffc000781000)
root@(none)$

Thanks!
Yijing.



> 
> This is the sixth version of ACPI core patches for ARM64 based on ACPI
> 5.1.
> 
> updates from v5:
>   - fix the NULL pointer reference in cpu_get_ops() if PSCI is absent
>     and NULL will passed, which found by Suravee when he was testing
>     those patches on Seattle platform. I added his Tested-by for all
>     those ACPI patches.
> 
>   - Rebased on 3.19-rc2 which ACPI table related patches already merged
>     into 3.19 by Rafael, and remove the first patch in v5 which is not needed
>     any more.
> 
>   - Add two cleanup patches to convert ACPI ID to physical ID to make the
>     ACPI core looks more ARCH agnostic, those two patches were expected going
>     into 3.19 but conflicted with IOAPIC hotplug patches so Rafael left them
>     for 3.20.
> 
>   - updates to the doc about ACPI on ARM to address comments from Catalin,
>     Timur, Ashwin. continue discussion will bw needed about this doc.
> 
>   - we did lots of work as Al pointed out in the "[RFC] ACPI on arm64 TODO List"
>     thread [1], and we already make FWTS running on ARM64, thanks FuWei for doing
>     that. Here is the test results for linaro leg kernel release test results:
> 
> Test report for leg-20141215.0 (Revision: d37eefeb160cc9cc1db997031793723e317be7b7)
> 
> This test Image comes from  https://ci.linaro.org/job/linux-leg-fuwei
> The CI job Link: https://ci.linaro.org/job/linux-leg-fuwei/37/
> 
> Notes : All the tests ran on FVP base model in LAVA server : http://validation.linaro.org/
> 
> The startup.nsh boot test Link :https://validation.linaro.org/scheduler/job/222779
> 
> The ACPI test Link : https://validation.linaro.org/scheduler/job/222781
>     The results.log file Link : https://validation.linaro.org/dashboard/attachment/1267957/view
> 
> The grub-install test Link : https://validation.linaro.org/scheduler/job/222780
> 
> and here is the *summary*:
> 
> summary        -SUM:77 passed, 6 failed, 2 warnings, 5 aborted, 186 skipped, 8 info only.
> summary        -NLN:
> summary        -SUM:Test Failure Summary
> summary        -SEP:===========================================================================================
> summary        -NLN:
> summary        -SUM:Critical failures: NONE
> summary        -NLN:
> summary        -SUM:High failures: 2
> summary        -SUM: uefirttime: Failed to get wakeup time with UEFI runtime service.
> summary        -SUM: uefirttime: Failed to set wakeup time with UEFI runtime service.
> summary        -NLN:
> summary        -SUM:Medium failures: 5
> summary        -SUM: wakealarm: Could not find an RTC with an alarm ioctl() interface.
> summary        -SUM: method: \_SB_.COM0._CID returned a string 'PL011' but it was not a valid PNP ID or a valid ACPI ID.
> summary        -SUM: method: Object _PRS did not exist.
> summary        -SUM: method: Object _PTS did not exist.
> summary        -SUM: method: Object _WAK did not exist.
> summary        -NLN:
> summary        -SUM:Low failures: NONE
> summary        -NLN:
> summary        -SUM:Other failures: NONE
> summary        -NLN:
> summary        -SUM:Test           |Pass |Fail |Abort|Warn |Skip |Info |
> summary        -SUM:---------------+-----+-----+-----+-----+-----+-----+
> summary        -SUM:acpidump       |     |     |     |     |     |    1|
> summary        -SUM:acpiinfo       |     |     |     |     |     |    3|
> summary        -SUM:acpitables     |   11|     |     |    1|     |     |
> summary        -SUM:aspm           |     |     |     |     |    1|     |
> summary        -SUM:checksum       |    8|     |     |     |     |     |
> summary        -SUM:cpufreq        |     |     |     |    1|     |     |
> summary        -SUM:crsdump        |     |     |     |     |     |     |
> summary        -SUM:gpedump        |     |     |     |     |     |     |
> summary        -SUM:hda_audio      |     |     |     |     |    1|     |
> summary        -SUM:klog           |    1|     |     |     |     |     |
> summary        -SUM:maxreadreq     |     |     |     |     |     |     |
> summary        -SUM:method         |   29|    4|     |     |  173|     |
> summary        -SUM:oops           |    2|     |     |     |     |     |
> summary        -SUM:plddump        |     |     |     |     |     |     |
> summary        -SUM:prsdump        |     |     |     |     |     |     |
> summary        -SUM:securebootcert |     |     |    1|     |     |     |
> summary        -SUM:syntaxcheck    |    1|     |     |     |     |     |
> summary        -SUM:uefibootpath   |    1|     |     |     |     |     |
> summary        -SUM:uefidump       |     |     |     |     |     |     |
> summary        -SUM:uefirtmisc     |    2|     |     |     |   10|     |
> summary        -SUM:uefirttime     |    2|    2|     |     |     |     |
> summary        -SUM:uefirtvariable |   20|     |     |     |     |     |
> summary        -SUM:uefivarinfo    |     |     |     |     |     |     |
> summary        -SUM:version        |     |     |     |     |    1|    4|
> summary        -SUM:wakealarm      |     |     |    4|     |     |     |
> summary        -SUM:---------------+-----+-----+-----+-----+-----+-----+
> summary        -SUM:Total:         |   77|    6|    5|    2|  186|    8|
> summary        -SUM:---------------+-----+-----+-----+-----+-----+-----+
> 
> 
> [1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/310921.html
> 
> Thanks
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 


-- 
Thanks!
Yijing

