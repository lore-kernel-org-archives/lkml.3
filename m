Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaJVKGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:06:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528AbaJVKG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:06:28 -0400
Date: Wed, 22 Oct 2014 18:05:25 +0800
From: Baoquan He <bhe@redhat.com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, joro@8bytes.org,
        vgoyal@redhat.com, dyoung@redhat.com, iommu@lists.linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, alex.williamson@redhat.com,
        ddutile@redhat.com, ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com,
        doug.hatch@hp.com, jerry.hoemann@hp.com, tom.vaden@hp.com,
        li.zhang6@hp.com, lisa.mitchell@hp.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
Message-ID: <20141022100525.GD9060@dhcp-16-116.nay.redhat.com>
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413878659-1383-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhenhua,

I tested your latest patch on 3.18.0-rc1+, there are still some dmar
errors. I remember it worked well with Bill's original patchset.


0console [earlya[    0.000000] allocate tes of page_cg  'a ong[
0.000000] tsc: Fast TSC calibration using PIT
0031] Calibrating delay loop (skipped), value calculated using timer
frequency.. 5586.77 BogoMIPS (lpj=2793386)
[    0.010682] pid_max: default: 32768 minimum: 301
[    0.015317] ACPI: Core revision 20140828
[    0.044598] ACPI: All ACPI Tables successfully acquired
[    0.126450] Security Framework initialized
[    0.130569] SELinux:  Initializing.
[    0.135211] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.145731] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.154249] Mount-cache hash table entries: 32768 (order: 6, 262144
bytes)
[    0.161163] Mountpoint-cache hash table entries: 32768 (order: 6,
262144 bytes)
[    0.168731] Initializing cgroup subsys memory
[    0.173110] Initializing cgroup subsys devices
[    0.177570] Initializing cgroup subsys freezer
[    0.182026] Initializing cgroup subsys net_cls
[    0.186483] Initializing cgroup subsys blkio
[    0.190763] Initializing cgroup subsys perf_event
[    0.195479] Initializing cgroup subsys hugetlb
[    0.199955] CPU: Physical Processor ID: 0
[    0.203972] CPU: Processor Core ID: 0
[    0.207649] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.207649] ENERGY_PERF_BIAS: View and update with
x86_energy_perf_policy(8)
[    0.220704] mce: CPU supports 16 MCE banks
[    0.224832] CPU0: Thermal monitoring enabled (TM1)
[    0.229658] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.229658] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.241537] Freeing SMP alternatives memory: 24K (ffffffff81e80000 -
ffffffff81e86000)
[    0.250740] ftrace: allocating 27051 entries in 106 pages
[    0.268137] dmar: Host address width 46
[    0.271986] dmar: DRHD base: 0x000000dfffc000 flags: 0x1
[    0.277314] dmar: IOMMU 0: reg_base_addr dfffc000 ver 1:0 cap
d2078c106f0462 ecap f020fe
[    0.285423] dmar: RMRR base: 0x000000cba11000 end: 0x000000cba27fff
[    0.291703] dmar: ATSR flags: 0x0
[    0.295122] IOAPIC id 0 under DRHD base  0xdfffc000 IOMMU 0
[    0.300704] IOAPIC id 2 under DRHD base  0xdfffc000 IOMMU 0
[    0.306281] HPET id 0 under DRHD base 0xdfffc000
[    0.311011] Enabled IRQ remapping in xapic mode
[    0.316070] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.332096] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-1603 0 @ 2.80GHz
(fam: 06, model: 2d, stepping: 07)
[    0.341495] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge
events, full-width counters, Intel PMU driver.
[    0.352047] perf_event_intel: PEBS disabled due to CPU errata, please
upgrade microcode
[    0.360060] ... version:                3
[    0.364081] ... bit width:              48
[    0.368182] ... generic registers:      8
[    0.372196] ... value mask:             0000ffffffffffff
[    0.377513] ... max period:             0000ffffffffffff
[    0.382829] ... fixed-purpose events:   3
[    0.386842] ... event mask:             00000007000000ff
[    0.393368] x86: Booting SMP configuration:
[    0.397563] .... node  #0, CPUs:      #1
[    0.414672] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.422957]  #2 #3
[    0.451320] x86: Booted up 1 node, 4 CPUs
[    0.455539] smpboot: Total of 4 processors activated (22347.08
BogoMIPS)
[    0.466369] devtmpfs: initialized
[    0.472993] PM: Registering ACPI NVS region [mem
0xcb750000-0xcb7dafff] (569344 bytes)
[    0.480930] PM: Registering ACPI NVS region [mem
0xcbaad000-0xcbaaefff] (8192 bytes)
[    0.488689] PM: Registering ACPI NVS region [mem
0xcbabb000-0xcbacdfff] (77824 bytes)
[    0.496535] PM: Registering ACPI NVS region [mem
0xcbb56000-0xcbb5dfff] (32768 bytes)
[    0.504380] PM: Registering ACPI NVS region [mem
0xcbb71000-0xcbffffff] (4780032 bytes)
[    0.513294] atomic64_test: passed for x86-64 platform with CX8 and
with SSE
[    0.520272] pinctrl core: initialized pinctrl subsystem
[    0.525549] RTC time:  9:52:43, date: 10/22/14
[    0.530096] NET: Registered protocol family 16
[    0.539573] cpuidle: using governor menu
[    0.543583] ACPI: bus type PCI registered
[    0.547608] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.554133] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.563457] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in
E820
[    0.570548] PCI: Using configuration type 1 for base access
[    0.582492] ACPI: Added _OSI(Module Device)
[    0.586683] ACPI: Added _OSI(Processor Device)
[    0.591140] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.595849] ACPI: Added _OSI(Processor Aggregator Device)
[    0.608829] ACPI: Executed 1 blocks of module-level executable AML
code
[    0.670857] ACPI: Interpreter enabled
[    0.674537] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20140828/hwxface-580)
[    0.683821] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20140828/hwxface-580)
[    0.693098] ACPI: (supports S0 S3 S4 S5)
[    0.697032] ACPI: Using IOAPIC for interrupt routing
[    0.702029] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.711894] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.725668] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    0.731866] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.740165] acpi PNP0A08:00: _OSC: platform does not support
[PCIeCapability]
[    0.747362] acpi PNP0A08:00: _OSC: not requesting control; platform
does not support [PCIeCapability]
[    0.756597] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER
PCIeCapability]
[    0.764356] acpi PNP0A08:00: _OSC: platform willing to grant
[PCIeHotplug PME AER]
[    0.771942] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.778808] PCI host bridge to bus 0000:00
[    0.782921] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.788420] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.794615] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.800801] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.806990] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.813185] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff]
[    0.820069] pci_bus 0000:00: root bus resource [mem
0x000c0000-0x000dffff]
[    0.826961] pci_bus 0000:00: root bus resource [mem
0xd4000000-0xdfffffff]
[    0.833851] pci_bus 0000:00: root bus resource [mem
0x3c0000000000-0x3c007fffffff]
[    0.841697] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.847513] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.853334] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.860117] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.865961] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.871919] pci 0000:00:1c.0: Disabling UPDCR peer decodes
[    0.877420] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    0.882135] pci 0000:00:1c.0: Intel PCH root port ACS workaround
enabled
[    0.888874] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.894757] pci 0000:00:1c.5: Enabling MPC IRBNCE
[    0.899477] pci 0000:00:1c.5: Intel PCH root port ACS workaround
enabled
[    0.906212] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.912015] pci 0000:00:1c.6: Enabling MPC IRBNCE
[    0.916734] pci 0000:00:1c.6: Intel PCH root port ACS workaround
enabled
[    0.923473] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.929281] pci 0000:00:1c.7: Enabling MPC IRBNCE
[    0.933995] pci 0000:00:1c.7: Intel PCH root port ACS workaround
enabled
[    0.940733] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.946579] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.952347] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.958516] pci 0000:00:01.0: PCI bridge to [bus 03]
[    0.965531] pci 0000:00:02.0: PCI bridge to [bus 05]
[    0.970582] pci 0000:00:03.0: PCI bridge to [bus 04]
[    0.975877] pci 0000:00:11.0: PCI bridge to [bus 02]
[    0.980920] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.985995] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    0.991048] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    0.998052] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    1.003382] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive
decode)
[    1.010649] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    1.016843] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    1.025142] acpi PNP0A08:01: _OSC: platform does not support
[PCIeCapability]
[    1.032340] acpi PNP0A08:01: _OSC: not requesting control; platform
does not support [PCIeCapability]
[    1.041569] acpi PNP0A08:01: _OSC: OS requested [PCIeHotplug PME AER
PCIeCapability]
[    1.049329] acpi PNP0A08:01: _OSC: platform willing to grant
[PCIeHotplug PME AER]
[    1.056914] acpi PNP0A08:01: _OSC failed (AE_SUPPORT); disabling ASPM
[    1.063547] PCI host bridge to bus 0000:80
[    1.067655] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.073154] pci_bus 0000:80: root bus resource [io  0x0000-0x03af]
[    1.079347] pci_bus 0000:80: root bus resource [io  0x03e0-0x0cf7]
[    1.085541] pci_bus 0000:80: root bus resource [mem
0x000c0000-0x000dffff]
[    1.092508] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12
14 15)
[    1.099814] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12
14 15)
[    1.107112] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12
14 15)
[    1.114227] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12
14 15)
[    1.121333] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12
14 15)
[    1.128632] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12
14 15) *0
[    1.136129] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12
14 15)
[    1.143428] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12
14 15)
[    1.151240] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.156190] vgaarb: setting as boot device: PCI:0000:05:00.0
[    1.161855] vgaarb: device added:
PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.169955] vgaarb: loaded
[    1.172673] vgaarb: bridge control possible 0000:05:00.0
[    1.178057] SCSI subsystem initialized
[    1.181883] ACPI: bus type USB registered
[    1.185921] usbcore: registered new interface driver usbfs
[    1.191422] usbcore: registered new interface driver hub
[    1.196752] usbcore: registered new device driver usb
[    1.201901] PCI: Using ACPI for IRQ routing
[    1.211957] PCI: Discovered peer bus ff
[    1.215828] PCI host bridge to bus 0000:ff
[    1.219931] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    1.226124] pci_bus 0000:ff: root bus resource [mem
0x00000000-0x3fffffffffff]
[    1.233353] pci_bus 0000:ff: No busn resource found for root bus,
will use [bus ff-ff]
[    1.243478] NetLabel: Initializing
[    1.246889] NetLabel:  domain hash size = 128
[    1.251259] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.256250] NetLabel:  unlabeled traffic allowed by default
[    1.261908] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.268256] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.276129] Switched to clocksource hpet
[    1.285817] pnp: PnP ACPI init
[    1.288997] system 00:00: [mem 0xfc000000-0xfcffffff window] has been
reserved
[    1.296237] system 00:00: [mem 0xfd000000-0xfdffffff window] has been
reserved
[    1.303472] system 00:00: [mem 0xfe000000-0xfeafffff window] has been
reserved
[    1.310708] system 00:00: [mem 0xfeb00000-0xfebfffff window] has been
reserved
[    1.317948] system 00:00: [mem 0xfed00400-0xfed3ffff window] could
not be reserved
[    1.325533] system 00:00: [mem 0xfed45000-0xfedfffff window] has been
reserved
[    1.332772] system 00:00: [mem 0xdffff000-0xdfffffff window] has been
reserved
[    1.340129] system 00:01: [io  0x0620-0x063f] has been reserved
[    1.346067] system 00:01: [io  0x0610-0x061f] has been reserved
[    1.352170] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.358421] system 00:07: [io  0x0400-0x0453] could not be reserved
[    1.364706] system 00:07: [io  0x0458-0x047f] has been reserved
[    1.370643] system 00:07: [io  0x1180-0x119f] has been reserved
[    1.376577] system 00:07: [io  0x0500-0x057f] has been reserved
[    1.382514] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been
reserved
[    1.389143] system 00:07: [mem 0xfec00000-0xfecfffff] could not be
reserved
[    1.396122] system 00:07: [mem 0xfed08000-0xfed08fff] has been
reserved
[    1.402753] system 00:07: [mem 0xff000000-0xffffffff] has been
reserved
[    1.409443] system 00:08: [io  0x0454-0x0457] has been reserved
[    1.415680] system 00:09: [mem 0xfed40000-0xfed44fff] has been
reserved
[    1.422312] pnp: PnP ACPI: found 10 devices
[    1.432845] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.437830] pci 0000:00:02.0: PCI bridge to [bus 05]
[    1.442810] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    1.448919] pci 0000:00:02.0:   bridge window [mem
0xd6000000-0xd70fffff]
[    1.455723] pci 0000:00:02.0:   bridge window [mem
0xd8000000-0xddffffff 64bit pref]
[    1.463486] pci 0000:00:03.0: PCI bridge to [bus 04]
[    1.468475] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.473454] pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
[    1.479569] pci 0000:00:11.0:   bridge window [mem
0xde400000-0xde8fffff 64bit pref]
[    1.487329] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.492312] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    1.497306] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    1.502295] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    1.507276] pci 0000:00:1c.7:   bridge window [mem
0xd7200000-0xd72fffff]
[    1.514085] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    1.519064] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    1.525176] pci 0000:00:1e.0:   bridge window [mem
0xd7100000-0xd71fffff]
[    1.532053] NET: Registered protocol family 2
[    1.536629] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.544261] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes)
[    1.551132] TCP: Hash tables configured (established 131072 bind
65536)
[    1.557790] TCP: reno registered
[    1.561057] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    1.567222] UDP-Lite hash table entries: 8192 (order: 6, 262144
bytes)
[    1.573857] NET: Registered protocol family 1
[    1.620837] Unpacking initramfs...
[    2.695524] Freeing initrd memory: 73444K (ffff88002f07e000 -
ffff880033837000)
[    2.702941] IOMMU 0 0xdfffc000: using Queued invalidation
[    2.708357] IOMMU: Setting RMRR:
[    2.711609] IOMMU: Setting identity map for device 0000:00:1a.0
[0xcba11000 - 0xcba27fff]
[    2.719832] IOMMU: Setting identity map for device 0000:00:1d.0
[0xcba11000 - 0xcba27fff]
[    2.728048] IOMMU: Prepare 0-16MiB unity mapping for LPC
[    2.733387] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0
- 0xffffff]
[    2.740810] PCI-DMA: Intel(R) Virtualization Technology for Directed
I/O
[    2.751258] RAPL PMU detected, hw unit 2^-16 Joules, API unit is
2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    2.762183] AVX version of gcm_enc/dec engaged.
[    2.766728] AES CTR mode by8 optimization enabled
[    2.773059] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.779868] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    2.786077] Initialise system trusted keyring
[    2.790469] audit: initializing netlink subsys (disabled)
[    2.795898] audit: type=2000 audit(1413971563.899:1): initialized
[    2.802401] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.810069] zpool: loaded
[    2.812707] zbud: loaded
[    2.815416] VFS: Disk quotas dquot_6.5.2
[    2.819385] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.826151] msgmni has been set to 31563
[    2.830137] Key type big_key registered
[    2.834713] alg: No test for stdrng (krng)
[    2.838832] NET: Registered protocol family 38
[    2.843302] Key type asymmetric registered
[    2.847417] Asymmetric key parser 'x509' registered
[    2.852342] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 252)
[    2.859796] io scheduler noop registered
[    2.863735] io scheduler deadline registered
[    2.868059] io scheduler cfq registered (default)
[    2.873723] ioapic: probe of 0000:00:05.4 failed with error -22
[    2.879668] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.885265] pciehp: PCI Express Hot Plug Controller Driver version:
0.4
[    2.892141] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.900514] ACPI: Power Button [PWRB]
[    2.904222] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.911635] ACPI: Power Button [PWRF]
[    2.919209] GHES: HEST is not enabled!
[    2.923062] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.949936] serial 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud =
115200) is a 16550A
[    2.978817] serial 0000:00:16.3: ttyS1 at I/O 0xf060 (irq = 17,
base_baud = 115200) is a 16550A
[    2.987842] Non-volatile memory driver v1.3
[    2.992041] Linux agpgart interface v0.103
[    3.007061] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
0x5 impl RAID mode
[    3.015174] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio ems
sxs apst 
[    3.024682] scsi host0: ahci
[    3.027959] scsi host1: ahci
[    3.031213] scsi host2: ahci
[    3.034301] scsi host3: ahci
[    3.037390] scsi host4: ahci
[    3.040474] scsi host5: ahci
[    3.043399] ata1: SATA max UDMA/133 abar m2048@0xd7348000 port
0xd7348100 irq 27
[    3.050811] ata2: DUMMY
[    3.053269] ata3: SATA max UDMA/133 abar m2048@0xd7348000 port
0xd7348200 irq 27
[    3.060681] ata4: DUMMY
[    3.063140] ata5: DUMMY
[    3.065598] ata6: DUMMY
[    3.068158] libphy: Fixed MDIO Bus: probed
[    3.072380] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    3.077671] xhci_hcd 0000:08:00.0: new USB bus registered, assigned
bus number 1
[    3.085428] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002
[    3.092229] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.099465] usb usb1: Product: xHCI Host Controller
[    3.104358] usb usb1: Manufacturer: Linux 3.18.0-rc1+ xhci-hcd
[    3.110205] usb usb1: SerialNumber: 0000:08:00.0
[    3.115015] hub 1-0:1.0: USB hub found
[    3.118792] hub 1-0:1.0: 4 ports detected
[    3.122926] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    3.128302] xhci_hcd 0000:08:00.0: new USB bus registered, assigned
bus number 2
[    3.135773] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0003
[    3.142579] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.149816] usb usb2: Product: xHCI Host Controller
[    3.154708] usb usb2: Manufacturer: Linux 3.18.0-rc1+ xhci-hcd
[    3.160554] usb usb2: SerialNumber: 0000:08:00.0
[    3.165334] hub 2-0:1.0: USB hub found
[    3.169106] hub 2-0:1.0: 4 ports detected
[    3.173250] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
Driver
[    3.179798] ehci-pci: EHCI PCI platform driver
[    3.184350] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    3.189724] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    3.197172] ehci-pci 0000:00:1a.0: debug port 2
[    3.205655] ehci-pci 0000:00:1a.0: irq 16, io mem 0xd734b000
[    3.217315] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.223146] usb usb3: New USB device found, idVendor=1d6b,
idProduct=0002
[    3.229948] usb usb3: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.237185] usb usb3: Product: EHCI Host Controller
[    3.242079] usb usb3: Manufacturer: Linux 3.18.0-rc1+ ehci_hcd
[    3.247926] usb usb3: SerialNumber: 0000:00:1a.0
[    3.252761] hub 3-0:1.0: USB hub found
[    3.256529] hub 3-0:1.0: 3 ports detected
[    3.260744] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    3.266118] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 4
[    3.273632] ehci-pci 0000:00:1d.0: debug port 2
[    3.282093] ehci-pci 0000:00:1d.0: irq 23, io mem 0xd734a000
[    3.293363] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.299159] usb usb4: New USB device found, idVendor=1d6b,
idProduct=0002
[    3.305964] usb usb4: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    3.313200] usb usb4: Product: EHCI Host Controller
[    3.318089] usb usb4: Manufacturer: Linux 3.18.0-rc1+ ehci_hcd
[    3.323938] usb usb4: SerialNumber: 0000:00:1d.0
[    3.328701] hub 4-0:1.0: USB hub found
[    3.332467] hub 4-0:1.0: 3 ports detected
[    3.336603] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.342807] ohci-pci: OHCI PCI platform driver
[    3.347277] uhci_hcd: USB Universal Host Controller Interface driver
[    3.353695] usbcore: registered new interface driver usbserial
[    3.359545] usbcore: registered new interface driver
usbserial_generic
[    3.366097] usbserial: USB Serial support registered for generic
[    3.372146] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    3.374482] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.374514] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    3.392876] ata1.00: ATA-8: ST31000524AS, HP64, max UDMA/100
[    3.395363] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.395367] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.395501] mousedev: PS/2 mouse device common for all mice
[    3.395855] rtc_cmos 00:04: RTC can wake from S4
[    3.396045] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.396081] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes
nvram, hpet irqs
[    3.396138] device-mapper: uevent: version 1.0.3
[    3.396197] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17)
initialised: dm-devel@redhat.com
[    3.396253] Intel P-state driver initializing.
[    3.400075] hidraw: raw HID events driver (C) Jiri Kosina
[    3.400323] usbcore: registered new interface driver usbhid
[    3.400324] usbhid: USB HID core driver
[    3.400365] oprofile: using NMI interrupt.
[    3.400381] drop_monitor: Initializing network drop monitor service
[    3.400526] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.408605] TCP: cubic registered
[    3.408610] Initializing XFRM netlink socket
[    3.408703] NET: Registered protocol family 10
[    3.408877] mip6: Mobile IPv6
[    3.408880] NET: Registered protocol family 17
[    3.409260] Loading compiled-in X.509 certificates
[    3.410068] Loaded X.509 cert 'Magrathea: Glacier signing key:
d196e1366cc7c91295775c1e77c548314c3ad291'
[    3.410074] registered taskstats version 1
[    3.410807]   Magic number: 2:969:879
[    3.414189] rtc_cmos 00:04: setting system clock to 2014-10-22
09:52:46 UTC (1413971566)
[    3.530379] ata1.00: 1953525168 sectors, multi 16: LBA48 NCQ (depth
31/32)
[    3.530393] ata3.00: ATAPI: hp       CDDVDW SH-216ALN, HA5A, max
UDMA/100
[    3.530400] usb 1-1: new high-speed USB device number 2 using
xhci_hcd
[    3.551737] ata1.00: configured for UDMA/100
[    3.556094] ata3.00: configured for UDMA/100
[    3.556207] scsi 0:0:0:0: Direct-Access     ATA      ST31000524AS
HP64 PQ: 0 ANSI: 5
[    3.556400] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[    3.556426] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.556428] sd 0:0:0:0: [sda] Write Protect is off
[    3.556441] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    3.596437] scsi 2:0:0:0: CD-ROM            hp       CDDVDW SH-216ALN
HA5A PQ: 0 ANSI: 5
[    3.628854] sr 2:0:0:0: [sr0] scsi3-mmc drive: 40x/40x writer dvd-ram
cd/rw xa/form2 cdda tray
[    3.631763] usb 3-1: new high-speed USB device number 2 using
ehci-pci
[    3.644045] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.649740] sr 2:0:0:0: Attached scsi generic sg1 type 5
[    3.652402]  sda: sda1 sda2 sda4 < sda5 sda6 sda7 sda8 sda9 >
[    3.652800] usb 4-1: new high-speed USB device number 2 using
ehci-pci
[    3.653249] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.657953] usb 1-1: New USB device found, idVendor=0424,
idProduct=2412
[    3.657955] usb 1-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[    3.680553] hub 1-1:1.0: USB hub found
[    3.680899] hub 1-1:1.0: 2 ports detected
[    3.695764] Freeing unused kernel memory: 1428K (ffffffff81d1b000 -
ffffffff81e80000)
[    3.703629] Write protecting the kernel read-only data: 12288k
[    3.712879] Freeing unused kernel memory: 780K (ffff88000173d000 -
ffff880001800000)
[    3.723879] Freeing unused kernel memory: 896K (ffff880001b20000 -
ffff880001c00000)
[    3.736460] systemd[1]: systemd 208 running in system mode. (+PAM
+LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    3.746566] usb 3-1: New USB device found, idVendor=8087,
idProduct=0024
[    3.746568] usb 3-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[    3.746943] hub 3-1:1.0: USB hub found
[    3.747187] hub 3-1:1.0: 6 ports detected
[    3.754912] tsc: Refined TSC clocksource calibration: 2793.268 MHz
[    3.777155] systemd[1]: Running in initial RAM disk.

