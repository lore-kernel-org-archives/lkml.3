Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbbAIWkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:40:16 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:35962 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbbAIWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:40:10 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: SATA link power management issues
Date: Fri, 09 Jan 2015 23:40:05 +0100
Message-ID: <3692597.CKLdqSheWM@xps13>
In-Reply-To: <20150109220018.GH2785@htj.dyndns.org>
References: <3352987.ugV1Ipy7Z5@xps13> <20150109220018.GH2785@htj.dyndns.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 17:00:18 Tejun Heo wrote:
> Hello, Gabriele.
> 
> On Thu, Jan 08, 2015 at 08:37:35PM +0100, Gabriele Mazzotta wrote:
> > I'm having some problems with the link_power_management_policy on my
> > Dell XPS13 9333.
> > Changing policy from min_power or medium_power to max_performance
> > causes the following errors:
> > 
> > [ 3955.667086] ahci 0000:00:1f.2: port does not support device sleep
> > [ 3958.257106] ata3.00: exception Emask 0x10 SAct 0x40 SErr 0x50000 action 0xe frozen
> > [ 3958.257110] ata3.00: irq_stat 0x00400000, PHY RDY changed
> > [ 3958.257113] ata3: SError: { PHYRdyChg CommWake }
> > [ 3958.257116] ata3.00: failed command: READ FPDMA QUEUED
> > [ 3958.257120] ata3.00: cmd 60/00:30:c8:60:10/01:00:1d:00:00/40 tag 6 ncq 131072 in
> >          res 40/00:34:c8:60:10/00:00:1d:00:00/40 Emask 0x10 (ATA bus error)
> > [ 3958.257122] ata3.00: status: { DRDY }
> > [ 3958.257126] ata3: hard resetting link
> > [ 3958.981727] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> > [ 3958.984994] ata3.00: configured for UDMA/133
> > [ 3958.997686] ahci 0000:00:1f.2: port does not support device sleep
> 
> Ah, it actually happens.
> 
> > [ 3958.997698] ata3: EH complete
> > 
> > Sometimes I get "failed command: WRITE FPDMA QUEUED" multiple times.
> > 
> > As far as I know, this had always happened and it was confirmed
> > by another user. I've also come across some logs of the same system
> > and saw the same errors here and there, so it shouldn't be a problem
> > of my laptop in particular.
> > 
> > What I find interesting is that transitions from min_power to
> > medium_power and vice versa do not cause these errors. There are only
> > problem switching from min_power and medium_power to max_performance.
> > Doing the opposite, i.e. from max_performance to min_power or
> > medium_power, seems to work fine.
> > 
> > As a consequence of these continuous errors, the speed is reduced
> > from 6.0 Gbps to 1.5 Gbps.
> 
> Always?  Or does it sometimes get lucky and stabilize at a higher
> speed?

Let's say I need to change the policy a few times before 1.5 Gbps are
reached and the speed is always lowered to 3.0 Gbps first.
I've never noticed any different trend, but I haven't observed this
problem enough. The policy is normally changed when I plug and unplug
my laptop, so not frequently enough to be a 100% sure.

I could do some tests though, all I need is to do is change the policy
a bunch of times.

> > I'd prefer not to disable LPM as it saves a considerable amount of
> > power when I'm using the battery. For this reason I'm currently using
> > medium_power and min_power only to prevent errors.
> > 
> > Is it normal that these errors appears only when I switch to
> > max_performance? Was something similar observed on other systems?
> 
> It's not normal.  It definitely doesn't happen with all devices.  I
> guess it could be a quirk from the device side.  What's on the other
> side of the connector?  Can you post the full kernel log after such
> incidence?

There's connected an SSD. Let me know if you need more information than
those in the dmesg here below.

"setting max_performance" and "setting min_power" were added by me.


