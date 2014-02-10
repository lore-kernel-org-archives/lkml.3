Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaBJHXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 02:23:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30159 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaBJHXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 02:23:40 -0500
User-agent: mu4e 0.9.9.6pre2; emacs 24.3.1
From: Madper Xie <cxie@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi\@vger.kernel.org" <linux-efi@vger.kernel.org>
Subject: [BUG] can't boot up: unable to handle kernel paging request at ffffffffff340003
Date: Mon, 10 Feb 2014 15:23:33 +0800
Message-ID: <8738jr5t3e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Howdy,

With old kernel (from 3.10 to 3.14-rc1), my hp box shows following
outputs:
~~~
[    0.009166] Freeing SMP alternatives memory: 20K (ffffffff82234000 - ffffffff82239000)
[    0.010302] ioremap: invalid physical address 1376e01800000001
[    0.010303] ------------[ cut here ]------------
[    0.010308] WARNING: CPU: 0 PID: 0 at arch/x86/mm/ioremap.c:83 __ioremap_caller+0x357/0x380()
[    0.010309] Modules linked in:
[    0.010312] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc1 #8
[    0.010313] Hardware name: Hewlett-Packard HP Compaq Elite 8300 SFF/3397, BIOS K01 v02.05 05/07/2012
[    0.010314]  0000000000000009 ffffffff819dde58 ffffffff816b5eb9 0000000000000000
[    0.010317]  ffffffff819dde90 ffffffff8107793d 0000000000000000 1376e01800000006
[    0.010319]  0000000000000000 ffffffff81e0e2c0 0000000000000006 ffffffff819ddea0
[    0.010322] Call Trace:
[    0.010327]  [<ffffffff816b5eb9>] dump_stack+0x4d/0x66
[    0.010331]  [<ffffffff8107793d>] warn_slowpath_common+0x7d/0xa0
[    0.010333]  [<ffffffff81077a1a>] warn_slowpath_null+0x1a/0x20
[    0.010335]  [<ffffffff81060f37>] __ioremap_caller+0x357/0x380
[    0.010339]  [<ffffffff81d85b5f>] ? efi_bgrt_init+0x8b/0x12b
[    0.010341]  [<ffffffff81060f77>] ioremap_nocache+0x17/0x20
[    0.010343]  [<ffffffff81d85b5f>] efi_bgrt_init+0x8b/0x12b
[    0.010345]  [<ffffffff81d8522a>] efi_late_init+0x9/0xb
[    0.010349]  [<ffffffff81d68f59>] start_kernel+0x436/0x450
[    0.010351]  [<ffffffff81d6892c>] ? repair_env_string+0x5c/0x5c
[    0.010353]  [<ffffffff81d68120>] ? early_idt_handlers+0x120/0x120
[    0.010355]  [<ffffffff81d685de>] x86_64_start_reservations+0x2a/0x2c
[    0.010356]  [<ffffffff81d6871e>] x86_64_start_kernel+0x13e/0x14d
[    0.010368] ---[ end trace b6511b740249fba3 ]---
~~~
However the box can boot up and works well.
After I update kernel to 3.14-rc2, it panic when booting. Here is
console output:
~~~
[    0.010366] BUG: unable to handle kernel paging request at ffffffffff340003
[    0.017376] IP: [<ffffffff81d85ba4>] efi_bgrt_init+0x9d/0x133
[    0.023153] PGD 159eb067 PUD 159ed067 PMD 16240067 PTE 9376e01800000163
[    0.029842] Oops: 0009 [#1] SMP 
[    0.033108] Modules linked in:
[    0.036184] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc2+ #7
[    0.042540] Hardware name: Hewlett-Packard HP Compaq Elite 8300 SFF/3397, BIOS K01 v02.05 05/07/2012
[    0.051679] task: ffffffff819ef4c0 ti: ffffffff819dc000 task.ti: ffffffff819dc000
[    0.059167] RIP: 0010:[<ffffffff81d85ba4>]  [<ffffffff81d85ba4>] efi_bgrt_init+0x9d/0x133
[    0.067368] RSP: 0000:ffffffff819ddf20  EFLAGS: 00010202
[    0.072684] RAX: ffffffffff340001 RBX: ffffffffff340001 RCX: ffffffff00000abf
[    0.079825] RDX: 8000000000000163 RSI: 9376e01800000163 RDI: ffffffffff340000
[    0.086967] RBP: ffffffff819ddf38 R08: 8000000000000163 R09: 8000000000000163
[    0.094109] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
[    0.101249] R13: ffff88021ecc5640 R14: ffffffff81e0e2c0 R15: ffffffff819ddfb0
[    0.108391] FS:  0000000000000000(0000) GS:ffff880215c00000(0000) knlGS:0000000000000000
[    0.116489] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.122239] CR2: ffffffffff340003 CR3: 00000000159e8000 CR4: 00000000001406f0
[    0.129381] Stack:
[    0.131396]  ffffffffffffffff ffffffff81e04940 ffff88021ecc5640 ffffffff819ddf48
[    0.138867]  ffffffff81d8525d ffffffff819ddf88 ffffffff81d68f59 ffffffff81d6892c
[    0.146338]  ffffffff81e0e2c0 0000ffffffff81d6 00000000ffffffff 0000000000000020
[    0.153809] Call Trace:
[    0.156261]  [<ffffffff81d8525d>] efi_late_init+0x9/0xb
[    0.161499]  [<ffffffff81d68f59>] start_kernel+0x436/0x450
[    0.166987]  [<ffffffff81d6892c>] ? repair_env_string+0x5c/0x5c
[    0.172913]  [<ffffffff81d68120>] ? early_idt_handlers+0x120/0x120
[    0.179098]  [<ffffffff81d685de>] x86_64_start_reservations+0x2a/0x2c
[    0.185547]  [<ffffffff81d6871e>] x86_64_start_kernel+0x13e/0x14d
[    0.191646] Code: 89 c3 75 24 48 8b 05 34 37 53 00 be 06 00 00 00 48 8b 78 28 e8 93 d0 ff ff 48 85 c0 48 89 c 
[    0.211644] RIP  [<ffffffff81d85ba4>] efi_bgrt_init+0x9d/0x133
[    0.217501]  RSP <ffffffff819ddf20>
[    0.220994] CR2: ffffffffff340003
[    0.224320] ---[ end trace 4f8e0a3f5b9ff6b1 ]---
[    0.228946] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.235655] Rebooting in 3 seconds..
[    0.239146] ACPI MEMORY or I/O RESET_REG.