Welcome to Fedora 20 (Heisenbug) dracut-038-14.git20140724.fc22
(Initramfs)!

[    3.789762] usb 4-1: New USB device found, idVendor=8087,
idProduct=0024
[    3.797152] usb 4-1: New USB device strings: Mfr=0, Product=0,
SerialNumber=0
[    3.804417] systemd[1]: No hostname configured.
[    3.804782] hub 4-1:1.0: USB hub found
[    3.804980] hub 4-1:1.0: 8 ports detected
[    3.816768] systemd[1]: Set hostname to <localhost>.
[    3.821792] random: systemd urandom read with 27 bits of entropy
available
[    3.828692] systemd[1]: Initializing machine ID from random
generator.
[    3.886360] systemd[1]: Expecting device
dev-disk-by\x2duuid-f170152e\x2dde83\x2d46ee\x2d9546\x2d8ccd53f9753b.device...
         Expecting device
dev-disk-by\x2duuid-f170152e\x2dde8...9753b.device...
[    3.906204] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[    3.915160] systemd[1]: Created slice -.slice.
[    3.919638] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[    3.931155] systemd[1]: Created slice System Slice.
[    3.936080] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[    3.944167] systemd[1]: Reached target Slices.
[    3.948650] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[    3.957186] systemd[1]: Reached target Timers.
[    3.961689] systemd[1]: Starting Journal Socket.
[    3.961702] usb 1-1.1: new low-speed USB device number 3 using
xhci_hcd
[  OK  ] Listening on Journal Socket.
[    3.979241] systemd[1]: Listening on Journal Socket.
[    3.984302] systemd[1]: Started dracut ask for additional cmdline
parameters.
[    3.991590] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[    4.001628] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[    4.013470] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[    4.028247] systemd[1]: Started Journal Service.
[  OK  ] Reached target Encrypted Volumes.
         Starting Create list of required static device nodes...rrent
