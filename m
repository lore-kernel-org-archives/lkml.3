Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaJ0Kow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 06:44:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaJ0Kou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 06:44:50 -0400
Date: Mon, 27 Oct 2014 18:44:06 +0800
From: Baoquan He <bhe@redhat.com>
To: "Li, ZhenHua" <zhen-hual@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, joro@8bytes.org,
        vgoyal@redhat.com, dyoung@redhat.com, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        doug.hatch@hp.com, jerry.hoemann@hp.com, tom.vaden@hp.com,
        li.zhang6@hp.com, lisa.mitchell@hp.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20141027104406.GA27331@dhcp-16-116.nay.redhat.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
 <20141022100525.GD9060@dhcp-16-116.nay.redhat.com>
 <544DF46A.60109@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544DF46A.60109@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/14 at 03:29pm, Li, ZhenHua wrote:
> Hi Baoquan,
> I failed in testing this patchset for 3.18.0-rc1, this upstream
> 3.18.0-rc1 kernel cannot boot on my system, have not found out the
> reason.
> 
> Could you please test this patchset on 3.17.0 to see whether it has
> these faults?
> 
> Thanks
> Zhenhua

Failed too on 3.17.0, check the log as below:


[    0.103751] Mount-cache hash table entries: 512 (order: 0, 4096
bytes)
[    0.110285] Mountpoint-cache hash table entries: 512 (order: 0, 4096
bytes)
[    0.117549] Initializing cgroup subsys memory
[    0.121917] Initializing cgroup subsys devices
[    0.126367] Initializing cgroup subsys freezer
[    0.130817] Initializing cgroup subsys net_cls
[    0.135265] Initializing cgroup subsys blkio
[    0.139545] Initializing cgroup subsys perf_event
[    0.144254] Initializing cgroup subsys hugetlb
[    0.148741] CPU: Physical Processor ID: 0
[    0.152751] CPU: Processor Core ID: 1
[    0.156427] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.156427] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.180040] Freeing SMP alternatives memory: 24K (ffffffffade7a000 -
ffffffffade80000)
[    0.190787] ftrace: allocating 26881 entries in 106 pages
[    0.222955] dmar: Host address width 46
[    0.226796] dmar: DRHD base: 0x000000dfffc000 flags: 0x1
[    0.232128] dmar: IOMMU 0: reg_base_addr dfffc000 ver 1:0 cap
d2078c106f0462 ecap f020fe
[    0.240223] dmar: RMRR base: 0x000000cba11000 end: 0x000000cba27fff
[    0.246495] dmar: ATSR flags: 0x0
[    0.249921] IOAPIC id 0 under DRHD base  0xdfffc000 IOMMU 0
[    0.255499] IOAPIC id 2 under DRHD base  0xdfffc000 IOMMU 0
[    0.261076] HPET id 0 under DRHD base 0xdfffc000
[    0.265899] Enabled IRQ remapping in xapic mode
[    0.271030] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.287077] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-1603 0 @ 2.80GHz
(fam: 06, model: 2d, stepping: 07)
[    0.296535] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge
events, full-width counters, Broken BIOS detected, complain to your
hardware vendor.
[    0.310427] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
(MSR 38d is b0)
[    0.318087] Intel PMU driver.
[    0.321065] ... version:                3
[    0.325077] ... bit width:              48
[    0.329180] ... generic registers:      8
[    0.333198] ... value mask:             0000ffffffffffff
[    0.338516] ... max period:             0000ffffffffffff
[    0.343834] ... fixed-purpose events:   3
[    0.347848] ... event mask:             00000007000000ff
[    0.355607] x86: Booted up 1 node, 1 CPUs
[    0.359627] smpboot: Total of 1 processors activated (5586.06
BogoMIPS)
[    0.366281] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.377496] devtmpfs: initialized
[    0.386629] PM: Registering ACPI NVS region [mem
0xcb750000-0xcb7dafff] (569344 bytes)
[    0.394583] PM: Registering ACPI NVS region [mem
0xcbaad000-0xcbaaefff] (8192 bytes)
[    0.402337] PM: Registering ACPI NVS region [mem
0xcbabb000-0xcbacdfff] (77824 bytes)
[    0.410169] PM: Registering ACPI NVS region [mem
0xcbb56000-0xcbb5dfff] (32768 bytes)
[    0.418005] PM: Registering ACPI NVS region [mem
0xcbb71000-0xcbffffff] (4780032 bytes)
[    0.427905] atomic64_test: passed for x86-64 platform with CX8 and
with SSE
[    0.434883] pinctrl core: initialized pinctrl subsystem
[    0.440171] RTC time: 10:38:17, date: 10/27/14
[    0.444783] NET: Registered protocol family 16
[    0.449652] cpuidle: using governor menu
[    0.453820] ACPI: bus type PCI registered
[    0.457841] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.464406] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.473718] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in
E820
[    0.481119] PCI: Using configuration type 1 for base access
[    0.489116] ACPI: Added _OSI(Module Device)
[    0.493313] ACPI: Added _OSI(Processor Device)
[    0.497768] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.502477] ACPI: Added _OSI(Processor Aggregator Device)
[    0.521054] ACPI: Executed 1 blocks of module-level executable AML
code
[    0.653647] ACPI: Interpreter enabled
[    0.657334] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20140724/hwxface-580)
[    0.666610] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20140724/hwxface-580)
[    0.675902] ACPI: (supports S0 S3 S4 S5)
[    0.679833] ACPI: Using IOAPIC for interrupt routing
[    0.684858] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.695495] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.717663] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    0.723860] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.732282] acpi PNP0A08:00: _OSC: platform does not support
[PCIeCapability]
[    0.739533] acpi PNP0A08:00: _OSC: not requesting control; platform
does not support [PCIeCapability]
[    0.748760] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER
PCIeCapability]
[    0.756508] acpi PNP0A08:00: _OSC: platform willing to grant
[PCIeHotplug PME AER]
[    0.764081] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.771419] PCI host bridge to bus 0000:00
[    0.775530] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.781028] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.787217] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.793403] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.799588] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.805774] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff]
[    0.812652] pci_bus 0000:00: root bus resource [mem
0x000c0000-0x000dffff]
[    0.819534] pci_bus 0000:00: root bus resource [mem
0xd4000000-0xdfffffff]
[    0.826415] pci_bus 0000:00: root bus resource [mem
0x3c0000000000-0x3c007fffffff]
[    0.834401] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.840314] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.846229] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.853685] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.859627] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.865739] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    0.870456] pci 0000:00:1c.0: Intel PCH root port ACS workaround
enabled
[    0.877211] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.883134] pci 0000:00:1c.5: Enabling MPC IRBNCE
[    0.887855] pci 0000:00:1c.5: Intel PCH root port ACS workaround
enabled
[    0.894614] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.900478] pci 0000:00:1c.6: Enabling MPC IRBNCE
[    0.905191] pci 0000:00:1c.6: Intel PCH root port ACS workaround
enabled
[    0.911940] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.917810] pci 0000:00:1c.7: Enabling MPC IRBNCE
[    0.922521] pci 0000:00:1c.7: Intel PCH root port ACS workaround
enabled
[    0.929269] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.935207] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.941055] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.947547] pci 0000:00:01.0: PCI bridge to [bus 03]
[    0.954557] pci 0000:00:02.0: PCI bridge to [bus 05]
[    0.959646] pci 0000:00:03.0: PCI bridge to [bus 04]
[    0.965071] pci 0000:00:11.0: PCI bridge to [bus 02]
[    0.970155] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.975261] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    0.980344] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    0.987344] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    0.992859] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive
decode)
[    1.000574] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.006775] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    1.015203] acpi PNP0A08:01: _OSC: platform does not support
[PCIeCapability]
[    1.022462] acpi PNP0A08:01: _OSC: not requesting control; platform
does not support [PCIeCapability]
[    1.031684] acpi PNP0A08:01: _OSC: OS requested [PCIeHotplug PME AER
PCIeCapability]
[    1.039429] acpi PNP0A08:01: _OSC: platform willing to grant
[PCIeHotplug PME AER]
[    1.047001] acpi PNP0A08:01: _OSC failed (AE_SUPPORT); disabling ASPM
[    1.053854] PCI host bridge to bus 0000:80
[    1.057964] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.063461] pci_bus 0000:80: root bus resource [io  0x0000-0x03af]
[    1.069642] pci_bus 0000:80: root bus resource [io  0x03e0-0x0cf7]
[    1.075831] pci_bus 0000:80: root bus resource [mem
0x000c0000-0x000dffff]
[    1.082875] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12
14 15), disabled.
[    1.091209] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12
14 15), disabled.
[    1.099534] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12
14 15), disabled.
[    1.107681] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12
14 15), disabled.
[    1.115817] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12
14 15), disabled.
[    1.124143] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[    1.132665] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12
14 15), disabled.
[    1.140990] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12
14 15), disabled.
[    1.149476] APIC: Disabling requested cpu. Processor 4/0x0 ignored.
[    1.155751] ACPI: Unable to map lapic to logical cpu number
[    1.161598] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 5/0x4 ignored.
[    1.169435] ACPI: Unable to map lapic to logical cpu number
[    1.175171] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 6/0x6 ignored.
[    1.183002] ACPI: Unable to map lapic to logical cpu number
[    1.189281] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.194318] vgaarb: setting as boot device: PCI:0000:05:00.0
[    1.199985] vgaarb: device added:
PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.208085] vgaarb: loaded
[    1.210803] vgaarb: bridge control possible 0000:05:00.0
[    1.216252] SCSI subsystem initialized
[    1.220139] ACPI: bus type USB registered
[    1.224193] usbcore: registered new interface driver usbfs
[    1.229709] usbcore: registered new interface driver hub
[    1.235055] usbcore: registered new device driver usb
[    1.240288] PCI: Using ACPI for IRQ routing
[    1.252666] PCI: Discovered peer bus ff
[    1.256564] PCI host bridge to bus 0000:ff
[    1.260669] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    1.266863] pci_bus 0000:ff: root bus resource [mem
0x00000000-0x3fffffffffff]
[    1.274088] pci_bus 0000:ff: No busn resource found for root bus,
will use [bus ff-ff]
[    1.286496] NetLabel: Initializing
[    1.289907] NetLabel:  domain hash size = 128
[    1.294269] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.299266] NetLabel:  unlabeled traffic allowed by default
[    1.305076] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.311446] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.319336] Switched to clocksource hpet
[    1.333158] pnp: PnP ACPI init
[    1.336474] system 00:00: [mem 0xfc000000-0xfcffffff window] has been
reserved
[    1.343728] system 00:00: [mem 0xfd000000-0xfdffffff window] has been
reserved
[    1.350963] system 00:00: [mem 0xfe000000-0xfeafffff window] has been
reserved
[    1.358190] system 00:00: [mem 0xfeb00000-0xfebfffff window] has been
reserved
[    1.365416] system 00:00: [mem 0xfed00400-0xfed3ffff window] could
not be reserved
[    1.372990] system 00:00: [mem 0xfed45000-0xfedfffff window] has been
reserved
[    1.380217] system 00:00: [mem 0xdffff000-0xdfffffff window] has been
reserved
[    1.387700] system 00:01: [io  0x0620-0x063f] has been reserved
[    1.393636] system 00:01: [io  0x0610-0x061f] has been reserved
[    1.399918] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.406528] system 00:07: [io  0x0400-0x0453] could not be reserved
[    1.412809] system 00:07: [io  0x0458-0x047f] has been reserved
[    1.418740] system 00:07: [io  0x1180-0x119f] has been reserved
[    1.424674] system 00:07: [io  0x0500-0x057f] has been reserved
[    1.430602] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been
reserved
[    1.437229] system 00:07: [mem 0xfec00000-0xfecfffff] could not be
reserved
[    1.444201] system 00:07: [mem 0xfed08000-0xfed08fff] has been
reserved
[    1.450822] system 00:07: [mem 0xff000000-0xffffffff] has been
reserved
[    1.457579] system 00:08: [io  0x0454-0x0457] has been reserved
[    1.464120] system 00:09: [mem 0xfed40000-0xfed44fff] has been
reserved
[    1.470760] pnp: PnP ACPI: found 10 devices
[    1.482252] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.487245] pci 0000:00:02.0: PCI bridge to [bus 05]
[    1.492227] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    1.498334] pci 0000:00:02.0:   bridge window [mem
0xd6000000-0xd70fffff]
[    1.505139] pci 0000:00:02.0:   bridge window [mem
0xd8000000-0xddffffff 64bit pref]
[    1.512892] pci 0000:00:03.0: PCI bridge to [bus 04]
[    1.517881] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.522859] pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
[    1.528973] pci 0000:00:11.0:   bridge window [mem
0xde400000-0xde8fffff 64bit pref]
[    1.536727] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.541713] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    1.546705] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    1.551691] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    1.556671] pci 0000:00:1c.7:   bridge window [mem
0xd7200000-0xd72fffff]
[    1.563475] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    1.568449] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    1.574550] pci 0000:00:1e.0:   bridge window [mem
0xd7100000-0xd71fffff]
[    1.581508] NET: Registered protocol family 2
[    1.586188] TCP established hash table entries: 2048 (order: 2, 16384
bytes)
[    1.593281] TCP bind hash table entries: 2048 (order: 3, 32768 bytes)
[    1.599737] TCP: Hash tables configured (established 2048 bind 2048)
[    1.606119] TCP: reno registered
[    1.609362] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.615213] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.621558] NET: Registered protocol family 1
[    1.642965] pci 0000:08:00.0: xHCI HW did not halt within 16000 usec
status = 0x0
[    1.650671] Unpacking initramfs...
[    2.300402] Freeing initrd memory: 19876K (ffff88002bc97000 -
ffff88002d000000)
[    2.307780] IOMMU intel_iommu_in_crashdump = true
[    2.312501] IOMMU Skip disabling iommu hardware translations
[    2.318292] IOMMU Copying translate tables from panicked kernel
[    2.325958] IOMMU: root_new_virt:0xffff880026ac5000
phys:0x000026ac5000
[    2.332588] IOMMU:0 Domain ids from panicked kernel:
[    2.337564] DID did:4(0x0004)
[    2.340547] DID did:10(0x000a)
[    2.343613] DID did:8(0x0008)
[    2.346590] DID did:7(0x0007)
[    2.349568] DID did:3(0x0003)
[    2.352543] DID did:2(0x0002)
[    2.355521] DID did:6(0x0006)
[    2.358497] DID did:1(0x0001)
[    2.361474] DID did:9(0x0009)
[    2.364450] DID did:0(0x0000)
[    2.367423] DID did:11(0x000b)
[    2.370488] DID did:5(0x0005)
[    2.373460] ----------------------------------------
[    2.378435] IOMMU 0 0xdfffc000: using Queued invalidation
[    2.383849] PCI-DMA: Intel(R) Virtualization Technology for Directed
I/O
[    2.390568] dmar: DRHD: handling fault status reg 2
[    2.390572] dmar: DMAR:[DMA Read] Request device [08:00.0] fault addr
fffe2000 
[    2.390572] DMAR:[fault reason 06] PTE Read access is not set
[    2.410695] RAPL PMU detected, hw unit 2^-16 Joules, API unit is
2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    2.421589] AVX version of gcm_enc/dec engaged.
[    2.428886] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.435844] futex hash table entries: 256 (order: 2, 16384 bytes)
[    2.441987] Initialise system trusted keyring
[    2.446386] audit: initializing netlink subsys (disabled)
[    2.451827] audit: type=2000 audit(1414406297.499:1): initialized
[    2.458892] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.467977] zpool: loaded
[    2.470616] zbud: loaded
[    2.473443] VFS: Disk quotas dquot_6.5.2
[    2.477447] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.484532] msgmni has been set to 463
[    2.488406] Key type big_key registered
[    2.493349] alg: No test for stdrng (krng)
[    2.497471] NET: Registered protocol family 38
[    2.501947] Key type asymmetric registered
[    2.506072] Asymmetric key parser 'x509' registered
[    2.511036] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 252)
[    2.518485] io scheduler noop registered
[    2.522430] io scheduler deadline registered
[    2.526769] io scheduler cfq registered (default)
[    2.533088] ioapic: probe of 0000:00:05.4 failed with error -22
[    2.539037] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.544645] pciehp: PCI Express Hot Plug Controller Driver version:
0.4
[    2.551567] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.559935] ACPI: Power Button [PWRB]
[    2.563679] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.571095] ACPI: Power Button [PWRF]
[    2.576777] GHES: HEST is not enabled!
[    2.580654] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.607612] 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200)
is a 16550A
[    2.635948] 0000:00:16.3: ttyS1 at I/O 0xf060 (irq = 17, base_baud =
115200) is a 16550A
[    2.644522] Non-volatile memory driver v1.3
[    2.648730] Linux agpgart interface v0.103
[    2.663846] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
0x5 impl RAID mode
[    2.671946] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio ems
sxs apst 
[    2.679243] dmar: DRHD: handling fault status reg 102
[    2.684297] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[    2.684297] DMAR:[fault reason 05] PTE Write access is not set
[    2.697548] dmar: DRHD: handling fault status reg 202
[    2.702603] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[    2.702603] DMAR:[fault reason 05] PTE Write access is not set
[    2.716685] scsi host0: ahci
[    2.719766] scsi host1: ahci
[    2.722781] scsi host2: ahci
[    2.725786] scsi host3: ahci
[    2.728792] scsi host4: ahci
[    2.731797] scsi host5: ahci
[    2.734759] ata1: SATA max UDMA/133 abar m2048@0xd7348000 port
0xd7348100 irq 27
[    2.742162] ata2: DUMMY
[    2.744618] ata3: SATA max UDMA/133 abar m2048@0xd7348000 port
0xd7348200 irq 27
[    2.752014] ata4: DUMMY
[    2.754471] ata5: DUMMY
[    2.756925] ata6: DUMMY
[    2.759759] libphy: Fixed MDIO Bus: probed
[    2.763981] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
Driver
[    2.770526] ehci-pci: EHCI PCI platform driver
[    2.775150] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.780462] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    2.787884] ehci-pci 0000:00:1a.0: debug port 2
[    2.796393] ehci-pci 0000:00:1a.0: irq 16, io mem 0xd734b000
[    2.808014] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.813865] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002
[    2.820663] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.827893] usb usb1: Product: EHCI Host Controller
[    2.832783] usb usb1: Manufacturer: Linux 3.17.0+ ehci_hcd
[    2.838274] usb usb1: SerialNumber: 0000:00:1a.0
[    2.843125] hub 1-0:1.0: USB hub found
[    2.846900] hub 1-0:1.0: 3 ports detected
[    2.851312] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.856620] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    2.864047] ehci-pci 0000:00:1d.0: debug port 2
[    2.872555] ehci-pci 0000:00:1d.0: irq 23, io mem 0xd734a000
[    2.884095] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.889936] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0002
[    2.896733] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.903966] usb usb2: Product: EHCI Host Controller
[    2.908852] usb usb2: Manufacturer: Linux 3.17.0+ ehci_hcd
[    2.914343] usb usb2: SerialNumber: 0000:00:1d.0
[    2.919185] hub 2-0:1.0: USB hub found
[    2.922968] hub 2-0:1.0: 3 ports detected
[    2.927226] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.933434] ohci-pci: OHCI PCI platform driver
[    2.937912] uhci_hcd: USB Universal Host Controller Interface driver
[    2.944405] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    2.949705] xhci_hcd 0000:08:00.0: new USB bus registered, assigned
bus number 3
[    2.997744] xhci_hcd 0000:08:00.0: Host not halted after 16000
microseconds.
[    3.004800] xhci_hcd 0000:08:00.0: can't setup: -110
[    3.009781] xhci_hcd 0000:08:00.0: USB bus 3 deregistered
[    3.015317] xhci_hcd 0000:08:00.0: init 0000:08:00.0 fail, -110
[    3.021267] xhci_hcd: probe of 0000:08:00.0 failed with error -110
[    3.027578] usbcore: registered new interface driver usbserial
[    3.033442] usbcore: registered new interface driver
usbserial_generic
[    3.039995] usbserial: USB Serial support registered for generic
[    3.046076] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    3.057078] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.062119] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.067355] mousedev: PS/2 mouse device common for all mice
[    3.073243] rtc_cmos 00:04: RTC can wake from S4
[    3.078062] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.084230] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes
nvram, hpet irqs
[    3.092020] device-mapper: uevent: version 1.0.3
[    3.097178] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)
initialised: dm-devel@redhat.com
[    3.105735] Intel P-state driver initializing.
[    3.111328] dmar: DRHD: handling fault status reg 302
[    3.116389] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[    3.116389] DMAR:[fault reason 05] PTE Write access is not set
[    3.129630] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.135842] dmar: DRHD: handling fault status reg 402
[    3.140895] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fff80000 
[    3.140895] DMAR:[fault reason 06] PTE Read access is not set
[    3.153954] dmar: DRHD: handling fault status reg 502
[    3.159011] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[    3.159011] DMAR:[fault reason 05] PTE Write access is not set
[    3.172240] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.178440] dmar: DRHD: handling fault status reg 602
[    3.183496] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fffa0000 
[    3.183496] DMAR:[fault reason 06] PTE Read access is not set
[    3.197530] hidraw: raw HID events driver (C) Jiri Kosina
[    3.202955] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[    3.209724] usbcore: registered new interface driver usbhid
[    3.215308] usbhid: USB HID core driver
[    3.219196] oprofile: using NMI interrupt.
[    3.223318] drop_monitor: Initializing network drop monitor service
[    3.229698] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.235039] TCP: cubic registered
[    3.238368] Initializing XFRM netlink socket
[    3.242783] NET: Registered protocol family 10
[    3.247438] mip6: Mobile IPv6
[    3.250432] usb 1-1: new high-speed USB device number 2 using
ehci-pci
[    3.256975] NET: Registered protocol family 17
[    3.261435] dmar: DRHD: handling fault status reg 702
[    3.266488] dmar: DMAR:[DMA Read] Request device [00:1a.0] fault addr
ffffc000 
[    3.266488] DMAR:[fault reason 03] Invalid context entry
[    3.279098] ehci-pci 0000:00:1a.0: fatal error
[    3.283547] ehci-pci 0000:00:1a.0: HC died; cleaning up
[    3.288857] mce: Unable to init device /dev/mcelog (rc: -5)
[    3.294846] Loading compiled-in X.509 certificates
[    3.301390] Loaded X.509 cert 'Magrathea: Glacier signing key:
d196e1366cc7c91295775c1e77c548314c3ad291'
[    3.310895] registered taskstats version 1
[    3.315762]   Magic number: 2:694:629
[    3.319558] rtc_cmos 00:04: setting system clock to 2014-10-27
10:38:19 UTC (1414406299)
[    3.390674] usb 2-1: new high-speed USB device number 2 using
ehci-pci
[    3.397234] dmar: DRHD: handling fault status reg 2
[    3.402118] dmar: DMAR:[DMA Read] Request device [00:1d.0] fault addr
ffffc000 
[    3.402118] DMAR:[fault reason 03] Invalid context entry
[    3.414736] ehci-pci 0000:00:1d.0: fatal error
[    3.419188] ehci-pci 0000:00:1d.0: HC died; cleaning up
[    3.424435] tsc: Refined TSC clocksource calibration: 2793.268 MHz
[    4.431848] Switched to clocksource tsc
[    8.140895] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[    8.487277] dmar: DRHD: handling fault status reg 102
[    8.492342] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[    8.492342] DMAR:[fault reason 05] PTE Write access is not set
[    8.505575] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.511777] dmar: DRHD: handling fault status reg 202
[    8.516832] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fff80000 
[    8.516832] DMAR:[fault reason 06] PTE Read access is not set
[    8.529886] dmar: DRHD: handling fault status reg 302
[    8.534947] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[    8.534947] DMAR:[fault reason 05] PTE Write access is not set
[    8.548174] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    8.554373] dmar: DRHD: handling fault status reg 402
[    8.559432] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fffa0000 
[    8.559432] DMAR:[fault reason 06] PTE Read access is not set
[    8.572485] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[    8.578757] ata3: limiting SATA link speed to 1.5 Gbps
[   13.516819] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   13.523103] ata1: limiting SATA link speed to 3.0 Gbps
[   13.863200] dmar: DRHD: handling fault status reg 502
[   13.868258] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[   13.868258] DMAR:[fault reason 05] PTE Write access is not set
[   13.881493] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   13.887703] dmar: DRHD: handling fault status reg 602
[   13.892761] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fff80000 
[   13.892761] DMAR:[fault reason 06] PTE Read access is not set
[   13.905826] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[   13.912016] dmar: DRHD: handling fault status reg 702
[   13.917074] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fffa0000 
[   13.917074] DMAR:[fault reason 06] PTE Read access is not set
[   13.930136] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   18.892750] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   19.220093] dmar: DRHD: handling fault status reg 2
[   19.224982] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[   19.224982] DMAR:[fault reason 05] PTE Write access is not set
[   19.238210] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   19.244413] dmar: DRHD: handling fault status reg 102
[   19.249472] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[   19.249472] DMAR:[fault reason 05] PTE Write access is not set
[   19.262690] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[   19.270225] Freeing unused kernel memory: 1416K (ffffffffadd18000 -
ffffffffade7a000)
[   19.278056] Write protecting the kernel read-only data: 12288k
[   19.287456] Freeing unused kernel memory: 896K (ffff88002d720000 -
ffff88002d800000)
[   19.298184] Freeing unused kernel memory: 908K (ffff88002db1d000 -
ffff88002dc00000)
[   19.309094] systemd[1]: systemd 208 running in system mode. (+PAM
+LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   19.321688] systemd[1]: Running in initial RAM disk.