BTW: 3.14-rc2 works well on my DELL desktop.

I paste the dmidecode output of my HP desktop here:
# dmidecode 2.12
# SMBIOS entry point at 0xd943d918
SMBIOS 2.7 present.
58 structures occupying 2472 bytes.
Table at 0x000E92EB.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: Hewlett-Packard
	Version: K01 v02.05
	Release Date: 05/07/2012
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 16384 kB
	Characteristics:
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		Boot from CD is supported
		Selectable boot is supported
		EDD is supported
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		ACPI is supported
		USB legacy is supported
		BIOS boot specification is supported
		Function key-initiated network boot is supported
		Targeted content distribution is supported
		UEFI is supported
	BIOS Revision: 2.5

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: Hewlett-Packard
	Product Name: HP Compaq Elite 8300 SFF
	Version: Not Specified
	Serial Number: 6CR3164C25
	UUID: 10EC3380-A110-11E2-8178-6C3BE5225006
	Wake-up Type: Power Switch
	SKU Number: QV996AV
	Family: 103C_53307F G=D

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: Hewlett-Packard
	Product Name: 3397
	Version: Not Specified
	Serial Number: 6CR3164C25
	Asset Tag: 6CR3164C25
	Features:
		Board is a hosting board
		Board is removable
		Board is replaceable
	Location In Chassis: Not Specified
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 22 bytes
Chassis Information
	Manufacturer: Hewlett-Packard
	Type: Low Profile Desktop
	Lock: Not Present
	Version: Not Specified
	Serial Number: 6CR3164C25
	Asset Tag: 6CR3164C25
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0
	SKU Number: <BAD INDEX>

Handle 0x0004, DMI type 4, 42 bytes
Processor Information
	Socket Designation: SOCKET 0
	Type: Central Processor
	Family: Core i5
	Manufacturer: Intel
	ID: A9 06 03 00 FF FB EB BF
	Signature: Type 0, Family 6, Model 58, Stepping 9
	Flags:
		FPU (Floating-point unit on-chip)
		VME (Virtual mode extension)
		DE (Debugging extension)
		PSE (Page size extension)
		TSC (Time stamp counter)
		MSR (Model specific registers)
		PAE (Physical address extension)
		MCE (Machine check exception)
		CX8 (CMPXCHG8 instruction supported)
		APIC (On-chip APIC hardware supported)
		SEP (Fast system call)
		MTRR (Memory type range registers)
		PGE (Page global enable)
		MCA (Machine check architecture)
		CMOV (Conditional move instruction supported)
		PAT (Page attribute table)
		PSE-36 (36-bit page size extension)
		CLFSH (CLFLUSH instruction supported)
		DS (Debug store)
		ACPI (ACPI supported)
		MMX (MMX technology supported)
		FXSR (FXSAVE and FXSTOR instructions supported)
		SSE (Streaming SIMD extensions)
		SSE2 (Streaming SIMD extensions 2)
		SS (Self-snoop)
		HTT (Multi-threading)
		TM (Thermal monitor supported)
		PBE (Pending break enabled)
	Version: Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
	Voltage: 1.0 V
	External Clock: 100 MHz
	Max Speed: 3800 MHz
	Current Speed: 3200 MHz
	Status: Populated, Enabled
	Upgrade: Socket BGA1155
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: 0x0007
	Serial Number: Not Specified
	Asset Tag: Not Specified
	Part Number: Not Specified
	Core Count: 4
	Core Enabled: 4
	Thread Count: 4
	Characteristics:
		64-bit capable
		Multi-Core
		Execute Protection
		Enhanced Virtualization
		Power/Performance Control

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 256 kB
	Maximum Size: 256 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Parity
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Through
	Location: Internal
	Installed Size: 1024 kB
	Maximum Size: 1024 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: 8-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3-Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 6144 kB
	Maximum Size: 6144 kB
	Supported SRAM Types:
		Unknown
	Installed SRAM Type: Unknown
	Speed: Unknown
	Error Correction Type: Single-bit ECC
	System Type: Unified
	Associativity: Other

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: PS2Mouse
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1A1
	Internal Connector Type: None
	External Reference Designator: Keyboard
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A1
	Internal Connector Type: None
	External Reference Designator: TV Out
	External Connector Type: Mini Centronics Type-14
	Port Type: Other

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A2A
	Internal Connector Type: None
	External Reference Designator: COM A
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2A2B
	Internal Connector Type: None
	External Reference Designator: Video
	External Connector Type: DB-15 female
	Port Type: Video Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3A1
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3A1
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3A1
	Internal Connector Type: None
	External Reference Designator: USB3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9A1 - TPM HDR
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9C1 - PCIE DOCKING CONN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2B3 - CPU FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6C2 - EXT HDMI
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J3C1 - GMCH FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1D1 - ITP
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9E2 - MDC INTPSR
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9E4 - MDC INTPSR
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9E3 - LPC HOT DOCKING
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9E1 - SCAN MATRIX
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J9G1 - LPC SIDE BAND
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J8F1 - UNIFIED
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J6F1 - LVDS
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2F1 - LAI FAN
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J2G1 - GFX VID
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: J1G6 - AC JACK
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0020, DMI type 11, 5 bytes
OEM Strings
	String 1: ABS 70/71 60 61 62 63;
	String 2: FBYTE#2U2V3E3P3V3X47676J6S6b7B7H7M7Q7T7W7a7m8D9zag.Fn;
	String 3: BUILDID#12WWIDFW607#SAB2#DAB2;

Handle 0x0021, DMI type 12, 5 bytes
System Configuration Options
	Option 1: To Be Filled By O.E.M.

Handle 0x0022, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0023, DMI type 26, 22 bytes
Voltage Probe
	Description: LM78A
	Location: Power Unit
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0024, DMI type 28, 22 bytes
Temperature Probe
	Description: LM78A
	Location: Power Unit
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0025, DMI type 27, 15 bytes
Cooling Device
	Temperature Probe Handle: 0x0024
	Type: Power Supply Fan
	Status: OK
	Cooling Unit Group: 1
	OEM-specific Information: 0x00000000
	Nominal Speed: Unknown Or Non-rotating
	Description: Cooling Dev 1

Handle 0x0026, DMI type 29, 22 bytes
Electrical Current Probe
	Description: ABC
	Location: Power Unit
	Status: OK
	Maximum Value: Unknown
	Minimum Value: Unknown
	Resolution: Unknown
	Tolerance: Unknown
	Accuracy: Unknown
	OEM-specific Information: 0x00000000
	Nominal Value: Unknown

Handle 0x0027, DMI type 39, 22 bytes
System Power Supply
	Power Unit Group: 1
	Location: To Be Filled By O.E.M.
	Name: To Be Filled By O.E.M.
	Manufacturer: To Be Filled By O.E.M.
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Model Part Number: To Be Filled By O.E.M.
	Revision: To Be Filled By O.E.M.
	Max Power Capacity: Unknown
	Status: Present, OK
	Type: Switching
	Input Voltage Range Switching: Auto-switch
	Plugged: Yes
	Hot Replaceable: No
	Input Voltage Probe Handle: 0x0023
	Cooling Device Handle: 0x0025
	Input Current Probe Handle: 0x0026

Handle 0x0028, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard IGD
	Type: Video
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:02.0

Handle 0x0029, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard LAN
	Type: Ethernet
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:00:19.0

Handle 0x002A, DMI type 41, 11 bytes
Onboard Device
	Reference Designation:  Onboard 1394
	Type: Other
	Status: Enabled
	Type Instance: 1
	Bus Address: 0000:03:1c.2

Handle 0x002B, DMI type 16, 23 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 32 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x002C, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x002B
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM4
	Bank Locator: BANK 0
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: [Empty]
	Serial Number: [Empty]
	Asset Tag: 9876543210
	Part Number: [Empty]
	Rank: Unknown
	Configured Clock Speed: Unknown

Handle 0x002D, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x002B
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM3
	Bank Locator: BANK 1
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: Kingston
	Serial Number: 0D3AB88A
	Asset Tag: 9876543210
	Part Number: 99P5474-013.A00LF 
	Rank: 1
	Configured Clock Speed: 1600 MHz

Handle 0x002E, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x002D
	Memory Array Mapped Address Handle: 0x0032
	Partition Row Position: Unknown
	Interleave Position: 1
	Interleaved Data Depth: 2

Handle 0x002F, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x002B
	Error Information Handle: Not Provided
	Total Width: Unknown
	Data Width: Unknown
	Size: No Module Installed
	Form Factor: DIMM
	Set: None
	Locator: DIMM2
	Bank Locator: BANK 2
	Type: Unknown
	Type Detail: None
	Speed: Unknown
	Manufacturer: [Empty]
	Serial Number: [Empty]
	Asset Tag: 9876543210
	Part Number: [Empty]
	Rank: Unknown
	Configured Clock Speed: Unknown

Handle 0x0030, DMI type 17, 34 bytes
Memory Device
	Array Handle: 0x002B
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK 3
	Type: DDR3
	Type Detail: Synchronous
	Speed: 1600 MHz
	Manufacturer: 04CB
	Serial Number: 00009738
	Asset Tag: 9876543210
	Part Number: AM2L16BC4R1-B0AS  
	Rank: 1
	Configured Clock Speed: 1600 MHz

Handle 0x0031, DMI type 20, 35 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0030
	Memory Array Mapped Address Handle: 0x0032
	Partition Row Position: Unknown
	Interleave Position: 2
	Interleaved Data Depth: 2

Handle 0x0032, DMI type 19, 31 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 8 GB
	Physical Array Handle: 0x002B
	Partition Width: 4

Handle 0x003E, DMI type 13, 22 bytes
BIOS Language Information
	Language Description Format: Long
	Installable Languages: 12
		en|US|iso8859-1
		fr|FR|iso8859-1
		es|ES|iso8859-1
		de|DE|iso8859-1
		it|IT|iso8859-1
		da|DK|iso8859-1
		fi|FI|iso8859-1
		nl|NL|iso8859-1
		no|NO|iso8859-1
		pt|PT|iso8859-1
		sv|SE|iso8859-1
		ja|JP|unicode
	Currently Installed Language: en|US|iso8859-1

Handle 0x0040, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: HLCK
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: Other
	Port Type: Other

Handle 0x0041, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: HSNR
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: Other
	Port Type: Other

Handle 0x0042, DMI type 129, 8 bytes
OEM-specific Type
	Header and Data:
		81 08 42 00 01 01 02 01
	Strings:
		Intel_ASF
		Intel_ASF_001

Handle 0x0043, DMI type 130, 20 bytes
OEM-specific Type
	Header and Data:
		82 14 43 00 24 41 4D 54 01 01 01 01 01 A5 2F 02
		00 00 01 00

Handle 0x0044, DMI type 131, 64 bytes
OEM-specific Type
	Header and Data:
		83 40 44 00 37 00 00 00 08 00 00 00 00 00 3D 00
		F8 00 47 1E FF FF FF FF 09 C0 00 00 00 00 08 00
		A1 05 04 00 00 00 00 00 C8 00 02 15 00 00 00 00
		00 00 00 00 36 00 00 00 76 50 72 6F 00 00 00 00

Handle 0x0045, DMI type 127, 4 bytes
End Of Table

-- 
iMadper