kernel...
         Starting Setup Virtual Console...
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Swap.
[  OK  ] Reached target Local File Systems.
[    4.081629] usb 1-1.1: New USB device found, idVendor=03f0,
idProduct=0324
[    4.088528] usb 1-1.1: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    4.095861] usb 1-1.1: Product: HP Basic USB Keyboard
[    4.100933] usb 1-1.1: Manufacturer: Lite-On Technology Corp.
[  OK  [    4.106797] usb 1-1.1: ep 0x81 - rounding interval to 64
microframes, ep desc says 80 microframes
] Started Apply Kernel Variables.
[  OK  ] Started dracut cmdline hook.
[  OK  ] Started Create list of required static device nodes ...current[
4.133538] input: Lite-On Technology Corp. HP Basic USB Keyboard as
/devices/pci0000:00/005
 kernel.
[    4.149253] hid-generic 0003:03F0:0324.0001: input,hidraw0: USB HID
v1.10 Keyboard [Lite-On Technology Corp. HP Basic USB Keyboard] on
usb-0000:08:00.0-1.1/input0
[  OK  ] Started Setup Virtual Console.
         Starting Create static device nodes in /dev...
         Starting dracut pre-udev hook...
[  OK  ] Started Create static device nodes in /dev.
[    4.214568] RPC: Registered named UNIX socket transport module.
[    4.220509] RPC: Registered udp transport module.
[    4.225233] RPC: Registered tcp transport module.
[    4.229959] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    4.238837] usb 1-1.2: new low-speed USB device number 4 using
xhci_hcd
[  OK  ] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[    4.324559] systemd-udevd[295]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting dracut pre-trigger hook...
[    4.340679] usb 1-1.2: New USB device found, idVendor=03f0,
idProduct=0b4a
[    4.347574] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[    4.354903] usb 1-1.2: Product: USB Optical Mouse
[    4.359620] usb 1-1.2: Manufacturer: Logitech
[    4.364104] usb 1-1.2: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[    4.388938] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:03F0:0B4A.0002/input/input6
[    4.402909] hid-generic 0003:03F0:0B4A.0002: input,hidraw1: USB HID
v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:08:00.0-1.2/input0
[  OK  ] Started dracut pre-trigger hook.
         Starting udev Coldplug all Devices...
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
         Starting Show Plymouth Boot Screen...
[    4.512249] wmi: Mapper loaded
[    4.518629] pps_core: LinuxPPS API ver. 1 registered
[    4.523615] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[    4.534406] [drm] Initialized drm 1.1.0 20060810
[    4.539099] PTP clock support registered
[    4.543082] scsi host6: ata_generic
[    4.546671] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[    4.553222] tulip: Linux Tulip driver version 1.1.15 (Feb 27, 2007)
[    4.559598] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    4.559609] isci 0000:02:00.0: driver configured for rev: 5 silicon
[    4.559632] isci 0000:02:00.0: OEM SAS parameters (version: 1.3)
loaded (firmware)
[    4.559866] tulip: tulip_init_one: Enabled WOL support for AN983B
[    4.560585] tulip0:  MII transceiver #1 config 3100 status 7849
advertising 05e1
[    4.568024] net eth0: ADMtek Comet rev 17 at MMIO 0xd7121000,
00:b0:c0:06:70:90, IRQ 20
[    4.570776] scsi host7: ata_generic
[    4.570822] ata7: PATA max UDMA/100 cmd 0xf0b0 ctl 0xf0a0 bmdma
0xf070 irq 18
[    4.570823] ata8: PATA max UDMA/100 cmd 0xf090 ctl 0xf080 bmdma
0xf078 irq 18
[    4.593813] isci 0000:02:00.0: SCU controller 0: phy 3-0 cables:
{short, short, short, short}
[    4.596196] scsi host8: isci
[    4.606431] tulip 0000:09:04.0 p6p1: renamed from eth0
[    4.635280] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    4.641389] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec)
set to dynamic conservative mode
[    4.652422] alg: No test for crc32 (crc32-pclmul)
[    4.680990] systemd-udevd[389]: renamed network interface eth0 to
p6p1
[    4.703965] firewire_ohci 0000:09:05.0: added OHCI v1.0 device as
card 0, 8 IR + 8 IT contexts, quirks 0x0
[    4.772777] Switched to clocksource tsc
[    4.843434] e1000e 0000:00:19.0 eth0: registered PHC clock
[    4.848941] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1)
80:c1:6e:f8:9f:92
[    4.856881] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network
Connection
[    4.863808] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No:
0100FF-0FF
[    4.878631] e1000e 0000:00:19.0 em1: renamed from eth0
[    4.900219] systemd-udevd[371]: renamed network interface eth0 to em1
[    5.142991] random: nonblocking pool is initialized
[    5.214656] firewire_core 0000:09:05.0: created device fw0: GUID
0060b000008cec98, S400
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
[  OK  ] Found device ST31000524AS.
[  OK  ] Started dracut initqueue hook.
         Starting drac[    5.688241] EXT4-fs (sda2): INFO: recovery
required on readonly filesystem
[    5.695372] EXT4-fs (sda2): write access will be enabled during
recovery
ut pre-mount hook...
[  OK  ] Reached target Remote File Systems (Pre).
[  OK  ] Reached target Remote File Systems.
[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
[  OK  ] Started dracut pre-mount hook.
         Mounting /sysroot...
[    8.745808] EXT4-fs (sda2): orphan cleanup on readonly fs
[    8.751420] EXT4-fs (sda2): 2 orphan inodes deleted
[    8.756331] EXT4-fs (sda2): recovery complete
[    8.852253] EXT4-fs (sda2): mounted filesystem with ordered data
mode. Opts: (null)
[  OK  ] Mounted /sysroot.
[  OK  ] Reached target Initrd Root File System.
         Starting Reload Configuration from the Real Root...
[  OK  ] Started Reload Configuration from the Real Root.
[  OK  ] Reached target Initrd File Systems.
[  OK  ] Reached target Initrd Default Target.
[    9.228197] systemd-journald[151]: Received SIGTERM
[   10.038168] SELinux:  Permission audit_read in class capability2 not
defined in policy.
[   10.046190] SELinux: the above unknown classes and permissions will
be allowed
[   10.062413] audit: type=1403 audit(1413971573.143:2): policy loaded
auid=4294967295 ses=4294967295
[   10.076427] systemd[1]: Successfully loaded SELinux policy in
215.463ms.
[   10.287501] systemd[1]: Relabelled /dev and /run in 31.807ms.

Welcome to Fedora 20 (Heisenbug)!

[  OK  ] Stopped Switch Root.
[  OK  ] Stopped target Switch Root.
[  OK  ] Stopped target Initrd File Systems.
[  OK  ] Stopped target Initrd Root File System.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Created slice system-serial\x2dgetty.slice.
         Expecting device dev-ttyS0.device...
[  OK  ] Created slice system-getty.slice.
[  OK  ] Reached target Remote File Systems.
         Starting Collect Read-Ahead Data...
         Starting Replay Read-Ahead Data...
[  OK  ] Reached target Slices.
[  OK  ] Listening on Delayed Shutdown Socket.
[[   11.691991] systemd-readahead[518]: Bumped block_nr parameter of 8:0
to 20480. This is a temporary hack and should be removed one day.
  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
         Mounting Huge Pages File System...
         Starting Create list of required static device nodes...rrent
kernel...
         Mounting Debug File System...
[  OK  ] Set up automount Arbitrary Executable File Formats F...utomount
Point.
         Mounting POSIX Message Queue File System...
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
         Starting udev Coldplug all Devices...
[  OK  ] Listening on LVM2 metadata daemon socket.
[  OK  ] Listening on Device-mapper event daemon FIFOs.
         Starting Monitoring of LVM2 mirrors, snapshots etc. ...ress
polling...
         Expecting device
dev-disk-by\x2duuid-3429ef24\x2d72c...30516.device...
         Mounting Temporary Directory...
         Expecting device
dev-disk-by\x2duuid-06476532\x2d367...e5455.device...
         Expecting device dev-sda5.device...
[  OK  ] Started Collect Read-Ahead Data.
[  OK  ] Started Replay Read-Ahead Data.
[  OK  ] Started Create list of required static device nodes ...current
kernel.
         Starting Create static device nodes in /dev...
         Starting Apply Kernel Variables...
         Starting Set Up Additional Binary Formats...
         Starting File System Check on Root Device...
[  OK  ] Stopped Trigger Flushing of Journal to Persistent Storage.
         Stopping Journal Service...
[  OK  ] Stopped Journal Service.
         Starting Journal Service...
[  OK  ] Started Journal Service.
[  OK  ] Started udev Coldplug all Devices.
         Starting udev Wait for Complete Device Initialization...
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Mounted Debug File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Mounted Temporary Directory.
[   12.251281] systemd[1]: Got automount request for
/proc/sys/fs/binfmt_misc, triggered by 532 (systemd-binfmt)
         Mounting Arbitrary Executable File Formats File System...
         Starting LVM2 metadata daemon...
[  OK  ] Started LVM2 metadata daemon.
[  OK  ] Started File System Check on Root Device.
         Starting Remount Root and Kernel File Systems...
[  OK  ] Started Apply Kernel Variables.
[   12.698407] EXT4-fs (sda2): re-mounted. Opts: (null)
[  OK  ] Started Remount Root and Kernel File Systems.
         Starting Import network configuration from initramfs...
         Starting Configure read-only root support...
         Starting Load/Save Random Seed...
[   11.835335] systemd-fsck[533]: /dev/sda2: clean, 764767/12804096
files, 29923436/51200000 blocks
[  OK  ] Started Create static device nodes in /dev.
         Starting udev Kernel Device Manager...
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Started Configure read-only root support.
[  OK  ] Started Load/Save Random Seed.
[   13.150173] systemd-udevd[557]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
[  OK  ] Mounted Arbitrary Executable File Formats File System.
[  OK  ] Started Import network configuration from initramfs.
[  OK  ] Started Set Up Additional Binary Formats.
[  OK  ] Started Monitoring of LVM2 mirrors, snapshots etc. u...ogress
polling.
[   13.727411] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[   13.746528] EDAC MC: Ver: 3.0.0
[   13.770194] input: PC Speaker as
/devices/platform/pcspkr/input/input7
[  OK  ] Found device /dev/ttyS0.
[   13.788550] microcode: CPU0 sig=0x206d7, pf=0x1, revision=0x70a
[   14.057309] microcode: CPU0 sig=0x206d7, pf=0x1, revision=0x70a
[   14.064513] microcode: CPU0 updated to revision 0x710, date =
2013-06-17
[   14.071276] microcode: CPU1 sig=0x206d7, pf=0x1, revision=0x70a
[   14.077273] microcode: CPU1 sig=0x206d7, pf=0x1, revision=0x70a
[   14.083967] microcode: CPU1 updated to revision 0x710, date =
2013-06-17
[   14.090703] microcode: CPU2 sig=0x206d7, pf=0x1, revision=0x70a
[   14.096683] microcode: CPU2 sig=0x206d7, pf=0x1, revision=0x70a
[   14.103126] microcode: CPU2 updated to revision 0x710, date =
2013-06-17
[   14.109840] microcode: CPU3 sig=0x206d7, pf=0x1, revision=0x70a
[   14.115792] microcode: CPU3 sig=0x206d7, pf=0x1, revision=0x70a
[   14.122214] microcode: CPU3 updated to revision 0x710, date =
2013-06-17
[   14.128926] perf_event_intel: PEBS enabled due to microcode update
[   14.135169] microcode: Microcode Update Driver: v2.00
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[   14.248144] shpchp: Standard Hot Plug PCI Controller Driver version:
0.4
[   14.271813] WARNING! power/level is deprecated; use power/control
instead
[   14.420616] iTCO_vendor_support: vendor-support=0
[   14.426856] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[   14.432485] iTCO_wdt: unable to reset NO_REBOOT flag, device disabled
by hardware/BIOS
[  OK  ] Started udev Wait for Complete Device Initialization.
         Starting Activation of DM RAI[   14.455365] snd_hda_intel
0000:05:00.1: Disabling MSI
D sets...
[   14.461832] snd_hda_intel 0000:05:00.1: Handle VGA-switcheroo audio
client
[   14.473273] sound hdaudioC0D0: ALC262: SKU not ready 0x411111f0
[   14.479610] sound hdaudioC0D0: autoconfig: line_outs=1
(0x15/0x0/0x0/0x0/0x0) type:line
[   14.487631] sound hdaudioC0D0:    speaker_outs=1
(0x16/0x0/0x0/0x0/0x0)
[   14.494268] sound hdaudioC0D0:    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[   14.500465] sound hdaudioC0D0:    mono: mono_out=0x0
[   14.505444] sound hdaudioC0D0:    inputs:
[   14.509474] sound hdaudioC0D0:      Front Mic=0x19
[   14.514283] sound hdaudioC0D0:      Rear Mic=0x18
[   14.519004] sound hdaudioC0D0:      Line=0x1a
[   14.534148] input: HDA Intel PCH Front Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[  OK  [   14.543371] input: HDA Intel PCH Rear Mic as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input10
] Reached target[   14.553521] input: HDA Intel PCH Line as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input11
 Sound Card.
[   14.563465] input: HDA Intel PCH Line Out as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input12
[   14.573669] input: HDA Intel PCH Front Headphone as
/devices/pci0000:00/0000:00:1b.0/sound/card0/input13
[  OK  ] Started Activation of DM RAID sets.
[  [   14.650020] input: HP WMI hotkeys as /devices/virtual/input/input8
OK  ] Reached target Encrypted Volumes.
[   14.861374] input: HDA NVidia HDMI/DP,pcm=3 as
/devices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input14
[   14.871750] input: HDA NVidia HDMI/DP,pcm=7 as
/devices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input15
[   14.882111] input: HDA NVidia HDMI/DP,pcm=8 as
/devices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input16
[   14.892494] input: HDA NVidia HDMI/DP,pcm=9 as
/devices/pci0000:00/0000:00:02.0/0000:05:00.1/sound/card1/input17
[  OK  ] Found device ST31000524AS.
         Starting File System Check on
/dev/disk/by-uuid/0647...f0b6564e5455...
[  OK  ] Found device ST31000524AS.
         Activating swap
/dev/disk/by-uuid/3429ef24-72c1-435f...15132ef30516...
[   15.331176] Adding 14195708k swap on /dev/sda9.  Priority:-1
extents:1 across:14195708k FS
[  OK  ] Activated swap
/dev/disk/by-uuid/3429ef24-72c1-435f-a55b-15132ef30516.
[  OK  ] Reached target Swap.
[   14.739416] systemd-fsck[754]: /dev/sda1: recovering journal
[  OK  ] Found device ST31000524AS.
         Mounting /mnt/foo...
[   16.328179] EXT4-fs (sda5): recovery complete
[   16.332562] EXT4-fs (sda5): mounted filesystem with ordered data
mode. Opts: (null)
[  OK  ] Mounted /mnt/foo.
[   15.657813] systemd-fsck[754]: /dev/sda1: clean, 1055/640848 files,
363426/2560000 blocks
[  OK  ] Started File System Check on
/dev/disk/by-uuid/06476...d-f0b6564e5455.
         Mounting /boot...
[   16.803480] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
         Starting Tell[   16.824355] systemd-journald[534]: Received
request to flush runtime journal from PID 1
 Plymouth To Write Out Runtime Data...
         Starting Trigger Flushing of Journal to Persistent Storage...
         Starting Create Volatile Files and Directories...
         Starting Security Auditing Service...
[  OK  ] Started Trigger Flushing of Journal to Persistent Storage.
[  OK  ] Started Security Auditing Service.
[  OK  ] Started Tell Plymouth To Write Out Runtime Data.
[   16.888896] audit: type=1305 audit(1413971579.962:3): audit_pid=772
old=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:auditd_t:s0
res=1
[  OK  ] Started Create Volatile Files and Directories.
         Starting Update UTMP about System Reboot/Shutdown...
[  OK  ] Started Update UTMP about System Reboot/Shutdown.
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Timers.
         Starting Manage Sound Card State (restore and store)...
[  OK  ] Started Manage Sound Card State (restore and store).
[  OK  ] Listening on Open-iSCSI iscsid Socket.
[  OK  ] Listening on PC/SC Smart Card Daemon Activation Socket.
[  OK  ] Listening on CUPS Printing Service Sockets.
[  OK  ] Listening on Open-iSCSI iscsiuio Socket.
[  OK  ] Reached target Paths.
[   17.417620] systemd-journald[534]: File
/var/log/journal/5504ea9d96a745d3bfa88caececd2740/system.journal
corrupted or uncleanly shut down, renaming and replacing.
[  OK  ] Listening on RPCbind Server Activation Socket.
[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
         Starting firewalld - dynamic firewall daemon...
         Starting Permit User Sessions...
         Starting ABRT Automated Bug Reporting Tool...
[  OK  ] Started ABRT Automated Bug Reporting Tool.
         Starting Install ABRT coredump hook...
         Starting Self Monitoring and Reporting Technology (SMART)
Daemon...
[  OK  ] Started Self Monitoring and Reporting Technology (SMART)
Daemon.
         Starting ABRT Xorg log watcher...
[  OK  ] Started ABRT Xorg log watcher.
         Starting Restorecon maintaining path file context...
[  OK  ] Started Restorecon maintaining path file context.
         Starting ABRT kernel log watcher...
[  OK  ] Started ABRT kernel log watcher.
         Starting irqbalance daemon...
[  OK  ] Started irqbalance daemon.
         Starting Hardware RNG Entropy Gatherer Daemon...
[  OK  ] Started Hardware RNG Entropy Gatherer Daemon.
         Starting RPC bind service...
         Starting System Logging Service...
         Starting Machine Check Exception Logging Daemon...
         Starting Avahi mDNS/DNS-SD Stack...
         Starting Login Service...
         Starting D-Bus System Message Bus...
[  OK  ] Started D-Bus System Message Bus.
[  OK  ] Started Permit User Sessions.
[  OK  ] Started Install ABRT coredump hook.
[   17.883468] systemd[1]: Unit rngd.service entered failed state.
         Starting Terminate Plymouth Boot Screen...
         Starting Command Scheduler...
[  OK  ] Started Command Scheduler.
         Starting Job spooling tools...
[  OK  ] Started Job spooling tools.
         Starting Wait for Plymouth Boot Screen to Quit...
[   20.504054] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   21.700499] Ebtables v2.0 registered
[   21.923678] bridge: automatic filtering via arp/ip/ip6tables has been
deprecated. Update your scripts to load br_netfilter if you need this.
[   23.919942] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)

Fedora release 20 (Heisenbug)
Kernel 3.18.0-rc1+ on an x86_64 (ttyS0)

dhcp-16-105 login: [   24.738924] cfg80211: Calling CRDA to update world
regulatory domain
[   24.787880] cfg80211: World regulatory domain updated:
[   24.793032] cfg80211:  DFS Master region: unset
[   24.797412] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   24.807193] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[   24.815206] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[   24.823222] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(N/A, 2000 mBm), (N/A)
[   24.831246] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[   24.839271] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[   24.847285] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz),
(N/A, 0 mBm), (N/A)
[   25.084687] nf_reject_ipv6: module license 'unspecified' taints
kernel.
[   25.091343] Disabling lock debugging due to kernel taint
[   25.096791] nf_reject_ipv6: Unknown symbol ip6_local_out (err 0)
[   25.948589] IPv6: ADDRCONF(NETDEV_UP): em1: link is not ready
[   29.600674] e1000e: em1 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: None
[   29.608149] IPv6: ADDRCONF(NETDEV_CHANGE): em1: link becomes ready
[   42.632070] tun: Universal TUN/TAP device driver, 1.6
[   42.637138] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[   42.669715] device virbr0-nic entered promiscuous mode
[   43.523326] device virbr0-nic left promiscuous mode
[   43.528246] virbr0: port 1(virbr0-nic) entered disabled state
[   57.978562] usb 1-1.2: USB disconnect, device number 4
[   59.437582] usb 1-1.2: new low-speed USB device number 5 using
xhci_hcd
[   59.538331] usb 1-1.2: New USB device found, idVendor=03f0,
idProduct=0b4a
[   59.545220] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[   59.552546] usb 1-1.2: Product: USB Optical Mouse
[   59.557263] usb 1-1.2: Manufacturer: Logitech
[   59.561762] usb 1-1.2: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[   59.582351] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:03F0:0B4A.0003/input/input18
[   59.596353] hid-generic 0003:03F0:0B4A.0003: input,hidraw1: USB HID
v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:08:00.0-1.2/input0