Welcome to Fedora 20 (Heisenbug) dracut-038-14.git20140724.fc22
(Initramfs)!

[   19.335364] systemd[1]: Set hostname to <dhcp-16-105.nay.redhat.com>.
[   19.342471] random: systemd urandom read with 6 bits of entropy
available
[   19.377569] systemd[1]: Expecting device
dev-disk-by\x2duuid-3429ef24\x2d72c1\x2d435f\x2da55b\x2d15132ef30516.device...
         Expecting device
dev-disk-by\x2duuid-3429ef24\x2d72c...30516.device...
[   19.397365] systemd[1]: Expecting device
dev-disk-by\x2duuid-06476532\x2d3675\x2d40ce\x2d98dd\x2df0b6564e5455.device...
         Expecting device
dev-disk-by\x2duuid-06476532\x2d367...e5455.device...
[   19.416381] systemd[1]: Expecting device
dev-disk-by\x2duuid-f170152e\x2dde83\x2d46ee\x2d9546\x2d8ccd53f9753b.device...
         Expecting device
dev-disk-by\x2duuid-f170152e\x2dde8...9753b.device...
[   19.435400] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[   19.444412] systemd[1]: Created slice -.slice.
[   19.448880] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[   19.459427] systemd[1]: Created slice System Slice.
[   19.464332] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[   19.472442] systemd[1]: Reached target Slices.
[   19.476908] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[   19.485455] systemd[1]: Reached target Timers.
[   19.489927] systemd[1]: Starting Dispatch Password Requests to
Console Directory Watch.
[   19.497983] systemd[1]: Started Dispatch Password Requests to Console
Directory Watch.
[   19.505911] systemd[1]: Starting Paths.
[  OK  ] Reached target Paths.
[   19.514486] systemd[1]: Reached target Paths.
[   19.518864] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[   19.528504] systemd[1]: Listening on Journal Socket.
[   19.533539] systemd[1]: Started dracut ask for additional cmdline
parameters.
[   19.540790] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[   19.550788] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[   19.565701] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[   19.583518] systemd[1]: Started Journal Service.
         Starting Create list of required static device nodes...rrent
