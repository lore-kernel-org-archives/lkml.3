Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbaDQAT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 20:19:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaDQATW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 20:19:22 -0400
Date: Wed, 16 Apr 2014 20:18:43 -0400
From: Dave Jones <davej@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Borislav Petkov <bp@alien8.de>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Zhang, Rui" <rui.zhang@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Stephane Eranian <eranian@google.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140417001843.GA8527@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	"Zhang, Rui" <rui.zhang@intel.com>,
	"Lu, Aaron" <aaron.lu@intel.com>,
	lkml <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	Linux PCI <linux-pci@vger.kernel.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephane Eranian <eranian@google.com>,
	"Yan, Zheng Z" <zheng.z.yan@intel.com>
References: <20140224162400.GE16457@pd.tnic>
 <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
 <CAErSpo55DjkGQB=7ksow34BpCObnY+o3eNnt0n5oQEh6Lfw1pw@mail.gmail.com>
 <1558044.S1G2VU7srO@vostro.rjw.lan>
 <CAErSpo4pDYMhHo6e-1TN6XDRO0xy0u8H+=oucFnrEK+kbjZvzw@mail.gmail.com>
 <20140416190404.GA7070@pd.tnic>
 <20140416203138.GA17661@google.com>
 <20140416223122.GA2767@redhat.com>
 <20140416225600.GA23781@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20140416225600.GA23781@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 04:56:00PM -0600, Bjorn Helgaas wrote:
 
 > > I'm seeing the exact same message on my thinkpad t430s.
 > > When I try your patch, modesetting no longer works. When it tries
 > > to change to the framebuffer I get a black screen and lockup.
 > > If I boot with nomodeset it locks up when it gets to X.
 > > It all scrolls by too fast to read, but it looks like there's still
 > > a backtrace present.
 > 
 > Ouch, sorry about that.  I do see a bug in my patch (fixed below), but I
 > don't see how that could cause what you're seeing.

updated diff made no difference fwiw.

 > Maybe I could figure
 > out something from this info (this can be from a kernel without my patch):
 > 
 >     - dmesg log
 >     - output of "find /sys/devices/pnp0 -name id -o -name resources | xargs grep ."
 >     - output of "sudo lspci -s00:00.0 -xxx"

attached from a fedora build of rc1.

	Dave


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pnp.txt"

/sys/devices/pnp0/00:00/id:PNP0c01
/sys/devices/pnp0/00:00/resources:state = active
/sys/devices/pnp0/00:00/resources:mem 0x0-0x9ffff
/sys/devices/pnp0/00:00/resources:mem 0xc0000-0xc3fff
/sys/devices/pnp0/00:00/resources:mem 0xc4000-0xc7fff
/sys/devices/pnp0/00:00/resources:mem 0xc8000-0xcbfff
/sys/devices/pnp0/00:00/resources:mem 0xcc000-0xcffff
/sys/devices/pnp0/00:00/resources:mem 0xd0000-0xd3fff
/sys/devices/pnp0/00:00/resources:mem 0xd4000-0xd7fff
/sys/devices/pnp0/00:00/resources:mem 0xd8000-0xdbfff
/sys/devices/pnp0/00:00/resources:mem 0xdc000-0xdffff
/sys/devices/pnp0/00:00/resources:mem 0xe0000-0xe3fff
/sys/devices/pnp0/00:00/resources:mem 0xe4000-0xe7fff
/sys/devices/pnp0/00:00/resources:mem 0xe8000-0xebfff
/sys/devices/pnp0/00:00/resources:mem 0xec000-0xeffff
/sys/devices/pnp0/00:00/resources:mem 0xf0000-0xfffff
/sys/devices/pnp0/00:00/resources:mem 0x100000-0xbf9fffff
/sys/devices/pnp0/00:00/resources:mem 0xfec00000-0xfed3ffff
/sys/devices/pnp0/00:00/resources:mem 0xfed4c000-0xffffffff
/sys/devices/pnp0/00:01/id:PNP0c02
/sys/devices/pnp0/00:01/resources:state = active
/sys/devices/pnp0/00:01/resources:io 0x10-0x1f
/sys/devices/pnp0/00:01/resources:io 0x90-0x9f
/sys/devices/pnp0/00:01/resources:io 0x24-0x25
/sys/devices/pnp0/00:01/resources:io 0x28-0x29
/sys/devices/pnp0/00:01/resources:io 0x2c-0x2d
/sys/devices/pnp0/00:01/resources:io 0x30-0x31
/sys/devices/pnp0/00:01/resources:io 0x34-0x35
/sys/devices/pnp0/00:01/resources:io 0x38-0x39
/sys/devices/pnp0/00:01/resources:io 0x3c-0x3d
/sys/devices/pnp0/00:01/resources:io 0xa4-0xa5
/sys/devices/pnp0/00:01/resources:io 0xa8-0xa9
/sys/devices/pnp0/00:01/resources:io 0xac-0xad
/sys/devices/pnp0/00:01/resources:io 0xb0-0xb5
/sys/devices/pnp0/00:01/resources:io 0xb8-0xb9
/sys/devices/pnp0/00:01/resources:io 0xbc-0xbd
/sys/devices/pnp0/00:01/resources:io 0x50-0x53
/sys/devices/pnp0/00:01/resources:io 0x72-0x77
/sys/devices/pnp0/00:01/resources:io 0x400-0x47f
/sys/devices/pnp0/00:01/resources:io 0x500-0x57f
/sys/devices/pnp0/00:01/resources:io 0x800-0x80f
/sys/devices/pnp0/00:01/resources:io 0x15e0-0x15ef
/sys/devices/pnp0/00:01/resources:io 0x1600-0x167f
/sys/devices/pnp0/00:01/resources:mem 0xf8000000-0xfbffffff
/sys/devices/pnp0/00:01/resources:mem disabled
/sys/devices/pnp0/00:01/resources:mem 0xfed1c000-0xfed1ffff
/sys/devices/pnp0/00:01/resources:mem 0xfed10000-0xfed13fff
/sys/devices/pnp0/00:01/resources:mem 0xfed18000-0xfed18fff
/sys/devices/pnp0/00:01/resources:mem 0xfed19000-0xfed19fff
/sys/devices/pnp0/00:01/resources:mem 0xfed45000-0xfed4bfff
/sys/devices/pnp0/00:02/id:PNP0103
/sys/devices/pnp0/00:02/resources:state = active
/sys/devices/pnp0/00:02/resources:mem 0xfed00000-0xfed003ff
/sys/devices/pnp0/00:03/id:PNP0200
/sys/devices/pnp0/00:03/resources:state = active
/sys/devices/pnp0/00:03/resources:io 0x0-0xf
/sys/devices/pnp0/00:03/resources:io 0x80-0x8f
/sys/devices/pnp0/00:03/resources:io 0xc0-0xdf
/sys/devices/pnp0/00:03/resources:dma 4
/sys/devices/pnp0/00:04/id:PNP0800
/sys/devices/pnp0/00:04/resources:state = active
/sys/devices/pnp0/00:04/resources:io 0x61-0x61
/sys/devices/pnp0/00:05/id:PNP0c04
/sys/devices/pnp0/00:05/resources:state = active
/sys/devices/pnp0/00:05/resources:io 0xf0-0xf0
/sys/devices/pnp0/00:05/resources:irq 13
/sys/devices/pnp0/00:06/id:PNP0b00
/sys/devices/pnp0/00:06/resources:state = active
/sys/devices/pnp0/00:06/resources:io 0x70-0x71
/sys/devices/pnp0/00:06/resources:irq 8
/sys/devices/pnp0/00:07/id:LEN0071
/sys/devices/pnp0/00:07/id:PNP0303
/sys/devices/pnp0/00:07/resources:state = active
/sys/devices/pnp0/00:07/resources:io 0x60-0x60
/sys/devices/pnp0/00:07/resources:io 0x64-0x64
/sys/devices/pnp0/00:07/resources:irq 1
/sys/devices/pnp0/00:08/id:LEN0015
/sys/devices/pnp0/00:08/id:PNP0f13
/sys/devices/pnp0/00:08/resources:state = active
/sys/devices/pnp0/00:08/resources:irq 12
/sys/devices/pnp0/00:09/id:SMO1200
/sys/devices/pnp0/00:09/id:PNP0c31
/sys/devices/pnp0/00:09/resources:state = active
/sys/devices/pnp0/00:09/resources:mem 0xfed40000-0xfed44fff


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=pci

00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
00: 86 80 54 01 06 00 90 20 09 00 00 06 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fb 21
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 90 d1 fe 00 00 00 00 01 00 d1 fe 00 00 00 00
50: 11 02 00 00 19 00 00 00 07 00 90 bf 01 00 00 bb
60: 05 00 00 f8 00 00 00 00 01 80 d1 fe 00 00 00 00
70: 00 00 00 fe 00 00 00 00 00 0c 00 fe 7f 00 00 00
80: 10 11 11 11 11 11 11 00 1a 00 00 00 00 00 00 00
90: 01 00 00 00 01 00 00 00 01 00 50 3e 01 00 00 00
a0: 01 00 00 00 01 00 00 00 01 00 60 3e 01 00 00 00
b0: 01 00 a0 bb 01 00 80 bb 01 00 00 bb 01 00 a0 bf
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 09 00 0c 01 9b 61 00 82 d0 00 e8 76 00 00 00 00
f0: 00 00 00 01 00 00 00 00 c8 0f 09 00 00 00 00 00


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.15.0-0.rc1.git0.1.fc21.x86_64 (mockbuild@bkernel02) (gcc version 4.9.0 20140411 (Red Hat 4.9.0-0.10) (GCC) ) #1 SMP Mon Apr 14 15:42:28 UTC 2014
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.15.0-0.rc1.git0.1.fc21.x86_64 root=/dev/mapper/luks-88d41cc3-dbf6-42da-be04-55c0b18fc495 ro rd.luks.uuid=luks-a022e7c3-2439-4570-a0a0-f2bc1ed10c93 rd.luks.uuid=luks-88d41cc3-dbf6-42da-be04-55c0b18fc495 biosdevname=0 vconsole.font=latarcyrheb-sun16 rdshell consoleblank=0 console=ttyUSB0,115200 console=tty0 pause_on_oops=30 SYSFONT=default8x9 LANG=en_US.UTF-8
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x0000000040003fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040004000-0x0000000040004fff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040005000-0x00000000aed2ffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000aed30000-0x00000000bae9efff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000bae9f000-0x00000000baf9efff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000baf9f000-0x00000000baffefff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000bafff000-0x00000000bf9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ffc00000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000013e5fffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: LENOVO 2356JK8/2356JK8, BIOS G7ET94WW (2.54 ) 04/30/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x13e600 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0FFC00000 mask FFFC00000 write-protect
[    0.000000]   1 base 000000000 mask F80000000 write-back
[    0.000000]   2 base 080000000 mask FC0000000 write-back
[    0.000000]   3 base 0BC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0BB000000 mask FFF000000 uncachable
[    0.000000]   5 base 100000000 mask FC0000000 write-back
[    0.000000]   6 base 13F000000 mask FFF000000 uncachable
[    0.000000]   7 base 13E800000 mask FFF800000 uncachable
[    0.000000]   8 base 13E600000 mask FFFE00000 uncachable
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: last_pfn = 0xaed30 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000f0100-0x000f010f] mapped at [ffff8800000f0100]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x02033000, 0x02033fff] PGTABLE
[    0.000000] BRK [0x02034000, 0x02034fff] PGTABLE
[    0.000000] BRK [0x02035000, 0x02035fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13e400000-0x13e5fffff]
[    0.000000]  [mem 0x13e400000-0x13e5fffff] page 2M
[    0.000000] BRK [0x02036000, 0x02036fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x13c000000-0x13e3fffff]
[    0.000000]  [mem 0x13c000000-0x13e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x100000000-0x13bffffff]
[    0.000000]  [mem 0x100000000-0x13bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x40003fff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000]  [mem 0x40000000-0x40003fff] page 4k
[    0.000000] BRK [0x02037000, 0x02037fff] PGTABLE
[    0.000000] BRK [0x02038000, 0x02038fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x40005000-0xaed2ffff]
[    0.000000]  [mem 0x40005000-0x401fffff] page 4k
[    0.000000]  [mem 0x40200000-0xaebfffff] page 2M
[    0.000000]  [mem 0xaec00000-0xaed2ffff] page 4k
[    0.000000] RAMDISK: [mem 0x35b6f000-0x36daffff]
[    0.000000] ACPI: RSDP 0x00000000000F0120 000024 (v02 LENOVO)
[    0.000000] ACPI: XSDT 0x00000000BAFFE170 0000BC (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: FACP 0x00000000BAFE6000 00010C (v05 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: DSDT 0x00000000BAFE8000 010B02 (v01 LENOVO TP-G7    00002540 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000BAF5A000 000040
[    0.000000] ACPI: SLIC 0x00000000BAFFD000 000176 (v01 LENOVO TP-G7    00002540 PTL  00000001)
[    0.000000] ACPI: TCPA 0x00000000BAFFC000 000032 (v02 PTL    LENOVO   06040000 LNVO 00000001)
[    0.000000] ACPI: SSDT 0x00000000BAFFB000 000408 (v01 LENOVO TP-SSDT2 00000200 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000BAFFA000 000033 (v01 LENOVO TP-SSDT1 00000100 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000BAFF9000 000797 (v01 LENOVO SataAhci 00001000 INTL 20061109)
[    0.000000] ACPI: HPET 0x00000000BAFE4000 000038 (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: APIC 0x00000000BAFE3000 000098 (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: MCFG 0x00000000BAFE2000 00003C (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: ECDT 0x00000000BAFE1000 000052 (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: FPDT 0x00000000BAFE0000 000064 (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: ASF! 0x00000000BAFE7000 0000A5 (v32 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000BAFDF000 00003E (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: UEFI 0x00000000BAFDE000 000042 (v01 PTL    COMBUF   00000001 PTL  00000001)
[    0.000000] ACPI: POAT 0x00000000BAFDD000 000055 (v03 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: SSDT 0x00000000BAFDC000 000BF3 (v01 PmRef  Cpu0Ist  00003000 INTL 20061109)
[    0.000000] ACPI: SSDT 0x00000000BAFDB000 000A83 (v01 PmRef  CpuPm    00003000 INTL 20061109)
[    0.000000] ACPI: UEFI 0x00000000BAFDA000 0002A6 (v01 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: DBG2 0x00000000BAFD9000 0000E9 (v00 LENOVO TP-G7    00002540 PTL  00000002)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000013e5fffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x13e5fffff]
[    0.000000]   NODE_DATA [mem 0x13e5ea000-0x13e5fdfff]
[    0.000000]  [ffffea0000000000-ffffea0004ffffff] PMD -> [ffff88013a000000-ffff88013dbfffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x13e5fffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x40003fff]
[    0.000000]   node   0: [mem 0x40005000-0xaed2ffff]
[    0.000000]   node   0: [mem 0x100000000-0x13e5fffff]
[    0.000000] On node 0 totalpages: 970955
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 11117 pages used for memmap
[    0.000000]   DMA32 zone: 711471 pages, LIFO batch:31
[    0.000000]   Normal zone: 3992 pages used for memmap
[    0.000000]   Normal zone: 255488 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xbba00000-0xbf9fffff
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
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40004000-0x40004fff]
[    0.000000] PM: Registered nosave memory: [mem 0xaed30000-0xbae9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbae9f000-0xbaf9efff]
[    0.000000] PM: Registered nosave memory: [mem 0xbaf9f000-0xbaffefff]
[    0.000000] PM: Registered nosave memory: [mem 0xbafff000-0xbf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xbfa00000-0xf7ffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffbfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xffc00000-0xffffffff]
[    0.000000] e820: [mem 0xbfa00000-0xf7ffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:1024 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88013e200000 s88128 r8192 d22464 u262144
[    0.000000] pcpu-alloc: s88128 r8192 d22464 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 955761
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.15.0-0.rc1.git0.1.fc21.x86_64 root=/dev/mapper/luks-88d41cc3-dbf6-42da-be04-55c0b18fc495 ro rd.luks.uuid=luks-a022e7c3-2439-4570-a0a0-f2bc1ed10c93 rd.luks.uuid=luks-88d41cc3-dbf6-42da-be04-55c0b18fc495 biosdevname=0 vconsole.font=latarcyrheb-sun16 rdshell consoleblank=0 console=ttyUSB0,115200 console=tty0 pause_on_oops=30 SYSFONT=default8x9 LANG=en_US.UTF-8
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Memory: 3719672K/3883820K available (7250K kernel code, 1171K rwdata, 3080K rodata, 1440K init, 1652K bss, 164148K reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=1024 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=8
[    0.000000] NR_IRQS:65792 nr_irqs:744 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 15728640 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 2893.501 MHz processor
[    0.000031] Calibrating delay loop (skipped), value calculated using timer frequency.. 5787.00 BogoMIPS (lpj=2893501)
[    0.000173] pid_max: default: 32768 minimum: 301
[    0.000252] ACPI: Core revision 20140214
[    0.009974] ACPI: All ACPI Tables successfully acquired
[    0.011481] Security Framework initialized
[    0.011561] SELinux:  Initializing.
[    0.011638] SELinux:  Starting in permissive mode
[    0.011911] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.012895] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.013358] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.013442] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.013685] Initializing cgroup subsys memory
[    0.013764] Initializing cgroup subsys devices
[    0.013838] Initializing cgroup subsys freezer
[    0.013922] Initializing cgroup subsys net_cls
[    0.013995] Initializing cgroup subsys blkio
[    0.014068] Initializing cgroup subsys perf_event
[    0.014142] Initializing cgroup subsys net_prio
[    0.014215] Initializing cgroup subsys hugetlb
[    0.014308] CPU: Physical Processor ID: 0
[    0.014384] CPU: Processor Core ID: 0
[    0.014887] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.015304] mce: CPU supports 7 MCE banks
[    0.015387] CPU0: Thermal monitoring enabled (TM1)
[    0.015466] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
tlb_flushall_shift: 2
[    0.015687] Freeing SMP alternatives memory: 24K (ffffffff81e8e000 - ffffffff81e94000)
[    0.016746] ftrace: allocating 26542 entries in 104 pages
[    0.028127] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.038227] smpboot: CPU0: Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz (fam: 06, model: 3a, stepping: 09)
[    0.038508] TSC deadline timer enabled
[    0.038516] Performance Events: PEBS fmt1+, 16-deep LBR, IvyBridge events, full-width counters, Intel PMU driver.
[    0.038878] ... version:                3
[    0.038971] ... bit width:              48
[    0.039063] ... generic registers:      4
[    0.039156] ... value mask:             0000ffffffffffff
[    0.039250] ... max period:             0000ffffffffffff
[    0.039345] ... fixed-purpose events:   3
[    0.039438] ... event mask:             000000070000000f
[    0.040584] x86: Booting SMP configuration:
[    0.040682] .... node  #0, CPUs:      #1
[    0.054314] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.054612]  #2 #3
[    0.081854] x86: Booted up 1 node, 4 CPUs
[    0.082041] smpboot: Total of 4 processors activated (23148.00 BogoMIPS)
[    0.085501] devtmpfs: initialized
[    0.087592] PM: Registering ACPI NVS region [mem 0xbae9f000-0xbaf9efff] (1048576 bytes)
[    0.088390] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.088492] pinctrl core: initialized pinctrl subsystem
[    0.088623] RTC time: 20:12:16, date: 04/16/14
[    0.088749] NET: Registered protocol family 16
[    0.088939] cpuidle: using governor menu
[    0.089092] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.089235] ACPI: bus type PCI registered
[    0.089332] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.089599] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.089745] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.094009] PCI: Using configuration type 1 for base access
[    0.095213] ACPI: Added _OSI(Module Device)
[    0.095310] ACPI: Added _OSI(Processor Device)
[    0.095405] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.095499] ACPI: Added _OSI(Processor Aggregator Device)
[    0.096762] ACPI : EC: EC description table is found, configuring boot EC
[    0.100379] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.112972] ACPI: SSDT 0x00000000BAE3A018 000A01 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.113495] ACPI: Dynamic OEM Table Load:
[    0.113675] ACPI: SSDT 0x0000000000000000 000A01 (v01 PmRef  Cpu0Cst  00003001 INTL 20061109)
[    0.116584] ACPI: SSDT 0x00000000BAE3BA98 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.117148] ACPI: Dynamic OEM Table Load:
[    0.117327] ACPI: SSDT 0x0000000000000000 000303 (v01 PmRef  ApIst    00003000 INTL 20061109)
[    0.120582] ACPI: SSDT 0x00000000BAE39D98 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.121102] ACPI: Dynamic OEM Table Load:
[    0.121283] ACPI: SSDT 0x0000000000000000 000119 (v01 PmRef  ApCst    00003000 INTL 20061109)
[    0.125008] ACPI: Interpreter enabled
[    0.125107] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140214/hwxface-580)
[    0.125340] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140214/hwxface-580)
[    0.125582] ACPI: (supports S0 S3 S4 S5)
[    0.125679] ACPI: Using IOAPIC for interrupt routing
[    0.125789] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.130940] ACPI: Power Resource [PUBS] (on)
[    0.131654] acpi PNP0C0A:01: ACPI dock station (docks/bays count: 1)
[    0.132613] acpi LNXIOBAY:00: ACPI dock station (docks/bays count: 2)
[    0.135020] ACPI: \_PR_.CPU4: failed to get CPU APIC ID.
[    0.135023] ACPI: \_PR_.CPU5: failed to get CPU APIC ID.
[    0.135026] ACPI: \_PR_.CPU6: failed to get CPU APIC ID.
[    0.135028] ACPI: \_PR_.CPU7: failed to get CPU APIC ID.
[    0.135089] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
[    0.135671] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11)
[    0.136246] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 *7 9 10 11)
[    0.136825] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
[    0.137400] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
[    0.137977] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 9 10 11)
[    0.138551] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 *10 11)
[    0.139126] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11)
[    0.139667] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3f])
[    0.139767] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.139993] acpi PNP0A08:00: _OSC: platform does not support [PCIeCapability]
[    0.140131] acpi PNP0A08:00: _OSC: not requesting control; platform does not support [PCIeCapability]
[    0.140277] acpi PNP0A08:00: _OSC: OS requested [PCIeHotplug PME AER PCIeCapability]
[    0.140419] acpi PNP0A08:00: _OSC: platform willing to grant [PCIeHotplug PME AER]
[    0.140560] acpi PNP0A08:00: _OSC failed (AE_SUPPORT); disabling ASPM
[    0.140798] PCI host bridge to bus 0000:00
[    0.140892] pci_bus 0000:00: root bus resource [bus 00-3f]
[    0.140988] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.141084] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.141179] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.141276] pci_bus 0000:00: root bus resource [mem 0xbfa00000-0xfebfffff]
[    0.141374] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed4bfff]
[    0.141476] pci 0000:00:00.0: [8086:0154] type 00 class 0x060000
[    0.141541] pci 0000:00:01.0: [8086:0151] type 01 class 0x060400
[    0.141568] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.141622] pci 0000:00:02.0: [8086:0166] type 00 class 0x030000
[    0.141631] pci 0000:00:02.0: reg 0x10: [mem 0xf1000000-0xf13fffff 64bit]
[    0.141637] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.141641] pci 0000:00:02.0: reg 0x20: [io  0x6000-0x603f]
[    0.141721] pci 0000:00:14.0: [8086:1e31] type 00 class 0x0c0330
[    0.141742] pci 0000:00:14.0: reg 0x10: [mem 0xf3520000-0xf352ffff 64bit]
[    0.141812] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.141838] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.141971] pci 0000:00:16.0: [8086:1e3a] type 00 class 0x078000
[    0.141993] pci 0000:00:16.0: reg 0x10: [mem 0xf3535000-0xf353500f 64bit]
[    0.142066] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.142130] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.142147] pci 0000:00:19.0: reg 0x10: [mem 0xf3500000-0xf351ffff]
[    0.142155] pci 0000:00:19.0: reg 0x14: [mem 0xf353b000-0xf353bfff]
[    0.142163] pci 0000:00:19.0: reg 0x18: [io  0x6080-0x609f]
[    0.142223] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.142249] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.142378] pci 0000:00:1a.0: [8086:1e2d] type 00 class 0x0c0320
[    0.142398] pci 0000:00:1a.0: reg 0x10: [mem 0xf353a000-0xf353a3ff]
[    0.142484] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.142512] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.142643] pci 0000:00:1b.0: [8086:1e20] type 00 class 0x040300
[    0.142657] pci 0000:00:1b.0: reg 0x10: [mem 0xf3530000-0xf3533fff 64bit]
[    0.142728] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.142759] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.142894] pci 0000:00:1c.0: [8086:1e10] type 01 class 0x060400
[    0.143027] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.143101] pci 0000:00:1c.1: [8086:1e12] type 01 class 0x060400
[    0.143235] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.143305] pci 0000:00:1c.2: [8086:1e14] type 01 class 0x060400
[    0.143437] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.143476] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.143610] pci 0000:00:1d.0: [8086:1e26] type 00 class 0x0c0320
[    0.143630] pci 0000:00:1d.0: reg 0x10: [mem 0xf3539000-0xf35393ff]
[    0.143716] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.143745] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.143879] pci 0000:00:1f.0: [8086:1e55] type 00 class 0x060100
[    0.144030] pci 0000:00:1f.2: [8086:1e03] type 00 class 0x010601
[    0.144047] pci 0000:00:1f.2: reg 0x10: [io  0x60a8-0x60af]
[    0.144054] pci 0000:00:1f.2: reg 0x14: [io  0x60b4-0x60b7]
[    0.144062] pci 0000:00:1f.2: reg 0x18: [io  0x60a0-0x60a7]
[    0.144070] pci 0000:00:1f.2: reg 0x1c: [io  0x60b0-0x60b3]
[    0.144077] pci 0000:00:1f.2: reg 0x20: [io  0x6060-0x607f]
[    0.144084] pci 0000:00:1f.2: reg 0x24: [mem 0xf3538000-0xf35387ff]
[    0.144127] pci 0000:00:1f.2: PME# supported from D3hot
[    0.144179] pci 0000:00:1f.3: [8086:1e22] type 00 class 0x0c0500
[    0.144194] pci 0000:00:1f.3: reg 0x10: [mem 0xf3534000-0xf35340ff 64bit]
[    0.144213] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
[    0.144318] pci 0000:01:00.0: [10de:1140] type 00 class 0x030200
[    0.144327] pci 0000:01:00.0: reg 0x10: [mem 0xf0000000-0xf0ffffff]
[    0.144336] pci 0000:01:00.0: reg 0x14: [mem 0xc0000000-0xcfffffff 64bit pref]
[    0.144345] pci 0000:01:00.0: reg 0x1c: [mem 0xd0000000-0xd1ffffff 64bit pref]
[    0.144352] pci 0000:01:00.0: reg 0x24: [io  0x5000-0x507f]
[    0.144359] pci 0000:01:00.0: reg 0x30: [mem 0xfff80000-0xffffffff pref]
[    0.145884] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.146003] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.146005] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf0ffffff]
[    0.146008] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.146098] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.146196] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.146200] pci 0000:00:1c.0:   bridge window [mem 0xf2d00000-0xf34fffff]
[    0.146209] pci 0000:00:1c.0:   bridge window [mem 0xf1400000-0xf1bfffff 64bit pref]
[    0.146435] pci 0000:03:00.0: [8086:4238] type 00 class 0x028000
[    0.146583] pci 0000:03:00.0: reg 0x10: [mem 0xf2c00000-0xf2c01fff 64bit]
[    0.147354] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.149006] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.149109] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf2cfffff]
[    0.149211] acpiphp: Slot [1] registered
[    0.149470] pci 0000:04:00.0: [1180:e822] type 00 class 0x088000
[    0.149489] pci 0000:04:00.0: MMC controller base frequency changed to 50Mhz.
[    0.149772] pci 0000:04:00.0: reg 0x10: [mem 0xf2400000-0xf24000ff]
[    0.149995] pci 0000:04:00.0: supports D1 D2
[    0.149996] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.152073] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.152171] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.152175] pci 0000:00:1c.2:   bridge window [mem 0xf2400000-0xf2bfffff]
[    0.152184] pci 0000:00:1c.2:   bridge window [mem 0xf1c00000-0xf23fffff 64bit pref]
[    0.152847] ACPI: Enabled 5 GPEs in block 00 to 3F
[    0.153071] ACPI : EC: GPE = 0x11, I/O: command/status = 0x66, data = 0x62
[    0.153240] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.153386] vgaarb: loaded
[    0.153478] vgaarb: bridge control possible 0000:00:02.0
[    0.153622] SCSI subsystem initialized
[    0.153745] libata version 3.00 loaded.
[    0.153764] ACPI: bus type USB registered
[    0.153874] usbcore: registered new interface driver usbfs
[    0.153977] usbcore: registered new interface driver hub
[    0.154107] usbcore: registered new device driver usb
[    0.154251] PCI: Using ACPI for IRQ routing
[    0.156285] PCI: pci_cache_line_size set to 64 bytes
[    0.156772] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.156773] e820: reserve RAM buffer [mem 0x40004000-0x43ffffff]
[    0.156774] e820: reserve RAM buffer [mem 0xaed30000-0xafffffff]
[    0.156775] e820: reserve RAM buffer [mem 0x13e600000-0x13fffffff]
[    0.156846] NetLabel: Initializing
[    0.156940] NetLabel:  domain hash size = 128
[    0.157033] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.157136] NetLabel:  unlabeled traffic allowed by default
[    0.157287] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.157761] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.159882] Switched to clocksource hpet
[    0.160003] Could not create debugfs 'set_ftrace_filter' entry
[    0.160103] Could not create debugfs 'set_ftrace_notrace' entry
[    0.164865] pnp: PnP ACPI init
[    0.164981] ACPI: bus type PNP registered
[    0.165392] system 00:00: [mem 0x00000000-0x0009ffff] could not be reserved
[    0.165494] system 00:00: [mem 0x000c0000-0x000c3fff] could not be reserved
[    0.165592] system 00:00: [mem 0x000c4000-0x000c7fff] could not be reserved
[    0.165690] system 00:00: [mem 0x000c8000-0x000cbfff] has been reserved
[    0.165787] system 00:00: [mem 0x000cc000-0x000cffff] has been reserved
[    0.165891] system 00:00: [mem 0x000d0000-0x000d3fff] has been reserved
[    0.165988] system 00:00: [mem 0x000d4000-0x000d7fff] has been reserved
[    0.166086] system 00:00: [mem 0x000d8000-0x000dbfff] has been reserved
[    0.166183] system 00:00: [mem 0x000dc000-0x000dffff] has been reserved
[    0.166280] system 00:00: [mem 0x000e0000-0x000e3fff] could not be reserved
[    0.166377] system 00:00: [mem 0x000e4000-0x000e7fff] could not be reserved
[    0.166474] system 00:00: [mem 0x000e8000-0x000ebfff] could not be reserved
[    0.166572] system 00:00: [mem 0x000ec000-0x000effff] could not be reserved
[    0.166669] system 00:00: [mem 0x000f0000-0x000fffff] could not be reserved
[    0.166768] system 00:00: [mem 0x00100000-0xbf9fffff] could not be reserved
[    0.166865] system 00:00: [mem 0xfec00000-0xfed3ffff] could not be reserved
[    0.166968] system 00:00: [mem 0xfed4c000-0xffffffff] could not be reserved
[    0.167067] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.167135] pnp 00:01: disabling [mem 0xfffff000-0xffffffff] because it overlaps 0000:01:00.0 BAR 6 [mem 0xfff80000-0xffffffff pref]
[    0.167308] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.167407] system 00:01: [io  0x0500-0x057f] has been reserved
[    0.167503] system 00:01: [io  0x0800-0x080f] has been reserved
[    0.167599] system 00:01: [io  0x15e0-0x15ef] has been reserved
[    0.167696] system 00:01: [io  0x1600-0x167f] has been reserved
[    0.167793] system 00:01: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.167896] system 00:01: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.167995] system 00:01: [mem 0xfed10000-0xfed13fff] has been reserved
[    0.168091] system 00:01: [mem 0xfed18000-0xfed18fff] has been reserved
[    0.168189] system 00:01: [mem 0xfed19000-0xfed19fff] has been reserved
[    0.168286] system 00:01: [mem 0xfed45000-0xfed4bfff] has been reserved
[    0.168383] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.168428] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.168434] pnp 00:03: [dma 4]
[    0.168449] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.168465] pnp 00:04: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.168494] pnp 00:05: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.168517] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.168542] pnp 00:07: Plug and Play ACPI device, IDs LEN0071 PNP0303 (active)
[    0.168564] pnp 00:08: Plug and Play ACPI device, IDs LEN0015 PNP0f13 (active)
[    0.168601] pnp 00:09: Plug and Play ACPI device, IDs SMO1200 PNP0c31 (active)
[    0.169023] pnp: PnP ACPI: found 10 devices
[    0.169120] ACPI: bus type PNP unregistered
[    0.175617] pci 0000:01:00.0: can't claim BAR 6 [mem 0xfff80000-0xffffffff pref]: no compatible bridge window
[    0.175807] pci 0000:01:00.0: BAR 6: can't assign mem pref (size 0x80000)
[    0.175909] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.176004] pci 0000:00:01.0:   bridge window [io  0x5000-0x5fff]
[    0.176101] pci 0000:00:01.0:   bridge window [mem 0xf0000000-0xf0ffffff]
[    0.176199] pci 0000:00:01.0:   bridge window [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.176342] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.177646] pci 0000:00:1c.0:   bridge window [io  0x4000-0x4fff]
[    0.177747] pci 0000:00:1c.0:   bridge window [mem 0xf2d00000-0xf34fffff]
[    0.177847] pci 0000:00:1c.0:   bridge window [mem 0xf1400000-0xf1bfffff 64bit pref]
[    0.177998] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.178097] pci 0000:00:1c.1:   bridge window [mem 0xf2c00000-0xf2cfffff]
[    0.178205] pci 0000:00:1c.2: PCI bridge to [bus 04-0b]
[    0.178303] pci 0000:00:1c.2:   bridge window [io  0x3000-0x3fff]
[    0.178404] pci 0000:00:1c.2:   bridge window [mem 0xf2400000-0xf2bfffff]
[    0.178505] pci 0000:00:1c.2:   bridge window [mem 0xf1c00000-0xf23fffff 64bit pref]
[    0.178654] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.178655] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.178656] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.178658] pci_bus 0000:00: resource 7 [mem 0xbfa00000-0xfebfffff]
[    0.178659] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed4bfff]
[    0.178660] pci_bus 0000:01: resource 0 [io  0x5000-0x5fff]
[    0.178661] pci_bus 0000:01: resource 1 [mem 0xf0000000-0xf0ffffff]
[    0.178663] pci_bus 0000:01: resource 2 [mem 0xc0000000-0xd1ffffff 64bit pref]
[    0.178664] pci_bus 0000:02: resource 0 [io  0x4000-0x4fff]
[    0.178665] pci_bus 0000:02: resource 1 [mem 0xf2d00000-0xf34fffff]
[    0.178667] pci_bus 0000:02: resource 2 [mem 0xf1400000-0xf1bfffff 64bit pref]
[    0.178668] pci_bus 0000:03: resource 1 [mem 0xf2c00000-0xf2cfffff]
[    0.178669] pci_bus 0000:04: resource 0 [io  0x3000-0x3fff]
[    0.178671] pci_bus 0000:04: resource 1 [mem 0xf2400000-0xf2bfffff]
[    0.178672] pci_bus 0000:04: resource 2 [mem 0xf1c00000-0xf23fffff 64bit pref]
[    0.178693] NET: Registered protocol family 2
[    0.178928] TCP established hash table entries: 32768 (order: 6, 262144 bytes)
[    0.179141] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
[    0.179328] TCP: Hash tables configured (established 32768 bind 32768)
[    0.179442] TCP: reno registered
[    0.179545] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.179659] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
[    0.179803] NET: Registered protocol family 1
[    0.179914] pci 0000:00:02.0: Boot video device
[    0.180445] PCI: CLS 64 bytes, default 64
[    0.180480] Unpacking initramfs...
[    0.419917] Freeing initrd memory: 18692K (ffff880035b6f000 - ffff880036db0000)
[    0.420092] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.420193] software IO TLB [mem 0xaad30000-0xaed30000] (64MB) mapped at [ffff8800aad30000-ffff8800aed2ffff]
[    0.420565] resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
[    0.420713] ------------[ cut here ]------------
[    0.420810] WARNING: CPU: 0 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x2dd/0x380()
[    0.420962] Info: mapping multiple BARs. Your kernel is fine.
[    0.421012] Modules linked in:
[    0.421235] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.15.0-0.rc1.git0.1.fc21.x86_64 #1
[    0.421377] Hardware name: LENOVO 2356JK8/2356JK8, BIOS G7ET94WW (2.54 ) 04/30/2013
[    0.421518]  0000000000000000 00000000294ea4b4 ffff8801385f9b08 ffffffff8170077e
[    0.421829]  ffff8801385f9b50 ffff8801385f9b40 ffffffff81089f6d ffffc90000670000
[    0.422142]  ffff8800a874e200 ffffc90000670000 ffffc90000670000 0000000000006000
[    0.422450] Call Trace:
[    0.422545]  [<ffffffff8170077e>] dump_stack+0x45/0x56
[    0.422642]  [<ffffffff81089f6d>] warn_slowpath_common+0x7d/0xa0
[    0.422738]  [<ffffffff81089fec>] warn_slowpath_fmt+0x5c/0x80
[    0.422834]  [<ffffffff810911d8>] ? iomem_map_sanity_check+0xc8/0xd0
[    0.422932]  [<ffffffff8105786d>] __ioremap_caller+0x2dd/0x380
[    0.423042]  [<ffffffff81057927>] ioremap_nocache+0x17/0x20
[    0.423138]  [<ffffffff81033d0c>] snb_uncore_imc_init_box+0x7c/0xc0
[    0.423235]  [<ffffffff81036da5>] uncore_pci_probe+0xd5/0x1b0
[    0.423334]  [<ffffffff8139c915>] local_pci_probe+0x45/0xa0
[    0.423430]  [<ffffffff8139dca9>] pci_device_probe+0xf9/0x150
[    0.423527]  [<ffffffff8146d39c>] driver_probe_device+0x9c/0x3d0
[    0.423625]  [<ffffffff8146d79b>] __driver_attach+0x8b/0x90
[    0.423722]  [<ffffffff8146d710>] ? __device_attach+0x40/0x40
[    0.423818]  [<ffffffff8146b0c3>] bus_for_each_dev+0x73/0xc0
[    0.423915]  [<ffffffff8146cdee>] driver_attach+0x1e/0x20
[    0.424038]  [<ffffffff8146c990>] bus_add_driver+0x180/0x250
[    0.424137]  [<ffffffff81d4990d>] ? uncore_types_init+0x1a7/0x1a7
[    0.424234]  [<ffffffff8146de44>] driver_register+0x64/0xf0
[    0.424330]  [<ffffffff81d4990d>] ? uncore_types_init+0x1a7/0x1a7
[    0.424427]  [<ffffffff8139c1cc>] __pci_register_driver+0x4c/0x50
[    0.424524]  [<ffffffff81d49a81>] intel_uncore_init+0x174/0x416
[    0.424622]  [<ffffffff81d4990d>] ? uncore_types_init+0x1a7/0x1a7
[    0.424719]  [<ffffffff81002162>] do_one_initcall+0xf2/0x1b0
[    0.424816]  [<ffffffff810abd1d>] ? parse_args+0x21d/0x4d0
[    0.424913]  [<ffffffff81d3d087>] kernel_init_freeable+0x1b8/0x254
[    0.425018]  [<ffffffff816f48e0>] ? rest_init+0x80/0x80
[    0.425114]  [<ffffffff816f48ee>] kernel_init+0xe/0xf0
[    0.425211]  [<ffffffff8171043c>] ret_from_fork+0x7c/0xb0
[    0.425306]  [<ffffffff816f48e0>] ? rest_init+0x80/0x80
[    0.425405] ---[ end trace 6765dd4a297528d0 ]---


--PNTmBPCT7hxwcZjr--