Fedora release 20 (Heisenbug)
Kernel 3.18.0-rc1+ on an x86_64 (ttyS0)

dhcp-16-105 login: root
Password: 
Login incorrect

dhcp-16-105 login: root
Password: 
Last failed login: Wed Oct 22 17:53:57 CST 2014 on ttyS0
There was 1 failed login attempt since the last successful login.
Last login: Wed Oct 22 15:45:44 on ttyS0
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# ls
1.svg            Documents                            minicom.log
Templates
anaconda-ks.cfg  Downloads                            Music
test.sh
aslr.sh          dump-failure.txt                     Pictures
Videos
Desktop          kexec-tools-2.0.4-32.el7.x86_64.rpm  Public
[root@dhcp-16-105 ~]# uname -a
Linux dhcp-16-105.nay.redhat.com 3.18.0-rc1+ #76 SMP Wed Oct 22 15:15:32
CST 2014 x86_64 x86_64 x86_64 GNU/Linux
[root@dhcp-16-105 ~]# kdumpctl restart
kexec: unloaded kdump kernel
Stopping kdump: [OK]
kexec: loaded kdump kernel
Starting kdump: [OK]
[root@dhcp-16-105 ~]# cat /proc/cmdline 
BOOT_IMAGE=/vmlinuz-3.18.0-rc1+
root=UUID=f170152e-de83-46ee-9546-8ccd53f9753b ro rd.md=0 rd.lvm=0
rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-sunt
[root@dhcp-16-105 ~]# less /proc/cmdline 
BOOT_IMAGE=/vmlinuz-3.18.0-rc1+
root=UUID=f170152e-de83-46ee-9546-8ccd53f9753b ro rd.md=0 rd.lvm=0
rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-suit
(END)[  113.077182] usb 1-1.2: USB disconnect, device number 5
...skipping...
BOOT_IMAGE=/vmlinuz-3.18.0-rc1+
root=UUID=f170152e-de83-46ee-9546-8ccd53f9753b ro rd.md=0 rd.lvm=0
rd.dm=0 vconsole.keymap=us rd.luks=0 vconsole.font=latarcyrheb-suit
~
~
~
~
BOOT_IMAGE=/vmlinuz-3.18.0-rc1+
root=UUID=f170152e-de83-46ee-9546-8ccd53f9753b r 
o rd.md=0 rd.lvm=0 rd.dm=0 vconsole.keymap=us rd.luks=0
vconsole.font=latarcyrhe 
b-sun16 rd.shell crashkernel=256M LANG=en_US.UTF-8
console=ttyS0,115200n8 intel_ 
iommu=on earlyprintk=serial nokaslr nomodeset
~
~
~
~
~
~
~
~
~
~
~
(END)[  114.537466] usb 1-1.2: new low-speed USB device number 6 using
xhci_hcd
(END)[  114.642462] usb 1-1.2: New USB device found, idVendor=03f0,
idProduct=0b4a
[  114.649381] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  114.656722] usb 1-1.2: Product: USB Optical Mouse
[  114.661443] usb 1-1.2: Manufacturer: Logitech
[  114.666112] usb 1-1.2: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[  114.681135] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:03F0:0B4A.0004/input/input19
[  114.695318] hid-generic 0003:03F0:0B4A.0004: input,hidraw1: USB HID
v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:08:00.0-1.2/input0
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# 
[root@dhcp-16-105 ~]# echo c >[  168.175473] usb 1-1.2: USB disconnect,
device number 6
[  169.636143] usb 1-1.2: new low-speed USB device number 7 using
xhci_hcd
[  169.740999] usb 1-1.2: New USB device found, idVendor=03f0,
idProduct=0b4a
[  169.747910] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  169.755240] usb 1-1.2: Product: USB Optical Mouse
[  169.759961] usb 1-1.2: Manufacturer: Logitech
[  169.764600] usb 1-1.2: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[  169.779073] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:03F0:0B4A.0005/input/input20
[  169.793273] hid-generic 0003:03F0:0B4A.0005: input,hidraw1: USB HID
v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:08:00.0-1.2/input0
[  223.273783] usb 1-1.2: USB disconnect, device number 7
[  224.733810] usb 1-1.2: new low-speed USB device number 8 using
xhci_hcd
[  224.838806] usb 1-1.2: New USB device found, idVendor=03f0,
idProduct=0b4a
[  224.845721] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  224.853059] usb 1-1.2: Product: USB Optical Mouse
[  224.857785] usb 1-1.2: Manufacturer: Logitech
[  224.862438] usb 1-1.2: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[  224.876877] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:03F0:0B4A.0006/input/input21
[  224.891163] hid-generic 0003:03F0:0B4A.0006: input,hidraw1: USB HID
v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:08:00.0-1.2/input0
[  278.372084] usb 1-1.2: USB disconnect, device number 8
[  279.832487] usb 1-1.2: new low-speed USB device number 9 using
xhci_hcd
[  279.934347] usb 1-1.2: New USB device found, idVendor=03f0,
idProduct=0b4a
[  279.941258] usb 1-1.2: New USB device strings: Mfr=1, Product=2,
SerialNumber=0
[  279.948587] usb 1-1.2: Product: USB Optical Mouse
[  279.953313] usb 1-1.2: Manufacturer: Logitech
[  279.957963] usb 1-1.2: ep 0x81 - rounding interval to 64 microframes,
ep desc says 80 microframes
[  279.975205] input: Logitech USB Optical Mouse as
/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/usb1/1-1/1-1.2/1-1.2:1.0/0003:03F0:0B4A.0007/input/input22
[  279.990344] hid-generic 0003:03F0:0B4A.0007: input,hidraw1: USB HID
v1.11 Mouse [Logitech USB Optical Mouse] on usb-0000:08:00.0-1.2/input0