kernel...
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Swap.
[  OK  ] Reached target Local File Systems.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Started Create list of required static device nodes ...current
kernel.
         Starting Create static device nodes in /dev...
[  OK  ] Started Create static device nodes in /dev.
[  OK  ] Started dracut cmdline hook.
         Starting dracut pre-udev hook...
[  OK  ] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[   19.709098] systemd-udevd[205]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Basic System.
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
[   19.793773] wmi: Mapper loaded
[   19.818351] [drm] Initialized drm 1.1.0 20060810
[   19.876138] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[   20.000257] isci 0000:02:00.0: driver configured for rev: 5 silicon
[   20.010362] nouveau  [  DEVICE][0000:05:00.0] BOOT0  : 0x0a8c00b1
[   20.016512] nouveau  [  DEVICE][0000:05:00.0] Chipset: GT218 (NVA8)
[   20.022796] nouveau  [  DEVICE][0000:05:00.0] Family : NV50
[   20.044490] random: nonblocking pool is initialized
[   20.057249] isci 0000:02:00.0: OEM SAS parameters (version: 1.3)
loaded (firmware)
[   20.085175] nouveau  [   VBIOS][0000:05:00.0] checking PRAMIN for
image...
[   20.514604] nouveau  [   VBIOS][0000:05:00.0] ... appears to be valid
[   20.521058] nouveau  [   VBIOS][0000:05:00.0] using image from PRAMIN
[   20.528219] nouveau  [   VBIOS][0000:05:00.0] BIT signature found
[   20.534340] nouveau  [   VBIOS][0000:05:00.0] version 70.18.89.00.02
[   20.541268] isci 0000:02:00.0: SCU controller 0: phy 3-0 cables:
{short, short, short, short}
[   20.597906] scsi host6: isci
[   20.641020] dmar: DRHD: handling fault status reg 202
[   20.646077] dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr
ffe62000 
[   20.646077] DMAR:[fault reason 03] Invalid context entry
[   20.829828] nouveau  [     PMC][0000:05:00.0] MSI interrupts enabled
> 