[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.19.0-rc2+ (root@xps13) (gcc version 4.9.2 (Debian 4.9.2-10) ) #8 SMP Thu Jan 8 19:37:54 CET 2015
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-rc2+ root=/dev/sda6 ro quiet rootfstype=ext4 resume=/dev/sda3 possible_cpus=4
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009cfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x00000000000bffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x0000000081afcfff] usable
[    0.000000] BIOS-e820: [mem 0x0000000081afd000-0x0000000081cfefff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000081cff000-0x00000000dadb6fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dadb7000-0x00000000dafb6fff] type 20
[    0.000000] BIOS-e820: [mem 0x00000000dafb7000-0x00000000dceeefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dceef000-0x00000000dcf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dcf9f000-0x00000000dcffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000dcfff000-0x00000000dcffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dd000000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f80f8000-0x00000000f80f8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe101000-0x00000000fe112fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000021f5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.31 by Phoenix Technologies Ltd.
[    0.000000] efi:  ACPI=0xdcffe000  ACPI 2.0=0xdcffe014  SMBIOS=0xdcc45000 
[    0.000000] efi: mem00: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000000000-0x0000000000058000) (0MB)
[    0.000000] efi: mem01: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000058000-0x0000000000059000) (0MB)
[    0.000000] efi: mem02: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000059000-0x000000000009d000) (0MB)
[    0.000000] efi: mem03: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000009d000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem04: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x00000000000e0000-0x0000000000100000) (0MB)
[    0.000000] efi: mem05: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000000100000-0x000000000133b000) (18MB)
[    0.000000] efi: mem06: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000133b000-0x0000000001400000) (0MB)
[    0.000000] efi: mem07: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000001400000-0x000000000263b000) (18MB)
[    0.000000] efi: mem08: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000000263b000-0x0000000049fce000) (1145MB)
[    0.000000] efi: mem09: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000049fce000-0x000000007fa57000) (858MB)
[    0.000000] efi: mem10: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007fa57000-0x000000007fa77000) (0MB)
[    0.000000] efi: mem11: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x000000007fa77000-0x0000000081ae6000) (32MB)
[    0.000000] efi: mem12: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000081ae6000-0x0000000081afd000) (0MB)
[    0.000000] efi: mem13: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000081afd000-0x0000000081cff000) (2MB)
[    0.000000] efi: mem14: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000081cff000-0x0000000082a47000) (13MB)
[    0.000000] efi: mem15: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000082a47000-0x00000000c5af4000) (1072MB)
[    0.000000] efi: mem16: [Loader Code        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c5af4000-0x00000000c5b12000) (0MB)
[    0.000000] efi: mem17: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000c5b12000-0x00000000cd648000) (123MB)
[    0.000000] efi: mem18: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cd648000-0x00000000cd649000) (0MB)
[    0.000000] efi: mem19: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cd649000-0x00000000cd65a000) (0MB)
[    0.000000] efi: mem20: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cd65a000-0x00000000cf183000) (27MB)
[    0.000000] efi: mem21: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cf183000-0x00000000cf184000) (0MB)
[    0.000000] efi: mem22: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cf184000-0x00000000cf69d000) (5MB)
[    0.000000] efi: mem23: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cf69d000-0x00000000cf6b0000) (0MB)
[    0.000000] efi: mem24: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000cf6b0000-0x00000000d045e000) (13MB)
[    0.000000] efi: mem25: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000d045e000-0x00000000da8b2000) (164MB)
[    0.000000] efi: mem26: [Loader Data        |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000da8b2000-0x00000000da8bb000) (0MB)
[    0.000000] efi: mem27: [Boot Code          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000da8bb000-0x00000000dadb7000) (4MB)
[    0.000000] efi: mem28: [Runtime Code       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000dadb7000-0x00000000dafb7000) (2MB)
[    0.000000] efi: mem29: [Runtime Data       |RUN|  |  |  |   |WB|WT|WC|UC] range=[0x00000000dafb7000-0x00000000dc8d7000) (25MB)
[    0.000000] efi: mem30: [Reserved           |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dc8d7000-0x00000000dceef000) (6MB)
[    0.000000] efi: mem31: [ACPI Memory NVS    |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dceef000-0x00000000dcf9f000) (0MB)
[    0.000000] efi: mem32: [ACPI Reclaim Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dcf9f000-0x00000000dcfff000) (0MB)
[    0.000000] efi: mem33: [Boot Data          |   |  |  |  |   |WB|WT|WC|UC] range=[0x00000000dcfff000-0x00000000dd000000) (0MB)
[    0.000000] efi: mem34: [Conventional Memory|   |  |  |  |   |WB|WT|WC|UC] range=[0x0000000100000000-0x000000021f600000) (4598MB)
[    0.000000] efi: mem35: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x00000000000a0000-0x00000000000c0000) (0MB)
[    0.000000] efi: mem36: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x00000000dd000000-0x00000000dfa00000) (42MB)
[    0.000000] efi: mem37: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000f80f8000-0x00000000f80f9000) (0MB)
[    0.000000] efi: mem38: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x00000000fe101000-0x00000000fe113000) (0MB)
[    0.000000] efi: mem39: [Memory Mapped I/O  |RUN|  |  |  |   |  |  |  |UC] range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem40: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000) (0MB)
[    0.000000] efi: mem41: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000) (0MB)
[    0.000000] efi: mem42: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000) (0MB)
[    0.000000] efi: mem43: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000) (0MB)
[    0.000000] efi: mem44: [Reserved           |   |  |  |  |   |  |  |  |  ] range=[0x0000000000000000-0x0000000000000000) (0MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: Dell Inc. XPS13 9333/0GFTRT, BIOS A06 11/07/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x21f600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask 7FE0000000 uncachable
[    0.000000]   1 base 00DE000000 mask 7FFE000000 uncachable
[    0.000000]   2 base 00DD000000 mask 7FFF000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] PAT configuration [0-7]: WB  WC  UC- UC  WB  WC  UC- UC  
[    0.000000] e820: last_pfn = 0xdd000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x022d5000, 0x022d5fff] PGTABLE
[    0.000000] BRK [0x022d6000, 0x022d6fff] PGTABLE
[    0.000000] BRK [0x022d7000, 0x022d7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21f400000-0x21f5fffff]
[    0.000000]  [mem 0x21f400000-0x21f5fffff] page 2M
[    0.000000] BRK [0x022d8000, 0x022d8fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x21c000000-0x21f3fffff]
[    0.000000]  [mem 0x21c000000-0x21f3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x200000000-0x21bffffff]
[    0.000000]  [mem 0x200000000-0x21bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x81afcfff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x7fffffff] page 1G
[    0.000000]  [mem 0x80000000-0x819fffff] page 2M
[    0.000000]  [mem 0x81a00000-0x81afcfff] page 4k
[    0.000000] init_memory_mapping: [mem 0x81cff000-0xdadb6fff]
[    0.000000]  [mem 0x81cff000-0x81dfffff] page 4k
[    0.000000]  [mem 0x81e00000-0xdabfffff] page 2M
[    0.000000]  [mem 0xdac00000-0xdadb6fff] page 4k
[    0.000000] BRK [0x022d9000, 0x022d9fff] PGTABLE
[    0.000000] BRK [0x022da000, 0x022dafff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdcfff000-0xdcffffff]
[    0.000000]  [mem 0xdcfff000-0xdcffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x1ffffffff]
[    0.000000]  [mem 0x100000000-0x1ffffffff] page 1G
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000DCFFE014 000024 (v02 DELL  )
[    0.000000] ACPI: XSDT 0x00000000DCFFE170 0000C4 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: FACP 0x00000000DCFFB000 00010C (v05 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: DSDT 0x00000000DCFE6000 010640 (v02 DELL   HSW-LPT  00000000 INTL 20120711)
[    0.000000] ACPI: FACS 0x00000000DCF9C000 000040
[    0.000000] ACPI: ASF! 0x00000000DCFFD000 0000A5 (v32 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: HPET 0x00000000DCFFA000 000038 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: LPIT 0x00000000DCFF9000 000094 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: APIC 0x00000000DCFF8000 000098 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: MCFG 0x00000000DCFF7000 00003C (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: SSDT 0x00000000DCFE5000 000228 (v01 DELL   sensrhub 00000000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFE2000 002028 (v01 DELL   PtidDevc 00001000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFE1000 000539 (v01 DELL   Cpu0Ist  00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFE0000 000AD8 (v01 DELL   CpuPm    00003000 INTL 20120711)
[    0.000000] ACPI: SSDT 0x00000000DCFDC000 003688 (v01 DELL   SaSsdt   00003000 INTL 20120711)
[    0.000000] ACPI: UEFI 0x00000000DCFDB000 000042 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: MSDM 0x00000000DCF77000 000055 (v03 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: BATB 0x00000000DCFDA000 000046 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: FPDT 0x00000000DCFD9000 000064 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: SLIC 0x00000000DCFD8000 000176 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: UEFI 0x00000000DCFD7000 0002A6 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: SSDT 0x00000000DCFD6000 0000D0 (v01 DELL   IffsAsl  00003000 INTL 20120711)
[    0.000000] ACPI: BGRT 0x00000000DCFD5000 000038 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: CSRT 0x00000000DCFD4000 0000C4 (v01 DELL   QA09     00000002 LOHR 00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000021f5fffff]
[    0.000000] NODE_DATA(0) allocated [mem 0x21f5f8000-0x21f5fbfff]
[    0.000000]  [ffffea0000000000-ffffea00087fffff] PMD -> [ffff880216c00000-ffff88021ebfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x21f5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x00057fff]
[    0.000000]   node   0: [mem 0x00059000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x81afcfff]
[    0.000000]   node   0: [mem 0x81cff000-0xdadb6fff]
[    0.000000]   node   0: [mem 0xdcfff000-0xdcffffff]
[    0.000000]   node   0: [mem 0x100000000-0x21f5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00001000-0x21f5fffff]
[    0.000000] On node 0 totalpages: 2072913
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 22 pages reserved
[    0.000000]   DMA zone: 3995 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13935 pages used for memmap
[    0.000000]   DMA32 zone: 891830 pages, LIFO batch:31
[    0.000000]   Normal zone: 18392 pages used for memmap
[    0.000000]   Normal zone: 1177088 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdda00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
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
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-39
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x000bffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000c0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x81afd000-0x81cfefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdadb7000-0xdafb6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdafb7000-0xdceeefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdceef000-0xdcf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xdcf9f000-0xdcffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdd000000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf80f7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f8000-0xf80f8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xf80f9000-0xfe100fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe101000-0xfe112fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe113000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xf80f7fff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff88021f200000 s85824 r8192 d28864 u524288
[    0.000000] pcpu-alloc: s85824 r8192 d28864 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 2040500
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.19.0-rc2+ root=/dev/sda6 ro quiet rootfstype=ext4 resume=/dev/sda3 possible_cpus=4
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340 using standard form
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 8012492K/8291652K available (6672K kernel code, 847K rwdata, 2312K rodata, 1224K init, 792K bss, 279160K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:728 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2394.309 MHz processor
[    0.000037] Calibrating delay loop (skipped), value calculated using timer frequency.. 4788.61 BogoMIPS (lpj=9577236)
[    0.000039] pid_max: default: 32768 minimum: 301
[    0.000045] ACPI: Core revision 20141107
[    0.018609] ACPI: All ACPI Tables successfully acquired
[    0.055353] Security Framework initialized
[    0.055360] AppArmor: AppArmor disabled by boot time parameter
[    0.055361] Yama: becoming mindful.
[    0.055963] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.057399] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.057975] Mount-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.057987] Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.058207] Initializing cgroup subsys devices
[    0.058210] Initializing cgroup subsys freezer
[    0.058213] Initializing cgroup subsys net_cls
[    0.058215] Initializing cgroup subsys blkio
[    0.058217] Initializing cgroup subsys bfqio
[    0.058219] Initializing cgroup subsys net_prio
[    0.058246] CPU: Physical Processor ID: 0
[    0.058247] CPU: Processor Core ID: 0
[    0.058252] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.059439] mce: CPU supports 7 MCE banks
[    0.059453] CPU0: Thermal monitoring enabled (TM1)
[    0.059465] Last level iTLB entries: 4KB 1024, 2MB 1024, 4MB 1024
Last level dTLB entries: 4KB 1024, 2MB 1024, 4MB 1024, 1GB 4
[    0.059619] Freeing SMP alternatives memory: 24K (ffffffff81e07000 - ffffffff81e0d000)
[    0.060625] Ignoring BGRT: invalid status 0 (expected 1)
[    0.062825] ftrace: allocating 25706 entries in 101 pages
[    0.075439] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.115154] smpboot: CPU0: Intel(R) Core(TM) i7-4500U CPU @ 1.80GHz (fam: 06, model: 45, stepping: 01)
[    0.115163] TSC deadline timer enabled
[    0.115187] Performance Events: PEBS fmt2+, 16-deep LBR, Haswell events, full-width counters, Intel PMU driver.
[    0.115212] ... version:                3
[    0.115213] ... bit width:              48
[    0.115214] ... generic registers:      4
[    0.115215] ... value mask:             0000ffffffffffff
[    0.115216] ... max period:             0000ffffffffffff
[    0.115217] ... fixed-purpose events:   3
[    0.115218] ... event mask:             000000070000000f
[    0.115479] x86: Booting SMP configuration:
[    0.115481] .... node  #0, CPUs:      #1
[    0.130070] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.130150]  #2 #3
[    0.158916] x86: Booted up 1 node, 4 CPUs
[    0.158919] smpboot: Total of 4 processors activated (19154.47 BogoMIPS)
[    0.164367] devtmpfs: initialized
[    0.167096] PM: Registering ACPI NVS region [mem 0xdceef000-0xdcf9efff] (720896 bytes)
[    0.167273] pinctrl core: initialized pinctrl subsystem
[    0.167378] NET: Registered protocol family 16
[    0.176237] cpuidle: using governor ladder
[    0.192246] cpuidle: using governor menu
[    0.192321] ACPI: bus type PCI registered
[    0.192323] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.192394] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.192397] PCI: not using MMCONFIG
[    0.192398] PCI: Using configuration type 1 for base access
[    0.192518] dmi type 0xB1 record - unknown flag
[    0.204611] ACPI: Added _OSI(Module Device)
[    0.204613] ACPI: Added _OSI(Processor Device)
[    0.204615] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.204616] ACPI: Added _OSI(Processor Aggregator Device)
[    0.209431] ACPI: Executed 1 blocks of module-level executable AML code
[    0.212861] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.213938] ACPI: Dynamic OEM Table Load:
[    0.213950] ACPI: SSDT 0xFFFF880215416000 0003D3 (v01 PmRef  Cpu0Cst  00003001 INTL 20120711)
[    0.214806] ACPI: Dynamic OEM Table Load:
[    0.214816] ACPI: SSDT 0xFFFF88021543A000 0005AA (v01 PmRef  ApIst    00003000 INTL 20120711)
[    0.215717] ACPI: Dynamic OEM Table Load:
[    0.215726] ACPI: SSDT 0xFFFF880215494200 000119 (v01 PmRef  ApCst    00003000 INTL 20120711)
[    0.219609] ACPI: Interpreter enabled
[    0.219628] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20141107/hwxface-580)
[    0.219651] ACPI: (supports S0 S1 S3 S4 S5)
[    0.219652] ACPI: Using IOAPIC for interrupt routing
[    0.219675] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.220194] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.220311] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.232852] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    0.232859] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.232996] \_SB_.PCI0:_OSC invalid UUID
[    0.232997] _OSC request data:1 1f 0 
[    0.233001] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.233540] PCI host bridge to bus 0000:00
[    0.233543] pci_bus 0000:00: root bus resource [bus 00-3e]
[    0.233545] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.233547] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.233549] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.233551] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000c3fff]
[    0.233552] pci_bus 0000:00: root bus resource [mem 0x000c4000-0x000c7fff]
[    0.233554] pci_bus 0000:00: root bus resource [mem 0x000c8000-0x000cbfff]
[    0.233556] pci_bus 0000:00: root bus resource [mem 0x000cc000-0x000cffff]
[    0.233557] pci_bus 0000:00: root bus resource [mem 0x000d0000-0x000d3fff]
[    0.233559] pci_bus 0000:00: root bus resource [mem 0x000d4000-0x000d7fff]
[    0.233561] pci_bus 0000:00: root bus resource [mem 0x000d8000-0x000dbfff]
[    0.233562] pci_bus 0000:00: root bus resource [mem 0x000dc000-0x000dffff]
[    0.233564] pci_bus 0000:00: root bus resource [mem 0x000e0000-0x000e3fff]
[    0.233565] pci_bus 0000:00: root bus resource [mem 0x000e4000-0x000e7fff]
[    0.233567] pci_bus 0000:00: root bus resource [mem 0x000e8000-0x000ebfff]
[    0.233569] pci_bus 0000:00: root bus resource [mem 0x000ec000-0x000effff]
[    0.233570] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
[    0.233580] pci 0000:00:00.0: [8086:0a04] type 00 class 0x060000
[    0.233778] pci 0000:00:02.0: [8086:0a16] type 00 class 0x030000
[    0.233792] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
[    0.233800] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.233806] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
[    0.233989] pci 0000:00:03.0: [8086:0a0c] type 00 class 0x040300
[    0.233999] pci 0000:00:03.0: reg 0x10: [mem 0xf0510000-0xf0513fff 64bit]
[    0.234210] pci 0000:00:14.0: [8086:9c31] type 00 class 0x0c0330
[    0.234229] pci 0000:00:14.0: reg 0x10: [mem 0xf0500000-0xf050ffff 64bit]
[    0.234294] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.234424] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.234465] pci 0000:00:16.0: [8086:9c3a] type 00 class 0x078000
[    0.234486] pci 0000:00:16.0: reg 0x10: [mem 0xf0519000-0xf051901f 64bit]
[    0.234562] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.234738] pci 0000:00:1b.0: [8086:9c20] type 00 class 0x040300
[    0.234753] pci 0000:00:1b.0: reg 0x10: [mem 0xf0514000-0xf0517fff 64bit]
[    0.234825] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.234956] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.234999] pci 0000:00:1c.0: [8086:9c10] type 01 class 0x060400
[    0.235083] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.235218] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.235261] pci 0000:00:1c.2: [8086:9c14] type 01 class 0x060400
[    0.235348] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.235484] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.235531] pci 0000:00:1d.0: [8086:9c26] type 00 class 0x0c0320
[    0.235552] pci 0000:00:1d.0: reg 0x10: [mem 0xf051d000-0xf051d3ff]
[    0.235649] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.235796] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.235837] pci 0000:00:1f.0: [8086:9c43] type 00 class 0x060100
[    0.236112] pci 0000:00:1f.2: [8086:9c03] type 00 class 0x010601
[    0.236128] pci 0000:00:1f.2: reg 0x10: [io  0x3088-0x308f]
[    0.236135] pci 0000:00:1f.2: reg 0x14: [io  0x3094-0x3097]
[    0.236143] pci 0000:00:1f.2: reg 0x18: [io  0x3080-0x3087]
[    0.236150] pci 0000:00:1f.2: reg 0x1c: [io  0x3090-0x3093]
[    0.236157] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
[    0.236165] pci 0000:00:1f.2: reg 0x24: [mem 0xf051c000-0xf051c7ff]
[    0.236206] pci 0000:00:1f.2: PME# supported from D3hot
[    0.236374] pci 0000:00:1f.3: [8086:9c22] type 00 class 0x0c0500
[    0.236389] pci 0000:00:1f.3: reg 0x10: [mem 0xf0518000-0xf05180ff 64bit]
[    0.236409] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.236651] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.236760] pci 0000:02:00.0: [8086:08b1] type 00 class 0x028000
[    0.236807] pci 0000:02:00.0: reg 0x10: [mem 0xf0400000-0xf0401fff 64bit]
[    0.237018] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.237065] pci 0000:02:00.0: System wakeup disabled by ACPI
[    0.244359] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.244365] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf04fffff]
[    0.245734] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.245788] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.245841] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.245895] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.245946] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.245996] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.246047] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.246097] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 11 12 14 15) *0, disabled.
[    0.246390] ACPI: Enabled 5 GPEs in block 00 to 7F
[    0.246451] ACPI : EC: GPE = 0xa, I/O: command/status = 0x66, data = 0x62
[    0.246588] SCSI subsystem initialized
[    0.246632] libata version 3.00 loaded.
[    0.246729] PCI: Using ACPI for IRQ routing
[    0.248127] PCI: pci_cache_line_size set to 64 bytes
[    0.248191] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.248192] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    0.248194] e820: reserve RAM buffer [mem 0x81afd000-0x83ffffff]
[    0.248195] e820: reserve RAM buffer [mem 0xdadb7000-0xdbffffff]
[    0.248197] e820: reserve RAM buffer [mem 0xdd000000-0xdfffffff]
[    0.248198] e820: reserve RAM buffer [mem 0x21f600000-0x21fffffff]
[    0.248360] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.248366] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.250389] Switched to clocksource hpet
[    0.253406] pnp: PnP ACPI init
[    0.253532] system 00:00: [io  0x0680-0x069f] has been reserved
[    0.253536] system 00:00: [io  0xffff] has been reserved
[    0.253539] system 00:00: [io  0xffff] has been reserved
[    0.253541] system 00:00: [io  0xffff] has been reserved
[    0.253544] system 00:00: [io  0x1800-0x18fe] could not be reserved
[    0.253546] system 00:00: [io  0x164e-0x164f] has been reserved
[    0.253550] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.253599] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.253647] system 00:02: [io  0x1854-0x1857] has been reserved
[    0.253650] system 00:02: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.253691] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.253723] pnp 00:04: Plug and Play ACPI device, IDs SYN0608 PNP0f03 (active)
[    0.253856] system 00:05: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.253859] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    0.253861] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.253864] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.253866] system 00:05: [mem 0xf8000000-0xfbffffff] could not be reserved
[    0.253869] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.253871] system 00:05: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.253874] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.253876] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    0.253879] system 00:05: [mem 0xfee00000-0xfeefffff] has been reserved
[    0.253881] system 00:05: [mem 0xdfa10000-0xdfa1ffff] has been reserved
[    0.253884] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.254221] system 00:06: [mem 0xfe102000-0xfe102fff] has been reserved
[    0.254224] system 00:06: [mem 0xfe104000-0xfe104fff] has been reserved
[    0.254227] system 00:06: [mem 0xfe106000-0xfe106fff] has been reserved
[    0.254229] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.254943] pnp: PnP ACPI: found 7 devices
[    0.261217] pci 0000:00:1c.0: PCI bridge to [bus 01]
[    0.261232] pci 0000:00:1c.2: PCI bridge to [bus 02]
[    0.261237] pci 0000:00:1c.2:   bridge window [mem 0xf0400000-0xf04fffff]
[    0.261246] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.261248] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.261250] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.261252] pci_bus 0000:00: resource 7 [mem 0x000c0000-0x000c3fff]
[    0.261253] pci_bus 0000:00: resource 8 [mem 0x000c4000-0x000c7fff]
[    0.261255] pci_bus 0000:00: resource 9 [mem 0x000c8000-0x000cbfff]
[    0.261257] pci_bus 0000:00: resource 10 [mem 0x000cc000-0x000cffff]
[    0.261258] pci_bus 0000:00: resource 11 [mem 0x000d0000-0x000d3fff]
[    0.261260] pci_bus 0000:00: resource 12 [mem 0x000d4000-0x000d7fff]
[    0.261262] pci_bus 0000:00: resource 13 [mem 0x000d8000-0x000dbfff]
[    0.261263] pci_bus 0000:00: resource 14 [mem 0x000dc000-0x000dffff]
[    0.261265] pci_bus 0000:00: resource 15 [mem 0x000e0000-0x000e3fff]
[    0.261267] pci_bus 0000:00: resource 16 [mem 0x000e4000-0x000e7fff]
[    0.261268] pci_bus 0000:00: resource 17 [mem 0x000e8000-0x000ebfff]
[    0.261270] pci_bus 0000:00: resource 18 [mem 0x000ec000-0x000effff]
[    0.261272] pci_bus 0000:00: resource 19 [mem 0xdfa00000-0xfeafffff]
[    0.261274] pci_bus 0000:02: resource 1 [mem 0xf0400000-0xf04fffff]
[    0.261301] NET: Registered protocol family 2
[    0.261497] TCP established hash table entries: 65536 (order: 7, 524288 bytes)
[    0.261661] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.261791] TCP: Hash tables configured (established 65536 bind 65536)
[    0.261809] TCP: reno registered
[    0.261824] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.261855] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.261911] NET: Registered protocol family 1
[    0.261929] pci 0000:00:02.0: Video device with shadowed ROM
[    0.262007] pci 0000:00:14.0: can't derive routing for PCI INT A
[    0.262009] pci 0000:00:14.0: PCI INT A: no GSI
[    0.262218] PCI: CLS 64 bytes, default 64
[    0.262264] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.262267] software IO TLB [mem 0xd68bb000-0xda8bb000] (64MB) mapped at [ffff8800d68bb000-ffff8800da8bafff]
[    0.262475] RAPL PMU detected, hw unit 2^-14 Joules, API unit is 2^-32 Joules, 4 fixed counters 655360 ms ovfl timer
[    0.262525] microcode: CPU0 sig=0x40651, pf=0x40, revision=0x1c
[    0.262533] microcode: CPU1 sig=0x40651, pf=0x40, revision=0x1c
[    0.262542] microcode: CPU2 sig=0x40651, pf=0x40, revision=0x1c
[    0.262550] microcode: CPU3 sig=0x40651, pf=0x40, revision=0x1c
[    0.262588] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.262852] simple-framebuffer simple-framebuffer.0: framebuffer at 0xe0000000, 0x7e9000 bytes, mapped to 0xffffc90004f00000
[    0.262854] simple-framebuffer simple-framebuffer.0: format=a8r8g8b8, mode=1920x1080x32, linelength=7680
[    0.268213] Console: switching to colour frame buffer device 240x67
[    0.273487] simple-framebuffer simple-framebuffer.0: fb0: simplefb registered!
[    0.273691] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.273720] audit: initializing netlink subsys (disabled)
[    0.273730] audit: type=2000 audit(1420844760.264:1): initialized
[    0.273938] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.275151] VFS: Disk quotas dquot_6.5.2
[    0.275182] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.276104] alg: No test for stdrng (krng)
[    0.276143] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.276181] io scheduler noop registered
[    0.276185] io scheduler deadline registered
[    0.276210] io scheduler cfq registered
[    0.276233] io scheduler bfq registered (default)
[    0.276234] BFQ I/O-scheduler version: v7r7
[    0.276547] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.276566] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.276583] intel_idle: MWAIT substates: 0x11142120
[    0.276584] intel_idle: v0.4 model 0x45
[    0.276585] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.276881] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    0.276885] ACPI: Power Button [PWRB]
[    0.276923] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
[    0.277368] ACPI: Lid Switch [LID0]
[    0.277410] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    0.277413] ACPI: Power Button [PWRF]
[    0.277469] GHES: HEST is not enabled!
[    0.277538] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.278793] Linux agpgart interface v0.103
[    0.278821] [drm] Initialized drm 1.1.0 20060810
[    0.279666] [drm] Memory usable by graphics device = 2048M
[    0.279670] checking generic (e0000000 7e9000) vs hw (e0000000 10000000)
[    0.279671] fb: switching to inteldrmfb from simple
[    0.279687] Console: switching to colour dummy device 80x25
[    0.279851] [drm] Replacing VGA console driver
[    0.306596] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    0.306599] [drm] Driver supports precise vblank timestamp query.
[    0.364283] fbcon: inteldrmfb (fb0) is primary device
[    0.365832] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    0.366003] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
[    0.366026] [drm] Initialized i915 1.6.0 20141121 for 0000:00:02.0 on minor 0
[    0.366120] ahci 0000:00:1f.2: version 3.0
[    0.378572] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 4 ports 6 Gbps 0x4 impl SATA mode
[    0.378575] ahci 0000:00:1f.2: flags: 64bit ncq pm led clo only pio slum part deso sadm sds apst 
[    0.379132] scsi host0: ahci
[    0.379374] scsi host1: ahci
[    0.379632] scsi host2: ahci
[    0.379887] scsi host3: ahci
[    0.379938] ata1: DUMMY
[    0.379938] ata2: DUMMY
[    0.379941] ata3: SATA max UDMA/133 abar m2048@0xf051c000 port 0xf051c200 irq 41
[    0.379942] ata4: DUMMY
[    0.380007] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    0.385398] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.385402] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.385521] mousedev: PS/2 mouse device common for all mice
[    0.385622] rtc_cmos 00:01: RTC can wake from S4
[    0.385775] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    0.385803] rtc_cmos 00:01: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
[    0.385849] Intel P-state driver initializing.
[    0.386038] EFI Variables Facility v0.08 2004-May-17
[    0.393203] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input4
[    0.398258] pstore: Registered efi as persistent store backend
[    0.398447] TCP: cubic registered
[    0.398654] NET: Registered protocol family 10
[    0.399013] mip6: Mobile IPv6
[    0.399018] NET: Registered protocol family 17
[    0.399028] mpls_gso: MPLS GSO support
[    0.399572] registered taskstats version 1
[    0.400330] rtc_cmos 00:01: setting system clock to 2015-01-09 23:06:00 UTC (1420844760)
[    0.400500] PM: Checking hibernation image partition /dev/sda3
[    0.698842] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    0.701419] ata3.00: ATA-8: LITEONIT LMT-256M6M mSATA 256GB, DM8110F, max UDMA/133
[    0.701421] ata3.00: 500118192 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    0.701982] ata3.00: configured for UDMA/133
[    1.259281] tsc: Refined TSC clocksource calibration: 2394.460 MHz
[    1.439646] Console: switching to colour frame buffer device 240x67
[    1.442780] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    1.442781] i915 0000:00:02.0: registered panic notifier
[    1.467725] scsi 2:0:0:0: Direct-Access     ATA      LITEONIT LMT-256 10F  PQ: 0 ANSI: 5
[    1.468095] sd 2:0:0:0: [sda] 500118192 512-byte logical blocks: (256 GB/238 GiB)
[    1.468551] sd 2:0:0:0: [sda] Write Protect is off
[    1.468555] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.468667] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.473378]  sda: sda1 sda2 sda3 sda4 sda5 sda6
[    1.473930] sd 2:0:0:0: [sda] Attached SCSI disk
[    1.473945] PM: Hibernation image partition 8:3 present
[    1.473947] PM: Looking for hibernation image.
[    1.474099] PM: Image not found (code -22)
[    1.474101] PM: Hibernation image not present or could not be loaded.
[    1.477077] EXT4-fs (sda6): mounted filesystem with ordered data mode. Opts: (null)
[    1.477088] VFS: Mounted root (ext4 filesystem) readonly on device 8:6.
[    1.477344] Freeing unused kernel memory: 1224K (ffffffff81cd5000 - ffffffff81e07000)
[    1.477346] Write protecting the kernel read-only data: 12288k
[    1.477731] Freeing unused kernel memory: 1508K (ffff880001a87000 - ffff880001c00000)
[    1.478021] Freeing unused kernel memory: 1784K (ffff880001e42000 - ffff880002000000)
[    1.512827] systemd[1]: RTC configured in localtime, applying delta of 60 minutes to system time.
[    1.515673] random: systemd urandom read with 14 bits of entropy available
[    1.698556] systemd-default-display-manager-generator[78]: No default display manager unit service enabled, setup is manual or a sysvinit file
[    1.751539] systemd[1]: Cannot add dependency job for unit avahi-daemon.service, ignoring: Unit avahi-daemon.service failed to load: No such file or directory.
[    1.751563] systemd[1]: Cannot add dependency job for unit display-manager.service, ignoring: Unit display-manager.service failed to load: No such file or directory.
[    1.776732] lp: driver loaded but no devices found
[    1.777792] ppdev: user-space parallel port driver
[    1.782251] fuse init (API version 7.23)
[    1.793289] systemd-udevd[123]: starting version 215
[    1.856343] ACPI: bus type USB registered
[    1.856368] usbcore: registered new interface driver usbfs
[    1.856379] usbcore: registered new interface driver hub
[    1.856575] usbcore: registered new device driver usb
[    1.856603] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.858141] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.858712] xhci_hcd 0000:00:14.0: can't derive routing for PCI INT A
[    1.858714] xhci_hcd 0000:00:14.0: PCI INT A: no GSI
[    1.858738] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.858742] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 1
[    1.858826] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.858888] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.858890] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.858891] usb usb1: Product: xHCI Host Controller
[    1.858892] usb usb1: Manufacturer: Linux 3.19.0-rc2+ xhci-hcd
[    1.858893] usb usb1: SerialNumber: 0000:00:14.0
[    1.859021] hub 1-0:1.0: USB hub found
[    1.859039] hub 1-0:1.0: 9 ports detected
[    1.860250] ehci-pci: EHCI PCI platform driver
[    1.862054] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.862058] xhci_hcd 0000:00:14.0: new USB bus registered, assigned bus number 2
[    1.862086] usb usb2: New USB device found, idVendor=1d6b, idProduct=0003
[    1.862087] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.862088] usb usb2: Product: xHCI Host Controller
[    1.862090] usb usb2: Manufacturer: Linux 3.19.0-rc2+ xhci-hcd
[    1.862091] usb usb2: SerialNumber: 0000:00:14.0
[    1.862676] hub 2-0:1.0: USB hub found
[    1.862687] hub 2-0:1.0: 4 ports detected
[    1.863682] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    1.863705] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 3
[    1.863726] ehci-pci 0000:00:1d.0: debug port 2
[    1.867617] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    1.868137] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf051d000
[    1.869459] sdhci: Secure Digital Host Controller Interface driver
[    1.869461] sdhci: Copyright(c) Pierre Ossman
[    1.879782] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    1.879844] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
[    1.879847] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.879849] usb usb3: Product: EHCI Host Controller
[    1.879851] usb usb3: Manufacturer: Linux 3.19.0-rc2+ ehci_hcd
[    1.879852] usb usb3: SerialNumber: 0000:00:1d.0
[    1.879991] hub 3-0:1.0: USB hub found
[    1.879999] hub 3-0:1.0: 2 ports detected
[    1.882460] thermal LNXTHERM:00: registered as thermal_zone0
[    1.882463] ACPI: Thermal Zone [TZ00] (28 C)
[    1.882602] thermal LNXTHERM:01: registered as thermal_zone1
[    1.882604] ACPI: Thermal Zone [TZ01] (30 C)
[    1.886544] ACPI Warning: SystemIO range 0x000000000000efa0-0x000000000000efbf conflicts with OpRegion 0x000000000000efa0-0x000000000000efaf (\_SB_.PCI0.SBUS.SMBI) (20141107/utaddress-258)
[    1.886551] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[    1.891532] cfg80211: Calling CRDA to update world regulatory domain
[    1.891575] sd 2:0:0:0: Attached scsi generic sg0 type 0
[    1.893732] Intel(R) Wireless WiFi driver for Linux, in-tree:
[    1.893735] Copyright(c) 2003- 2014 Intel Corporation
[    1.896681] sound hdaudioC1D0: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0) type:speaker
[    1.896684] sound hdaudioC1D0:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    1.896685] sound hdaudioC1D0:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
[    1.896686] sound hdaudioC1D0:    mono: mono_out=0x0
[    1.896687] sound hdaudioC1D0:    inputs:
[    1.896688] sound hdaudioC1D0:      Headphone Mic=0x19
[    1.896690] sound hdaudioC1D0:      Headset Mic=0x1b
[    1.896691] sound hdaudioC1D0:      Internal Mic=0x12
[    1.898137] iwlwifi 0000:02:00.0: loaded firmware version 23.11.10.0 op_mode iwlmvm
[    1.901886] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    1.907215] input: HDA Intel HDMI HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:03.0/sound/card0/input8
[    1.907271] input: HDA Intel HDMI HDMI/DP,pcm=7 as /devices/pci0000:00/0000:00:03.0/sound/card0/input9
[    1.907316] input: HDA Intel HDMI HDMI/DP,pcm=8 as /devices/pci0000:00/0000:00:03.0/sound/card0/input10
[    1.914437] iwlwifi 0000:02:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
[    1.914508] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[    1.914730] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.
[    1.914763] iwlwifi 0000:02:00.0: L1 Enabled - LTR Enabled
[    1.914844] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/sound/card1/hdaudioC1D0/input7
[    1.915040] input: HDA Intel PCH Headphone Mic as /devices/pci0000:00/0000:00:1b.0/sound/card1/input11
[    1.920817] AVX2 version of gcm_enc/dec engaged.
[    1.920820] AES CTR mode by8 optimization enabled
[    1.922056] EXT4-fs (sda6): re-mounted. Opts: errors=remount-ro
[    1.928751] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)
[    1.935663] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'
[    1.941447] alg: No test for crc32 (crc32-pclmul)
[    1.964082] intel_rapl: Found RAPL domain package
[    1.964086] intel_rapl: Found RAPL domain core
[    1.964089] intel_rapl: Found RAPL domain uncore
[    1.964091] intel_rapl: Found RAPL domain dram
[    1.965082] Adding 8388604k swap on /dev/sda3.  Priority:-1 extents:1 across:8388604k SSFS
[    1.968187] iTCO_vendor_support: vendor-support=0
[    1.968770] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    1.968808] iTCO_wdt: Found a Lynx Point_LP TCO device (Version=2, TCOBASE=0x1860)
[    1.969757] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    2.017902] cfg80211: World regulatory domain updated:
[    2.017906] cfg80211:  DFS Master region: unset
[    2.017908] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp), (dfs_cac_time)
[    2.017910] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.017912] cfg80211:   (2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm), (N/A)
[    2.017913] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (N/A, 2000 mBm), (N/A)
[    2.017915] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (N/A)
[    2.017917] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz, 160000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[    2.017919] cfg80211:   (5490000 KHz - 5730000 KHz @ 160000 KHz), (N/A, 2000 mBm), (0 s)
[    2.017921] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz), (N/A, 2000 mBm), (N/A)
[    2.017922] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 0 mBm), (N/A)
[    2.039942] FAT-fs (sda1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[    2.048269] systemd-journald[101]: Received request to flush runtime journal from PID 1
[    2.067942] ACPI: AC Adapter [ADP0] (on-line)
[    2.077475] ACPI: Battery Slot [BAT0] (battery present)
[    2.077699] wmi: Mapper loaded
[    2.172057] usb 1-3: new full-speed USB device number 2 using xhci_hcd
[    2.173991] input: Dell WMI hotkeys as /devices/virtual/input/input12
[    2.192006] usb 3-1: new high-speed USB device number 2 using ehci-pci
[    2.260230] Switched to clocksource tsc
[    2.301869] usb 1-3: New USB device found, idVendor=06cb, idProduct=0af8
[    2.301873] usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    2.301875] usb 1-3: Product: Synaptics Large Touch Screen
[    2.301877] usb 1-3: Manufacturer: SYNAPTICS
[    2.324643] usb 3-1: New USB device found, idVendor=8087, idProduct=8000
[    2.324647] usb 3-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.324987] hub 3-1:1.0: USB hub found
[    2.325053] hub 3-1:1.0: 8 ports detected
[    2.468280] usb 1-5: new high-speed USB device number 3 using xhci_hcd
[    2.621983] usb 1-5: New USB device found, idVendor=0bda, idProduct=5752
[    2.621987] usb 1-5: New USB device strings: Mfr=3, Product=1, SerialNumber=2
[    2.621989] usb 1-5: Product: Integrated_Webcam_HD
[    2.621990] usb 1-5: Manufacturer: CN0Y2TKG724873B4D4HXA00
[    2.621992] usb 1-5: SerialNumber: 200901010001
[    2.634813] hidraw: raw HID events driver (C) Jiri Kosina
[    2.636134] media: Linux media interface: v0.10
[    2.637128] usbcore: registered new interface driver usbhid
[    2.637130] usbhid: USB HID core driver
[    2.638588] Linux video capture interface: v2.00
[    2.639094] input: SYNAPTICS Synaptics Large Touch Screen as /devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3:1.0/0003:06CB:0AF8.0001/input/input13
[    2.639228] hid-multitouch 0003:06CB:0AF8.0001: input,hiddev0,hidraw0: USB HID v1.11 Mouse [SYNAPTICS Synaptics Large Touch Screen] on usb-0000:00:14.0-3/input0
[    2.642018] uvcvideo: Found UVC 1.00 device Integrated_Webcam_HD (0bda:5752)
[    2.645537] input: Integrated_Webcam_HD as /devices/pci0000:00/0000:00:14.0/usb1/1-5/1-5:1.0/input/input15
[    2.645619] usbcore: registered new interface driver uvcvideo
[    2.645622] USB Video Class driver (1.1.1)
[    3.137679] RPC: Registered named UNIX socket transport module.
[    3.137682] RPC: Registered udp transport module.
[    3.137683] RPC: Registered tcp transport module.
[    3.137684] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    3.140387] FS-Cache: Loaded
[    3.146236] FS-Cache: Netfs 'nfs' registered for caching
[    3.152280] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    3.311354] vboxdrv: Found 4 processor cores.
[    3.312413] vboxdrv: fAsync=0 offMin=0x10b offMax=0x1383
[    3.312475] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[    3.312477] vboxdrv: Successfully loaded version 4.3.20_Debian (interface 0x001a0008).
[    3.328870] vboxpci: pci-stub module not available, cannot detach PCI devices
[    3.328873] vboxpci: IOMMU not found (not registered)
[    3.380056] Bluetooth: Core ver 2.20
[    3.380069] NET: Registered protocol family 31
[    3.380071] Bluetooth: HCI device and connection manager initialized
[    3.380074] Bluetooth: HCI socket layer initialized
[    3.380077] Bluetooth: L2CAP socket layer initialized
[    3.380082] Bluetooth: SCO socket layer initialized
[    3.407658] hid-rmi 0018:06CB:2734.0002: Scanning PDT...
[    3.411236] hid-rmi 0018:06CB:2734.0002: Found F34 on page 0x00
[    3.413663] random: nonblocking pool is initialized
[    3.414483] hid-rmi 0018:06CB:2734.0002: Found F01 on page 0x00
[    3.419042] hid-rmi 0018:06CB:2734.0002: Found F11 on page 0x00
[    3.426669] hid-rmi 0018:06CB:2734.0002: Found F54 on page 0x01
[    3.429673] hid-rmi 0018:06CB:2734.0002: Found F30 on page 0x01
[    3.441014] hid-rmi 0018:06CB:2734.0002: Found F55 on page 0x02
[    3.453514] hid-rmi 0018:06CB:2734.0002: Found F51 on page 0x03
[    3.461084] hid-rmi 0018:06CB:2734.0002: rmi_scan_pdt: Done with PDT scan.
[    3.469333] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[    3.469337] Bluetooth: BNEP filters: protocol multicast
[    3.469341] Bluetooth: BNEP socket layer initialized
[    3.479077] hid-rmi 0018:06CB:2734.0002: rmi_populate_f11: size in mm: 97 x 59
[    3.493817] input: DLL060A:00 06CB:2734 as /devices/pci0000:00/INT33C3:00/i2c-8/i2c-DLL060A:00/0018:06CB:2734.0002/input/input16
[    3.493945] hid-rmi 0018:06CB:2734.0002: input,hidraw1: <UNKNOWN> HID v1.00 Pointer [DLL060A:00 06CB:2734] on 
[   74.955130] setting min_power
[   84.073694] ahci 0000:00:1f.2: port does not support device sleep
[  106.540094] setting max_performance
[  106.559201] ahci 0000:00:1f.2: port does not support device sleep
[  106.567268] ata3.00: exception Emask 0x10 SAct 0x400 SErr 0x50000 action 0xe frozen
[  106.567272] ata3.00: irq_stat 0x00400000, PHY RDY changed
[  106.567275] ata3: SError: { PHYRdyChg CommWake }
[  106.567278] ata3.00: failed command: READ FPDMA QUEUED
[  106.567282] ata3.00: cmd 60/08:50:98:2a:08/00:00:1c:00:00/40 tag 10 ncq 4096 in
         res 40/00:54:98:2a:08/00:00:1c:00:00/40 Emask 0x10 (ATA bus error)
