Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaKGFri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 00:47:38 -0500
Received: from mga09.intel.com ([134.134.136.24]:55165 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaKGFrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 00:47:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,329,1413270000"; 
   d="scan'208";a="603936737"
Date: Fri, 7 Nov 2014 13:47:41 +0800
From: LKP <lkp@01.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b error
 9 cr2 ffffffffff240000
Message-ID: <20141107054741.GB30507@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

FYI, we noticed the below changes on

https://git.linaro.org/people/ard.biesheuvel/linux-arm efi-for-3.19
commit aacdce6e880894acb57d71dcb2e3fc61b4ed4e96 ("dmi: add support for SMBIOS 3.0 64-bit entry point")


+-----------------------+------------+------------+
|                       | 2fa165a26c | aacdce6e88 |
+-----------------------+------------+------------+
| boot_successes        | 20         | 10         |
| early-boot-hang       | 1          |            |
| boot_failures         | 0          | 5          |
| PANIC:early_exception | 0          | 5          |
+-----------------------+------------+------------+


[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000036fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
PANIC: early exception 0e rip 10:ffffffff81899e6b error 9 cr2 ffffffffff240000
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gc5221e6 #1
[    0.000000]  0000000000000000 ffffffff82203d30 ffffffff819f0a6e 00000000000003f8
[    0.000000]  ffffffffff240000 ffffffff82203e18 ffffffff823701b0 ffffffff82511401
[    0.000000]  0000000000000000 0000000000000ba3 0000000000000000 ffffffffff240000
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff819f0a6e>] dump_stack+0x4e/0x68
[    0.000000]  [<ffffffff823701b0>] early_idt_handler+0x90/0xb7
[    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
[    0.000000]  [<ffffffff81899e6b>] ? dmi_table+0x3f/0x94
[    0.000000]  [<ffffffff81899e42>] ? dmi_table+0x16/0x94
[    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
[    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
[    0.000000]  [<ffffffff823c7eff>] dmi_walk_early+0x44/0x69
[    0.000000]  [<ffffffff823c88a2>] dmi_present+0x180/0x1ff
[    0.000000]  [<ffffffff823c8ab3>] dmi_scan_machine+0x144/0x191
[    0.000000]  [<ffffffff82370702>] ? loglevel+0x31/0x31
[    0.000000]  [<ffffffff82377f52>] setup_arch+0x490/0xc73
[    0.000000]  [<ffffffff819eef73>] ? printk+0x4d/0x4f
[    0.000000]  [<ffffffff82370b90>] start_kernel+0x9c/0x43f
[    0.000000]  [<ffffffff82370120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff823704a2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff823705df>] x86_64_start_kernel+0x13b/0x14a
[    0.000000] RIP 0x4

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".dmesg"

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.18.0-rc2-gc5221e6 (kbuild@xian) (gcc version 4.9.1 (Debian 4.9.1-11) ) #1 SMP Wed Oct 29 11:52:18 CST 2014
[    0.000000] Command line: BOOT_IMAGE=/kernel/x86_64-lkp/c5221e6c2fcfa2f0f1871b672edbf8ea0f055213/vmlinuz-3.18.0-rc2-gc5221e6 user=lkp job=/lkp/scheduled/lkp-ne04/boot_boot-performance-1-x86_64-lkp-c5221e6c2fcfa2f0f1871b672edbf8ea0f055213-0.yaml ARCH=x86_64 BOOT_IMAGE=/kernel/x86_64-lkp/c5221e6c2fcfa2f0f1871b672edbf8ea0f055213/vmlinuz-3.18.0-rc2-gc5221e6 kconfig=x86_64-lkp commit=c5221e6c2fcfa2f0f1871b672edbf8ea0f055213 branch=linux-devel/devel-hourly-2014102911 root=/dev/ram0 max_uptime=3600 RESULT_ROOT=/result/lkp-ne04/boot/performance-1/debian-x86_64.cgz/x86_64-lkp/c5221e6c2fcfa2f0f1871b672edbf8ea0f055213/0 ip=::::lkp-ne04::dhcp earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=-1 softlockup_panic=1 nmi_watchdog=panic oops=panic load_ramdisk=2 prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal rw
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000100-0x000000000009a3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009a400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000008c555fff] usable
[    0.000000] BIOS-e820: [mem 0x000000008c556000-0x000000008c628fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008c629000-0x000000008c701fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008c702000-0x000000008db01fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008db02000-0x000000008f601fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f602000-0x000000008f64efff] reserved
[    0.000000] BIOS-e820: [mem 0x000000008f64f000-0x000000008f6e5fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f6e6000-0x000000008f6effff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008f6f0000-0x000000008f6f1fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f6f2000-0x000000008f7cefff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000008f7cf000-0x000000008f7fffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000008f800000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000a0000000-0x00000000afffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fc000000-0x00000000fcffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000036fffffff] usable
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
PANIC: early exception 0e rip 10:ffffffff81899e6b error 9 cr2 ffffffffff240000
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gc5221e6 #1
[    0.000000]  0000000000000000 ffffffff82203d30 ffffffff819f0a6e 00000000000003f8
[    0.000000]  ffffffffff240000 ffffffff82203e18 ffffffff823701b0 ffffffff82511401
[    0.000000]  0000000000000000 0000000000000ba3 0000000000000000 ffffffffff240000
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff819f0a6e>] dump_stack+0x4e/0x68
[    0.000000]  [<ffffffff823701b0>] early_idt_handler+0x90/0xb7
[    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
[    0.000000]  [<ffffffff81899e6b>] ? dmi_table+0x3f/0x94
[    0.000000]  [<ffffffff81899e42>] ? dmi_table+0x16/0x94
[    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
[    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
[    0.000000]  [<ffffffff823c7eff>] dmi_walk_early+0x44/0x69
[    0.000000]  [<ffffffff823c88a2>] dmi_present+0x180/0x1ff
[    0.000000]  [<ffffffff823c8ab3>] dmi_scan_machine+0x144/0x191
[    0.000000]  [<ffffffff82370702>] ? loglevel+0x31/0x31
[    0.000000]  [<ffffffff82377f52>] setup_arch+0x490/0xc73
[    0.000000]  [<ffffffff819eef73>] ? printk+0x4d/0x4f
[    0.000000]  [<ffffffff82370b90>] start_kernel+0x9c/0x43f
[    0.000000]  [<ffffffff82370120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff823704a2>] x86_64_start_reservations+0x2a/0x2c
[    0.000000]  [<ffffffff823705df>] x86_64_start_kernel+0x13b/0x14a
[    0.000000] RIP 0x4

--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

_______________________________________________
LKP mailing list
LKP@linux.intel.com

--vGgW1X5XWziG23Ko--
