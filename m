Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaBLQvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 11:51:11 -0500
Received: from mail1.start.ca ([64.140.120.57]:33154 "EHLO mail1.start.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbaBLQvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 11:51:08 -0500
X-Greylist: delayed 1062 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Feb 2014 11:51:07 EST
Message-ID: <52FBA234.8080509@start.ca>
Date: Wed, 12 Feb 2014 11:32:52 -0500
From: Mark Lord <kernel@start.ca>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: 3.13.2: intel_iommu=on WARN_ONCE()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New install: Haswell i7-4770 CPU, Q87 chipset.

When I enable intel_iommu=on at boot, it clutters the log with this WARN_ONCE():


...
[0.313282] Freeing initrd memory: 5092K (ffff880037af7000 - ffff880037ff0000)
[0.313603] DMAR: No ATSR found
[0.313774] IOMMU 0 0xfed90000: using Queued invalidation
[0.313935] IOMMU: Setting RMRR:
[0.314098] IOMMU: Setting identity map for device 0000:00:1d.0 [0xcec5e000 - 0xcec6afff]
[0.314419] IOMMU: Setting identity map for device 0000:00:1a.0 [0xcec5e000 - 0xcec6afff]
[0.314740] IOMMU: Setting identity map for device 0000:00:14.0 [0xcec5e000 - 0xcec6afff]
[0.315052] IOMMU: Prepare 0-16MiB unity mapping for LPC
[0.315216] IOMMU: Setting identity map for device 0000:00:1f.0 [0x0 - 0xffffff]
[0.315530] PCI-DMA: Intel(R) Virtualization Technology for Directed I/O
[0.315734] ------------[ cut here ]------------
[0.315897] WARNING: CPU: 0 PID: 1 at drivers/pci/search.c:46 pci_find_upstream_pcie_bridge+0x5d/0x70()
[0.316201] Modules linked in:
[0.316203] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.13.2 #1
[0.316204] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./Q87M-D2H, BIOS F7
01/17/2014
[0.316205]  0000000000000009 ffffffff814f7908 0000000000000000 ffffffff8103c141
[0.316206]  ffff88041b1f2098 ffff88041b1f2000 ffff88041b1f2098 1fffffffffffffff
[0.316208]  ffff88041b805720 ffffffff812b31bd ffffffff8143c683 ffff88041b1f2098
[0.316209] Call Trace:
[0.316213]  [<ffffffff814f7908>] ? dump_stack+0x49/0x6a
[0.316216]  [<ffffffff8103c141>] ? warn_slowpath_common+0x81/0xb0
[0.316217]  [<ffffffff812b31bd>] ? pci_find_upstream_pcie_bridge+0x5d/0x70
[0.316219]  [<ffffffff8143c683>] ? intel_iommu_add_device+0x43/0x210
[0.316221]  [<ffffffff81439940>] ? bus_set_iommu+0x60/0x60
[0.316222]  [<ffffffff8143996b>] ? add_iommu_group+0x2b/0x60
[0.316224]  [<ffffffff8134a90d>] ? bus_for_each_dev+0x4d/0x80
[0.316225]  [<ffffffff81439929>] ? bus_set_iommu+0x49/0x60
[0.316228]  [<ffffffff81ad8353>] ? intel_iommu_init+0xa04/0xb23
[0.316230]  [<ffffffff81ab1b5b>] ? memblock_find_dma_reserve+0x148/0x148
[0.316231]  [<ffffffff81ab1b69>] ? pci_iommu_init+0xe/0x37
[0.316233]  [<ffffffff81000352>] ? do_one_initcall+0x122/0x170
[0.316235]  [<ffffffff81057b0e>] ? parse_args+0x1fe/0x340
[0.316237]  [<ffffffff81aadf07>] ? kernel_init_freeable+0x145/0x1d3
[0.316238]  [<ffffffff81aad746>] ? loglevel+0x31/0x31
[0.316240]  [<ffffffff814f07c0>] ? rest_init+0x80/0x80
[0.316241]  [<ffffffff814f07c5>] ? kernel_init+0x5/0x120
[0.316243]  [<ffffffff814fd7bc>] ? ret_from_fork+0x7c/0xb0
[0.316244]  [<ffffffff814f07c0>] ? rest_init+0x80/0x80
[0.316247] ---[ end trace 860cc01b6444c516 ]---
...

00:00.0 Host bridge: Intel Corporation Haswell DRAM Controller (rev 06)
00:01.0 PCI bridge: Intel Corporation Haswell PCI Express x16 Controller (rev 06)
00:14.0 USB controller: Intel Corporation Lynx Point USB xHCI Host Controller (rev 04)
00:16.0 Communication controller: Intel Corporation Lynx Point MEI Controller #1 (rev 04)
00:16.3 Serial controller: Intel Corporation Lynx Point KT Controller (rev 04)
00:19.0 Ethernet controller: Intel Corporation Ethernet Connection I217-LM (rev 04)
00:1a.0 USB controller: Intel Corporation Lynx Point USB Enhanced Host Controller #2 (rev 04)
00:1b.0 Audio device: Intel Corporation Lynx Point High Definition Audio Controller (rev 04)
00:1c.0 PCI bridge: Intel Corporation Lynx Point PCI Express Root Port #1 (rev d4)
00:1c.1 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d4)
00:1c.4 PCI bridge: Intel Corporation Lynx Point PCI Express Root Port #5 (rev d4)
00:1d.0 USB controller: Intel Corporation Lynx Point USB Enhanced Host Controller #1 (rev 04)
00:1f.0 ISA bridge: Intel Corporation Lynx Point LPC Controller (rev 04)
00:1f.2 SATA controller: Intel Corporation Lynx Point 6-port SATA Controller 1 [AHCI mode] (rev 04)
00:1f.3 SMBus: Intel Corporation Lynx Point SMBus Controller (rev 04)
01:00.0 VGA compatible controller: NVIDIA Corporation Device 1284 (rev a1)
01:00.1 Audio device: NVIDIA Corporation Device 0e0f (rev a1)
03:00.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 41)
04:00.0 Multimedia video controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio
Decoder (rev 05)
04:00.1 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder
[Audio Port] (rev 05)
04:00.2 Multimedia controller: Conexant Systems, Inc. CX23880/1/2/3 PCI Video and Audio Decoder
[MPEG Port] (rev 05)
05:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA Raid II Controller (rev 01)


processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3899.375
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3894.859
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3888.218
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3899.906
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 6
initial apicid	: 6
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 4
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3897.117
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 0
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 5
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3903.492
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 1
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 6
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3903.359
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 5
initial apicid	: 5
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:

processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 60
model name	: Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz
stepping	: 3
microcode	: 0x10
cpu MHz		: 3906.679
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 3
cpu cores	: 4
apicid		: 7
initial apicid	: 7
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi
mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts
rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx
est tm2 ssse3 fma cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave
avx f16c rdrand lahf_lm abm ida arat xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid
fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips	: 6784.91
clflush size	: 64
cache_alignment	: 64
address sizes	: 39 bits physical, 48 bits virtual
power management:
