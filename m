Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3LLRcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 12:32:07 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:33303 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3LLRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 12:32:02 -0500
Message-ID: <1386869221.1791.311.camel@misato.fc.hp.com>
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org
Date: Thu, 12 Dec 2013 10:27:01 -0700
In-Reply-To: <1386866583.1791.310.camel@misato.fc.hp.com>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
	 <20131212002946.GF8863@pd.tnic>
	 <1386808323.1791.299.camel@misato.fc.hp.com>
	 <1386810484.1791.306.camel@misato.fc.hp.com>
	 <1386810620.1791.307.camel@misato.fc.hp.com>
	 <20131212162351.GA26927@pd.tnic>
	 <1386866583.1791.310.camel@misato.fc.hp.com>
Content-Type: multipart/mixed; boundary="=-kdKEQaSuD1L4Kg5e9cpT"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kdKEQaSuD1L4Kg5e9cpT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Thu, 2013-12-12 at 09:43 -0700, Toshi Kani wrote:
> On Thu, 2013-12-12 at 17:23 +0100, Borislav Petkov wrote:
> > On Wed, Dec 11, 2013 at 06:10:20PM -0700, Toshi Kani wrote:
> > > > Unfortunately, it did not work.  Hit the same panic again.
> > > 
> > > dmesg output attached.
> > 
> > Ok, thanks.
> > 
> > Let's have a look at the EFI pagetable then. Please apply the attached
> > patch, make sure CONFIG_X86_PTDUMP is enabled, build, boot and catch
> > full dmesg again and send it to me.
> 
> Yes, I will test with the change, and send a full dmesg output to you.

Attached.

Thanks!
-Toshi

--=-kdKEQaSuD1L4Kg5e9cpT
Content-Disposition: attachment; filename="log.efi.panic6"
Content-Type: text/plain; name="log.efi.panic6"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

[Linux-EFI, setup=0x10e3, size=0x425a30]
   [Initrd, addr=0x7413e000, size=0x11aa91c]
Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Initializing cgroup subsys cpuacct
Linux version 3.12.0+ (toshi@misato.fc.hp.com) (gcc version 4.8.2 20131017 (Red Hat 4.8.2-1) (GCC) ) #56 SMP Thu Dec 12 09:43:25 MST 2013
Command line: ro root=/dev/mapper/vg_dhf1-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD  KEYTABLE=us console=ttyS0,115200 rd_LVM_LV=vg_dhf1/lv_swap crashkernel=512M rd_LVM_LV=vg_dhf1/lv_root SYSFONT=latarcyrheb-sun16 rd_NO_DM
e820: BIOS-provided physical RAM map:
BIOS-e820: [mem 0x0000000000000000-0x000000000008dfff] usable
BIOS-e820: [mem 0x000000000008e000-0x000000000008ffff] reserved
BIOS-e820: [mem 0x0000000000090000-0x000000000009ffff] usable
BIOS-e820: [mem 0x0000000000100000-0x000000006de77fff] usable
BIOS-e820: [mem 0x000000006de78000-0x000000006ee77fff] ACPI NVS
BIOS-e820: [mem 0x000000006ee78000-0x00000000721fefff] usable
BIOS-e820: [mem 0x00000000721ff000-0x0000000072efefff] reserved
BIOS-e820: [mem 0x0000000072eff000-0x0000000073efefff] ACPI NVS
BIOS-e820: [mem 0x0000000073eff000-0x0000000073ffefff] ACPI data
BIOS-e820: [mem 0x0000000073fff000-0x000000007bffffff] usable
BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
BIOS-e820: [mem 0x00000000ff000000-0x00000000ff1fffff] reserved
BIOS-e820: [mem 0x0000000100000000-0x000000087fffffff] usable
BIOS-e820: [mem 0x0000020000000000-0x00000203ffffffff] usable
BIOS-e820: [mem 0x00003fdfe0000000-0x00003fdff3ffffff] reserved
BIOS-e820: [mem 0x00003fe060000000-0x00003fe073ffffff] reserved
BIOS-e820: [mem 0x00003fe0e0000000-0x00003fe0f3ffffff] reserved
BIOS-e820: [mem 0x00003fe160000000-0x00003fe173ffffff] reserved
BIOS-e820: [mem 0x00003fe1e0000000-0x00003fe1f3ffffff] reserved
BIOS-e820: [mem 0x00003fe260000000-0x00003fe273ffffff] reserved
BIOS-e820: [mem 0x00003fe2e0000000-0x00003fe2f3ffffff] reserved
BIOS-e820: [mem 0x00003fe360000000-0x00003fe373ffffff] reserved
BIOS-e820: [mem 0x00003fe3e0000000-0x00003fe3f3ffffff] reserved
BIOS-e820: [mem 0x00003fe460000000-0x00003fe473ffffff] reserved
BIOS-e820: [mem 0x00003fe4e0000000-0x00003fe4f3ffffff] reserved
BIOS-e820: [mem 0x00003fe560000000-0x00003fe573ffffff] reserved
BIOS-e820: [mem 0x00003fe5e0000000-0x00003fe5f3ffffff] reserved
BIOS-e820: [mem 0x00003fe660000000-0x00003fe673ffffff] reserved
BIOS-e820: [mem 0x00003fe6e0000000-0x00003fe6f3ffffff] reserved
BIOS-e820: [mem 0x00003fe760000000-0x00003fe773ffffff] reserved
BIOS-e820: [mem 0x00003fe7e0000000-0x00003fe7f3ffffff] reserved
NX (Execute Disable) protection: active
efi: EFI v2.31 by HP
efi:  ACPI=0x73ffe000  ACPI 2.0=0x73ffe014  SMBIOS=0x72ef8000 
efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
efi: mem01: type=7, attr=0xf, range=[0x0000000000001000-0x000000000008c000) (0MB)
efi: mem02: type=2, attr=0xf, range=[0x000000000008c000-0x000000000008e000) (0MB)
efi: mem03: type=0, attr=0xf, range=[0x000000000008e000-0x0000000000090000) (0MB)
efi: mem04: type=7, attr=0xf, range=[0x0000000000090000-0x00000000000a0000) (0MB)
efi: mem05: type=7, attr=0xf, range=[0x0000000000100000-0x0000000010000000) (255MB)
efi: mem06: type=3, attr=0xf, range=[0x0000000010000000-0x0000000010065000) (0MB)
efi: mem07: type=7, attr=0xf, range=[0x0000000010065000-0x000000005de00000) (1245MB)
efi: mem08: type=4, attr=0xf, range=[0x000000005de00000-0x000000005e000000) (2MB)
efi: mem09: type=7, attr=0xf, range=[0x000000005e000000-0x000000006d652000) (246MB)
efi: mem10: type=2, attr=0xf, range=[0x000000006d652000-0x000000006de78000) (8MB)
efi: mem11: type=10, attr=0xf, range=[0x000000006de78000-0x000000006ee78000) (16MB)
efi: mem12: type=4, attr=0xf, range=[0x000000006ee78000-0x00000000709fc000) (27MB)
efi: mem13: type=7, attr=0xf, range=[0x00000000709fc000-0x0000000070dfa000) (3MB)
efi: mem14: type=2, attr=0xf, range=[0x0000000070dfa000-0x0000000070dff000) (0MB)
efi: mem15: type=7, attr=0xf, range=[0x0000000070dff000-0x000000007109e000) (2MB)
efi: mem16: type=1, attr=0xf, range=[0x000000007109e000-0x00000000711ff000) (1MB)
efi: mem17: type=7, attr=0xf, range=[0x00000000711ff000-0x000000007182d000) (6MB)
efi: mem18: type=3, attr=0xf, range=[0x000000007182d000-0x00000000721ff000) (9MB)
efi: mem19: type=6, attr=0x800000000000000f, range=[0x00000000721ff000-0x00000000725ff000) (4MB)
efi: mem20: type=5, attr=0x800000000000000f, range=[0x00000000725ff000-0x0000000072dff000) (8MB)
efi: mem21: type=0, attr=0xf, range=[0x0000000072dff000-0x0000000072eff000) (1MB)
efi: mem22: type=10, attr=0xf, range=[0x0000000072eff000-0x0000000073eff000) (16MB)
efi: mem23: type=9, attr=0xf, range=[0x0000000073eff000-0x0000000073fff000) (1MB)
efi: mem24: type=7, attr=0xf, range=[0x0000000073fff000-0x000000007413e000) (1MB)
efi: mem25: type=2, attr=0xf, range=[0x000000007413e000-0x00000000752e9000) (17MB)
efi: mem26: type=4, attr=0xf, range=[0x00000000752e9000-0x000000007540a000) (1MB)
efi: mem27: type=7, attr=0xf, range=[0x000000007540a000-0x0000000075462000) (0MB)
efi: mem28: type=4, attr=0xf, range=[0x0000000075462000-0x000000007c000000) (107MB)
efi: mem29: type=7, attr=0xf, range=[0x0000000100000000-0x0000000880000000) (30720MB)
efi: mem30: type=7, attr=0xf, range=[0x0000020000000000-0x0000020400000000) (16384MB)
efi: mem31: type=11, attr=0x8000000000000001, range=[0x0000000080000000-0x0000000090000000) (256MB)
efi: mem32: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
efi: mem33: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x00000000ff200000) (2MB)
efi: mem34: type=11, attr=0x8000000000000001, range=[0x00003fdfe0000000-0x00003fdff4000000) (320MB)
efi: mem35: type=11, attr=0x8000000000000001, range=[0x00003fe060000000-0x00003fe074000000) (320MB)
efi: mem36: type=11, attr=0x8000000000000001, range=[0x00003fe0e0000000-0x00003fe0f4000000) (320MB)
efi: mem37: type=11, attr=0x8000000000000001, range=[0x00003fe160000000-0x00003fe174000000) (320MB)
efi: mem38: type=11, attr=0x8000000000000001, range=[0x00003fe1e0000000-0x00003fe1f4000000) (320MB)
efi: mem39: type=11, attr=0x8000000000000001, range=[0x00003fe260000000-0x00003fe274000000) (320MB)
efi: mem40: type=11, attr=0x8000000000000001, range=[0x00003fe2e0000000-0x00003fe2f4000000) (320MB)
efi: mem41: type=11, attr=0x8000000000000001, range=[0x00003fe360000000-0x00003fe374000000) (320MB)
efi: mem42: type=11, attr=0x8000000000000001, range=[0x00003fe3e0000000-0x00003fe3f4000000) (320MB)
efi: mem43: type=11, attr=0x8000000000000001, range=[0x00003fe460000000-0x00003fe474000000) (320MB)
efi: mem44: type=11, attr=0x8000000000000001, range=[0x00003fe4e0000000-0x00003fe4f4000000) (320MB)
efi: mem45: type=11, attr=0x8000000000000001, range=[0x00003fe560000000-0x00003fe574000000) (320MB)
efi: mem46: type=11, attr=0x8000000000000001, range=[0x00003fe5e0000000-0x00003fe5f4000000) (320MB)
efi: mem47: type=11, attr=0x8000000000000001, range=[0x00003fe660000000-0x00003fe674000000) (320MB)
efi: mem48: type=11, attr=0x8000000000000001, range=[0x00003fe6e0000000-0x00003fe6f4000000) (320MB)
efi: mem49: type=11, attr=0x8000000000000001, range=[0x00003fe760000000-0x00003fe774000000) (320MB)
efi: mem50: type=11, attr=0x8000000000000001, range=[0x00003fe7e0000000-0x00003fe7f4000000) (320MB)
SMBIOS 2.7 present.
No AGP bridge found
e820: last_pfn = 0x20400000 max_arch_pfn = 0x400000000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
x2apic enabled by BIOS, switching to x2apic ops
e820: last_pfn = 0x7c000 max_arch_pfn = 0x400000000
Using GB pages for direct mapping
init_memory_mapping: [mem 0x00000000-0x000fffff]
init_memory_mapping: [mem 0x203ffe00000-0x203ffffffff]
init_memory_mapping: [mem 0x203fc000000-0x203ffdfffff]
init_memory_mapping: [mem 0x20380000000-0x203fbffffff]
init_memory_mapping: [mem 0x20000000000-0x2037fffffff]
init_memory_mapping: [mem 0x00100000-0x6de77fff]
init_memory_mapping: [mem 0x6ee78000-0x721fefff]
init_memory_mapping: [mem 0x73fff000-0x7bffffff]
init_memory_mapping: [mem 0x100000000-0x87fffffff]
RAMDISK: [mem 0x7413e000-0x752e8fff]
Reserving 512MB of memory at 384MB for crashkernel (System RAM: 49041MB)
ACPI: RSDP 0000000073ffe014 00024 (v02 HP    )
ACPI: XSDT 0000000073ffd0e8 000AC (v01 HP     03010201 00000002 MSFT 01000013)
ACPI: FACP 0000000073ffb000 0010C (v05 HP     03010201 00000002 HPAG 00020000)
ACPI: DSDT 0000000073ff1000 00864 (v02 HP     CORE     00000002 HPAG 00020000)
ACPI: FACS 0000000073e82000 00040
ACPI: MCEJ 0000000073ffc000 00130 (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: HPET 0000000073ffa000 00038 (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: MCFG 0000000073ff9000 0003C (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: SLIT 0000000073ff8000 0003C (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: APIC 0000000073ff7000 00684 (v03 HP     03010201 00000002 HPAG 00020000)
ACPI: SRAT 0000000073ff6000 005E8 (v02 HP     03010201 00000002 HPAG 00020000)
ACPI: SPMI 0000000073ff5000 00040 (v05 HP     03010201 00000002 HPAG 00020000)
ACPI: SPCR 0000000073ff4000 00050 (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: DBGP 0000000073ff3000 00034 (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: RASF 0000000073ff2000 00030 (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: SSDT 0000000073fda000 166BC (v02 HP     BLADE000 00000002 HPAG 00020000)
ACPI: DMAR 0000000073fd8000 001D0 (v01 HP     03010201 00000002 HPAG 00020000)
ACPI: HEST 0000000073fd7000 00144 (v01 INTEL           00000001 INTL 00000001)
ACPI: BERT 0000000073fd6000 00030 (v01 INTEL           00000001 INTL 00000001)
ACPI: ERST 0000000073fd5000 00230 (v01 INTEL           00000001 INTL 00000001)
ACPI: EINJ 0000000073fd4000 00150 (v01 INTEL           00000001 INTL 00000001)
Setting APIC routing to physical x2apic.
SRAT: PXM 1 -> APIC 0x0000 -> Node 0
SRAT: PXM 1 -> APIC 0x0001 -> Node 0
SRAT: PXM 1 -> APIC 0x0002 -> Node 0
SRAT: PXM 1 -> APIC 0x0003 -> Node 0
SRAT: PXM 1 -> APIC 0x0004 -> Node 0
SRAT: PXM 1 -> APIC 0x0005 -> Node 0
SRAT: PXM 1 -> APIC 0x0006 -> Node 0
SRAT: PXM 1 -> APIC 0x0007 -> Node 0
SRAT: PXM 1 -> APIC 0x0008 -> Node 0
SRAT: PXM 1 -> APIC 0x0009 -> Node 0
SRAT: PXM 1 -> APIC 0x000a -> Node 0
SRAT: PXM 1 -> APIC 0x000b -> Node 0
SRAT: PXM 1 -> APIC 0x000c -> Node 0
SRAT: PXM 1 -> APIC 0x000d -> Node 0
SRAT: PXM 1 -> APIC 0x000e -> Node 0
SRAT: PXM 1 -> APIC 0x000f -> Node 0
SRAT: PXM 1 -> APIC 0x0010 -> Node 0
SRAT: PXM 1 -> APIC 0x0011 -> Node 0
SRAT: PXM 1 -> APIC 0x0012 -> Node 0
SRAT: PXM 1 -> APIC 0x0013 -> Node 0
SRAT: PXM 1 -> APIC 0x0014 -> Node 0
SRAT: PXM 1 -> APIC 0x0015 -> Node 0
SRAT: PXM 1 -> APIC 0x0016 -> Node 0
SRAT: PXM 1 -> APIC 0x0017 -> Node 0
SRAT: PXM 1 -> APIC 0x0018 -> Node 0
SRAT: PXM 1 -> APIC 0x0019 -> Node 0
SRAT: PXM 1 -> APIC 0x001a -> Node 0
SRAT: PXM 1 -> APIC 0x001b -> Node 0
SRAT: PXM 2 -> APIC 0x0022 -> Node 1
SRAT: PXM 2 -> APIC 0x0023 -> Node 1
SRAT: PXM 2 -> APIC 0x0024 -> Node 1
SRAT: PXM 2 -> APIC 0x0025 -> Node 1
SRAT: PXM 2 -> APIC 0x0026 -> Node 1
SRAT: PXM 2 -> APIC 0x0027 -> Node 1
SRAT: PXM 2 -> APIC 0x0028 -> Node 1
SRAT: PXM 2 -> APIC 0x0029 -> Node 1
SRAT: PXM 2 -> APIC 0x002a -> Node 1
SRAT: PXM 2 -> APIC 0x002b -> Node 1
SRAT: PXM 2 -> APIC 0x002c -> Node 1
SRAT: PXM 2 -> APIC 0x002d -> Node 1
SRAT: PXM 2 -> APIC 0x002e -> Node 1
SRAT: PXM 2 -> APIC 0x002f -> Node 1
SRAT: PXM 2 -> APIC 0x0030 -> Node 1
SRAT: PXM 2 -> APIC 0x0031 -> Node 1
SRAT: PXM 2 -> APIC 0x0032 -> Node 1
SRAT: PXM 2 -> APIC 0x0033 -> Node 1
SRAT: PXM 2 -> APIC 0x0034 -> Node 1
SRAT: PXM 2 -> APIC 0x0035 -> Node 1
SRAT: PXM 2 -> APIC 0x0036 -> Node 1
SRAT: PXM 2 -> APIC 0x0037 -> Node 1
SRAT: PXM 2 -> APIC 0x0038 -> Node 1
SRAT: PXM 2 -> APIC 0x0039 -> Node 1
SRAT: PXM 2 -> APIC 0x003a -> Node 1
SRAT: PXM 2 -> APIC 0x003b -> Node 1
SRAT: PXM 2 -> APIC 0x003c -> Node 1
SRAT: PXM 2 -> APIC 0x003d -> Node 1
SRAT: Node 0 PXM 1 [mem 0x00000000-0x7fffffff]
SRAT: Node 0 PXM 1 [mem 0x100000000-0x87fffffff]
SRAT: Node 1 PXM 2 [mem 0x20000000000-0x203ffffffff]
NUMA: Warning: node ids are out of bound, from=-1 to=-1 distance=10
NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x87fffffff] -> [mem 0x00000000-0x87fffffff]
Initmem setup node 0 [mem 0x00000000-0x87fffffff]
  NODE_DATA [mem 0x87ffd9000-0x87fffffff]
Initmem setup node 1 [mem 0x20000000000-0x203ffffffff]
  NODE_DATA [mem 0x203fffd5000-0x203ffffbfff]
Zone ranges:
  DMA      [mem 0x00001000-0x00ffffff]
  DMA32    [mem 0x01000000-0xffffffff]
  Normal   [mem 0x100000000-0x203ffffffff]
Movable zone start for each node
Early memory node ranges
  node   0: [mem 0x00001000-0x0008dfff]
  node   0: [mem 0x00090000-0x0009ffff]
  node   0: [mem 0x00100000-0x6de77fff]
  node   0: [mem 0x6ee78000-0x721fefff]
  node   0: [mem 0x73fff000-0x7bffffff]
  node   0: [mem 0x100000000-0x87fffffff]
  node   1: [mem 0x20000000000-0x203ffffffff]
ACPI: X2APIC (apic_id[0x00] uid[0x00] enabled)
ACPI: X2APIC (apic_id[0x02] uid[0x02] enabled)
ACPI: X2APIC (apic_id[0x04] uid[0x04] enabled)
ACPI: X2APIC (apic_id[0x06] uid[0x06] enabled)
ACPI: X2APIC (apic_id[0x08] uid[0x08] enabled)
ACPI: X2APIC (apic_id[0x0a] uid[0x0a] enabled)
ACPI: X2APIC (apic_id[0x0c] uid[0x0c] enabled)
ACPI: X2APIC (apic_id[0x0e] uid[0x0e] enabled)
ACPI: X2APIC (apic_id[0x10] uid[0x10] enabled)
ACPI: X2APIC (apic_id[0x12] uid[0x12] enabled)
ACPI: X2APIC (apic_id[0x14] uid[0x14] enabled)
ACPI: X2APIC (apic_id[0x16] uid[0x16] enabled)
ACPI: X2APIC (apic_id[0x18] uid[0x18] enabled)
ACPI: X2APIC (apic_id[0x1a] uid[0x1a] enabled)
ACPI: X2APIC (apic_id[0x22] uid[0x26] enabled)
ACPI: X2APIC (apic_id[0x24] uid[0x28] enabled)
ACPI: X2APIC (apic_id[0x26] uid[0x2a] enabled)
ACPI: X2APIC (apic_id[0x28] uid[0x2c] enabled)
ACPI: X2APIC (apic_id[0x2a] uid[0x2e] enabled)
ACPI: X2APIC (apic_id[0x2c] uid[0x30] enabled)
ACPI: X2APIC (apic_id[0x2e] uid[0x32] enabled)
ACPI: X2APIC (apic_id[0x30] uid[0x34] enabled)
ACPI: X2APIC (apic_id[0x32] uid[0x36] enabled)
ACPI: X2APIC (apic_id[0x34] uid[0x38] enabled)
ACPI: X2APIC (apic_id[0x36] uid[0x3a] enabled)
ACPI: X2APIC (apic_id[0x38] uid[0x3c] enabled)
ACPI: X2APIC (apic_id[0x3a] uid[0x3e] enabled)
ACPI: X2APIC (apic_id[0x3c] uid[0x40] enabled)
ACPI: X2APIC (apic_id[0x01] uid[0x01] enabled)
ACPI: X2APIC (apic_id[0x03] uid[0x03] enabled)
ACPI: X2APIC (apic_id[0x05] uid[0x05] enabled)
ACPI: X2APIC (apic_id[0x07] uid[0x07] enabled)
ACPI: X2APIC (apic_id[0x09] uid[0x09] enabled)
ACPI: X2APIC (apic_id[0x0b] uid[0x0b] enabled)
ACPI: X2APIC (apic_id[0x0d] uid[0x0d] enabled)
ACPI: X2APIC (apic_id[0x0f] uid[0x0f] enabled)
ACPI: X2APIC (apic_id[0x11] uid[0x11] enabled)
ACPI: X2APIC (apic_id[0x13] uid[0x13] enabled)
ACPI: X2APIC (apic_id[0x15] uid[0x15] enabled)
ACPI: X2APIC (apic_id[0x17] uid[0x17] enabled)
ACPI: X2APIC (apic_id[0x19] uid[0x19] enabled)
ACPI: X2APIC (apic_id[0x1b] uid[0x1b] enabled)
ACPI: X2APIC (apic_id[0x23] uid[0x27] enabled)
ACPI: X2APIC (apic_id[0x25] uid[0x29] enabled)
ACPI: X2APIC (apic_id[0x27] uid[0x2b] enabled)
ACPI: X2APIC (apic_id[0x29] uid[0x2d] enabled)
ACPI: X2APIC (apic_id[0x2b] uid[0x2f] enabled)
ACPI: X2APIC (apic_id[0x2d] uid[0x31] enabled)
ACPI: X2APIC (apic_id[0x2f] uid[0x33] enabled)
ACPI: X2APIC (apic_id[0x31] uid[0x35] enabled)
ACPI: X2APIC (apic_id[0x33] uid[0x37] enabled)
ACPI: X2APIC (apic_id[0x35] uid[0x39] enabled)
ACPI: X2APIC (apic_id[0x37] uid[0x3b] enabled)
ACPI: X2APIC (apic_id[0x39] uid[0x3d] enabled)
ACPI: X2APIC (apic_id[0x3b] uid[0x3f] enabled)
ACPI: X2APIC (apic_id[0x3d] uid[0x41] enabled)
ACPI: X2APIC_NMI (uid[0x00] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x01] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x02] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x03] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x04] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x05] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x06] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x07] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x08] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x09] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x0a] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x0b] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x0c] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x0d] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x0e] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x0f] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x10] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x11] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x12] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x13] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x14] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x15] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x16] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x17] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x18] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x19] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x1a] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x1b] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x26] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x27] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x28] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x29] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x2a] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x2b] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x2c] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x2d] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x2e] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x2f] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x30] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x31] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x32] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x33] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x34] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x35] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x36] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x37] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x38] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x39] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x3a] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x3b] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x3c] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x3d] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x3e] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x3f] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x40] high level lint[0x1])
ACPI: X2APIC_NMI (uid[0x41] high level lint[0x1])
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec01000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec01000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec04000] gsi_base[48])
IOAPIC[2]: apic_id 10, version 32, address 0xfec04000, GSI 48-71
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a301 base: 0xfed00000
smpboot: Allowing 56 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: [mem 0x0008e000-0x0008ffff]
PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
PM: Registered nosave memory: [mem 0x6de78000-0x6ee77fff]
PM: Registered nosave memory: [mem 0x721ff000-0x72efefff]
PM: Registered nosave memory: [mem 0x72eff000-0x73efefff]
PM: Registered nosave memory: [mem 0x73eff000-0x73ffefff]
PM: Registered nosave memory: [mem 0x7c000000-0x7fffffff]
PM: Registered nosave memory: [mem 0x80000000-0x8fffffff]
PM: Registered nosave memory: [mem 0x90000000-0xfed1bfff]
PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
PM: Registered nosave memory: [mem 0xff000000-0xff1fffff]
PM: Registered nosave memory: [mem 0xff200000-0xffffffff]
PM: Registered nosave memory: [mem 0x880000000-0x1ffffffffff]
e820: [mem 0x90000000-0xfed1bfff] available for PCI devices
setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:56 nr_node_ids:2
PERCPU: Embedded 27 pages/cpu @ffff88087fa00000 s80704 r8192 d21696 u131072
Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 12382984
Policy zone: Normal
Kernel command line: ro root=/dev/mapper/vg_dhf1-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD  KEYTABLE=us console=ttyS0,115200 rd_LVM_LV=vg_dhf1/lv_swap crashkernel=512M rd_LVM_LV=vg_dhf1/lv_root SYSFONT=latarcyrheb-sun16 rd_NO_DM
PID hash table entries: 4096 (order: 3, 32768 bytes)
xsave: enabled xstate_bv 0x7, cntxt size 0x340
Checking aperture...
No AGP bridge found
Memory: 48748476K/50218612K available (5405K kernel code, 854K rwdata, 2576K rodata, 1672K init, 1872K bss, 1470136K reserved)
Hierarchical RCU implementation.
	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=56.
NR_IRQS:16640 nr_irqs:1944 16
Console: colour dummy device 80x25
console [ttyS0] enabled
tsc: Fast TSC calibration using PIT
tsc: Detected 2799.880 MHz processor
Calibrating delay loop (skipped), value calculated using timer frequency.. 5599.76 BogoMIPS (lpj=2799880)
pid_max: default: 57344 minimum: 448
PA: 0x0 -> VA: 0x0
PA: 0x0 -> VA: 0xffffffff00000000
PA: 0x10000000 -> VA: 0x10000000
PA: 0x10000000 -> VA: 0xfffffffeffe00000
PA: 0x5de00000 -> VA: 0x5de00000
PA: 0x5de00000 -> VA: 0xfffffffeffc00000
PA: 0x6ee78000 -> VA: 0x6ee78000
PA: 0x6ee78000 -> VA: 0xfffffffefe078000
PA: 0x7182d000 -> VA: 0x7182d000
PA: 0x7182d000 -> VA: 0xfffffffefd62d000
PA: 0x721ff000 -> VA: 0x721ff000
PA: 0x721ff000 -> VA: 0xfffffffefd1ff000
PA: 0x725ff000 -> VA: 0x725ff000
PA: 0x725ff000 -> VA: 0xfffffffefc9ff000
PA: 0x752e9000 -> VA: 0x752e9000
PA: 0x752e9000 -> VA: 0xfffffffefc6e9000
PA: 0x75462000 -> VA: 0x75462000
PA: 0x75462000 -> VA: 0xfffffffef5a62000
PA: 0x80000000 -> VA: 0x80000000
PA: 0x80000000 -> VA: 0xfffffffee5a00000
PA: 0xfed1c000 -> VA: 0xfed1c000
PA: 0xfed1c000 -> VA: 0xfffffffee591c000
PA: 0xff000000 -> VA: 0xff000000
PA: 0xff000000 -> VA: 0xfffffffee5600000
PA: 0x3fdfe0000000 -> VA: 0x3fdfe0000000
PA: 0x3fdfe0000000 -> VA: 0xfffffffed1600000
PA: 0x3fe060000000 -> VA: 0x3fe060000000
PA: 0x3fe060000000 -> VA: 0xfffffffebd600000
PA: 0x3fe0e0000000 -> VA: 0x3fe0e0000000
PA: 0x3fe0e0000000 -> VA: 0xfffffffea9600000
PA: 0x3fe160000000 -> VA: 0x3fe160000000
PA: 0x3fe160000000 -> VA: 0xfffffffe95600000
PA: 0x3fe1e0000000 -> VA: 0x3fe1e0000000
PA: 0x3fe1e0000000 -> VA: 0xfffffffe81600000
PA: 0x3fe260000000 -> VA: 0x3fe260000000
PA: 0x3fe260000000 -> VA: 0xfffffffe6d600000
PA: 0x3fe2e0000000 -> VA: 0x3fe2e0000000
PA: 0x3fe2e0000000 -> VA: 0xfffffffe59600000
PA: 0x3fe360000000 -> VA: 0x3fe360000000
PA: 0x3fe360000000 -> VA: 0xfffffffe45600000
PA: 0x3fe3e0000000 -> VA: 0x3fe3e0000000
PA: 0x3fe3e0000000 -> VA: 0xfffffffe31600000
PA: 0x3fe460000000 -> VA: 0x3fe460000000
PA: 0x3fe460000000 -> VA: 0xfffffffe1d600000
PA: 0x3fe4e0000000 -> VA: 0x3fe4e0000000
PA: 0x3fe4e0000000 -> VA: 0xfffffffe09600000
PA: 0x3fe560000000 -> VA: 0x3fe560000000
PA: 0x3fe560000000 -> VA: 0xfffffffdf5600000
PA: 0x3fe5e0000000 -> VA: 0x3fe5e0000000
PA: 0x3fe5e0000000 -> VA: 0xfffffffde1600000
PA: 0x3fe660000000 -> VA: 0x3fe660000000
PA: 0x3fe660000000 -> VA: 0xfffffffdcd600000
PA: 0x3fe6e0000000 -> VA: 0x3fe6e0000000
PA: 0x3fe6e0000000 -> VA: 0xfffffffdb9600000
PA: 0x3fe760000000 -> VA: 0x3fe760000000
PA: 0x3fe760000000 -> VA: 0xfffffffda5600000
PA: 0x3fe7e0000000 -> VA: 0x3fe7e0000000
PA: 0x3fe7e0000000 -> VA: 0xfffffffd91600000
efi: desc_size: 48, count: 29, new_memmap: ffff8a03fec16800, pa: 0x203fec16800
---[ User Space ]---
0x0000000000000000-0x0000000000200000           2M     RW             GLB NX pte
0x0000000000200000-0x0000000010000000         254M     RW         PSE GLB NX pmd
0x0000000010000000-0x0000000010065000         404K     RW             GLB x  pte
0x0000000010065000-0x0000000010200000        1644K     RW             GLB NX pte
0x0000000010200000-0x000000005de00000        1244M     RW         PSE GLB NX pmd
0x000000005de00000-0x000000005e000000           2M     RW         PSE GLB x  pmd
0x000000005e000000-0x000000006de00000         254M     RW         PSE GLB NX pmd
0x000000006de00000-0x000000006de78000         480K     RW             GLB NX pte
0x000000006de78000-0x000000006e000000        1568K                           pte
0x000000006e000000-0x000000006ee00000          14M                           pmd
0x000000006ee00000-0x000000006ee78000         480K                           pte
0x000000006ee78000-0x000000006f000000        1568K     RW             GLB x  pte
0x000000006f000000-0x0000000070800000          24M     RW         PSE GLB x  pmd
0x0000000070800000-0x00000000709fc000        2032K     RW             GLB x  pte
0x00000000709fc000-0x0000000070a00000          16K     RW             GLB NX pte
0x0000000070a00000-0x0000000071800000          14M     RW         PSE GLB NX pmd
0x0000000071800000-0x000000007182d000         180K     RW             GLB NX pte
0x000000007182d000-0x0000000071a00000        1868K     RW             GLB x  pte
0x0000000071a00000-0x0000000072000000           6M     RW         PSE GLB x  pmd
0x0000000072000000-0x00000000721ff000        2044K     RW             GLB x  pte
0x00000000721ff000-0x0000000072200000           4K     RW                 x  pte
0x0000000072200000-0x0000000072400000           2M     RW         PSE     x  pmd
0x0000000072400000-0x0000000072600000           2M     RW                 x  pte
0x0000000072600000-0x0000000072c00000           6M     RW         PSE     x  pmd
0x0000000072c00000-0x0000000072dff000        2044K     RW                 x  pte
0x0000000072dff000-0x0000000072e00000           4K                           pte
0x0000000072e00000-0x0000000073e00000          16M                           pmd
0x0000000073e00000-0x0000000073fff000        2044K                           pte
0x0000000073fff000-0x0000000074000000           4K     RW             GLB NX pte
0x0000000074000000-0x0000000075200000          18M     RW         PSE GLB NX pmd
0x0000000075200000-0x00000000752e9000         932K     RW             GLB NX pte
0x00000000752e9000-0x000000007540a000        1156K     RW             GLB x  pte
0x000000007540a000-0x0000000075462000         352K     RW             GLB NX pte
0x0000000075462000-0x0000000075600000        1656K     RW             GLB x  pte
0x0000000075600000-0x000000007c000000         106M     RW         PSE GLB x  pmd
0x000000007c000000-0x0000000080000000          64M                           pmd
0x0000000080000000-0x0000000090000000         256M     RW     PCD PSE     x  pmd
0x0000000090000000-0x00000000fec00000        1772M                           pmd
0x00000000fec00000-0x00000000fed1c000        1136K                           pte
0x00000000fed1c000-0x00000000fed20000          16K     RW     PCD         x  pte
0x00000000fed20000-0x00000000fee00000         896K                           pte
0x00000000fee00000-0x00000000ff000000           2M                           pmd
0x00000000ff000000-0x00000000ff200000           2M     RW     PCD PSE     x  pmd
0x00000000ff200000-0x0000000100000000          14M                           pmd
0x0000000100000000-0x0000000880000000          30G     RW         PSE GLB NX pud
0x0000000880000000-0x0000008000000000         478G                           pud
0x0000008000000000-0x00003f8000000000          63T                           pgd
0x00003f8000000000-0x00003fdfc0000000         383G                           pud
0x00003fdfc0000000-0x00003fdfe0000000         512M                           pmd
0x00003fdfe0000000-0x00003fdff4000000         320M     RW     PCD PSE     x  pmd
0x00003fdff4000000-0x00003fe000000000         192M                           pmd
0x00003fe000000000-0x00003fe040000000           1G                           pud
0x00003fe040000000-0x00003fe060000000         512M                           pmd
0x00003fe060000000-0x00003fe074000000         320M     RW     PCD PSE     x  pmd
0x00003fe074000000-0x00003fe080000000         192M                           pmd
0x00003fe080000000-0x00003fe0c0000000           1G                           pud
0x00003fe0c0000000-0x00003fe0e0000000         512M                           pmd
0x00003fe0e0000000-0x00003fe0f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe0f4000000-0x00003fe100000000         192M                           pmd
0x00003fe100000000-0x00003fe140000000           1G                           pud
0x00003fe140000000-0x00003fe160000000         512M                           pmd
0x00003fe160000000-0x00003fe174000000         320M     RW     PCD PSE     x  pmd
0x00003fe174000000-0x00003fe180000000         192M                           pmd
0x00003fe180000000-0x00003fe1c0000000           1G                           pud
0x00003fe1c0000000-0x00003fe1e0000000         512M                           pmd
0x00003fe1e0000000-0x00003fe1f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe1f4000000-0x00003fe200000000         192M                           pmd
0x00003fe200000000-0x00003fe240000000           1G                           pud
0x00003fe240000000-0x00003fe260000000         512M                           pmd
0x00003fe260000000-0x00003fe274000000         320M     RW     PCD PSE     x  pmd
0x00003fe274000000-0x00003fe280000000         192M                           pmd
0x00003fe280000000-0x00003fe2c0000000           1G                           pud
0x00003fe2c0000000-0x00003fe2e0000000         512M                           pmd
0x00003fe2e0000000-0x00003fe2f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe2f4000000-0x00003fe300000000         192M                           pmd
0x00003fe300000000-0x00003fe340000000           1G                           pud
0x00003fe340000000-0x00003fe360000000         512M                           pmd
0x00003fe360000000-0x00003fe374000000         320M     RW     PCD PSE     x  pmd
0x00003fe374000000-0x00003fe380000000         192M                           pmd
0x00003fe380000000-0x00003fe3c0000000           1G                           pud
0x00003fe3c0000000-0x00003fe3e0000000         512M                           pmd
0x00003fe3e0000000-0x00003fe3f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe3f4000000-0x00003fe400000000         192M                           pmd
0x00003fe400000000-0x00003fe440000000           1G                           pud
0x00003fe440000000-0x00003fe460000000         512M                           pmd
0x00003fe460000000-0x00003fe474000000         320M     RW     PCD PSE     x  pmd
0x00003fe474000000-0x00003fe480000000         192M                           pmd
0x00003fe480000000-0x00003fe4c0000000           1G                           pud
0x00003fe4c0000000-0x00003fe4e0000000         512M                           pmd
0x00003fe4e0000000-0x00003fe4f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe4f4000000-0x00003fe500000000         192M                           pmd
0x00003fe500000000-0x00003fe540000000           1G                           pud
0x00003fe540000000-0x00003fe560000000         512M                           pmd
0x00003fe560000000-0x00003fe574000000         320M     RW     PCD PSE     x  pmd
0x00003fe574000000-0x00003fe580000000         192M                           pmd
0x00003fe580000000-0x00003fe5c0000000           1G                           pud
0x00003fe5c0000000-0x00003fe5e0000000         512M                           pmd
0x00003fe5e0000000-0x00003fe5f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe5f4000000-0x00003fe600000000         192M                           pmd
0x00003fe600000000-0x00003fe640000000           1G                           pud
0x00003fe640000000-0x00003fe660000000         512M                           pmd
0x00003fe660000000-0x00003fe674000000         320M     RW     PCD PSE     x  pmd
0x00003fe674000000-0x00003fe680000000         192M                           pmd
0x00003fe680000000-0x00003fe6c0000000           1G                           pud
0x00003fe6c0000000-0x00003fe6e0000000         512M                           pmd
0x00003fe6e0000000-0x00003fe6f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe6f4000000-0x00003fe700000000         192M                           pmd
0x00003fe700000000-0x00003fe740000000           1G                           pud
0x00003fe740000000-0x00003fe760000000         512M                           pmd
0x00003fe760000000-0x00003fe774000000         320M     RW     PCD PSE     x  pmd
0x00003fe774000000-0x00003fe780000000         192M                           pmd
0x00003fe780000000-0x00003fe7c0000000           1G                           pud
0x00003fe7c0000000-0x00003fe7e0000000         512M                           pmd
0x00003fe7e0000000-0x00003fe7f4000000         320M     RW     PCD PSE     x  pmd
0x00003fe7f4000000-0x00003fe800000000         192M                           pmd
0x00003fe800000000-0x0000400000000000          96G                           pud
0x0000400000000000-0xffff800000000000    16777024T                           pgd
---[ Kernel Space ]---
0xffff800000000000-0xffff880000000000           8T                           pgd
---[ Low Kernel Mapping ]---
0xffff880000000000-0xffff880000200000           2M     RW             GLB NX pte
0xffff880000200000-0xffff880010000000         254M     RW         PSE GLB NX pmd
0xffff880010000000-0xffff880010065000         404K     RW             GLB x  pte
0xffff880010065000-0xffff880010200000        1644K     RW             GLB NX pte
0xffff880010200000-0xffff88005de00000        1244M     RW         PSE GLB NX pmd
0xffff88005de00000-0xffff88005e000000           2M     RW         PSE GLB x  pmd
0xffff88005e000000-0xffff88006de00000         254M     RW         PSE GLB NX pmd
0xffff88006de00000-0xffff88006de78000         480K     RW             GLB NX pte
0xffff88006de78000-0xffff88006e000000        1568K                           pte
0xffff88006e000000-0xffff88006ee00000          14M                           pmd
0xffff88006ee00000-0xffff88006ee78000         480K                           pte
0xffff88006ee78000-0xffff88006f000000        1568K     RW             GLB x  pte
0xffff88006f000000-0xffff880070800000          24M     RW         PSE GLB x  pmd
0xffff880070800000-0xffff8800709fc000        2032K     RW             GLB x  pte
0xffff8800709fc000-0xffff880070a00000          16K     RW             GLB NX pte
0xffff880070a00000-0xffff880071800000          14M     RW         PSE GLB NX pmd
0xffff880071800000-0xffff88007182d000         180K     RW             GLB NX pte
0xffff88007182d000-0xffff880071a00000        1868K     RW             GLB x  pte
0xffff880071a00000-0xffff880072000000           6M     RW         PSE GLB x  pmd
0xffff880072000000-0xffff8800721ff000        2044K     RW             GLB x  pte
0xffff8800721ff000-0xffff880072200000           4K     RW                 x  pte
0xffff880072200000-0xffff880072400000           2M     RW         PSE     x  pmd
0xffff880072400000-0xffff880072600000           2M     RW                 x  pte
0xffff880072600000-0xffff880072c00000           6M     RW         PSE     x  pmd
0xffff880072c00000-0xffff880072dff000        2044K     RW                 x  pte
0xffff880072dff000-0xffff880072e00000           4K                           pte
0xffff880072e00000-0xffff880073e00000          16M                           pmd
0xffff880073e00000-0xffff880073fff000        2044K                           pte
0xffff880073fff000-0xffff880074000000           4K     RW             GLB NX pte
0xffff880074000000-0xffff880075200000          18M     RW         PSE GLB NX pmd
0xffff880075200000-0xffff8800752e9000         932K     RW             GLB NX pte
0xffff8800752e9000-0xffff88007540a000        1156K     RW             GLB x  pte
0xffff88007540a000-0xffff880075462000         352K     RW             GLB NX pte
0xffff880075462000-0xffff880075600000        1656K     RW             GLB x  pte
0xffff880075600000-0xffff88007c000000         106M     RW         PSE GLB x  pmd
0xffff88007c000000-0xffff880080000000          64M                           pmd
0xffff880080000000-0xffff880090000000         256M     RW     PCD PSE     x  pmd
0xffff880090000000-0xffff8800fec00000        1772M                           pmd
0xffff8800fec00000-0xffff8800fed1c000        1136K                           pte
0xffff8800fed1c000-0xffff8800fed20000          16K     RW     PCD         x  pte
0xffff8800fed20000-0xffff8800fee00000         896K                           pte
0xffff8800fee00000-0xffff8800ff000000           2M                           pmd
0xffff8800ff000000-0xffff8800ff200000           2M     RW     PCD PSE     x  pmd
0xffff8800ff200000-0xffff880100000000          14M                           pmd
0xffff880100000000-0xffff880880000000          30G     RW         PSE GLB NX pud
0xffff880880000000-0xffff888000000000         478G                           pud
0xffff888000000000-0xffff8a0000000000        1536G                           pgd
0xffff8a0000000000-0xffff8a0400000000          16G     RW         PSE GLB NX pud
0xffff8a0400000000-0xffff8a8000000000         496G                           pud
0xffff8a8000000000-0xffffc90000000000       64000G                           pgd
---[ vmalloc() Area ]---
0xffffc90000000000-0xffffc90000001000           4K     RW     PCD     GLB NX pte
0xffffc90000001000-0xffffc90000200000        2044K                           pte
0xffffc90000200000-0xffffc90040000000        1022M                           pmd
0xffffc90040000000-0xffffc98000000000         511G                           pud
0xffffc98000000000-0xffffea0000000000       33280G                           pgd
---[ Vmemmap ]---
0xffffea0000000000-0xffffea0001c00000          28M     RW         PSE GLB NX pmd
0xffffea0001c00000-0xffffea0003800000          28M                           pmd
0xffffea0003800000-0xffffea001dc00000         420M     RW         PSE GLB NX pmd
0xffffea001dc00000-0xffffea0040000000         548M                           pmd
0xffffea0040000000-0xffffea0700000000          27G                           pud
0xffffea0700000000-0xffffea070e000000         224M     RW         PSE GLB NX pmd
0xffffea070e000000-0xffffea0740000000         800M                           pmd
0xffffea0740000000-0xffffea8000000000         483G                           pud
0xffffea8000000000-0xffffff8000000000          21T                           pgd
0xffffff8000000000-0xfffffffd80000000         502G                           pud
0xfffffffd80000000-0xfffffffd91600000         278M                           pmd
0xfffffffd91600000-0xfffffffee5800000        5442M     RW     PCD PSE     x  pmd
0xfffffffee5800000-0xfffffffee591c000        1136K                           pte
0xfffffffee591c000-0xfffffffee5920000          16K     RW     PCD         x  pte
0xfffffffee5920000-0xfffffffee5a00000         896K                           pte
0xfffffffee5a00000-0xfffffffef5a00000         256M     RW     PCD PSE     x  pmd
0xfffffffef5a00000-0xfffffffef5a62000         392K                           pte
0xfffffffef5a62000-0xfffffffef5c00000        1656K     RW                 x  pte
0xfffffffef5c00000-0xfffffffefc600000         106M     RW         PSE     x  pmd
0xfffffffefc600000-0xfffffffefc6e9000         932K                           pte
0xfffffffefc6e9000-0xfffffffefc80a000        1156K     RW                 x  pte
0xfffffffefc80a000-0xfffffffefc9ff000        2004K                           pte
0xfffffffefc9ff000-0xfffffffefca00000           4K     RW                 x  pte
0xfffffffefca00000-0xfffffffefd000000           6M     RW         PSE     x  pmd
0xfffffffefd000000-0xfffffffefd200000           2M     RW                 x  pte
0xfffffffefd200000-0xfffffffefd400000           2M     RW         PSE     x  pmd
0xfffffffefd400000-0xfffffffefd5ff000        2044K     RW                 x  pte
0xfffffffefd5ff000-0xfffffffefd62d000         184K                           pte
0xfffffffefd62d000-0xfffffffefd800000        1868K     RW                 x  pte
0xfffffffefd800000-0xfffffffefde00000           6M     RW         PSE     x  pmd
0xfffffffefde00000-0xfffffffefdfff000        2044K     RW                 x  pte
0xfffffffefdfff000-0xfffffffefe078000         484K                           pte
0xfffffffefe078000-0xfffffffefe200000        1568K     RW                 x  pte
0xfffffffefe200000-0xfffffffeffa00000          24M     RW         PSE     x  pmd
0xfffffffeffa00000-0xfffffffeffbfc000        2032K     RW                 x  pte
0xfffffffeffbfc000-0xfffffffeffc00000          16K                           pte
0xfffffffeffc00000-0xfffffffeffe00000           2M     RW         PSE     x  pmd
0xfffffffeffe00000-0xfffffffeffe65000         404K     RW                 x  pte
0xfffffffeffe65000-0xffffffff00000000        1644K                           pte
0xffffffff00000000-0xffffffff80000000           2G                           pud
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82000000          16M     RW         PSE GLB x  pmd
0xffffffff82000000-0xffffffffa0000000         480M                           pmd
---[ Modules ]---
0xffffffffa0000000-0xffffffffff000000        1520M                           pmd
---[ End Modules ]---
0xffffffffff000000-0xffffffffff400000           4M                           pmd
0xffffffffff400000-0xffffffffff477000         476K                           pte
0xffffffffff477000-0xffffffffff478000           4K     RW             GLB NX pte
0xffffffffff478000-0xffffffffff579000        1028K                           pte
0xffffffffff579000-0xffffffffff57a000           4K     ro             GLB NX pte
0xffffffffff57a000-0xffffffffff5f7000         500K                           pte
0xffffffffff5f7000-0xffffffffff5fa000          12K     RW PWT PCD     GLB NX pte
0xffffffffff5fa000-0xffffffffff5fe000          16K                           pte
0xffffffffff5fe000-0xffffffffff5ff000           4K USR ro PWT PCD     GLB NX pte
0xffffffffff5ff000-0xffffffffff601000           8K USR ro             GLB NX pte
0xffffffffff601000-0xffffffffff800000        2044K                           pte
0xffffffffff800000-0x0000000000000000           8M                           pmd
BUG: unable to handle kernel paging request at 00000203fec16820
IP: [<0000000072dcda76>] 0x72dcda75
PGD 0 
Oops: 0000 [#1] SMP 
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.12.0+ #56
Hardware name: HP CB920s x1, BIOS Bundle: 005.028.018 SFW: 012.124.000 10/28/2013
task: ffffffff81a10480 ti: ffffffff81a00000 task.ti: ffffffff81a00000
RIP: 0010:[<0000000072dcda76>]  [<0000000072dcda76>] 0x72dcda75
RSP: 0000:ffffffff81a01e08  EFLAGS: 00010206
RAX: 00000000725fee18 RBX: 00000000725feda0 RCX: 00000203fec16800
RDX: 0000000072dfe070 RSI: 0000000060000202 RDI: 0000000072dcdac8
RBP: 0000000072dd0560 R08: 0000000000000000 R09: 000000000000001d
R10: 0000000000000030 R11: 8000000000000000 R12: ffff8a03fec16800
R13: 0000000000000570 R14: 0000000000000030 R15: 000000000009c000
FS:  0000000000000000(0000) GS:ffff88087fa00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000203fec16820 CR3: 000000000009c000 CR4: 00000000000406b0
Stack:
 0000000072dfb88f 0000000000000001 0000000000002722 0000000000000000
 ffffffff81acc728 0000000072dcdac8 0000000072dcdb93 0000000000000001
 ffffffff81a01f80 0000000000000570 ffff880001a0f000 0000000000000000
Call Trace:
 [<ffffffff81043e7a>] ? ptdump_show+0x2ba/0x2d0
 [<ffffffff810462cc>] ? efi_call4+0x6c/0xf0
 [<ffffffff81b02f2f>] ? efi_enter_virtual_mode+0x1f3/0x3a7
 [<ffffffff81aebdf2>] ? start_kernel+0x36c/0x407
 [<ffffffff81aeb88f>] ? repair_env_string+0x5c/0x5c
 [<ffffffff81aeb5a3>] ? x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81aeb696>] ? x86_64_start_kernel+0xf1/0xf4
Code:  Bad RIP value.
RIP  [<0000000072dcda76>] 0x72dcda75
 RSP <ffffffff81a01e08>
CR2: 00000203fec16820
---[ end trace 243af497e6e63797 ]---
Kernel panic - not syncing: Attempted to kill the idle task!

--=-kdKEQaSuD1L4Kg5e9cpT--