-bash: syntax error near unexpected token `newline'
[root@dhcp-16-105 ~]# echo c >/proc/sysrq-trigger 
[  302.991695] SysRq : Trigger a crash
[  302.995270] BUG: unable to handle kernel NULL pointer dereference at
(null)
[  303.003163] IP: [<ffffffff81446d66>] sysrq_handle_crash+0x16/0x20
[  303.009300] PGD cb140067 PUD c7334067 PMD 0 
[  303.013652] Oops: 0002 [#1] SMP 
[  303.016930] Modules linked in: xt_CHECKSUM tun nf_conntrack_ipv6
nf_defrag_ipv6 cfg80211 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack
nf_conntrack ebtable_nat ebc
[  303.103047] CPU: 1 PID: 1169 Comm: bash Tainted: P
3.18.0-rc1+ #76
[  303.110454] Hardware name: Hewlett-Packard HP Z420 Workstation/1589,
BIOS J61 v01.02 03/09/2012
[  303.119166] task: ffff88040dbb9bc0 ti: ffff880415898000 task.ti:
ffff880415898000
[  303.126662] RIP: 0010:[<ffffffff81446d66>]  [<ffffffff81446d66>]
sysrq_handle_crash+0x16/0x20
[  303.135227] RSP: 0018:ffff88041589be58  EFLAGS: 00010246
[  303.140551] RAX: 000000000000000f RBX: ffffffff81caeb00 RCX:
0000000000000000
[  303.147700] RDX: 0000000000000000 RSI: ffff88042fc8e038 RDI:
0000000000000063
[  303.154841] RBP: ffff88041589be58 R08: 00000000000000c2 R09:
ffffffff81ee0e9c
[  303.161993] R10: 000000000000041c R11: 000000000000041b R12:
0000000000000063
[  303.169141] R13: 0000000000000000 R14: 0000000000000007 R15:
0000000000000000
[  303.176287] FS:  00007f411bed9740(0000) GS:ffff88042fc80000(0000)
knlGS:0000000000000000
[  303.184389] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  303.190145] CR2: 0000000000000000 CR3: 00000000c72e2000 CR4:
00000000000407e0
[  303.197289] Stack:
[  303.199315]  ffff88041589be88 ffffffff81447557 0000000000000002
00007f411bef7000
[  303.206797]  0000000000000002 ffff88041589bf48 ffff88041589bea8
ffffffff81447a03
[  303.214274]  0000000000000001 ffff8804190f5a80 ffff88041589bed8
ffffffff8126029d
[  303.221744] Call Trace:
[  303.224203]  [<ffffffff81447557>] __handle_sysrq+0x107/0x170
[  303.229879]  [<ffffffff81447a03>] write_sysrq_trigger+0x33/0x40
[  303.235811]  [<ffffffff8126029d>] proc_reg_write+0x3d/0x80
[  303.241314]  [<ffffffff811f7cd7>] vfs_write+0xb7/0x1f0
[  303.246475]  [<ffffffff8102196c>] ? do_audit_syscall_entry+0x6c/0x70
[  303.252843]  [<ffffffff811f87c5>] SyS_write+0x55/0xd0
[  303.257916]  [<ffffffff81734ca9>] system_call_fastpath+0x12/0x17
[  303.263938] Code: c1 f7 ff ff eb db 66 2e 0f 1f 84 00 00 00 00 00 0f
1f 44 00 00 66 66 66 66 90 55 c7 05 64 66 a9 00 01 00 00 00 48 89 e5 0f
ae f8 <c6> 04 25 00 0 
[  303.283989] RIP  [<ffffffff81446d66>] sysrq_handle_crash+0x16/0x20
[  303.290209]  RSP <ffff88041589be58>
[  303.293709] CR2: 0000000000000000
I'm in purgatory
earlyser0] disabled
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2793.258 MHz processor
[    0.000062] Calibrating delay loop (skipped), value calculated using
timer frequency.. 5586.51 BogoMIPS (lpj=2793258)
[    0.010711] pid_max: default: 32768 minimum: 301
[    0.015350] ACPI: Core revision 20140828
[    0.073036] ACPI: All ACPI Tables successfully acquired
[    0.078367] Security Framework initialized
[    0.082481] SELinux:  Initializing.
[    0.086084] Dentry cache hash table entries: 32768 (order: 6, 262144
bytes)
[    0.093162] Inode-cache hash table entries: 16384 (order: 5, 131072
bytes)
[    0.100099] Mount-cache hash table entries: 512 (order: 0, 4096
bytes)
[    0.106633] Mountpoint-cache hash table entries: 512 (order: 0, 4096
bytes)
[    0.113883] Initializing cgroup subsys memory
[    0.118251] Initializing cgroup subsys devices
[    0.122704] Initializing cgroup subsys freezer
[    0.127157] Initializing cgroup subsys net_cls
[    0.131616] Initializing cgroup subsys blkio
[    0.135900] Initializing cgroup subsys perf_event
[    0.140617] Initializing cgroup subsys hugetlb
[    0.145111] CPU: Physical Processor ID: 0
[    0.149128] CPU: Processor Core ID: 1
[    0.152817] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.152817] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.175675] Freeing SMP alternatives memory: 24K (ffffffffade80000 -
ffffffffade86000)
[    0.186233] ftrace: allocating 27051 entries in 106 pages
[    0.216370] dmar: Host address width 46
[    0.220217] dmar: DRHD base: 0x000000dfffc000 flags: 0x1
[    0.225550] dmar: IOMMU 0: reg_base_addr dfffc000 ver 1:0 cap
d2078c106f0462 ecap f020fe
[    0.233654] dmar: RMRR base: 0x000000cba11000 end: 0x000000cba27fff
[    0.239931] dmar: ATSR flags: 0x0
[    0.243357] IOAPIC id 0 under DRHD base  0xdfffc000 IOMMU 0
[    0.248936] IOAPIC id 2 under DRHD base  0xdfffc000 IOMMU 0
[    0.254521] HPET id 0 under DRHD base 0xdfffc000
[    0.259338] Enabled IRQ remapping in xapic mode
[    0.264465] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.280520] smpboot: CPU0: Intel(R) Xeon(R) CPU E5-1603 0 @ 2.80GHz
(fam: 06, model: 2d, stepping: 07)
[    0.289972] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge
events, full-width counters, Broken BIOS detected, complain to your
hardware vendor.
[    0.303872] [Firmware Bug]: the BIOS has corrupted hw-PMU resources
(MSR 38d is b0)
[    0.311542] Intel PMU driver.
[    0.314527] ... version:                3
[    0.318547] ... bit width:              48
[    0.322654] ... generic registers:      8
[    0.326677] ... value mask:             0000ffffffffffff
[    0.332003] ... max period:             0000ffffffffffff
[    0.337330] ... fixed-purpose events:   3
[    0.341350] ... event mask:             00000007000000ff
[    0.348995] x86: Booted up 1 node, 1 CPUs
[    0.353023] smpboot: Total of 1 processors activated (5586.51
BogoMIPS)
[    0.359685] NMI watchdog: enabled on all CPUs, permanently consumes
one hw-PMU counter.
[    0.370673] devtmpfs: initialized
[    0.378421] PM: Registering ACPI NVS region [mem
0xcb750000-0xcb7dafff] (569344 bytes)
[    0.386375] PM: Registering ACPI NVS region [mem
0xcbaad000-0xcbaaefff] (8192 bytes)
[    0.394133] PM: Registering ACPI NVS region [mem
0xcbabb000-0xcbacdfff] (77824 bytes)
[    0.401983] PM: Registering ACPI NVS region [mem
0xcbb56000-0xcbb5dfff] (32768 bytes)
[    0.409826] PM: Registering ACPI NVS region [mem
0xcbb71000-0xcbffffff] (4780032 bytes)
[    0.419640] atomic64_test: passed for x86-64 platform with CX8 and
with SSE
[    0.426625] pinctrl core: initialized pinctrl subsystem
[    0.431918] RTC time:  9:57:56, date: 10/22/14
[    0.436548] NET: Registered protocol family 16
[    0.441384] cpuidle: using governor menu
[    0.445546] ACPI: bus type PCI registered
[    0.449572] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.456155] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.465479] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in
E820
[    0.472847] PCI: Using configuration type 1 for base access
[    0.480712] ACPI: Added _OSI(Module Device)
[    0.484911] ACPI: Added _OSI(Processor Device)
[    0.489362] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.494080] ACPI: Added _OSI(Processor Aggregator Device)
[    0.512071] ACPI: Executed 1 blocks of module-level executable AML
code
[    0.633617] ACPI: Interpreter enabled
[    0.637301] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S1_] (20140828/hwxface-580)
[    0.646590] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep
State [\_S2_] (20140828/hwxface-580)
[    0.655889] ACPI: (supports S0 S3 S4 S5)
[    0.659830] ACPI: Using IOAPIC for interrupt routing
[    0.664855] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    0.675416] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.696563] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-7f])
[    0.702770] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.711195] acpi PNP0A08:00: _OSC: platform does not support
[PCIeCapability]
[    0.718444] acpi PNP0A08:00: _OSC: not requesting control; platform
does not support [PCIeCapability]
[    0.727682] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER
PCIeCapability]
[    0.735439] acpi PNP0A08:00: _OSC: platform willing to grant
[PCIeHotplug PME AER]
[    0.743024] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.750309] PCI host bridge to bus 0000:00
[    0.754422] pci_bus 0000:00: root bus resource [bus 00-7f]
[    0.759918] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.766112] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.772304] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.778498] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.784695] pci_bus 0000:00: root bus resource [mem
0x000a0000-0x000bffff]
[    0.791581] pci_bus 0000:00: root bus resource [mem
0x000c0000-0x000dffff]
[    0.798470] pci_bus 0000:00: root bus resource [mem
0xd4000000-0xdfffffff]
[    0.805360] pci_bus 0000:00: root bus resource [mem
0x3c0000000000-0x3c007fffffff]
[    0.813350] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.819266] pci 0000:00:02.0: System wakeup disabled by ACPI
[    0.825175] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.832571] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.838507] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.844614] pci 0000:00:1c.0: Enabling MPC IRBNCE
[    0.849334] pci 0000:00:1c.0: Intel PCH root port ACS workaround
enabled
[    0.856087] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.862019] pci 0000:00:1c.5: Enabling MPC IRBNCE
[    0.866733] pci 0000:00:1c.5: Intel PCH root port ACS workaround
enabled
[    0.873488] pci 0000:00:1c.5: System wakeup disabled by ACPI
[    0.879358] pci 0000:00:1c.6: Enabling MPC IRBNCE
[    0.884074] pci 0000:00:1c.6: Intel PCH root port ACS workaround
enabled
[    0.890831] pci 0000:00:1c.6: System wakeup disabled by ACPI
[    0.896699] pci 0000:00:1c.7: Enabling MPC IRBNCE
[    0.901423] pci 0000:00:1c.7: Intel PCH root port ACS workaround
enabled
[    0.908185] pci 0000:00:1c.7: System wakeup disabled by ACPI
[    0.914122] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.919960] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.926419] pci 0000:00:01.0: PCI bridge to [bus 03]
[    0.933439] pci 0000:00:02.0: PCI bridge to [bus 05]
[    0.938534] pci 0000:00:03.0: PCI bridge to [bus 04]
[    0.943949] pci 0000:00:11.0: PCI bridge to [bus 02]
[    0.949041] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.954153] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    0.959237] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    0.966238] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    0.971737] pci 0000:00:1e.0: PCI bridge to [bus 09] (subtractive
decode)
[    0.979423] ACPI: PCI Root Bridge [PCI1] (domain 0000 [bus 80-ff])
[    0.985625] acpi PNP0A08:01: _OSC: OS supports [ExtendedConfig ASPM
ClockPM Segments MSI]
[    0.994048] acpi PNP0A08:01: _OSC: platform does not support
[PCIeCapability]
[    1.001306] acpi PNP0A08:01: _OSC: not requesting control; platform
does not support [PCIeCapability]
[    1.010545] acpi PNP0A08:01: _OSC: OS requested [PCIeHotplug PME AER
PCIeCapability]
[    1.018301] acpi PNP0A08:01: _OSC: platform willing to grant
[PCIeHotplug PME AER]
[    1.025882] acpi PNP0A08:01: _OSC failed (AE_SUPPORT); disabling ASPM
[    1.032713] PCI host bridge to bus 0000:80
[    1.036824] pci_bus 0000:80: root bus resource [bus 80-ff]
[    1.042327] pci_bus 0000:80: root bus resource [io  0x0000-0x03af]
[    1.048523] pci_bus 0000:80: root bus resource [io  0x03e0-0x0cf7]
[    1.054715] pci_bus 0000:80: root bus resource [mem
0x000c0000-0x000dffff]
[    1.061762] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12
14 15), disabled.
[    1.070108] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12
14 15), disabled.
[    1.078448] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12
14 15), disabled.
[    1.086594] ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 6 10 11 12
14 15), disabled.
[    1.094733] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 10 11 12
14 15), disabled.
[    1.103063] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12
14 15) *0, disabled.
[    1.111589] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12
14 15), disabled.
[    1.119926] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12
14 15), disabled.
[    1.128398] APIC: Disabling requested cpu. Processor 4/0x0 ignored.
[    1.134686] ACPI: Unable to map lapic to logical cpu number
[    1.140528] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 5/0x4 ignored.
[    1.148372] ACPI: Unable to map lapic to logical cpu number
[    1.154106] ACPI: NR_CPUS/possible_cpus limit of 1 reached.
Processor 6/0x6 ignored.
[    1.161946] ACPI: Unable to map lapic to logical cpu number
[    1.168184] ACPI: Enabled 2 GPEs in block 00 to 3F
[    1.173207] vgaarb: setting as boot device: PCI:0000:05:00.0
[    1.178880] vgaarb: device added:
PCI:0000:05:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.186982] vgaarb: loaded
[    1.189700] vgaarb: bridge control possible 0000:05:00.0
[    1.195147] SCSI subsystem initialized
[    1.199024] ACPI: bus type USB registered
[    1.203086] usbcore: registered new interface driver usbfs
[    1.208594] usbcore: registered new interface driver hub
[    1.213938] usbcore: registered new device driver usb
[    1.219153] PCI: Using ACPI for IRQ routing
[    1.231169] PCI: Discovered peer bus ff
[    1.235070] PCI host bridge to bus 0000:ff
[    1.239179] pci_bus 0000:ff: root bus resource [io  0x0000-0xffff]
[    1.245370] pci_bus 0000:ff: root bus resource [mem
0x00000000-0x3fffffffffff]
[    1.252608] pci_bus 0000:ff: No busn resource found for root bus,
will use [bus ff-ff]
[    1.264714] NetLabel: Initializing
[    1.268127] NetLabel:  domain hash size = 128
[    1.272491] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.277497] NetLabel:  unlabeled traffic allowed by default
[    1.283296] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    1.289663] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.298564] Switched to clocksource hpet
[    1.311704] pnp: PnP ACPI init
[    1.314979] system 00:00: [mem 0xfc000000-0xfcffffff window] has been
reserved
[    1.322236] system 00:00: [mem 0xfd000000-0xfdffffff window] has been
reserved
[    1.329479] system 00:00: [mem 0xfe000000-0xfeafffff window] has been
reserved
[    1.336718] system 00:00: [mem 0xfeb00000-0xfebfffff window] has been
reserved
[    1.343955] system 00:00: [mem 0xfed00400-0xfed3ffff window] could
not be reserved
[    1.351545] system 00:00: [mem 0xfed45000-0xfedfffff window] has been
reserved
[    1.358781] system 00:00: [mem 0xdffff000-0xdfffffff window] has been
reserved
[    1.366266] system 00:01: [io  0x0620-0x063f] has been reserved
[    1.372205] system 00:01: [io  0x0610-0x061f] has been reserved
[    1.378470] system 00:05: [io  0x04d0-0x04d1] has been reserved
[    1.385043] system 00:07: [io  0x0400-0x0453] could not be reserved
[    1.391337] system 00:07: [io  0x0458-0x047f] has been reserved
[    1.397275] system 00:07: [io  0x1180-0x119f] has been reserved
[    1.403208] system 00:07: [io  0x0500-0x057f] has been reserved
[    1.409144] system 00:07: [mem 0xfed1c000-0xfed1ffff] has been
reserved
[    1.415772] system 00:07: [mem 0xfec00000-0xfecfffff] could not be
reserved
[    1.422746] system 00:07: [mem 0xfed08000-0xfed08fff] has been
reserved
[    1.429376] system 00:07: [mem 0xff000000-0xffffffff] has been
reserved
[    1.436117] system 00:08: [io  0x0454-0x0457] has been reserved
[    1.442645] system 00:09: [mem 0xfed40000-0xfed44fff] has been
reserved
[    1.449289] pnp: PnP ACPI: found 10 devices
[    1.460619] pci 0000:00:01.0: PCI bridge to [bus 03]
[    1.465617] pci 0000:00:02.0: PCI bridge to [bus 05]
[    1.470602] pci 0000:00:02.0:   bridge window [io  0xd000-0xdfff]
[    1.476723] pci 0000:00:02.0:   bridge window [mem
0xd6000000-0xd70fffff]
[    1.483534] pci 0000:00:02.0:   bridge window [mem
0xd8000000-0xddffffff 64bit pref]
[    1.491301] pci 0000:00:03.0: PCI bridge to [bus 04]
[    1.496292] pci 0000:00:11.0: PCI bridge to [bus 02]
[    1.501277] pci 0000:00:11.0:   bridge window [io  0xe000-0xefff]
[    1.507392] pci 0000:00:11.0:   bridge window [mem
0xde400000-0xde8fffff 64bit pref]
[    1.515157] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    1.520149] pci 0000:00:1c.5: PCI bridge to [bus 06]
[    1.525140] pci 0000:00:1c.6: PCI bridge to [bus 07]
[    1.530133] pci 0000:00:1c.7: PCI bridge to [bus 08]
[    1.535120] pci 0000:00:1c.7:   bridge window [mem
0xd7200000-0xd72fffff]
[    1.541935] pci 0000:00:1e.0: PCI bridge to [bus 09]
[    1.546919] pci 0000:00:1e.0:   bridge window [io  0xc000-0xcfff]
[    1.553027] pci 0000:00:1e.0:   bridge window [mem
0xd7100000-0xd71fffff]
[    1.559993] NET: Registered protocol family 2
[    1.564629] TCP established hash table entries: 2048 (order: 2, 16384
bytes)
[    1.571721] TCP bind hash table entries: 2048 (order: 3, 32768 bytes)
[    1.578192] TCP: Hash tables configured (established 2048 bind 2048)
[    1.584583] TCP: reno registered
[    1.587827] UDP hash table entries: 256 (order: 1, 8192 bytes)
[    1.593681] UDP-Lite hash table entries: 256 (order: 1, 8192 bytes)
[    1.600029] NET: Registered protocol family 1
[    1.621368] pci 0000:08:00.0: xHCI HW did not halt within 16000 usec
status = 0x0
[    1.629082] Unpacking initramfs...
[    2.108338] Freeing initrd memory: 16204K (ffff88002c02d000 -
ffff88002d000000)
[    2.115728] IOMMU intel_iommu_in_crashdump = true
[    2.120458] IOMMU Skip disabling iommu hardware translations
[    2.126222] IOMMU Copying translate tables from panicked kernel
[    2.133478] IOMMU: root_new_virt:0xffff880027ddf000
phys:0x000027ddf000
[    2.140116] IOMMU:0 Domain ids from panicked kernel:
[    2.145099] DID did:4(0x0004)
[    2.148078] DID did:9(0x0009)
[    2.151059] DID did:7(0x0007)
[    2.154038] DID did:3(0x0003)
[    2.157019] DID did:2(0x0002)
[    2.159998] DID did:6(0x0006)
[    2.162981] DID did:1(0x0001)
[    2.165958] DID did:8(0x0008)
[    2.168941] DID did:0(0x0000)
[    2.171919] DID did:10(0x000a)
[    2.174988] DID did:5(0x0005)
[    2.177966] ----------------------------------------
[    2.182947] IOMMU 0 0xdfffc000: using Queued invalidation
[    2.188366] PCI-DMA: Intel(R) Virtualization Technology for Directed
I/O
[    2.195091] dmar: DRHD: handling fault status reg 2
[    2.195096] dmar: DMAR:[DMA Read] Request device [08:00.0] fault addr
ffff2000 
[    2.195096] DMAR:[fault reason 12] non-zero reserved fields in PTE
[    2.215841] RAPL PMU detected, hw unit 2^-16 Joules, API unit is
2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    2.226738] AVX version of gcm_enc/dec engaged.
[    2.231292] AES CTR mode by8 optimization enabled
[    2.238553] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    2.245466] futex hash table entries: 256 (order: 2, 16384 bytes)
[    2.251622] Initialise system trusted keyring
[    2.256036] audit: initializing netlink subsys (disabled)
[    2.261520] audit: type=2000 audit(1413971876.315:1): initialized
[    2.268376] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.277283] zpool: loaded
[    2.279935] zbud: loaded
[    2.282811] VFS: Disk quotas dquot_6.5.2
[    2.286815] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    2.293868] msgmni has been set to 463
[    2.297735] Key type big_key registered
[    2.302645] alg: No test for stdrng (krng)
[    2.306778] NET: Registered protocol family 38
[    2.311268] Key type asymmetric registered
[    2.315401] Asymmetric key parser 'x509' registered
[    2.320372] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 252)
[    2.327837] io scheduler noop registered
[    2.331787] io scheduler deadline registered
[    2.336133] io scheduler cfq registered (default)
[    2.342328] ioapic: probe of 0000:00:05.4 failed with error -22
[    2.348285] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.353897] pciehp: PCI Express Hot Plug Controller Driver version:
0.4
[    2.360815] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    2.369189] ACPI: Power Button [PWRB]
[    2.372933] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    2.380359] ACPI: Power Button [PWRF]
[    2.385897] GHES: HEST is not enabled!
[    2.389803] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.416763] serial 00:06: ttyS0 at I/O 0x3f8 (irq = 4, base_baud =
115200) is a 16550A
[    2.445683] serial 0000:00:16.3: ttyS1 at I/O 0xf060 (irq = 17,
base_baud = 115200) is a 16550A
[    2.454856] Non-volatile memory driver v1.3
[    2.459066] Linux agpgart interface v0.103
[    2.473906] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps
0x5 impl RAID mode
[    2.482029] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio ems
sxs apst 
[    2.489341] dmar: DRHD: handling fault status reg 102
[    2.494411] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[    2.494411] DMAR:[fault reason 05] PTE Write access is not set
[    2.507684] dmar: DRHD: handling fault status reg 202
[    2.512751] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[    2.512751] DMAR:[fault reason 05] PTE Write access is not set
[    2.526844] scsi host0: ahci
[    2.529928] scsi host1: ahci
[    2.532945] scsi host2: ahci
[    2.535953] scsi host3: ahci
[    2.538965] scsi host4: ahci
[    2.541969] scsi host5: ahci
[    2.544931] ata1: SATA max UDMA/133 abar m2048@0xd7348000 port
0xd7348100 irq 27
[    2.552347] ata2: DUMMY
[    2.554813] ata3: SATA max UDMA/133 abar m2048@0xd7348000 port
0xd7348200 irq 27
[    2.562232] ata4: DUMMY
[    2.564692] ata5: DUMMY
[    2.567150] ata6: DUMMY
[    2.569960] libphy: Fixed MDIO Bus: probed
[    2.574264] xhci_hcd 0000:08:00.0: xHCI Host Controller
[    2.579579] xhci_hcd 0000:08:00.0: new USB bus registered, assigned
bus number 1
[    2.627224] xhci_hcd 0000:08:00.0: Host not halted after 16000
microseconds.
[    2.634294] xhci_hcd 0000:08:00.0: can't setup: -110
[    2.639273] xhci_hcd 0000:08:00.0: USB bus 1 deregistered
[    2.644790] xhci_hcd 0000:08:00.0: init 0000:08:00.0 fail, -110
[    2.650745] xhci_hcd: probe of 0000:08:00.0 failed with error -110
[    2.656968] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
Driver
[    2.663534] ehci-pci: EHCI PCI platform driver
[    2.668147] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    2.673441] ehci-pci 0000:00:1a.0: new USB bus registered, assigned
bus number 1
[    2.680876] ehci-pci 0000:00:1a.0: debug port 2
[    2.689369] ehci-pci 0000:00:1a.0: irq 16, io mem 0xd734b000
[    2.700138] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.705994] usb usb1: New USB device found, idVendor=1d6b,
idProduct=0002
[    2.712805] usb usb1: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.720046] usb usb1: Product: EHCI Host Controller
[    2.724939] usb usb1: Manufacturer: Linux 3.18.0-rc1+ ehci_hcd
[    2.730790] usb usb1: SerialNumber: 0000:00:1a.0
[    2.735614] hub 1-0:1.0: USB hub found
[    2.739403] hub 1-0:1.0: 3 ports detected
[    2.743798] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    2.749118] ehci-pci 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    2.756550] ehci-pci 0000:00:1d.0: debug port 2
[    2.765045] ehci-pci 0000:00:1d.0: irq 23, io mem 0xd734a000
[    2.776219] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.782069] usb usb2: New USB device found, idVendor=1d6b,
idProduct=0002
[    2.788879] usb usb2: New USB device strings: Mfr=3, Product=2,
SerialNumber=1
[    2.796121] usb usb2: Product: EHCI Host Controller
[    2.801018] usb usb2: Manufacturer: Linux 3.18.0-rc1+ ehci_hcd
[    2.806862] usb usb2: SerialNumber: 0000:00:1d.0
[    2.811682] hub 2-0:1.0: USB hub found
[    2.815463] hub 2-0:1.0: 3 ports detected
[    2.819699] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.825917] ohci-pci: OHCI PCI platform driver
[    2.830402] uhci_hcd: USB Universal Host Controller Interface driver
[    2.836863] usbcore: registered new interface driver usbserial
[    2.842736] usbcore: registered new interface driver
usbserial_generic
[    2.849336] usbserial: USB Serial support registered for generic
[    2.855427] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M]
at 0x60,0x64 irq 1,12
[    2.865965] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.870968] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.876174] mousedev: PS/2 mouse device common for all mice
[    2.881777] dmar: DRHD: handling fault status reg 302
[    2.886838] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[    2.886838] DMAR:[fault reason 05] PTE Write access is not set
[    2.900089] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.906303] dmar: DRHD: handling fault status reg 402
[    2.911362] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fff80000 
[    2.911362] DMAR:[fault reason 06] PTE Read access is not set
[    2.924446] dmar: DRHD: handling fault status reg 502
[    2.929508] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[    2.929508] DMAR:[fault reason 05] PTE Write access is not set
[    2.942756] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    2.948961] dmar: DRHD: handling fault status reg 602
[    2.954020] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fffa0000 
[    2.954020] DMAR:[fault reason 06] PTE Read access is not set
[    2.967195] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[    2.973713] rtc_cmos 00:04: RTC can wake from S4
[    2.998582] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    3.004729] rtc_cmos 00:04: alarms up to one month, y3k, 114 bytes
nvram, hpet irqs
[    3.012928] device-mapper: uevent: version 1.0.3
[    3.017920] device-mapper: ioctl: 4.28.0-ioctl (2014-09-17)
initialised: dm-devel@redhat.com
[    3.026600] Intel P-state driver initializing.
[    3.032432] hidraw: raw HID events driver (C) Jiri Kosina
[    3.038489] usbcore: registered new interface driver usbhid
[    3.044082] usbhid: USB HID core driver
[    3.047965] oprofile: using NMI interrupt.
[    3.052434] drop_monitor: Initializing network drop monitor service
[    3.058843] ip_tables: (C) 2000-2006 Netfilter Core Team
[    3.064200] TCP: cubic registered
[    3.067566] Initializing XFRM netlink socket
[    3.071865] usb 1-1: new high-speed USB device number 2 using
ehci-pci
[    3.078568] NET: Registered protocol family 10
[    3.083052] dmar: DRHD: handling fault status reg 702
[    3.088126] dmar: DMAR:[DMA Read] Request device [00:1a.0] fault addr
ffffc000 
[    3.088126] DMAR:[fault reason 06] PTE Read access is not set
[    3.101185] ehci-pci 0000:00:1a.0: fatal error
[    3.105649] ehci-pci 0000:00:1a.0: HC died; cleaning up
[    3.111200] mip6: Mobile IPv6
[    3.114184] NET: Registered protocol family 17
[    3.118933] mce: Unable to init device /dev/mcelog (rc: -5)
[    3.124808] Loading compiled-in X.509 certificates
[    3.130800] Loaded X.509 cert 'Magrathea: Glacier signing key:
d196e1366cc7c91295775c1e77c548314c3ad291'
[    3.140315] registered taskstats version 1
[    3.145006]   Magic number: 2:75:981
[    3.148688] rtc_cmos 00:04: setting system clock to 2014-10-22
09:57:59 UTC (1413971879)
[    3.169677] usb 2-1: new high-speed USB device number 2 using
ehci-pci
[    3.176236] dmar: DRHD: handling fault status reg 2
[    3.181125] dmar: DMAR:[DMA Read] Request device [00:1d.0] fault addr
ffffc000 
[    3.181125] DMAR:[fault reason 06] PTE Read access is not set
[    3.194189] ehci-pci 0000:00:1d.0: fatal error
[    3.198641] ehci-pci 0000:00:1d.0: HC died; cleaning up
[    3.217718] tsc: Refined TSC clocksource calibration: 2793.268 MHz
[    4.224868] Switched to clocksource tsc
[    7.953940] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[    8.263278] dmar: DRHD: handling fault status reg 102
[    8.268341] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[    8.268341] DMAR:[fault reason 05] PTE Write access is not set
[    8.281591] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    8.287798] dmar: DRHD: handling fault status reg 202
[    8.292864] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fffa0000 
[    8.292864] DMAR:[fault reason 06] PTE Read access is not set
[    8.305939] dmar: DRHD: handling fault status reg 302
[    8.311000] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[    8.311000] DMAR:[fault reason 05] PTE Write access is not set
[    8.324248] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.330451] dmar: DRHD: handling fault status reg 402
[    8.335516] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fff80000 
[    8.335516] DMAR:[fault reason 06] PTE Read access is not set
[    8.348586] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[    8.354866] ata1: limiting SATA link speed to 3.0 Gbps
[   13.292823] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   13.299109] ata3: limiting SATA link speed to 1.5 Gbps
[   13.639202] dmar: DRHD: handling fault status reg 502
[   13.644267] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[   13.644267] DMAR:[fault reason 05] PTE Write access is not set
[   13.657517] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[   13.663732] dmar: DRHD: handling fault status reg 602
[   13.668791] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fffa0000 
[   13.668791] DMAR:[fault reason 06] PTE Read access is not set
[   13.681865] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   13.688074] dmar: DRHD: handling fault status reg 702
[   13.693136] dmar: DMAR:[DMA Read] Request device [00:1f.2] fault addr
fff80000 
[   13.693136] DMAR:[fault reason 06] PTE Read access is not set
[   13.706244] ata1.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   18.668754] ata3.00: failed to IDENTIFY (I/O error, err_mask=0x100)
[   18.996092] dmar: DRHD: handling fault status reg 2
[   19.000991] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fffa0000 
[   19.000991] DMAR:[fault reason 05] PTE Write access is not set
[   19.014238] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[   19.020470] dmar: DRHD: handling fault status reg 102
[   19.025531] dmar: DMAR:[DMA Write] Request device [00:1f.2] fault
addr fff80000 
[   19.025531] DMAR:[fault reason 05] PTE Write access is not set
[   19.038777] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[   19.046230] Freeing unused kernel memory: 1428K (ffffffffadd1b000 -
ffffffffade80000)
[   19.054081] Write protecting the kernel read-only data: 12288k
[   19.062742] Freeing unused kernel memory: 780K (ffff88002d73d000 -
ffff88002d800000)
[   19.073229] Freeing unused kernel memory: 896K (ffff88002db20000 -
ffff88002dc00000)
[   19.084013] systemd[1]: systemd 208 running in system mode. (+PAM
+LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[   19.096625] systemd[1]: Running in initial RAM disk.

Welcome to Fedora 20 (Heisenbug) dracut-038-14.git20140724.fc22
(Initramfs)!

[   19.110372] systemd[1]: Set hostname to <dhcp-16-105.nay.redhat.com>.
[   19.117490] random: systemd urandom read with 5 bits of entropy
available
[   19.152961] systemd[1]: Expecting device
dev-disk-by\x2duuid-3429ef24\x2d72c1\x2d435f\x2da55b\x2d15132ef30516.device...
         Expecting device
dev-disk-by\x2duuid-3429ef24\x2d72c...30516.device...
[   19.172364] systemd[1]: Expecting device
dev-disk-by\x2duuid-06476532\x2d3675\x2d40ce\x2d98dd\x2df0b6564e5455.device...
         Expecting device
dev-disk-by\x2duuid-06476532\x2d367...e5455.device...
[   19.191387] systemd[1]: Expecting device
dev-disk-by\x2duuid-f170152e\x2dde83\x2d46ee\x2d9546\x2d8ccd53f9753b.device...
         Expecting device
dev-disk-by\x2duuid-f170152e\x2dde8...9753b.device...
[   19.210406] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[   19.219412] systemd[1]: Created slice -.slice.
[   19.223887] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[   19.234432] systemd[1]: Created slice System Slice.
[   19.239348] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[   19.247440] systemd[1]: Reached target Slices.
[   19.251914] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[   19.260456] systemd[1]: Reached target Timers.
[   19.264945] systemd[1]: Starting Dispatch Password Requests to
Console Directory Watch.
[   19.273011] systemd[1]: Started Dispatch Password Requests to Console
Directory Watch.
[   19.280961] systemd[1]: Starting Paths.
[  OK  ] Reached target Paths.
[   19.289487] systemd[1]: Reached target Paths.
[   19.293873] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[   19.303500] systemd[1]: Listening on Journal Socket.
[   19.308541] systemd[1]: Started dracut ask for additional cmdline
parameters.
[   19.315797] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[   19.325786] systemd[1]: Starting Apply Kernel Variables...
         Starting Apply Kernel Variables...
[   19.339701] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[   19.357521] systemd[1]: Started Journal Service.
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
[   19.486226] systemd-udevd[208]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Basic System.
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
[   19.602503] scsi host6: ata_generic
[   19.611919] isci: Intel(R) C600 SAS Controller Driver - version 1.2.0
[   19.618384] scsi host7: ata_generic
[   19.622795] ata7: PATA max UDMA/100 cmd 0xf0b0 ctl 0xf0a0 bmdma
0xf070 irq 18
[   19.629950] ata8: PATA max UDMA/100 cmd 0xf090 ctl 0xf080 bmdma
0xf078 irq 18
[   19.641788] isci 0000:02:00.0: driver configured for rev: 5 silicon
[   19.655815] isci 0000:02:00.0: OEM SAS parameters (version: 1.3)
loaded (firmware)
[   19.677821] isci 0000:02:00.0: SCU controller 0: phy 3-0 cables:
{short, short, short, short}
[   19.695100] scsi host8: isci
[   19.707158] dmar: DRHD: handling fault status reg 202
[   19.712220] dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr
ffe62000 
[   19.712220] DMAR:[fault reason 03] Invalid context entry
[   19.729420] random: nonblocking pool is initialized
[   32.664118] dmar: DRHD: handling fault status reg 302
[   32.669177] dmar: DMAR:[DMA Write] Request device [00:19.0] fault
addr fffdf000 
[   32.669177] DMAR:[fault reason 03] Invalid context entry
[   33.129634] pps_core: LinuxPPS API ver. 1 registered
[   33.134635] pps_core: Software ver. 5.3.6 - Copyright 2005-2007
Rodolfo Giometti <giometti@linux.it>
[   36.529376] dmar: DRHD: handling fault status reg 402
[   36.534434] dmar: DMAR:[DMA Write] Request device [00:19.0] fault
addr fffde000 
[   36.534434] DMAR:[fault reason 03] Invalid context entry
[   42.796282] PTP clock support registered
[   45.991802] dmar: DRHD: handling fault status reg 502
[   45.996862] dmar: DMAR:[DMA Write] Request device [00:19.0] fault
addr fffdd000 
[   45.996862] DMAR:[fault reason 03] Invalid context entry
[   73.057617] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 23s!
[systemd-udevd:211]
[   73.065458] Modules linked in: ptp pps_core isci libsas
scsi_transport_sas ata_generic pata_acpi
[   73.074414] CPU: 0 PID: 211 Comm: systemd-udevd Not tainted
3.18.0-rc1+ #76
[   73.081391] Hardware name: Hewlett-Packard HP Z420 Workstation/1589,
BIOS J61 v01.02 03/09/2012
[   73.090099] task: ffff88002c9d9bc0 ti: ffff88002c9d4000 task.ti:
ffff88002c9d4000
[   73.097596] RIP: 0010:[<ffffffffad326265>]  [<ffffffffad326265>]
sha256_transform+0x785/0x1c40
[   73.106246] RSP: 0000:ffff88002c9d7ad8  EFLAGS: 00000a02
[   73.111569] RAX: 00000000d9feb2d0 RBX: ffff88002ca0d840 RCX:
0000000049cd83f9
[   73.118718] RDX: ffff88002c9d7ae0 RSI: 000000006e6e48c5 RDI:
ffff88002ca0d9f8
[   73.125866] RBP: ffff88002c9d7c18 R08: 000000006e7e58c4 R09:
000000003e2e6c85
[   73.133005] R10: 000000004db92e92 R11: 0000000040429e07 R12:
0000000092f09b68
[   73.140152] R13: ffffffffad3810e4 R14: ffffffffad0bf94c R15:
ffff88002c9d7a78
[   73.147299] FS:  00007fe467c6b880(0000) GS:ffff88002ec00000(0000)
knlGS:0000000000000000
[   73.155395] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.161143] CR2: 00007f8f51c67000 CR3: 000000002c9ba000 CR4:
00000000000407b0
[   73.168287] Stack:
[   73.170307]  ffff88002c9d7fd8 0000000029000000 01000a0035150000
00000000f00e0000
[   73.177777]  000000001f000000 01000a0044150000 00000000200f0000
0000000024000000
[   73.185245]  01000a0053150000 6b17c7e74a14f0a8 dff7871b1e0aaa88
8a4c71a4f0208e6e
[   73.192715] Call Trace:
[   73.195168]  [<ffffffffad32777b>] crypto_sha256_update+0x5b/0xd0
[   73.201187]  [<ffffffffad31f3a8>] crypto_shash_update+0x38/0x100
[   73.207204]  [<ffffffffad31f537>] shash_finup_unaligned+0x17/0x30
[   73.213307]  [<ffffffffad31f56f>] crypto_shash_finup+0x1f/0x40
[   73.219151]  [<ffffffffad109bd8>] mod_verify_sig+0x288/0x440
[   73.224817]  [<ffffffffad10692d>] load_module+0x7d/0x2730
[   73.230230]  [<ffffffffad104cbe>] ?
copy_module_from_fd.isra.47+0x5e/0x180
[   73.237111]  [<ffffffffad104d89>] ?
copy_module_from_fd.isra.47+0x129/0x180
[   73.244085]  [<ffffffffad2f494b>] ? cap_capable+0x5b/0x80
[   73.249487]  [<ffffffffad109196>] SyS_finit_module+0xa6/0xd0
[   73.255155]  [<ffffffffad734ca9>] system_call_fastpath+0x12/0x17
[   73.261167] Code: 44 09 c6 41 89 ca 44 21 ce 45 21 c2 41 c1 cf 02 44
09 d6 41 89 ca 44 03 ad 08 ff ff ff 41 c1 ca 0d 45 31 fa 41 89 cf 41 c1
cf 16 <45> 31 fa 44 0 
[   74.457162] sched: RT throttling activated
[   85.536366] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[   85.542209] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[   86.420339] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec)
set to dynamic conservative mode
[   97.994089] e1000e 0000:00:19.0 eth0: registered PHC clock
[   98.002096] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1)
80:c1:6e:f8:9f:92
[   98.012106] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network
Connection
[   98.132239] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No:
0100FF-0FF