[  106.567285] ata3.00: status: { DRDY }
[  106.567288] ata3: hard resetting link
[  107.291770] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  107.294604] ata3.00: configured for UDMA/133
[  107.307771] ahci 0000:00:1f.2: port does not support device sleep
[  107.307782] ata3: EH complete
[  132.128168] setting min_power
[  132.128224] ahci 0000:00:1f.2: port does not support device sleep
[  143.778885] setting max_performance
[  143.796864] ahci 0000:00:1f.2: port does not support device sleep
[  147.007445] ata3.00: exception Emask 0x10 SAct 0x18000000 SErr 0x50000 action 0xe frozen
[  147.007449] ata3.00: irq_stat 0x00400000, PHY RDY changed
[  147.007452] ata3: SError: { PHYRdyChg CommWake }
[  147.007455] ata3.00: failed command: READ FPDMA QUEUED
[  147.007459] ata3.00: cmd 60/08:d8:78:28:c7/00:00:17:00:00/40 tag 27 ncq 4096 in
         res 40/00:e4:e0:06:d4/00:00:17:00:00/40 Emask 0x10 (ATA bus error)
[  147.007461] ata3.00: status: { DRDY }
[  147.007462] ata3.00: failed command: WRITE FPDMA QUEUED
[  147.007466] ata3.00: cmd 61/20:e0:e0:06:d4/01:00:17:00:00/40 tag 28 ncq 147456 out
         res 40/00:e4:e0:06:d4/00:00:17:00:00/40 Emask 0x10 (ATA bus error)
[  147.007467] ata3.00: status: { DRDY }
[  147.007470] ata3: hard resetting link
[  147.732032] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  147.734934] ata3.00: configured for UDMA/133
[  147.748034] ahci 0000:00:1f.2: port does not support device sleep
[  147.748048] ata3: EH complete
