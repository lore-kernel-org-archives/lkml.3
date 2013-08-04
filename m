Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824Ab3HDLkk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 07:40:40 -0400
Received: from mout.gmx.net ([212.227.17.20]:50742 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3HDLkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 07:40:32 -0400
Message-ID: <51FE3D9D.9030602@gmx.de>
Date: Sun, 04 Aug 2013 13:40:13 +0200
From: edr <e-d-r@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tomas.winkler@intel.com
Subject: System freeze apparently caused by mei module
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:PeiHM11p7cJQBtccIv9j42rNb0RrmJv9NeVFyLEULtTSzdZEtcc
 ByHxMTIaJGDUCeg1uVBr9ONa5eRikZ1GxBh1q6cPh+zXw0fH+rFyesLDWQ+dTdYigNhvlOU
 8khybKmWW8a7WTxSA8puUHPThImoXOHdaK/k+DyiTLxigw/XNYORw53/PNMPvMLboEwtRHM
 opIAWZ8fUi7HxamBBdw5g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel developers

I have observed freezes on my system lately which seem to be related to
the mei_me module. While I did see discussions about the reset flow
being worked on I did not see any posts that mentioned complete system
freezes, so I thought it might make sense to report the behavior just in
case.
I have followed the recommended questionnaire for kernel bug reports as
closely as possible, but please do not hesitate to contact me if I
missed anything, or if there is anything I can do to help in diagnosing
the problem further.

Kind regards
edr


[1.] One line summary of the problem:
The running system freezes randomly. Only hard reset resolves the problem.

[2.] Full description of the problem/report:
Freezes are happening under X, sometimes when performing basic things
such as double-clicking a text file in thunar to open it in leafpad, and
sometimes when the computer is completely idle (xscreensaver active).
This is happening on an ASUS N56V Laptop running aptosid 12.1 with
kernel 3.10-3 and fluxbox.

[3.] Keywords (i.e., modules, networking, kernel):
I think the problem might be related to the kernel module mei_me because
everytime when I look into /var/log/messages after the freeze I find
messages like this one:
mei 0000:00:16.0: unexpected reset: dev_state = RESETTING

Also if I blacklist the module the freezes do not occur any longer.

[4.] Kernel version (from /proc/version):
Linux version 3.10-3.slh.2-aptosid-amd64 (Debian 3.10-10) (s.l-h@gmx.de)
(gcc version 4.8.1 (Debian 4.8.1-8) ) #1 SMP PREEMPT Fri Jul 26 21:23:40
UTC 2013

[5.] Output of Oops.. message (if applicable) with symbolic information
     resolved (see Documentation/oops-tracing.txt)
Here is a /var/log/messages for a session that ended in a freeze:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Initializing cgroup
subsys cpuset
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Initializing cgroup
subsys cpu
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Initializing cgroup
subsys cpuacct
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Linux version
3.10-3.slh.2-aptosid-amd64 (Debian 3.10-10) (s.l-h@gmx.de) (gcc version
4.8.1 (Debian 4.8.1-8) ) #1 SMP PREEMPT Fri Jul 26 21:23:40 UTC 2013
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Command line:
BOOT_IMAGE=/boot/vmlinuz-3.10-3.slh.2-aptosid-amd64
root=UUID=385a4fdb-284c-4473-9e27-929a10afd6c0 ro acpi_backlight=vendor
quiet
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] e820: BIOS-provided
physical RAM map:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x0000000000000000-0x000000000009efff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x000000000009f000-0x000000000009ffff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x0000000000100000-0x000000001fffffff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x0000000020000000-0x00000000201fffff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x0000000020200000-0x0000000040003fff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x0000000040004000-0x0000000040004fff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x0000000040005000-0x00000000c90ebfff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000c90ec000-0x00000000c912efff] ACPI NVS
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000c912f000-0x00000000c9532fff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000c9533000-0x00000000c97f8fff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000c97f9000-0x00000000ca75efff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000ca75f000-0x00000000cad7afff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000cad7b000-0x00000000caffafff] ACPI NVS
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000caffb000-0x00000000caffffff] ACPI data
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000cbc00000-0x00000000cfdfffff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000f8000000-0x00000000fbffffff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000fec00000-0x00000000fec00fff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed00000-0x00000000fed03fff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000fed1c000-0x00000000fed1ffff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000fee00000-0x00000000fee00fff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x00000000ff000000-0x00000000ffffffff] reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BIOS-e820: [mem
0x0000000100000000-0x000000022f1fffff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] NX (Execute Disable)
protection: active
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: EFI v2.31 by
American Megatrends
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi:  ACPI=0xcafce000
ACPI 2.0=0xcafce000  SMBIOS=0xf0480  MPS=0xfc990
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem00: type=3,
attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem01: type=7,
attr=0xf, range=[0x0000000000008000-0x0000000000058000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem02: type=4,
attr=0xf, range=[0x0000000000058000-0x0000000000059000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem03: type=7,
attr=0xf, range=[0x0000000000059000-0x000000000005f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem04: type=4,
attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem05: type=3,
attr=0xf, range=[0x0000000000060000-0x000000000009f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem06: type=6,
attr=0x800000000000000f, range=[0x000000000009f000-0x00000000000a0000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem07: type=2,
attr=0xf, range=[0x0000000000100000-0x0000000000c39000) (11MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem08: type=7,
attr=0xf, range=[0x0000000000c39000-0x0000000001000000) (3MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem09: type=2,
attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem10: type=7,
attr=0xf, range=[0x0000000001100000-0x0000000002000000) (15MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem11: type=2,
attr=0xf, range=[0x0000000002000000-0x0000000002b39000) (11MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem12: type=7,
attr=0xf, range=[0x0000000002b39000-0x0000000008000000) (84MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem13: type=4,
attr=0xf, range=[0x0000000008000000-0x0000000008963000) (9MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem14: type=3,
attr=0xf, range=[0x0000000008963000-0x0000000008966000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem15: type=4,
attr=0xf, range=[0x0000000008966000-0x00000000089a6000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem16: type=3,
attr=0xf, range=[0x00000000089a6000-0x00000000089a7000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem17: type=4,
attr=0xf, range=[0x00000000089a7000-0x00000000089ab000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem18: type=3,
attr=0xf, range=[0x00000000089ab000-0x00000000089ac000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem19: type=4,
attr=0xf, range=[0x00000000089ac000-0x00000000089b0000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem20: type=3,
attr=0xf, range=[0x00000000089b0000-0x00000000089b2000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem21: type=4,
attr=0xf, range=[0x00000000089b2000-0x00000000089b4000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem22: type=3,
attr=0xf, range=[0x00000000089b4000-0x00000000089cd000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem23: type=4,
attr=0xf, range=[0x00000000089cd000-0x00000000089d7000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem24: type=3,
attr=0xf, range=[0x00000000089d7000-0x00000000089da000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem25: type=4,
attr=0xf, range=[0x00000000089da000-0x00000000089dd000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem26: type=3,
attr=0xf, range=[0x00000000089dd000-0x00000000089df000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem27: type=4,
attr=0xf, range=[0x00000000089df000-0x00000000089e7000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem28: type=3,
attr=0xf, range=[0x00000000089e7000-0x00000000089eb000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem29: type=4,
attr=0xf, range=[0x00000000089eb000-0x00000000089ee000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem30: type=3,
attr=0xf, range=[0x00000000089ee000-0x00000000089f1000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem31: type=4,
attr=0xf, range=[0x00000000089f1000-0x0000000008a32000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem32: type=3,
attr=0xf, range=[0x0000000008a32000-0x0000000008a33000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem33: type=4,
attr=0xf, range=[0x0000000008a33000-0x0000000008a35000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem34: type=3,
attr=0xf, range=[0x0000000008a35000-0x0000000008a36000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem35: type=4,
attr=0xf, range=[0x0000000008a36000-0x0000000008a44000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem36: type=3,
attr=0xf, range=[0x0000000008a44000-0x0000000008a49000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem37: type=4,
attr=0xf, range=[0x0000000008a49000-0x0000000008a4a000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem38: type=3,
attr=0xf, range=[0x0000000008a4a000-0x0000000008a4c000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem39: type=4,
attr=0xf, range=[0x0000000008a4c000-0x0000000008a5d000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem40: type=3,
attr=0xf, range=[0x0000000008a5d000-0x0000000008a69000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem41: type=4,
attr=0xf, range=[0x0000000008a69000-0x0000000008a74000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem42: type=3,
attr=0xf, range=[0x0000000008a74000-0x0000000008a75000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem43: type=4,
attr=0xf, range=[0x0000000008a75000-0x0000000008a76000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem44: type=3,
attr=0xf, range=[0x0000000008a76000-0x0000000008a7c000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem45: type=4,
attr=0xf, range=[0x0000000008a7c000-0x0000000008a7e000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem46: type=3,
attr=0xf, range=[0x0000000008a7e000-0x0000000008a7f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem47: type=4,
attr=0xf, range=[0x0000000008a7f000-0x0000000008a87000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem48: type=3,
attr=0xf, range=[0x0000000008a87000-0x0000000008a88000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem49: type=4,
attr=0xf, range=[0x0000000008a88000-0x0000000008a89000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem50: type=3,
attr=0xf, range=[0x0000000008a89000-0x0000000008a91000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem51: type=4,
attr=0xf, range=[0x0000000008a91000-0x0000000008a9f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem52: type=3,
attr=0xf, range=[0x0000000008a9f000-0x0000000008aa6000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem53: type=4,
attr=0xf, range=[0x0000000008aa6000-0x0000000008aa7000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem54: type=3,
attr=0xf, range=[0x0000000008aa7000-0x0000000008aa8000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem55: type=4,
attr=0xf, range=[0x0000000008aa8000-0x0000000008aab000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem56: type=3,
attr=0xf, range=[0x0000000008aab000-0x0000000008aac000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem57: type=4,
attr=0xf, range=[0x0000000008aac000-0x0000000008aad000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem58: type=3,
attr=0xf, range=[0x0000000008aad000-0x0000000008aaf000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem59: type=4,
attr=0xf, range=[0x0000000008aaf000-0x0000000008ad3000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem60: type=3,
attr=0xf, range=[0x0000000008ad3000-0x0000000008ae4000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem61: type=4,
attr=0xf, range=[0x0000000008ae4000-0x0000000008b13000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem62: type=3,
attr=0xf, range=[0x0000000008b13000-0x0000000008b14000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem63: type=4,
attr=0xf, range=[0x0000000008b14000-0x0000000008b2f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem64: type=3,
attr=0xf, range=[0x0000000008b2f000-0x0000000008b30000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem65: type=4,
attr=0xf, range=[0x0000000008b30000-0x0000000008b32000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem66: type=3,
attr=0xf, range=[0x0000000008b32000-0x0000000008b3e000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem67: type=4,
attr=0xf, range=[0x0000000008b3e000-0x0000000008b3f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem68: type=3,
attr=0xf, range=[0x0000000008b3f000-0x0000000008b41000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem69: type=4,
attr=0xf, range=[0x0000000008b41000-0x0000000008b4e000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem70: type=3,
attr=0xf, range=[0x0000000008b4e000-0x0000000008b54000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem71: type=4,
attr=0xf, range=[0x0000000008b54000-0x0000000008b58000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem72: type=3,
attr=0xf, range=[0x0000000008b58000-0x0000000008b5d000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem73: type=4,
attr=0xf, range=[0x0000000008b5d000-0x0000000008b67000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem74: type=3,
attr=0xf, range=[0x0000000008b67000-0x0000000008b6a000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem75: type=4,
attr=0xf, range=[0x0000000008b6a000-0x0000000008b72000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem76: type=3,
attr=0xf, range=[0x0000000008b72000-0x0000000008b76000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem77: type=4,
attr=0xf, range=[0x0000000008b76000-0x0000000008b7d000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem78: type=3,
attr=0xf, range=[0x0000000008b7d000-0x0000000008b7e000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem79: type=4,
attr=0xf, range=[0x0000000008b7e000-0x0000000008b95000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem80: type=3,
attr=0xf, range=[0x0000000008b95000-0x0000000008ba2000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem81: type=4,
attr=0xf, range=[0x0000000008ba2000-0x0000000008ba6000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem82: type=3,
attr=0xf, range=[0x0000000008ba6000-0x0000000008bac000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem83: type=4,
attr=0xf, range=[0x0000000008bac000-0x0000000008baf000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem84: type=3,
attr=0xf, range=[0x0000000008baf000-0x0000000008bb2000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem85: type=4,
attr=0xf, range=[0x0000000008bb2000-0x0000000008bb8000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem86: type=3,
attr=0xf, range=[0x0000000008bb8000-0x0000000008bb9000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem87: type=4,
attr=0xf, range=[0x0000000008bb9000-0x0000000008bba000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem88: type=3,
attr=0xf, range=[0x0000000008bba000-0x0000000008bbd000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem89: type=4,
attr=0xf, range=[0x0000000008bbd000-0x0000000008bda000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem90: type=3,
attr=0xf, range=[0x0000000008bda000-0x0000000008bf3000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem91: type=4,
attr=0xf, range=[0x0000000008bf3000-0x0000000008bf5000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem92: type=3,
attr=0xf, range=[0x0000000008bf5000-0x0000000008bfd000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem93: type=4,
attr=0xf, range=[0x0000000008bfd000-0x0000000008c03000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem94: type=3,
attr=0xf, range=[0x0000000008c03000-0x0000000008c05000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem95: type=4,
attr=0xf, range=[0x0000000008c05000-0x0000000008c07000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem96: type=3,
attr=0xf, range=[0x0000000008c07000-0x0000000008c0f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem97: type=4,
attr=0xf, range=[0x0000000008c0f000-0x0000000008c12000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem98: type=3,
attr=0xf, range=[0x0000000008c12000-0x0000000008c18000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem99: type=4,
attr=0xf, range=[0x0000000008c18000-0x0000000008c1f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem100: type=3,
attr=0xf, range=[0x0000000008c1f000-0x0000000008c24000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem101: type=4,
attr=0xf, range=[0x0000000008c24000-0x0000000008c28000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem102: type=3,
attr=0xf, range=[0x0000000008c28000-0x0000000008c2d000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem103: type=4,
attr=0xf, range=[0x0000000008c2d000-0x0000000008c39000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem104: type=3,
attr=0xf, range=[0x0000000008c39000-0x0000000008c3c000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem105: type=4,
attr=0xf, range=[0x0000000008c3c000-0x0000000008c42000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem106: type=3,
attr=0xf, range=[0x0000000008c42000-0x0000000008c44000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem107: type=4,
attr=0xf, range=[0x0000000008c44000-0x0000000008c46000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem108: type=3,
attr=0xf, range=[0x0000000008c46000-0x0000000008c4a000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem109: type=4,
attr=0xf, range=[0x0000000008c4a000-0x0000000008c4b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem110: type=3,
attr=0xf, range=[0x0000000008c4b000-0x0000000008c57000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem111: type=4,
attr=0xf, range=[0x0000000008c57000-0x0000000008c5c000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem112: type=3,
attr=0xf, range=[0x0000000008c5c000-0x0000000008c5f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem113: type=4,
attr=0xf, range=[0x0000000008c5f000-0x0000000008c70000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem114: type=3,
attr=0xf, range=[0x0000000008c70000-0x0000000008c73000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem115: type=4,
attr=0xf, range=[0x0000000008c73000-0x0000000008c74000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem116: type=3,
attr=0xf, range=[0x0000000008c74000-0x0000000008c86000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem117: type=4,
attr=0xf, range=[0x0000000008c86000-0x0000000008c88000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem118: type=3,
attr=0xf, range=[0x0000000008c88000-0x0000000008c89000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem119: type=4,
attr=0xf, range=[0x0000000008c89000-0x0000000008c8b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem120: type=3,
attr=0xf, range=[0x0000000008c8b000-0x0000000008c91000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem121: type=4,
attr=0xf, range=[0x0000000008c91000-0x0000000008cbb000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem122: type=3,
attr=0xf, range=[0x0000000008cbb000-0x0000000008cbd000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem123: type=4,
attr=0xf, range=[0x0000000008cbd000-0x0000000008cbe000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem124: type=3,
attr=0xf, range=[0x0000000008cbe000-0x0000000008cf7000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem125: type=4,
attr=0xf, range=[0x0000000008cf7000-0x0000000008d03000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem126: type=3,
attr=0xf, range=[0x0000000008d03000-0x0000000008d04000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem127: type=4,
attr=0xf, range=[0x0000000008d04000-0x0000000008d06000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem128: type=3,
attr=0xf, range=[0x0000000008d06000-0x0000000008d22000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem129: type=4,
attr=0xf, range=[0x0000000008d22000-0x0000000008d28000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem130: type=3,
attr=0xf, range=[0x0000000008d28000-0x0000000008d5f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem131: type=4,
attr=0xf, range=[0x0000000008d5f000-0x0000000008d65000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem132: type=3,
attr=0xf, range=[0x0000000008d65000-0x0000000008d67000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem133: type=4,
attr=0xf, range=[0x0000000008d67000-0x0000000008d6b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem134: type=3,
attr=0xf, range=[0x0000000008d6b000-0x0000000008d80000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem135: type=4,
attr=0xf, range=[0x0000000008d80000-0x0000000008dbb000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem136: type=3,
attr=0xf, range=[0x0000000008dbb000-0x0000000008dce000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem137: type=4,
attr=0xf, range=[0x0000000008dce000-0x0000000008dd6000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem138: type=3,
attr=0xf, range=[0x0000000008dd6000-0x0000000008e71000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem139: type=4,
attr=0xf, range=[0x0000000008e71000-0x0000000008e73000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem140: type=3,
attr=0xf, range=[0x0000000008e73000-0x0000000008e75000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem141: type=4,
attr=0xf, range=[0x0000000008e75000-0x0000000008e7b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem142: type=3,
attr=0xf, range=[0x0000000008e7b000-0x0000000008e7e000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem143: type=4,
attr=0xf, range=[0x0000000008e7e000-0x0000000008e85000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem144: type=3,
attr=0xf, range=[0x0000000008e85000-0x0000000008e87000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem145: type=4,
attr=0xf, range=[0x0000000008e87000-0x0000000008e89000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem146: type=3,
attr=0xf, range=[0x0000000008e89000-0x0000000008e8b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem147: type=4,
attr=0xf, range=[0x0000000008e8b000-0x0000000008e8c000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem148: type=7,
attr=0xf, range=[0x0000000008e8c000-0x0000000008e8d000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem149: type=3,
attr=0xf, range=[0x0000000008e8d000-0x0000000008e8f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem150: type=7,
attr=0xf, range=[0x0000000008e8f000-0x0000000008e91000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem151: type=4,
attr=0xf, range=[0x0000000008e91000-0x0000000008f5a000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem152: type=7,
attr=0xf, range=[0x0000000008f5a000-0x0000000008f5b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem153: type=4,
attr=0xf, range=[0x0000000008f5b000-0x00000000127bc000) (152MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem154: type=7,
attr=0xf, range=[0x00000000127bc000-0x00000000128e2000) (1MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem155: type=4,
attr=0xf, range=[0x00000000128e2000-0x00000000129a3000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem156: type=3,
attr=0xf, range=[0x00000000129a3000-0x00000000129af000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem157: type=4,
attr=0xf, range=[0x00000000129af000-0x00000000129b6000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem158: type=7,
attr=0xf, range=[0x00000000129b6000-0x00000000129c3000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem159: type=4,
attr=0xf, range=[0x00000000129c3000-0x0000000012b99000) (1MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem160: type=7,
attr=0xf, range=[0x0000000012b99000-0x0000000012bb9000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem161: type=1,
attr=0xf, range=[0x0000000012bb9000-0x0000000012bd9000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem162: type=7,
attr=0xf, range=[0x0000000012bd9000-0x0000000020000000) (212MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem163: type=0,
attr=0xf, range=[0x0000000020000000-0x0000000020200000) (2MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem164: type=7,
attr=0xf, range=[0x0000000020200000-0x000000003666a000) (356MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem165: type=2,
attr=0xf, range=[0x000000003666a000-0x000000003732d000) (12MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem166: type=7,
attr=0xf, range=[0x000000003732d000-0x0000000040004000) (140MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem167: type=0,
attr=0xf, range=[0x0000000040004000-0x0000000040005000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem168: type=7,
attr=0xf, range=[0x0000000040005000-0x0000000099480000) (1428MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem169: type=2,
attr=0xf, range=[0x0000000099480000-0x00000000c90ec000) (764MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem170: type=10,
attr=0xf, range=[0x00000000c90ec000-0x00000000c912f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem171: type=4,
attr=0xf, range=[0x00000000c912f000-0x00000000c9277000) (1MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem172: type=3,
attr=0xf, range=[0x00000000c9277000-0x00000000c9507000) (2MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem173: type=4,
attr=0xf, range=[0x00000000c9507000-0x00000000c9517000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem174: type=3,
attr=0xf, range=[0x00000000c9517000-0x00000000c9529000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem175: type=4,
attr=0xf, range=[0x00000000c9529000-0x00000000c952a000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem176: type=3,
attr=0xf, range=[0x00000000c952a000-0x00000000c952c000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem177: type=4,
attr=0xf, range=[0x00000000c952c000-0x00000000c9533000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem178: type=6,
attr=0x800000000000000f, range=[0x00000000c9533000-0x00000000c97f9000) (2MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem179: type=4,
attr=0xf, range=[0x00000000c97f9000-0x00000000c9812000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem180: type=7,
attr=0xf, range=[0x00000000c9812000-0x00000000ca753000) (15MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem181: type=2,
attr=0xf, range=[0x00000000ca753000-0x00000000ca75f000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem182: type=5,
attr=0x800000000000000f, range=[0x00000000ca75f000-0x00000000ca77b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem183: type=6,
attr=0x800000000000000f, range=[0x00000000ca77b000-0x00000000ca788000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem184: type=5,
attr=0x800000000000000f, range=[0x00000000ca788000-0x00000000ca7d8000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem185: type=6,
attr=0x800000000000000f, range=[0x00000000ca7d8000-0x00000000ca838000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem186: type=5,
attr=0x800000000000000f, range=[0x00000000ca838000-0x00000000ca851000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem187: type=6,
attr=0x800000000000000f, range=[0x00000000ca851000-0x00000000ca857000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem188: type=6,
attr=0x800000000000000f, range=[0x00000000ca857000-0x00000000ca85c000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem189: type=6,
attr=0x800000000000000f, range=[0x00000000ca85c000-0x00000000ca85e000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem190: type=6,
attr=0x800000000000000f, range=[0x00000000ca85e000-0x00000000ca87b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem191: type=0,
attr=0xf, range=[0x00000000ca87b000-0x00000000cabd0000) (3MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem192: type=0,
attr=0xf, range=[0x00000000cabd0000-0x00000000cad10000) (1MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem193: type=0,
attr=0xf, range=[0x00000000cad10000-0x00000000cad16000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem194: type=0,
attr=0xf, range=[0x00000000cad16000-0x00000000cad7b000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem195: type=10,
attr=0xf, range=[0x00000000cad7b000-0x00000000cae35000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem196: type=10,
attr=0xf, range=[0x00000000cae35000-0x00000000cafe4000) (1MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem197: type=10,
attr=0xf, range=[0x00000000cafe4000-0x00000000cafe6000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem198: type=10,
attr=0xf, range=[0x00000000cafe6000-0x00000000caffb000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem199: type=9,
attr=0xf, range=[0x00000000caffb000-0x00000000cafff000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem200: type=9,
attr=0xf, range=[0x00000000cafff000-0x00000000cb000000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem201: type=7,
attr=0xf, range=[0x0000000100000000-0x000000022f200000) (4850MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem202: type=0,
attr=0x8000000000000000, range=[0x00000000cbc00000-0x00000000cfe00000)
(66MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem203: type=11,
attr=0x8000000000000001, range=[0x00000000f8000000-0x00000000fc000000)
(64MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem204: type=11,
attr=0x8000000000000001, range=[0x00000000fec00000-0x00000000fec01000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem205: type=11,
attr=0x8000000000000001, range=[0x00000000fed00000-0x00000000fed04000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem206: type=11,
attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem207: type=11,
attr=0x8000000000000001, range=[0x00000000fee00000-0x00000000fee01000) (0MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] efi: mem208: type=11,
attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000)
(16MB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] SMBIOS 2.7 present.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] DMI: ASUSTeK COMPUTER
INC. N56VM/N56VM, BIOS N56VM.204 03/01/2012
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] e820: update [mem
0x00000000-0x00000fff] usable ==> reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] e820: remove [mem
0x000a0000-0x000fffff] usable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] No AGP bridge found
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] e820: last_pfn =
0x22f200 max_arch_pfn = 0x400000000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] MTRR default type:
uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] MTRR fixed ranges enabled:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   00000-9FFFF write-back
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   A0000-BFFFF uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   C0000-CFFFF write-protect
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   D0000-DFFFF uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   E0000-FFFFF write-protect
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] MTRR variable ranges
enabled:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   0 base 000000000 mask
E00000000 write-back
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   1 base 200000000 mask
FE0000000 write-back
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   2 base 220000000 mask
FF0000000 write-back
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   3 base 0E0000000 mask
FE0000000 uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   4 base 0D0000000 mask
FF0000000 uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   5 base 0CC000000 mask
FFC000000 uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   6 base 0CBC00000 mask
FFFC00000 uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   7 base 22F800000 mask
FFF800000 uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   8 base 22F400000 mask
FFFC00000 uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   9 base 22F200000 mask
FFFE00000 uncachable
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] x86 PAT enabled: cpu 0,
old 0x7040600070406, new 0x7010600070106
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] original variable MTRRs
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 0, base: 0GB,
range: 8GB, type WB
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 1, base: 8GB,
range: 512MB, type WB
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 2, base: 8704MB,
range: 256MB, type WB
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 3, base: 3584MB,
range: 512MB, type UC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 4, base: 3328MB,
range: 256MB, type UC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 5, base: 3264MB,
range: 64MB, type UC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 6, base: 3260MB,
range: 4MB, type UC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 7, base: 8952MB,
range: 8MB, type UC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 8, base: 8948MB,
range: 4MB, type UC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] reg 9, base: 8946MB,
range: 2MB, type UC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] total RAM covered: 8110M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 64K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 128K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 256K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 512K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 1M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 2M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 4M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64K
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 16M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 32M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 64M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 128M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 256M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 512M 	num_reg: 10  	lose cover RAM: -264M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 1G 	num_reg: 10  	lose cover RAM: -256M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 64K
chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1280M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128K
chunk_size: 128K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128K
chunk_size: 256K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128K
chunk_size: 512K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128K
chunk_size: 1M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128K
chunk_size: 2M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128K
chunk_size: 4M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128K
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 16M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 32M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 64M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 128M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 256M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 512M 	num_reg: 10  	lose cover RAM: -264M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 1G 	num_reg: 10  	lose cover RAM: -256M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 128K
chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1280M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256K
chunk_size: 256K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256K
chunk_size: 512K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256K
chunk_size: 1M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256K
chunk_size: 2M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256K
chunk_size: 4M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256K
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 16M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 32M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 64M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 128M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 256M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 512M 	num_reg: 10  	lose cover RAM: -264M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 1G 	num_reg: 10  	lose cover RAM: -256M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 256K
chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1280M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512K
chunk_size: 512K 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512K
chunk_size: 1M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512K
chunk_size: 2M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512K
chunk_size: 4M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512K
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 16M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 32M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 64M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 128M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 256M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 512M 	num_reg: 10  	lose cover RAM: -264M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 1G 	num_reg: 10  	lose cover RAM: -256M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 512K
chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1280M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 1M
chunk_size: 1M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 1M
chunk_size: 2M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 1M
chunk_size: 4M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 1M
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 16M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 32M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 64M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 128M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 256M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 512M 	num_reg: 10  	lose cover RAM: -264M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 1G 	num_reg: 10  	lose cover RAM: -256M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 1M
chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1280M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 2M
chunk_size: 2M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 2M
chunk_size: 4M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 2M
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 16M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 32M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 64M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 128M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 256M 	num_reg: 10  	lose cover RAM: -8M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 512M 	num_reg: 10  	lose cover RAM: -264M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 1G 	num_reg: 10  	lose cover RAM: -256M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] *BAD*gran_size: 2M
chunk_size: 2G 	num_reg: 10  	lose cover RAM: -1280M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 4M 	num_reg: 10  	lose cover RAM: 114M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 16M 	num_reg: 10  	lose cover RAM: 18M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 32M 	num_reg: 9  	lose cover RAM: 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 64M 	num_reg: 9  	lose cover RAM: 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 128M 	num_reg: 9  	lose cover RAM: 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 256M 	num_reg: 9  	lose cover RAM: 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 512M 	num_reg: 10  	lose cover RAM: 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 1G 	num_reg: 9  	lose cover RAM: 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 4M
chunk_size: 2G 	num_reg: 10  	lose cover RAM: 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 8M 	num_reg: 10  	lose cover RAM: 54M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 16M 	num_reg: 10  	lose cover RAM: 22M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 32M 	num_reg: 9  	lose cover RAM: 6M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 64M 	num_reg: 9  	lose cover RAM: 6M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 128M 	num_reg: 9  	lose cover RAM: 6M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 256M 	num_reg: 9  	lose cover RAM: 6M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 512M 	num_reg: 10  	lose cover RAM: 6M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 1G 	num_reg: 9  	lose cover RAM: 6M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 8M
chunk_size: 2G 	num_reg: 10  	lose cover RAM: 6M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 16M 	num_reg: 10  	lose cover RAM: 30M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 32M 	num_reg: 9  	lose cover RAM: 14M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 64M 	num_reg: 9  	lose cover RAM: 14M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 128M 	num_reg: 9  	lose cover RAM: 14M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 256M 	num_reg: 9  	lose cover RAM: 14M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 512M 	num_reg: 10  	lose cover RAM: 14M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 1G 	num_reg: 9  	lose cover RAM: 14M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 16M
chunk_size: 2G 	num_reg: 10  	lose cover RAM: 14M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 32M
chunk_size: 32M 	num_reg: 9  	lose cover RAM: 46M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 32M
chunk_size: 64M 	num_reg: 9  	lose cover RAM: 46M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 32M
chunk_size: 128M 	num_reg: 9  	lose cover RAM: 46M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 32M
chunk_size: 256M 	num_reg: 9  	lose cover RAM: 46M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 32M
chunk_size: 512M 	num_reg: 10  	lose cover RAM: 46M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 32M
chunk_size: 1G 	num_reg: 9  	lose cover RAM: 46M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 32M
chunk_size: 2G 	num_reg: 10  	lose cover RAM: 46M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64M
chunk_size: 64M 	num_reg: 7  	lose cover RAM: 110M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64M
chunk_size: 128M 	num_reg: 7  	lose cover RAM: 110M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64M
chunk_size: 256M 	num_reg: 8  	lose cover RAM: 110M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64M
chunk_size: 512M 	num_reg: 9  	lose cover RAM: 110M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64M
chunk_size: 1G 	num_reg: 8  	lose cover RAM: 110M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 64M
chunk_size: 2G 	num_reg: 9  	lose cover RAM: 110M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128M
chunk_size: 128M 	num_reg: 6  	lose cover RAM: 174M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128M
chunk_size: 256M 	num_reg: 8  	lose cover RAM: 174M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128M
chunk_size: 512M 	num_reg: 9  	lose cover RAM: 174M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128M
chunk_size: 1G 	num_reg: 8  	lose cover RAM: 174M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 128M
chunk_size: 2G 	num_reg: 9  	lose cover RAM: 174M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256M
chunk_size: 256M 	num_reg: 4  	lose cover RAM: 430M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256M
chunk_size: 512M 	num_reg: 4  	lose cover RAM: 430M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256M
chunk_size: 1G 	num_reg: 5  	lose cover RAM: 430M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 256M
chunk_size: 2G 	num_reg: 6  	lose cover RAM: 430M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512M
chunk_size: 512M 	num_reg: 4  	lose cover RAM: 430M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512M
chunk_size: 1G 	num_reg: 5  	lose cover RAM: 430M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 512M
chunk_size: 2G 	num_reg: 6  	lose cover RAM: 430M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 1G
chunk_size: 1G 	num_reg: 3  	lose cover RAM: 942M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 1G
chunk_size: 2G 	num_reg: 3  	lose cover RAM: 942M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  gran_size: 2G
chunk_size: 2G 	num_reg: 2  	lose cover RAM: 1966M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] mtrr_cleanup: can not
find optimal value
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] please specify
mtrr_gran_size/mtrr_chunk_size
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] e820: update [mem
0xcbc00000-0xffffffff] usable ==> reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] e820: last_pfn =
0xca75f max_arch_pfn = 0x400000000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] found SMP MP-table at
[mem 0x000fccd0-0x000fccdf] mapped at [ffff8800000fccd0]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Base memory trampoline
at [ffff880000097000] 97000 size 24576
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x00000000-0x000fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x00000000-0x000fffff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BRK [0x02718000,
0x02718fff] PGTABLE
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BRK [0x02719000,
0x02719fff] PGTABLE
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BRK [0x0271a000,
0x0271afff] PGTABLE
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x22f000000-0x22f1fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x22f000000-0x22f1fffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BRK [0x0271b000,
0x0271bfff] PGTABLE
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x22c000000-0x22effffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x22c000000-0x22effffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x200000000-0x22bffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x200000000-0x22bffffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x00100000-0x1fffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x00100000-0x001fffff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x00200000-0x1fffffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x20200000-0x40003fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x20200000-0x3fffffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x40000000-0x40003fff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] BRK [0x0271c000,
0x0271cfff] PGTABLE
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x40005000-0xc90ebfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x40005000-0x401fffff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x40200000-0xc8ffffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0xc9000000-0xc90ebfff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0xc912f000-0xc9532fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0xc912f000-0xc91fffff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0xc9200000-0xc93fffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0xc9400000-0xc9532fff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0xc97f9000-0xca75efff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0xc97f9000-0xc97fffff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0xc9800000-0xca5fffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0xca600000-0xca75efff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] init_memory_mapping:
[mem 0x100000000-0x1ffffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]  [mem
0x100000000-0x1ffffffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] RAMDISK: [mem
0x3666a000-0x3732cfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: RSDP
00000000cafce000 00024 (v02 _ASUS_)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: XSDT
00000000cafce078 0006C (v01 _ASUS_ Notebook 01072009 AMI  00010013)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: FACP
00000000cafe15d0 000F4 (v04 _ASUS_ Notebook 01072009 AMI  00010013)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: DSDT
00000000cafce178 13458 (v02 _ASUS_ Notebook 00000013 INTL 20091112)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: FACS
00000000caff8f80 00040
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: APIC
00000000cafe16c8 00092 (v03 _ASUS_ Notebook 01072009 AMI  00010013)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: ECDT
00000000cafe1760 000C1 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: MCFG
00000000cafe1828 0003C (v01 _ASUS_ Notebook 01072009 MSFT 00000097)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: SLIC
00000000cafe1868 00176 (v01 _ASUS_ Notebook 01072009 ASUS 00000001)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: HPET
00000000cafe19e0 00038 (v01 _ASUS_ Notebook 01072009 AMI. 00000005)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: SSDT
00000000cafe1a18 0090A (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: SSDT
00000000cafe2328 00A92 (v01  PmRef    CpuPm 00003000 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: BGRT
00000000cafe2dc0 00038 (v00 _ASUS_ Notebook 01072009 ASUS 00010013)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] No NUMA configuration found
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Faking a node at [mem
0x0000000000000000-0x000000022f1fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Initmem setup node 0
[mem 0x00000000-0x22f1fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   NODE_DATA [mem
0x22f1e1000-0x22f1f4fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]
[ffffea0000000000-ffffea0008bfffff] PMD ->
[ffff880226800000-ffff88022e7fffff] on node 0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Zone ranges:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   DMA      [mem
0x00001000-0x00ffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   DMA32    [mem
0x01000000-0xffffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   Normal   [mem
0x100000000-0x22f1fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Movable zone start for
each node
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Early memory node ranges
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   node   0: [mem
0x00001000-0x0009efff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   node   0: [mem
0x00100000-0x1fffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   node   0: [mem
0x20200000-0x40003fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   node   0: [mem
0x40005000-0xc90ebfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   node   0: [mem
0xc912f000-0xc9532fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   node   0: [mem
0xc97f9000-0xca75efff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   node   0: [mem
0x100000000-0x22f1fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] On node 0 totalpages:
2069491
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   DMA zone: 64 pages
used for memmap
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   DMA zone: 28 pages
reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   DMA zone: 3998 pages,
LIFO batch:0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   DMA32 zone: 12874
pages used for memmap
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   DMA32 zone: 823893
pages, LIFO batch:31
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   Normal zone: 19400
pages used for memmap
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000]   Normal zone: 1241600
pages, LIFO batch:31
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: PM-Timer IO Port:
0x408
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: Local APIC
address 0xfee00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x01] lapic_id[0x00] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x02] lapic_id[0x02] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x03] lapic_id[0x04] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x04] lapic_id[0x06] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x05] lapic_id[0x01] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x06] lapic_id[0x03] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x07] lapic_id[0x05] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC
(acpi_id[0x08] lapic_id[0x07] enabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: LAPIC_NMI
(acpi_id[0xff] high edge lint[0x1])
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: IOAPIC (id[0x02]
address[0xfec00000] gsi_base[0])
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] IOAPIC[0]: apic_id 2,
version 32, address 0xfec00000, GSI 0-23
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 0 global_irq 2 dfl dfl)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: INT_SRC_OVR (bus
0 bus_irq 9 global_irq 9 high level)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: IRQ0 used by
override.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: IRQ2 used by
override.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: IRQ9 used by
override.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Using ACPI (MADT) for
SMP configuration information
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] ACPI: HPET id:
0x8086a701 base: 0xfed00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] smpboot: Allowing 8
CPUs, 0 hotplug CPUs
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] nr_irqs_gsi: 40
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 000000000009f000 - 00000000000a0000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000000a0000 - 0000000000100000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 0000000020000000 - 0000000020200000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 0000000040004000 - 0000000040005000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000c90ec000 - 00000000c912f000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000c9533000 - 00000000c97f9000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000ca75f000 - 00000000cad7b000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000cad7b000 - 00000000caffb000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000caffb000 - 00000000cb000000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000cb000000 - 00000000cbc00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000cbc00000 - 00000000cfe00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000cfe00000 - 00000000f8000000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000f8000000 - 00000000fc000000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fc000000 - 00000000fec00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fec00000 - 00000000fec01000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fec01000 - 00000000fed00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed00000 - 00000000fed04000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed04000 - 00000000fed1c000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed1c000 - 00000000fed20000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fed20000 - 00000000fee00000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee00000 - 00000000fee01000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000fee01000 - 00000000ff000000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PM: Registered nosave
memory: 00000000ff000000 - 0000000100000000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] e820: [mem
0xcfe00000-0xf7ffffff] available for PCI devices
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Booting paravirtualized
kernel on bare hardware
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] setup_percpu:
NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PERCPU: Embedded 27
pages/cpu @ffff88022ee00000 s80064 r8192 d22336 u262144
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] pcpu-alloc: s80064
r8192 d22336 u262144 alloc=1*2097152
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] pcpu-alloc: [0] 0 1 2 3
4 5 6 7
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Built 1 zonelists in
Zone order, mobility grouping on.  Total pages: 2037125
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Policy zone: Normal
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-3.10-3.slh.2-aptosid-amd64
root=UUID=385a4fdb-284c-4473-9e27-929a10afd6c0 ro acpi_backlight=vendor
quiet
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] PID hash table entries:
4096 (order: 3, 32768 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] xsave: enabled
xstate_bv 0x7, cntxt size 0x340
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Checking aperture...
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] No AGP bridge found
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Calgary: detecting
Calgary via BIOS EBDA area
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Calgary: Unable to
locate Rio Grande table in EBDA - bailing!
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Memory:
7880452k/9160704k available (3430k kernel code, 882740k absent, 397512k
reserved, 2037k data, 964k init)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] SLUB: HWalign=64,
Order=0-3, MinObjects=0, CPUs=8, Nodes=1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Preemptible
hierarchical RCU implementation.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] 	RCU dyntick-idle
grace-period acceleration is enabled.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] 	Dump stacks of tasks
blocking RCU-preempt GP.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] 	RCU restricting CPUs
from NR_CPUS=256 to nr_cpu_ids=8.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] NR_IRQS:16640
nr_irqs:744 16
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] Console: colour dummy
device 80x25
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] console [tty0] enabled
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] hpet clockevent registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000000] tsc: Fast TSC
calibration using PIT
Jul 29 19:29:07 ASUS-N56V kernel: [    0.001000] tsc: Detected 2294.860
MHz processor
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000002] Calibrating delay loop
(skipped), value calculated using timer frequency.. 4589.72 BogoMIPS
(lpj=2294860)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000005] pid_max: default: 32768
minimum: 301
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000024] init_memory_mapping:
[mem 0xc9533000-0xc97f8fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000026]  [mem
0xc9533000-0xc97f8fff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000051] init_memory_mapping:
[mem 0xca75f000-0xca77afff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000052]  [mem
0xca75f000-0xca77afff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000061] init_memory_mapping:
[mem 0xca77b000-0xca787fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000062]  [mem
0xca77b000-0xca787fff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000070] init_memory_mapping:
[mem 0xca788000-0xca7d7fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000071]  [mem
0xca788000-0xca7d7fff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000081] init_memory_mapping:
[mem 0xca7d8000-0xca837fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000082]  [mem
0xca7d8000-0xca837fff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000093] init_memory_mapping:
[mem 0xca838000-0xca850fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000094]  [mem
0xca838000-0xca850fff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000103] init_memory_mapping:
[mem 0xca851000-0xca87afff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000105]  [mem
0xca851000-0xca87afff] page 4k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000114] init_memory_mapping:
[mem 0xcbc00000-0xcfdfffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.000115]  [mem
0xcbc00000-0xcfdfffff] page 2M
Jul 29 19:29:07 ASUS-N56V kernel: [    0.145764] Security Framework
initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    0.145768] SELinux:  Disabled at boot.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.146226] Dentry cache hash table
entries: 1048576 (order: 11, 8388608 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.148333] Inode-cache hash table
entries: 524288 (order: 10, 4194304 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149257] Mount-cache hash table
entries: 256
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149426] Initializing cgroup
subsys devices
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149428] Initializing cgroup
subsys freezer
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149429] Initializing cgroup
subsys net_cls
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149431] Initializing cgroup
subsys blkio
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149432] Initializing cgroup
subsys perf_event
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149455] CPU: Physical Processor
ID: 0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149456] CPU: Processor Core ID: 0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149461] ENERGY_PERF_BIAS: Set
to 'normal', was 'performance'
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149461] ENERGY_PERF_BIAS: View
and update with x86_energy_perf_policy(8)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149850] mce: CPU supports 9 MCE
banks
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149863] CPU0: Thermal
monitoring enabled (TM1)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149872] Last level iTLB
entries: 4KB 512, 2MB 0, 4MB 0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149872] Last level dTLB
entries: 4KB 512, 2MB 32, 4MB 32
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149872] tlb_flushall_shift: 1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.149967] Freeing SMP
alternatives: 8k freed
Jul 29 19:29:07 ASUS-N56V kernel: [    0.150317] ACPI: Core revision
20130328
Jul 29 19:29:07 ASUS-N56V kernel: [    0.157760] ACPI: All ACPI Tables
successfully acquired
Jul 29 19:29:07 ASUS-N56V kernel: [    0.179913] ..TIMER: vector=0x30
apic1=0 pin1=2 apic2=-1 pin2=-1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189911] smpboot: CPU0: Intel(R)
Core(TM) i7-3610QM CPU @ 2.30GHz (fam: 06, model: 3a, stepping: 09)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189919] TSC deadline timer enabled
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189927] Performance Events:
PEBS fmt1+, 16-deep LBR, IvyBridge events, Intel PMU driver.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189934] ... version:
     3
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189935] ... bit width:
     48
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189936] ... generic registers:
     4
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189937] ... value mask:
     0000ffffffffffff
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189938] ... max period:
     000000007fffffff
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189939] ... fixed-purpose
events:   3
Jul 29 19:29:07 ASUS-N56V kernel: [    0.189940] ... event mask:
     000000070000000f
Jul 29 19:29:07 ASUS-N56V kernel: [    0.198005] smpboot: Booting Node
 0, Processors  #1 #2 #3 #4 #5 #6 #7 OK
Jul 29 19:29:07 ASUS-N56V kernel: [    0.305715] Brought up 8 CPUs
Jul 29 19:29:07 ASUS-N56V kernel: [    0.305718] smpboot: Total of 8
processors activated (36717.76 BogoMIPS)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.312986] devtmpfs: initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    0.316098] PM: Registering ACPI
NVS region [mem 0xc90ec000-0xc912efff] (274432 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.316103] PM: Registering ACPI
NVS region [mem 0xcad7b000-0xcaffafff] (2621440 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.316230] NET: Registered
protocol family 16
Jul 29 19:29:07 ASUS-N56V kernel: [    0.316328] ACPI FADT declares the
system doesn't support PCIe ASPM, so disable it
Jul 29 19:29:07 ASUS-N56V kernel: [    0.316329] ACPI: bus type PCI
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.316383] PCI: MMCONFIG for
domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.316385] PCI: MMCONFIG at [mem
0xf8000000-0xfbffffff] reserved in E820
Jul 29 19:29:07 ASUS-N56V kernel: [    0.319807] PCI: Using
configuration type 1 for base access
Jul 29 19:29:07 ASUS-N56V kernel: [    0.320421] bio: create slab
<bio-0> at 0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.320531] ACPI: Added _OSI(Module
Device)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.320533] ACPI: Added
_OSI(Processor Device)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.320534] ACPI: Added _OSI(3.0
_SCP Extensions)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.320536] ACPI: Added
_OSI(Processor Aggregator Device)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.322751] ACPI: EC: EC
description table is found, configuring boot EC
Jul 29 19:29:07 ASUS-N56V kernel: [    0.325037] ACPI: Executed 1 blocks
of module-level executable AML code
Jul 29 19:29:07 ASUS-N56V kernel: [    0.382001] [Firmware Bug]: ACPI:
BIOS _OSI(Linux) query ignored
Jul 29 19:29:07 ASUS-N56V kernel: [    0.382465] ACPI: SSDT
00000000cad28018 00853 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.383030] ACPI: Dynamic OEM Table
Load:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.383032] ACPI: SSDT
(null) 00853 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.388158] ACPI: SSDT
00000000cad29a98 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.388745] ACPI: Dynamic OEM Table
Load:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.388747] ACPI: SSDT
(null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.392040] ACPI: SSDT
00000000cad2ac18 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.392598] ACPI: Dynamic OEM Table
Load:
Jul 29 19:29:07 ASUS-N56V kernel: [    0.392600] ACPI: SSDT
(null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.397122] ACPI: Interpreter enabled
Jul 29 19:29:07 ASUS-N56V kernel: [    0.397130] ACPI Exception:
AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20130328/hwxface-568)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.397136] ACPI Exception:
AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130328/hwxface-568)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.397150] ACPI: (supports S0 S3
S4 S5)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.397152] ACPI: Using IOAPIC for
interrupt routing
Jul 29 19:29:07 ASUS-N56V kernel: [    0.397175] PCI: Using host bridge
windows from ACPI; if necessary, use "pci=nocrs" and report a bug
Jul 29 19:29:07 ASUS-N56V kernel: [    0.397308] ACPI: No dock devices
found.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.407613] ACPI: PCI Root Bridge
[PCI0] (domain 0000 [bus 00-3e])
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408264] PCI host bridge to bus
0000:00
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408268] pci_bus 0000:00: root
bus resource [bus 00-3e]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408270] pci_bus 0000:00: root
bus resource [io  0x0000-0x0cf7]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408272] pci_bus 0000:00: root
bus resource [io  0x0d00-0xffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408274] pci_bus 0000:00: root
bus resource [mem 0x000a0000-0x000bffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408276] pci_bus 0000:00: root
bus resource [mem 0x000d0000-0x000d3fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408277] pci_bus 0000:00: root
bus resource [mem 0x000d4000-0x000d7fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408279] pci_bus 0000:00: root
bus resource [mem 0x000d8000-0x000dbfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408281] pci_bus 0000:00: root
bus resource [mem 0x000dc000-0x000dffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408283] pci_bus 0000:00: root
bus resource [mem 0xcfe00000-0xfeafffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408291] pci 0000:00:00.0:
[8086:0154] type 00 class 0x060000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408380] pci 0000:00:01.0:
[8086:0151] type 01 class 0x060400
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408413] pci 0000:00:01.0: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408432] pci 0000:00:01.0:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408465] pci 0000:00:02.0:
[8086:0166] type 00 class 0x030000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408477] pci 0000:00:02.0: reg
10: [mem 0xf7400000-0xf77fffff 64bit]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408484] pci 0000:00:02.0: reg
18: [mem 0xd0000000-0xdfffffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408489] pci 0000:00:02.0: reg
20: [io  0xf000-0xf03f]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408589] pci 0000:00:14.0:
[8086:1e31] type 00 class 0x0c0330
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408613] pci 0000:00:14.0: reg
10: [mem 0xf7a00000-0xf7a0ffff 64bit]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408688] pci 0000:00:14.0: PME#
supported from D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408713] pci 0000:00:14.0:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408747] pci 0000:00:16.0:
[8086:1e3a] type 00 class 0x078000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408772] pci 0000:00:16.0: reg
10: [mem 0xf7a1a000-0xf7a1a00f 64bit]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408852] pci 0000:00:16.0: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408949] pci 0000:00:1a.0:
[8086:1e2d] type 00 class 0x0c0320
Jul 29 19:29:07 ASUS-N56V kernel: [    0.408973] pci 0000:00:1a.0: reg
10: [mem 0xf7a18000-0xf7a183ff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409068] pci 0000:00:1a.0: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409101] pci 0000:00:1a.0:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409136] pci 0000:00:1b.0:
[8086:1e20] type 00 class 0x040300
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409152] pci 0000:00:1b.0: reg
10: [mem 0xf7a10000-0xf7a13fff 64bit]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409225] pci 0000:00:1b.0: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409261] pci 0000:00:1b.0:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409293] pci 0000:00:1c.0:
[8086:1e10] type 01 class 0x060400
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409377] pci 0000:00:1c.0: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409454] pci 0000:00:1c.1:
[8086:1e12] type 01 class 0x060400
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409536] pci 0000:00:1c.1: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409616] pci 0000:00:1c.3:
[8086:1e16] type 01 class 0x060400
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409699] pci 0000:00:1c.3: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409752] pci 0000:00:1c.3:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409791] pci 0000:00:1d.0:
[8086:1e26] type 00 class 0x0c0320
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409815] pci 0000:00:1d.0: reg
10: [mem 0xf7a17000-0xf7a173ff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409910] pci 0000:00:1d.0: PME#
supported from D0 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409942] pci 0000:00:1d.0:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.409976] pci 0000:00:1f.0:
[8086:1e59] type 00 class 0x060100
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410153] pci 0000:00:1f.2:
[8086:1e03] type 00 class 0x010601
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410174] pci 0000:00:1f.2: reg
10: [io  0xf0b0-0xf0b7]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410182] pci 0000:00:1f.2: reg
14: [io  0xf0a0-0xf0a3]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410191] pci 0000:00:1f.2: reg
18: [io  0xf090-0xf097]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410200] pci 0000:00:1f.2: reg
1c: [io  0xf080-0xf083]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410209] pci 0000:00:1f.2: reg
20: [io  0xf060-0xf07f]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410218] pci 0000:00:1f.2: reg
24: [mem 0xf7a16000-0xf7a167ff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410267] pci 0000:00:1f.2: PME#
supported from D3hot
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410332] pci 0000:00:1f.3:
[8086:1e22] type 00 class 0x0c0500
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410348] pci 0000:00:1f.3: reg
10: [mem 0xf7a15000-0xf7a150ff 64bit]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410371] pci 0000:00:1f.3: reg
20: [io  0xf040-0xf05f]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410492] pci 0000:01:00.0:
[10de:0de9] type 00 class 0x030000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410503] pci 0000:01:00.0: reg
10: [mem 0xf6000000-0xf6ffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410515] pci 0000:01:00.0: reg
14: [mem 0xe0000000-0xefffffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410526] pci 0000:01:00.0: reg
1c: [mem 0xf0000000-0xf1ffffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410534] pci 0000:01:00.0: reg
24: [io  0xe000-0xe07f]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.410542] pci 0000:01:00.0: reg
30: [mem 0xf7000000-0xf707ffff pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.412945] pci 0000:00:01.0: PCI
bridge to [bus 01]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.412951] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.412956] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.412974] pci 0000:00:01.0:
bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.413035] pci 0000:00:1c.0: PCI
bridge to [bus 02]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.413125] pci 0000:03:00.0:
[168c:0032] type 00 class 0x028000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.413153] pci 0000:03:00.0: reg
10: [mem 0xf7900000-0xf797ffff 64bit]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.413219] pci 0000:03:00.0: reg
30: [mem 0xf7980000-0xf798ffff pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.413288] pci 0000:03:00.0:
supports D1 D2
Jul 29 19:29:07 ASUS-N56V kernel: [    0.413290] pci 0000:03:00.0: PME#
supported from D0 D1 D2 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.413322] pci 0000:03:00.0:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.415957] pci 0000:00:1c.1: PCI
bridge to [bus 03]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.415982] pci 0000:00:1c.1:
bridge window [mem 0xf7900000-0xf79fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.416267] pci 0000:04:00.0:
[1969:1091] type 00 class 0x020000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.416621] pci 0000:04:00.0: reg
10: [mem 0xf7800000-0xf783ffff 64bit]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.416785] pci 0000:04:00.0: reg
18: [io  0xd000-0xd07f]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.418556] pci 0000:04:00.0: PME#
supported from D0 D1 D2 D3hot D3cold
Jul 29 19:29:07 ASUS-N56V kernel: [    0.418837] pci 0000:04:00.0:
System wakeup disabled by ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    0.420247] pci 0000:00:1c.3: PCI
bridge to [bus 04]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.420251] pci 0000:00:1c.3:
bridge window [io  0xd000-0xdfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.420256] pci 0000:00:1c.3:
bridge window [mem 0xf7800000-0xf78fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.420351] acpi PNP0A08:00:
Requesting ACPI _OSC control (0x1d)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.420466] acpi PNP0A08:00: ACPI
_OSC control (0x1d) granted
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421170] ACPI: PCI Interrupt
Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421219] ACPI: PCI Interrupt
Link [LNKB] (IRQs 3 4 5 6 7 *10 12)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421266] ACPI: PCI Interrupt
Link [LNKC] (IRQs 3 4 5 6 7 *10 12)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421312] ACPI: PCI Interrupt
Link [LNKD] (IRQs 3 4 *5 6 7 10 12)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421356] ACPI: PCI Interrupt
Link [LNKE] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421402] ACPI: PCI Interrupt
Link [LNKF] (IRQs 3 4 5 6 7 10 12) *0, disabled.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421448] ACPI: PCI Interrupt
Link [LNKG] (IRQs *3 4 5 6 7 10 12)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421494] ACPI: PCI Interrupt
Link [LNKH] (IRQs 3 *4 5 6 7 10 12)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421832] ACPI: Enabled 4 GPEs in
block 00 to 3F
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421838] acpi root: \_SB_.PCI0
notify handler is installed
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421900] Found 1 acpi root devices
Jul 29 19:29:07 ASUS-N56V kernel: [    0.421964] ACPI: EC: GPE = 0x19,
I/O: command/status = 0x66, data = 0x62
Jul 29 19:29:07 ASUS-N56V kernel: [    0.422064] vgaarb: device added:
PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
Jul 29 19:29:07 ASUS-N56V kernel: [    0.422069] vgaarb: device added:
PCI:0000:01:00.0,decodes=io+mem,owns=none,locks=none
Jul 29 19:29:07 ASUS-N56V kernel: [    0.422070] vgaarb: loaded
Jul 29 19:29:07 ASUS-N56V kernel: [    0.422071] vgaarb: bridge control
possible 0000:01:00.0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.422072] vgaarb: no bridge
control possible 0000:00:02.0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.422116] PCI: Using ACPI for IRQ
routing
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423683] PCI:
pci_cache_line_size set to 64 bytes
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423735] e820: reserve RAM
buffer [mem 0x0009f000-0x0009ffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423737] e820: reserve RAM
buffer [mem 0x40004000-0x43ffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423739] e820: reserve RAM
buffer [mem 0xc90ec000-0xcbffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423741] e820: reserve RAM
buffer [mem 0xc9533000-0xcbffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423743] e820: reserve RAM
buffer [mem 0xca75f000-0xcbffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423744] e820: reserve RAM
buffer [mem 0x22f200000-0x22fffffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423814] NetLabel: Initializing
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423816] NetLabel:  domain hash
size = 128
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423817] NetLabel:  protocols =
UNLABELED CIPSOv4
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423825] NetLabel:  unlabeled
traffic allowed by default
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423852] hpet0: at MMIO
0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.423858] hpet0: 8 comparators,
64-bit 14.318180 MHz counter
Jul 29 19:29:07 ASUS-N56V kernel: [    0.425872] Switching to
clocksource hpet
Jul 29 19:29:07 ASUS-N56V kernel: [    0.425916] pnp: PnP ACPI init
Jul 29 19:29:07 ASUS-N56V kernel: [    0.425924] ACPI: bus type PNP
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.425982] system 00:00: [mem
0xfed40000-0xfed44fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.425985] system 00:00: Plug and
Play ACPI device, IDs PNP0c01 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426054] pnp 00:01: [dma 4]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426070] pnp 00:01: Plug and
Play ACPI device, IDs PNP0200 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426091] pnp 00:02: Plug and
Play ACPI device, IDs INT0800 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426177] pnp 00:03: Plug and
Play ACPI device, IDs PNP0103 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426217] system 00:04: [io
0x0680-0x069f] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426219] system 00:04: [io
0x0200-0x020f] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426221] system 00:04: [io
0xffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426223] system 00:04: [io
0xffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426225] system 00:04: [io
0x0400-0x0453] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426227] system 00:04: [io
0x0458-0x047f] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426229] system 00:04: [io
0x0500-0x057f] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426231] system 00:04: [io
0x164e-0x164f] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426233] system 00:04: Plug and
Play ACPI device, IDs PNP0c02 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426260] pnp 00:05: Plug and
Play ACPI device, IDs PNP0b00 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426303] system 00:06: [io
0x0454-0x0457] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426306] system 00:06: Plug and
Play ACPI device, IDs INT3f0d PNP0c02 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426349] system 00:07: [io
0x04d0-0x04d1] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426352] system 00:07: Plug and
Play ACPI device, IDs PNP0c02 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426378] pnp 00:08: Plug and
Play ACPI device, IDs PNP0c04 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426433] pnp 00:09: Plug and
Play ACPI device, IDs ETD0108 SYN0a00 SYN0002 PNP0f03 PNP0f13 PNP0f12
(active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426470] pnp 00:0a: Plug and
Play ACPI device, IDs PNP0303 PNP030b (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426637] system 00:0b: [mem
0xfed1c000-0xfed1ffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426640] system 00:0b: [mem
0xfed10000-0xfed17fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426642] system 00:0b: [mem
0xfed18000-0xfed18fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426644] system 00:0b: [mem
0xfed19000-0xfed19fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426646] system 00:0b: [mem
0xf8000000-0xfbffffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426648] system 00:0b: [mem
0xfed20000-0xfed3ffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426650] system 00:0b: [mem
0xfed90000-0xfed93fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426652] system 00:0b: [mem
0xfed45000-0xfed8ffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426654] system 00:0b: [mem
0xff000000-0xffffffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426656] system 00:0b: [mem
0xfee00000-0xfeefffff] could not be reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426658] system 00:0b: [mem
0xcfe00000-0xcfe00fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426661] system 00:0b: Plug and
Play ACPI device, IDs PNP0c02 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426727] system 00:0c: [mem
0xcfe00000-0xcfe00fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426729] system 00:0c: Plug and
Play ACPI device, IDs PNP0c02 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426864] system 00:0d: [mem
0x20000000-0x201fffff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426867] system 00:0d: [mem
0x40004000-0x40004fff] has been reserved
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426879] system 00:0d: Plug and
Play ACPI device, IDs PNP0c01 (active)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426903] pnp: PnP ACPI: found 14
devices
Jul 29 19:29:07 ASUS-N56V kernel: [    0.426904] ACPI: bus type PNP
unregistered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433061] pci 0000:00:1c.0:
bridge window [io  0x1000-0x0fff] to [bus 02] add_size 1000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433065] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff 64bit pref] to [bus 02]
add_size 200000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433067] pci 0000:00:1c.0:
bridge window [mem 0x00100000-0x000fffff] to [bus 02] add_size 200000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433087] pci 0000:00:1c.0:
res[14]=[mem 0x00100000-0x000fffff] get_res_add_size add_size 200000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433089] pci 0000:00:1c.0:
res[15]=[mem 0x00100000-0x000fffff 64bit pref] get_res_add_size add_size
200000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433091] pci 0000:00:1c.0:
res[13]=[io  0x1000-0x0fff] get_res_add_size add_size 1000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433095] pci 0000:00:1c.0: BAR
14: assigned [mem 0xf2000000-0xf21fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433099] pci 0000:00:1c.0: BAR
15: assigned [mem 0xf2200000-0xf23fffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433102] pci 0000:00:1c.0: BAR
13: assigned [io  0x2000-0x2fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433104] pci 0000:00:01.0: PCI
bridge to [bus 01]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433107] pci 0000:00:01.0:
bridge window [io  0xe000-0xefff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433110] pci 0000:00:01.0:
bridge window [mem 0xf6000000-0xf70fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433112] pci 0000:00:01.0:
bridge window [mem 0xe0000000-0xf1ffffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433116] pci 0000:00:1c.0: PCI
bridge to [bus 02]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433119] pci 0000:00:1c.0:
bridge window [io  0x2000-0x2fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433125] pci 0000:00:1c.0:
bridge window [mem 0xf2000000-0xf21fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433129] pci 0000:00:1c.0:
bridge window [mem 0xf2200000-0xf23fffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433136] pci 0000:00:1c.1: PCI
bridge to [bus 03]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433142] pci 0000:00:1c.1:
bridge window [mem 0xf7900000-0xf79fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433151] pci 0000:00:1c.3: PCI
bridge to [bus 04]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433154] pci 0000:00:1c.3:
bridge window [io  0xd000-0xdfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433159] pci 0000:00:1c.3:
bridge window [mem 0xf7800000-0xf78fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433432] pci_bus 0000:00:
resource 4 [io  0x0000-0x0cf7]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433434] pci_bus 0000:00:
resource 5 [io  0x0d00-0xffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433436] pci_bus 0000:00:
resource 6 [mem 0x000a0000-0x000bffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433438] pci_bus 0000:00:
resource 7 [mem 0x000d0000-0x000d3fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433439] pci_bus 0000:00:
resource 8 [mem 0x000d4000-0x000d7fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433441] pci_bus 0000:00:
resource 9 [mem 0x000d8000-0x000dbfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433443] pci_bus 0000:00:
resource 10 [mem 0x000dc000-0x000dffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433445] pci_bus 0000:00:
resource 11 [mem 0xcfe00000-0xfeafffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433447] pci_bus 0000:01:
resource 0 [io  0xe000-0xefff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433448] pci_bus 0000:01:
resource 1 [mem 0xf6000000-0xf70fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433450] pci_bus 0000:01:
resource 2 [mem 0xe0000000-0xf1ffffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433452] pci_bus 0000:02:
resource 0 [io  0x2000-0x2fff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433454] pci_bus 0000:02:
resource 1 [mem 0xf2000000-0xf21fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433456] pci_bus 0000:02:
resource 2 [mem 0xf2200000-0xf23fffff 64bit pref]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433458] pci_bus 0000:03:
resource 1 [mem 0xf7900000-0xf79fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433460] pci_bus 0000:04:
resource 0 [io  0xd000-0xdfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433461] pci_bus 0000:04:
resource 1 [mem 0xf7800000-0xf78fffff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433487] NET: Registered
protocol family 2
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433673] TCP established hash
table entries: 65536 (order: 8, 1048576 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433853] TCP bind hash table
entries: 65536 (order: 8, 1048576 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433968] TCP: Hash tables
configured (established 65536 bind 65536)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433983] TCP: reno registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.433994] UDP hash table entries:
4096 (order: 5, 131072 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.434021] UDP-Lite hash table
entries: 4096 (order: 5, 131072 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.434088] NET: Registered
protocol family 1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.434100] pci 0000:00:02.0: Boot
video device
Jul 29 19:29:07 ASUS-N56V kernel: [    0.434571] pci 0000:04:00.0: set
MSI_INTX_DISABLE_BUG flag
Jul 29 19:29:07 ASUS-N56V kernel: [    0.434576] PCI: CLS 64 bytes,
default 64
Jul 29 19:29:07 ASUS-N56V kernel: [    0.434607] Unpacking initramfs...
Jul 29 19:29:07 ASUS-N56V kernel: [    0.682562] Freeing initrd memory:
13068k freed
Jul 29 19:29:07 ASUS-N56V kernel: [    0.684122] PCI-DMA: Using software
bounce buffering for IO (SWIOTLB)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.684127] software IO TLB [mem
0xc50ec000-0xc90ec000] (64MB) mapped at [ffff8800c50ec000-ffff8800c90ebfff]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.684593] audit: initializing
netlink socket (disabled)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.684607] type=2000
audit(1375118927.529:1): initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    0.685031] bounce pool size: 64 pages
Jul 29 19:29:07 ASUS-N56V kernel: [    0.685041] HugeTLB registered 2 MB
page size, pre-allocated 0 pages
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686333] VFS: Disk quotas
dquot_6.5.2
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686369] Dquot-cache hash table
entries: 512 (order 0, 4096 bytes)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686457] msgmni has been set to
15766
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686734] alg: No test for stdrng
(krng)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686743] Key type asymmetric
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686746] Asymmetric key parser
'x509' registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686783] Block layer SCSI
generic (bsg) driver version 0.4 loaded (major 252)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686828] io scheduler noop
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686831] io scheduler deadline
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686854] io scheduler cfq
registered (default)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686913] pcieport 0000:00:01.0:
irq 40 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    0.686977] pcieport 0000:00:1c.0:
irq 41 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687057] pcieport 0000:00:1c.1:
irq 42 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687131] pcieport 0000:00:1c.3:
irq 43 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687205] pcieport 0000:00:01.0:
Signaling PME through PCIe PME interrupt
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687207] pci 0000:01:00.0:
Signaling PME through PCIe PME interrupt
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687210] pcie_pme
0000:00:01.0:pcie01: service driver pcie_pme loaded
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687227] pcieport 0000:00:1c.0:
Signaling PME through PCIe PME interrupt
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687232] pcie_pme
0000:00:1c.0:pcie01: service driver pcie_pme loaded
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687250] pcieport 0000:00:1c.1:
Signaling PME through PCIe PME interrupt
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687252] pci 0000:03:00.0:
Signaling PME through PCIe PME interrupt
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687256] pcie_pme
0000:00:1c.1:pcie01: service driver pcie_pme loaded
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687273] pcieport 0000:00:1c.3:
Signaling PME through PCIe PME interrupt
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687275] pci 0000:04:00.0:
Signaling PME through PCIe PME interrupt
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687279] pcie_pme
0000:00:1c.3:pcie01: service driver pcie_pme loaded
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687348] efifb: probing for efifb
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687481] efifb: framebuffer at
0xd0000000, mapped to 0xffffc9000a000000, using 1920k, total 1920k
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687483] efifb: mode is
800x600x32, linelength=3200, pages=1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687484] efifb: scrolling: redraw
Jul 29 19:29:07 ASUS-N56V kernel: [    0.687486] efifb: Truecolor:
size=8:8:8:8, shift=24:16:8:0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.688720] Console: switching to
colour frame buffer device 100x37
Jul 29 19:29:07 ASUS-N56V kernel: [    0.689894] fb0: EFI VGA frame
buffer device
Jul 29 19:29:07 ASUS-N56V kernel: [    0.689899] intel_idle: MWAIT
substates: 0x21120
Jul 29 19:29:07 ASUS-N56V kernel: [    0.689900] intel_idle: v0.4 model 0x3A
Jul 29 19:29:07 ASUS-N56V kernel: [    0.689901] intel_idle:
lapic_timer_reliable_states 0xffffffff
Jul 29 19:29:07 ASUS-N56V kernel: [    0.689954] GHES: HEST is not enabled!
Jul 29 19:29:07 ASUS-N56V kernel: [    0.690000] Serial: 8250/16550
driver, 4 ports, IRQ sharing enabled
Jul 29 19:29:07 ASUS-N56V kernel: [    0.690497] Linux agpgart interface
v0.103
Jul 29 19:29:07 ASUS-N56V kernel: [    0.690620] mei_me 0000:00:16.0:
setting latency timer to 64
Jul 29 19:29:07 ASUS-N56V kernel: [    0.690647] mei_me 0000:00:16.0:
irq 44 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    0.693600] libphy: Fixed MDIO Bus:
probed
Jul 29 19:29:07 ASUS-N56V kernel: [    0.693636] i8042: PNP: PS/2
Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
Jul 29 19:29:07 ASUS-N56V kernel: [    0.696628] i8042: Detected active
multiplexing controller, rev 1.1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697569] serio: i8042 KBD port
at 0x60,0x64 irq 1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697590] serio: i8042 AUX0 port
at 0x60,0x64 irq 12
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697606] serio: i8042 AUX1 port
at 0x60,0x64 irq 12
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697618] serio: i8042 AUX2 port
at 0x60,0x64 irq 12
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697632] serio: i8042 AUX3 port
at 0x60,0x64 irq 12
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697684] mousedev: PS/2 mouse
device common for all mice
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697721] rtc_cmos 00:05: RTC can
wake from S4
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697851] rtc_cmos 00:05: rtc
core: registered rtc_cmos as rtc0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697880] rtc_cmos 00:05: alarms
up to one month, y3k, 242 bytes nvram, hpet irqs
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697889] Intel P-state driver
initializing.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697897] Intel pstate
controlling: cpu 0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697908] Intel pstate
controlling: cpu 1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697918] Intel pstate
controlling: cpu 2
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697927] Intel pstate
controlling: cpu 3
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697935] Intel pstate
controlling: cpu 4
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697945] Intel pstate
controlling: cpu 5
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697954] Intel pstate
controlling: cpu 6
Jul 29 19:29:07 ASUS-N56V kernel: [    0.697963] Intel pstate
controlling: cpu 7
Jul 29 19:29:07 ASUS-N56V kernel: [    0.698132] cpuidle: using governor
ladder
Jul 29 19:29:07 ASUS-N56V kernel: [    0.698346] cpuidle: using governor
menu
Jul 29 19:29:07 ASUS-N56V kernel: [    0.698416] EFI Variables Facility
v0.08 2004-May-17
Jul 29 19:29:07 ASUS-N56V kernel: [    0.755306] input: AT Translated
Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.826704] TCP: cubic registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.826765] NET: Registered
protocol family 10
Jul 29 19:29:07 ASUS-N56V kernel: [    0.826901] Key type dns_resolver
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.827554] registered taskstats
version 1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.827769] IMA: No TPM chip found,
activating TPM-bypass!
Jul 29 19:29:07 ASUS-N56V kernel: [    0.828615] rtc_cmos 00:05: setting
system clock to 2013-07-29 17:28:48 UTC (1375118928)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.829087] Freeing unused kernel
memory: 964k freed
Jul 29 19:29:07 ASUS-N56V kernel: [    0.905347] thermal LNXTHERM:00:
registered as thermal_zone0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.905351] ACPI: Thermal Zone
[THRM] (64 C)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.908503] ACPI: bus type USB
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.908527] usbcore: registered new
interface driver usbfs
Jul 29 19:29:07 ASUS-N56V kernel: [    0.908537] usbcore: registered new
interface driver hub
Jul 29 19:29:07 ASUS-N56V kernel: [    0.908585] usbcore: registered new
device driver usb
Jul 29 19:29:07 ASUS-N56V kernel: [    0.908990] ehci_hcd: USB 2.0
'Enhanced' Host Controller (EHCI) Driver
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909078] xhci_hcd 0000:00:14.0:
setting latency timer to 64
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909083] xhci_hcd 0000:00:14.0:
xHCI Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909089] xhci_hcd 0000:00:14.0:
new USB bus registered, assigned bus number 1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909185] xhci_hcd 0000:00:14.0:
cache line size of 64 is not supported
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909187] ehci-pci: EHCI PCI
platform driver
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909210] xhci_hcd 0000:00:14.0:
irq 45 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909265] usb usb1: New USB
device found, idVendor=1d6b, idProduct=0002
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909267] usb usb1: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909270] usb usb1: Product: xHCI
Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909272] usb usb1: Manufacturer:
Linux 3.10-3.slh.2-aptosid-amd64 xhci_hcd
Jul 29 19:29:07 ASUS-N56V kernel: [    0.909274] usb usb1: SerialNumber:
0000:00:14.0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910034] xHCI xhci_add_endpoint
called for root hub
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910036] xHCI
xhci_check_bandwidth called for root hub
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910065] hub 1-0:1.0: USB hub found
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910073] hub 1-0:1.0: 4 ports
detected
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910175] xhci_hcd 0000:00:14.0:
xHCI Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910179] xhci_hcd 0000:00:14.0:
new USB bus registered, assigned bus number 2
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910202] usb usb2: New USB
device found, idVendor=1d6b, idProduct=0003
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910205] usb usb2: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910207] usb usb2: Product: xHCI
Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910209] SCSI subsystem initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910210] usb usb2: Manufacturer:
Linux 3.10-3.slh.2-aptosid-amd64 xhci_hcd
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910212] usb usb2: SerialNumber:
0000:00:14.0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910288] xHCI xhci_add_endpoint
called for root hub
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910289] xHCI
xhci_check_bandwidth called for root hub
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910312] hub 2-0:1.0: USB hub found
Jul 29 19:29:07 ASUS-N56V kernel: [    0.910320] hub 2-0:1.0: 4 ports
detected
Jul 29 19:29:07 ASUS-N56V kernel: [    0.911009] ACPI: bus type ATA
registered
Jul 29 19:29:07 ASUS-N56V kernel: [    0.911073] libata version 3.00 loaded.
Jul 29 19:29:07 ASUS-N56V kernel: [    0.913504] alx 0000:04:00.0 eth0:
Qualcomm Atheros AR816x/AR817x Ethernet [10:bf:48:14:bb:d2]
Jul 29 19:29:07 ASUS-N56V kernel: [    0.916146] alg: No test for
__gcm-aes-aesni (__driver-gcm-aes-aesni)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.919358] alg: No test for crc32
(crc32-pclmul)
Jul 29 19:29:07 ASUS-N56V kernel: [    0.919905] ehci-pci 0000:00:1a.0:
setting latency timer to 64
Jul 29 19:29:07 ASUS-N56V kernel: [    0.919916] ehci-pci 0000:00:1a.0:
EHCI Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.919924] ehci-pci 0000:00:1a.0:
new USB bus registered, assigned bus number 3
Jul 29 19:29:07 ASUS-N56V kernel: [    0.919941] ehci-pci 0000:00:1a.0:
debug port 2
Jul 29 19:29:07 ASUS-N56V kernel: [    0.923846] ehci-pci 0000:00:1a.0:
cache line size of 64 is not supported
Jul 29 19:29:07 ASUS-N56V kernel: [    0.923862] ehci-pci 0000:00:1a.0:
irq 16, io mem 0xf7a18000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929665] ehci-pci 0000:00:1a.0:
USB 2.0 started, EHCI 1.00
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929700] usb usb3: New USB
device found, idVendor=1d6b, idProduct=0002
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929704] usb usb3: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929728] usb usb3: Product: EHCI
Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929729] usb usb3: Manufacturer:
Linux 3.10-3.slh.2-aptosid-amd64 ehci_hcd
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929730] usb usb3: SerialNumber:
0000:00:1a.0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929870] hub 3-0:1.0: USB hub found
Jul 29 19:29:07 ASUS-N56V kernel: [    0.929874] hub 3-0:1.0: 2 ports
detected
Jul 29 19:29:07 ASUS-N56V kernel: [    0.930001] ehci-pci 0000:00:1d.0:
setting latency timer to 64
Jul 29 19:29:07 ASUS-N56V kernel: [    0.930007] ehci-pci 0000:00:1d.0:
EHCI Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.930010] ehci-pci 0000:00:1d.0:
new USB bus registered, assigned bus number 4
Jul 29 19:29:07 ASUS-N56V kernel: [    0.930021] ehci-pci 0000:00:1d.0:
debug port 2
Jul 29 19:29:07 ASUS-N56V kernel: [    0.933911] ehci-pci 0000:00:1d.0:
cache line size of 64 is not supported
Jul 29 19:29:07 ASUS-N56V kernel: [    0.933922] ehci-pci 0000:00:1d.0:
irq 23, io mem 0xf7a17000
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939767] ehci-pci 0000:00:1d.0:
USB 2.0 started, EHCI 1.00
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939781] usb usb4: New USB
device found, idVendor=1d6b, idProduct=0002
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939783] usb usb4: New USB
device strings: Mfr=3, Product=2, SerialNumber=1
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939785] usb usb4: Product: EHCI
Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939786] usb usb4: Manufacturer:
Linux 3.10-3.slh.2-aptosid-amd64 ehci_hcd
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939788] usb usb4: SerialNumber:
0000:00:1d.0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939969] hub 4-0:1.0: USB hub found
Jul 29 19:29:07 ASUS-N56V kernel: [    0.939974] hub 4-0:1.0: 2 ports
detected
Jul 29 19:29:07 ASUS-N56V kernel: [    0.940088] ahci 0000:00:1f.2:
version 3.0
Jul 29 19:29:07 ASUS-N56V kernel: [    0.940180] ahci 0000:00:1f.2: irq
46 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    0.940207] ahci: SSS flag set,
parallel bus scan disabled
Jul 29 19:29:07 ASUS-N56V kernel: [    0.950675] ahci 0000:00:1f.2: AHCI
0001.0300 32 slots 6 ports 6 Gbps 0x5 impl SATA mode
Jul 29 19:29:07 ASUS-N56V kernel: [    0.950684] ahci 0000:00:1f.2:
flags: 64bit ncq stag pm led clo pio slum part ems apst
Jul 29 19:29:07 ASUS-N56V kernel: [    0.950693] ahci 0000:00:1f.2:
setting latency timer to 64
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953113] scsi0 : ahci
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953325] scsi1 : ahci
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953494] scsi2 : ahci
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953603] scsi3 : ahci
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953723] scsi4 : ahci
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953845] scsi5 : ahci
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953905] ata1: SATA max UDMA/133
abar m2048@0xf7a16000 port 0xf7a16100 irq 46
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953907] ata2: DUMMY
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953910] ata3: SATA max UDMA/133
abar m2048@0xf7a16000 port 0xf7a16200 irq 46
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953910] ata4: DUMMY
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953911] ata5: DUMMY
Jul 29 19:29:07 ASUS-N56V kernel: [    0.953912] ata6: DUMMY
Jul 29 19:29:07 ASUS-N56V kernel: [    1.258516] ata1: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Jul 29 19:29:07 ASUS-N56V kernel: [    1.262528] usb 1-2: new low-speed
USB device number 2 using xhci_hcd
Jul 29 19:29:07 ASUS-N56V kernel: [    1.265032] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Jul 29 19:29:07 ASUS-N56V kernel: [    1.265159] ata1.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 19:29:07 ASUS-N56V kernel: [    1.265165] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 19:29:07 ASUS-N56V kernel: [    1.271642] ata1.00: ATA-8:
ST1000LM024 HN-M101MBB, 2AR10001, max UDMA/133
Jul 29 19:29:07 ASUS-N56V kernel: [    1.271647] ata1.00: 1953525168
sectors, multi 16: LBA48 NCQ (depth 31/32), AA
Jul 29 19:29:07 ASUS-N56V kernel: [    1.277035] usb 1-2: New USB device
found, idVendor=0461, idProduct=4d15
Jul 29 19:29:07 ASUS-N56V kernel: [    1.277040] usb 1-2: New USB device
strings: Mfr=0, Product=2, SerialNumber=0
Jul 29 19:29:07 ASUS-N56V kernel: [    1.277042] usb 1-2: Product: USB
Optical Mouse
Jul 29 19:29:07 ASUS-N56V kernel: [    1.277262] usb 1-2: ep 0x81 -
rounding interval to 64 microframes, ep desc says 80 microframes
Jul 29 19:29:07 ASUS-N56V kernel: [    1.278177] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Jul 29 19:29:07 ASUS-N56V kernel: [    1.278235] ata1.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 19:29:07 ASUS-N56V kernel: [    1.278241] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 19:29:07 ASUS-N56V kernel: [    1.279302] hidraw: raw HID events
driver (C) Jiri Kosina
Jul 29 19:29:07 ASUS-N56V kernel: [    1.280962] usbcore: registered new
interface driver usbhid
Jul 29 19:29:07 ASUS-N56V kernel: [    1.280964] usbhid: USB HID core driver
Jul 29 19:29:07 ASUS-N56V kernel: [    1.282499] input: USB Optical
Mouse as /devices/pci0000:00/0000:00:14.0/usb1/1-2/1-2:1.0/input/input1
Jul 29 19:29:07 ASUS-N56V kernel: [    1.282709] hid-generic
0003:0461:4D15.0001: input,hidraw0: USB HID v1.11 Mouse [USB Optical
Mouse] on usb-0000:00:14.0-2/input0
Jul 29 19:29:07 ASUS-N56V kernel: [    1.284640] ata1.00: configured for
UDMA/133
Jul 29 19:29:07 ASUS-N56V kernel: [    1.284894] scsi 0:0:0:0:
Direct-Access     ATA      ST1000LM024 HN-M 2AR1 PQ: 0 ANSI: 5
Jul 29 19:29:07 ASUS-N56V kernel: [    1.379467] usb 3-1: new high-speed
USB device number 2 using ehci-pci
Jul 29 19:29:07 ASUS-N56V kernel: [    1.493791] usb 3-1: New USB device
found, idVendor=8087, idProduct=0024
Jul 29 19:29:07 ASUS-N56V kernel: [    1.493795] usb 3-1: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Jul 29 19:29:07 ASUS-N56V kernel: [    1.494183] hub 3-1:1.0: USB hub found
Jul 29 19:29:07 ASUS-N56V kernel: [    1.494273] hub 3-1:1.0: 6 ports
detected
Jul 29 19:29:07 ASUS-N56V kernel: [    1.590348] ata3: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Jul 29 19:29:07 ASUS-N56V kernel: [    1.594152] ata3.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 19:29:07 ASUS-N56V kernel: [    1.594157] ata3.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 19:29:07 ASUS-N56V kernel: [    1.594484] ata3.00: ATAPI:
Slimtype DVD A  DS8A8SH, KAA2, max UDMA/100
Jul 29 19:29:07 ASUS-N56V kernel: [    1.596014] ata3.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 19:29:07 ASUS-N56V kernel: [    1.596017] ata3.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 19:29:07 ASUS-N56V kernel: [    1.596330] ata3.00: configured for
UDMA/100
Jul 29 19:29:07 ASUS-N56V kernel: [    1.597294] usb 4-1: new high-speed
USB device number 2 using ehci-pci
Jul 29 19:29:07 ASUS-N56V kernel: [    1.604030] scsi 2:0:0:0: CD-ROM
         Slimtype DVD A  DS8A8SH   KAA2 PQ: 0 ANSI: 5
Jul 29 19:29:07 ASUS-N56V kernel: [    1.606930] sd 0:0:0:0: [sda]
1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
Jul 29 19:29:07 ASUS-N56V kernel: [    1.606932] sd 0:0:0:0: [sda]
4096-byte physical blocks
Jul 29 19:29:07 ASUS-N56V kernel: [    1.606964] sd 0:0:0:0: [sda] Write
Protect is off
Jul 29 19:29:07 ASUS-N56V kernel: [    1.606966] sd 0:0:0:0: [sda] Mode
Sense: 00 3a 00 00
Jul 29 19:29:07 ASUS-N56V kernel: [    1.606975] sd 0:0:0:0: [sda] Write
cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 29 19:29:07 ASUS-N56V kernel: [    1.613927] sr0: scsi3-mmc drive:
24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Jul 29 19:29:07 ASUS-N56V kernel: [    1.613933] cdrom: Uniform CD-ROM
driver Revision: 3.20
Jul 29 19:29:07 ASUS-N56V kernel: [    1.614127] sr 2:0:0:0: Attached
scsi CD-ROM sr0
Jul 29 19:29:07 ASUS-N56V kernel: [    1.615266] sd 0:0:0:0: Attached
scsi generic sg0 type 0
Jul 29 19:29:07 ASUS-N56V kernel: [    1.615353] sr 2:0:0:0: Attached
scsi generic sg1 type 5
Jul 29 19:29:07 ASUS-N56V kernel: [    1.668203]  sda: sda1 sda2 sda3
sda4 sda5 sda6 sda7 sda8 sda9 sda10
Jul 29 19:29:07 ASUS-N56V kernel: [    1.669240] sd 0:0:0:0: [sda]
Attached SCSI disk
Jul 29 19:29:07 ASUS-N56V kernel: [    1.684305] tsc: Refined TSC
clocksource calibration: 2294.786 MHz
Jul 29 19:29:07 ASUS-N56V kernel: [    1.684315] Switching to
clocksource tsc
Jul 29 19:29:07 ASUS-N56V kernel: [    1.711677] usb 4-1: New USB device
found, idVendor=8087, idProduct=0024
Jul 29 19:29:07 ASUS-N56V kernel: [    1.711681] usb 4-1: New USB device
strings: Mfr=0, Product=0, SerialNumber=0
Jul 29 19:29:07 ASUS-N56V kernel: [    1.712071] hub 4-1:1.0: USB hub found
Jul 29 19:29:07 ASUS-N56V kernel: [    1.712260] hub 4-1:1.0: 6 ports
detected
Jul 29 19:29:07 ASUS-N56V kernel: [    1.786341] usb 3-1.1: new
full-speed USB device number 3 using ehci-pci
Jul 29 19:29:07 ASUS-N56V kernel: [    1.873291] usb 3-1.1: New USB
device found, idVendor=13d3, idProduct=3362
Jul 29 19:29:07 ASUS-N56V kernel: [    1.873310] usb 3-1.1: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Jul 29 19:29:07 ASUS-N56V kernel: [    1.873312] usb 3-1.1: Product:
Bluetooth USB Host Controller
Jul 29 19:29:07 ASUS-N56V kernel: [    1.873314] usb 3-1.1:
Manufacturer: Atheros Communications
Jul 29 19:29:07 ASUS-N56V kernel: [    1.873316] usb 3-1.1:
SerialNumber: Alaska Day 2006
Jul 29 19:29:07 ASUS-N56V kernel: [    1.947307] usb 3-1.3: new
high-speed USB device number 4 using ehci-pci
Jul 29 19:29:07 ASUS-N56V kernel: [    2.142210] usb 3-1.3: New USB
device found, idVendor=1bcf, idProduct=2883
Jul 29 19:29:07 ASUS-N56V kernel: [    2.142213] usb 3-1.3: New USB
device strings: Mfr=1, Product=2, SerialNumber=0
Jul 29 19:29:07 ASUS-N56V kernel: [    2.142215] usb 3-1.3: Product:
ASUS USB2.0 Webcam
Jul 29 19:29:07 ASUS-N56V kernel: [    2.142217] usb 3-1.3:
Manufacturer: 04G626000611BQ2310001M5
Jul 29 19:29:07 ASUS-N56V kernel: [    3.534078] device-mapper: uevent:
version 1.0.3
Jul 29 19:29:07 ASUS-N56V kernel: [    3.534161] device-mapper: ioctl:
4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
Jul 29 19:29:07 ASUS-N56V kernel: [    3.583325] EXT4-fs (sda9): mounted
filesystem with ordered data mode. Opts: (null)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.037111] microcode: CPU0
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050640] microcode: CPU1
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050682] microcode: CPU2
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050729] microcode: CPU3
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050775] microcode: CPU4
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050782] microcode: CPU5
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050826] microcode: CPU6
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050872] microcode: CPU7
sig=0x306a9, pf=0x10, revision=0x10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.050981] microcode: Microcode
Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
Jul 29 19:29:07 ASUS-N56V kernel: [    7.235224] wmi: Mapper loaded
Jul 29 19:29:07 ASUS-N56V kernel: [    7.242796] input: Lid Switch as
/devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input2
Jul 29 19:29:07 ASUS-N56V kernel: [    7.253578] ACPI: AC Adapter [AC0]
(on-line)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.268488] ACPI: Lid Switch [LID]
Jul 29 19:29:07 ASUS-N56V kernel: [    7.268535] input: Sleep Button as
/devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
Jul 29 19:29:07 ASUS-N56V kernel: [    7.268551] ACPI: Sleep Button [SLPB]
Jul 29 19:29:07 ASUS-N56V kernel: [    7.268575] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
Jul 29 19:29:07 ASUS-N56V kernel: [    7.268577] ACPI: Power Button [PWRF]
Jul 29 19:29:07 ASUS-N56V kernel: [    7.309547] ACPI: Battery Slot
[BAT0] (battery present)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519873] ACPI Warning:
0x0000000000000428-0x000000000000042f SystemIO conflicts with Region
\GPIS 1 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519877] ACPI Warning:
0x0000000000000428-0x000000000000042f SystemIO conflicts with Region
\PMIO 2 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519880] ACPI: If an ACPI driver
is available for this device, you should use it instead of the native driver
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519883] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\GPIO 1 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519885] ACPI Warning:
0x0000000000000530-0x000000000000053f SystemIO conflicts with Region
\GP01 2 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519900] ACPI: If an ACPI driver
is available for this device, you should use it instead of the native driver
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519901] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\GPIO 1 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519903] ACPI Warning:
0x0000000000000500-0x000000000000052f SystemIO conflicts with Region
\GP01 2 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519905] ACPI: If an ACPI driver
is available for this device, you should use it instead of the native driver
Jul 29 19:29:07 ASUS-N56V kernel: [    7.519906] lpc_ich: Resource
conflict(s) found affecting gpio_ich
Jul 29 19:29:07 ASUS-N56V kernel: [    7.531251] ACPI: Requesting
acpi_cpufreq
Jul 29 19:29:07 ASUS-N56V kernel: [    7.641983] input: PC Speaker as
/devices/platform/pcspkr/input/input5
Jul 29 19:29:07 ASUS-N56V kernel: [    7.783747] iTCO_vendor_support:
vendor-support=0
Jul 29 19:29:07 ASUS-N56V kernel: [    7.792115] iTCO_wdt: Intel TCO
WatchDog Timer Driver v1.10
Jul 29 19:29:07 ASUS-N56V kernel: [    7.792139] iTCO_wdt: Found a
Panther Point TCO device (Version=2, TCOBASE=0x0460)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.792356] iTCO_wdt: initialized.
heartbeat=30 sec (nowayout=0)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.864857] [drm] Initialized drm
1.1.0 20060810
Jul 29 19:29:07 ASUS-N56V kernel: [    7.886384] ACPI Warning:
0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region
\SMB0 1 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.886389] ACPI Warning:
0x000000000000f040-0x000000000000f05f SystemIO conflicts with Region
\_SB_.PCI0.SBUS.SMBI 2 (20130328/utaddress-251)
Jul 29 19:29:07 ASUS-N56V kernel: [    7.886392] ACPI: If an ACPI driver
is available for this device, you should use it instead of the native driver
Jul 29 19:29:07 ASUS-N56V kernel: [    8.066292] [drm] Memory usable by
graphics device = 2048M
Jul 29 19:29:07 ASUS-N56V kernel: [    8.066295] checking generic
(d0000000 1e0000) vs hw (d0000000 10000000)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.066297] fb: conflicting fb hw
usage inteldrmfb vs EFI VGA - removing generic driver
Jul 29 19:29:07 ASUS-N56V kernel: [    8.066336] Console: switching to
colour dummy device 80x25
Jul 29 19:29:07 ASUS-N56V kernel: [    8.066387] i915 0000:00:02.0:
setting latency timer to 64
Jul 29 19:29:07 ASUS-N56V kernel: [    8.078490] i915 0000:00:02.0: irq
47 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    8.078496] [drm] Supports vblank
timestamp caching Rev 1 (10.10.2010).
Jul 29 19:29:07 ASUS-N56V kernel: [    8.078496] [drm] Driver supports
precise vblank timestamp query.
Jul 29 19:29:07 ASUS-N56V kernel: [    8.078584] vgaarb: device changed
decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
Jul 29 19:29:07 ASUS-N56V kernel: [    8.078586] vgaarb: transferring
owner from PCI:0000:00:02.0 to PCI:0000:01:00.0
Jul 29 19:29:07 ASUS-N56V kernel: [    8.094291] [drm] Wrong MCH_SSKPD
value: 0x20100406
Jul 29 19:29:07 ASUS-N56V kernel: [    8.094293] [drm] This can cause
pipe underruns and display issues.
Jul 29 19:29:07 ASUS-N56V kernel: [    8.094294] [drm] Please upgrade
your BIOS to fix this.
Jul 29 19:29:07 ASUS-N56V kernel: [    8.105834] fbcon: inteldrmfb (fb0)
is primary device
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214578] MXM: GUID detected in BIOS
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214625] ACPI Error: Needed
[Buffer/String/Package], found [Integer] ffff88022283c2d0
(20130328/exresop-590)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214627] ACPI Exception:
AE_AML_OPERAND_TYPE, While resolving operands for [OpcodeName
unavailable] (20130328/dswexec-460)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214633] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.GFX0._DSM] (Node ffff8802254a2398),
AE_AML_OPERAND_TYPE (20130328/psparse-537)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214637] failed to evaluate
_DSM: 12291
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214713] ACPI Error: Needed
[Buffer/String/Package], found [Integer] ffff88022283c2d0
(20130328/exresop-590)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214715] ACPI Exception:
AE_AML_OPERAND_TYPE, While resolving operands for [OpcodeName
unavailable] (20130328/dswexec-460)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214718] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.GFX0._DSM] (Node ffff8802254a2398),
AE_AML_OPERAND_TYPE (20130328/psparse-537)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214730] ACPI Error: Method
parse/execution failed [\_SB_.PCI0.PEG0.PEGP._DSM] (Node
ffff8802254bb488), AE_AML_OPERAND_TYPE (20130328/psparse-537)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214733] failed to evaluate
_DSM: 12291
Jul 29 19:29:07 ASUS-N56V kernel: [    8.214784] VGA switcheroo:
detected Optimus DSM method \_SB_.PCI0.PEG0.PEGP handle
Jul 29 19:29:07 ASUS-N56V kernel: [    8.278112] psmouse serio4: alps:
Unknown ALPS touchpad: E7=10 00 64, EC=10 00 64
Jul 29 19:29:07 ASUS-N56V kernel: [    8.300847] cfg80211: Calling CRDA
to update world regulatory domain
Jul 29 19:29:07 ASUS-N56V kernel: [    8.308227] Bluetooth: Core ver 2.16
Jul 29 19:29:07 ASUS-N56V kernel: [    8.308235] NET: Registered
protocol family 31
Jul 29 19:29:07 ASUS-N56V kernel: [    8.308235] Bluetooth: HCI device
and connection manager initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    8.308241] Bluetooth: HCI socket
layer initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    8.308242] Bluetooth: L2CAP socket
layer initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    8.308245] Bluetooth: SCO socket
layer initialized
Jul 29 19:29:07 ASUS-N56V kernel: [    8.409777] pci_hotplug: PCI Hot
Plug PCI Core version: 0.5
Jul 29 19:29:07 ASUS-N56V kernel: [    8.412872] media: Linux media
interface: v0.10
Jul 29 19:29:07 ASUS-N56V kernel: [    8.467791] Linux video capture
interface: v2.00
Jul 29 19:29:07 ASUS-N56V kernel: [    8.657198] uvcvideo: Found UVC
1.00 device ASUS USB2.0 Webcam (1bcf:2883)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.670466] ath: EEPROM regdomain: 0x60
Jul 29 19:29:07 ASUS-N56V kernel: [    8.670467] ath: EEPROM indicates
we should expect a direct regpair map
Jul 29 19:29:07 ASUS-N56V kernel: [    8.670468] ath: Country alpha2
being used: 00
Jul 29 19:29:07 ASUS-N56V kernel: [    8.670469] ath: Regpair used: 0x60
Jul 29 19:29:07 ASUS-N56V kernel: [    8.674530] input: ASUS USB2.0
Webcam as
/devices/pci0000:00/0000:00:1a.0/usb3/3-1/3-1.3/3-1.3:1.0/input/input6
Jul 29 19:29:07 ASUS-N56V kernel: [    8.674637] usbcore: registered new
interface driver uvcvideo
Jul 29 19:29:07 ASUS-N56V kernel: [    8.674638] USB Video Class driver
(1.1.1)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.711454] asus_wmi: ASUS WMI
generic driver loaded
Jul 29 19:29:07 ASUS-N56V kernel: [    8.711490] asus_wmi:
Initialization: 0x1
Jul 29 19:29:07 ASUS-N56V kernel: [    8.711546] asus_wmi: BIOS WMI
version: 7.9
Jul 29 19:29:07 ASUS-N56V kernel: [    8.712468] asus_wmi: SFUN value:
0x6a0877
Jul 29 19:29:07 ASUS-N56V kernel: [    8.712469] input: Asus WMI hotkeys
as /devices/platform/asus-nb-wmi/input/input7
Jul 29 19:29:07 ASUS-N56V kernel: [    8.737098] ieee80211 phy0:
Selected rate control algorithm 'minstrel_ht'
Jul 29 19:29:07 ASUS-N56V kernel: [    8.737246] ieee80211 phy0: Atheros
AR9485 Rev:1 mem=0xffffc9000a580000, irq=17
Jul 29 19:29:07 ASUS-N56V kernel: [    8.779261] ACPI Error: [IIA0]
Namespace lookup failure, AE_ALREADY_EXISTS (20130328/dsfield-211)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.779265] ACPI Error: Method
parse/execution failed [\_SB_.ATKD.WMNB] (Node ffff8802254ae0f0),
AE_ALREADY_EXISTS (20130328/psparse-537)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.779328] ACPI Error: [IIA0]
Namespace lookup failure, AE_ALREADY_EXISTS (20130328/dsfield-211)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.779331] ACPI Error: Method
parse/execution failed [\_SB_.ATKD.WMNB] (Node ffff8802254ae0f0),
AE_ALREADY_EXISTS (20130328/psparse-537)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.779436] ACPI: Marking method
WMNB as Serialized because of AE_ALREADY_EXISTS error
Jul 29 19:29:07 ASUS-N56V kernel: [    8.794829] psmouse serio4:
elantech: assuming hardware version 4 (with firmware version 0x361f03)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.809913] psmouse serio4:
elantech: Synaptics capabilities query result 0x10, 0x15, 0x0d.
Jul 29 19:29:07 ASUS-N56V kernel: [    8.812613] Console: switching to
colour frame buffer device 240x67
Jul 29 19:29:07 ASUS-N56V kernel: [    8.816401] i915 0000:00:02.0: fb0:
inteldrmfb frame buffer device
Jul 29 19:29:07 ASUS-N56V kernel: [    8.816402] i915 0000:00:02.0:
registered panic notifier
Jul 29 19:29:07 ASUS-N56V kernel: [    8.816441] nouveau 0000:01:00.0:
enabling device (0004 -> 0007)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.816541] asus-nb-wmi: probe of
asus-nb-wmi failed with error -5
Jul 29 19:29:07 ASUS-N56V kernel: [    8.816833] ACPI: Video Device
[PEGP] (multi-head: yes  rom: yes  post: no)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.816865] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:03/LNXVIDEO:00/input/input8
Jul 29 19:29:07 ASUS-N56V kernel: [    8.844162] usbcore: registered new
interface driver btusb
Jul 29 19:29:07 ASUS-N56V kernel: [    8.845365] ACPI: Video Device
[GFX0] (multi-head: yes  rom: no  post: no)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.845405] input: Video Bus as
/devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:01/input/input9
Jul 29 19:29:07 ASUS-N56V kernel: [    8.845553] [drm] Initialized i915
1.6.0 20080730 for 0000:00:02.0 on minor 0
Jul 29 19:29:07 ASUS-N56V kernel: [    8.845707] snd_hda_intel
0000:00:1b.0: irq 48 for MSI/MSI-X
Jul 29 19:29:07 ASUS-N56V kernel: [    8.845813] nouveau  [
DEVICE][0000:01:00.0] BOOT0  : 0x0c1480a1
Jul 29 19:29:07 ASUS-N56V kernel: [    8.845816] nouveau  [
DEVICE][0000:01:00.0] Chipset: GF108 (NVC1)
Jul 29 19:29:07 ASUS-N56V kernel: [    8.845818] nouveau  [
DEVICE][0000:01:00.0] Family : NVC0
Jul 29 19:29:07 ASUS-N56V kernel: [    8.846693] nouveau  [
VBIOS][0000:01:00.0] checking PRAMIN for image...
Jul 29 19:29:07 ASUS-N56V kernel: [    8.856418] nouveau  [
VBIOS][0000:01:00.0] ... signature not found
Jul 29 19:29:07 ASUS-N56V kernel: [    8.856421] nouveau  [
VBIOS][0000:01:00.0] checking PROM for image...
Jul 29 19:29:07 ASUS-N56V kernel: [    8.856478] nouveau  [
VBIOS][0000:01:00.0] ... signature not found
Jul 29 19:29:07 ASUS-N56V kernel: [    8.856480] nouveau  [
VBIOS][0000:01:00.0] checking ACPI for image...
Jul 29 19:29:07 ASUS-N56V kernel: [    8.891265] input: ETPS/2 Elantech
Touchpad as /devices/platform/i8042/serio4/input/input10
Jul 29 19:29:07 ASUS-N56V kernel: [    8.907234] input: HDA Intel PCH
Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input11
Jul 29 19:29:07 ASUS-N56V kernel: [    8.907290] input: HDA Intel PCH
Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input12
Jul 29 19:29:07 ASUS-N56V kernel: [    8.932844] usbcore: registered new
interface driver ath3k
Jul 29 19:29:07 ASUS-N56V kernel: [    9.159602] nouveau  [
VBIOS][0000:01:00.0] ... appears to be valid
Jul 29 19:29:07 ASUS-N56V kernel: [    9.159606] nouveau  [
VBIOS][0000:01:00.0] using image from ACPI
Jul 29 19:29:07 ASUS-N56V kernel: [    9.159737] nouveau  [
VBIOS][0000:01:00.0] BIT signature found
Jul 29 19:29:07 ASUS-N56V kernel: [    9.159740] nouveau  [
VBIOS][0000:01:00.0] version 70.08.a8.00.28
Jul 29 19:29:07 ASUS-N56V kernel: [    9.159927] nouveau  [
DEVINIT][0000:01:00.0] adaptor not initialised
Jul 29 19:29:07 ASUS-N56V kernel: [    9.159930] nouveau  [
VBIOS][0000:01:00.0] running init tables
Jul 29 19:29:07 ASUS-N56V kernel: [    9.267594] nouveau  [
PFB][0000:01:00.0] RAM type: DDR3
Jul 29 19:29:07 ASUS-N56V kernel: [    9.267597] nouveau  [
PFB][0000:01:00.0] RAM size: 1024 MiB
Jul 29 19:29:07 ASUS-N56V kernel: [    9.267598] nouveau  [
PFB][0000:01:00.0]    ZCOMP: 0 tags
Jul 29 19:29:07 ASUS-N56V kernel: [    9.290661] nouveau  [
PTHERM][0000:01:00.0] FAN control: none / external
Jul 29 19:29:07 ASUS-N56V kernel: [    9.290667] nouveau  [
PTHERM][0000:01:00.0] fan management: disabled
Jul 29 19:29:07 ASUS-N56V kernel: [    9.290670] nouveau  [
PTHERM][0000:01:00.0] internal sensor: yes
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294157] vga_switcheroo: enabled
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294387] [TTM] Zone  kernel:
Available graphics memory: 4036592 kiB
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294389] [TTM] Zone   dma32:
Available graphics memory: 2097152 kiB
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294391] [TTM] Initializing pool
allocator
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294395] [TTM] Initializing DMA
pool allocator
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294409] mtrr: type mismatch for
e0000000,10000000 old: write-back new: write-combining
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294411] nouveau  [     DRM]
VRAM: 1024 MiB
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294413] nouveau  [     DRM]
GART: 512 MiB
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294416] nouveau  [     DRM]
TMDS table version 2.0
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294418] nouveau  [     DRM] DCB
version 4.0
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294430] nouveau  [     DRM] DCB
outp 00: 02000362 00020010
Jul 29 19:29:07 ASUS-N56V kernel: [    9.294432] nouveau  [     DRM] DCB
conn 00: 00001061
Jul 29 19:29:07 ASUS-N56V kernel: [    9.295118] [drm] Supports vblank
timestamp caching Rev 1 (10.10.2010).
Jul 29 19:29:07 ASUS-N56V kernel: [    9.295119] [drm] No driver support
for vblank timestamp query.
Jul 29 19:29:07 ASUS-N56V kernel: [    9.295135] nouveau W[     DRM]
voltage table 0x50 unknown
Jul 29 19:29:07 ASUS-N56V kernel: [    9.295299] nouveau  [     DRM] 2
available performance level(s)
Jul 29 19:29:07 ASUS-N56V kernel: [    9.295301] nouveau  [     DRM] 1:
core 270MHz shader 540MHz memory 405MHz
Jul 29 19:29:07 ASUS-N56V kernel: [    9.295303] nouveau  [     DRM] 3:
core 475MHz shader 950MHz memory 900MHz voltage 10mV
Jul 29 19:29:07 ASUS-N56V kernel: [    9.295304] nouveau  [     DRM] c:
core 270MHz shader 540MHz memory 405MHz
Jul 29 19:29:07 ASUS-N56V kernel: [    9.300183] nouveau  [     DRM] MM:
using COPY0 for buffer copies
Jul 29 19:29:07 ASUS-N56V kernel: [    9.301232] nouveau 0000:01:00.0:
No connectors reported connected with modes
Jul 29 19:29:07 ASUS-N56V kernel: [    9.301233] [drm] Cannot find any
crtc or sizes - going 1024x768
Jul 29 19:29:07 ASUS-N56V kernel: [    9.332065] cfg80211: World
regulatory domain updated:
Jul 29 19:29:07 ASUS-N56V kernel: [    9.332068] cfg80211:   (start_freq
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 29 19:29:07 ASUS-N56V kernel: [    9.332071] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:29:07 ASUS-N56V kernel: [    9.332073] cfg80211:   (2457000
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:29:07 ASUS-N56V kernel: [    9.332075] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:29:07 ASUS-N56V kernel: [    9.332077] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:29:07 ASUS-N56V kernel: [    9.332079] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:29:07 ASUS-N56V kernel: [    9.333433] nouveau  [     DRM]
allocated 1024x768 fb: 0x60000, bo ffff8802240a4c00
Jul 29 19:29:07 ASUS-N56V kernel: [    9.333588] nouveau 0000:01:00.0:
fb1: nouveaufb frame buffer device
Jul 29 19:29:07 ASUS-N56V kernel: [    9.333592] [drm] Initialized
nouveau 1.1.1 20120801 for 0000:01:00.0 on minor 1
Jul 29 19:29:07 ASUS-N56V kernel: [    9.856407] [drm] Enabling RC6
states: RC6 on, RC6p on, RC6pp off
Jul 29 19:29:07 ASUS-N56V kernel: [   12.472955] EXT4-fs (sda9):
re-mounted. Opts: (null)
Jul 29 19:29:07 ASUS-N56V kernel: [   13.410517] EXT4-fs (sda9):
re-mounted. Opts: errors=remount-ro
Jul 29 19:29:07 ASUS-N56V kernel: [   14.248151] Key type trusted registered
Jul 29 19:29:07 ASUS-N56V kernel: [   14.273516] sha256_ssse3: Using AVX
optimized SHA-256 implementation
Jul 29 19:29:07 ASUS-N56V kernel: [   14.378549] Key type encrypted
registered
Jul 29 19:29:07 ASUS-N56V kernel: [   14.486887] fuse init (API version
7.22)
Jul 29 19:29:07 ASUS-N56V kernel: [   14.568259] asus_wmi:
Initialization: 0x1
Jul 29 19:29:07 ASUS-N56V kernel: [   14.568293] asus_wmi: BIOS WMI
version: 7.9asus_wmi: SFUN value: 0x6a0877
Jul 29 19:29:07 ASUS-N56V kernel: [   14.568909] input: Asus WMI hotkeys
as /devices/platform/asus-nb-wmi/input/input13
Jul 29 19:29:07 ASUS-N56V kernel: [   14.632284] asus_wmi: Disabling
ACPI video driver
Jul 29 19:29:07 ASUS-N56V kernel: [   16.051725] FAT-fs (sda1): Volume
was not properly unmounted. Some data may be corrupt. Please run fsck.
Jul 29 19:29:07 ASUS-N56V kernel: [   16.202192] kjournald starting.
Commit interval 5 seconds
Jul 29 19:29:07 ASUS-N56V kernel: [   16.202570] EXT3-fs (sda6): using
internal journal
Jul 29 19:29:07 ASUS-N56V kernel: [   16.202577] EXT3-fs (sda6): mounted
filesystem with writeback data mode
Jul 29 19:29:07 ASUS-N56V kernel: [   16.286094] EXT4-fs (sda8): mounted
filesystem with ordered data mode. Opts: (null)
Jul 29 19:29:07 ASUS-N56V kernel: [   16.364714] EXT4-fs (sda7): mounted
filesystem with ordered data mode. Opts: (null)
Jul 29 19:29:07 ASUS-N56V kernel: [   16.432397] EXT4-fs (sda10):
mounted filesystem with ordered data mode. Opts: (null)
Jul 29 19:29:07 ASUS-N56V kernel: [   16.788910] usb 3-1.1: USB
disconnect, device number 3
Jul 29 19:29:07 ASUS-N56V kernel: [   18.028504] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 19:29:07 ASUS-N56V kernel: [   18.078521] NET: Registered
protocol family 17
Jul 29 19:29:07 ASUS-N56V kernel: [   19.996966] input: ACPI Virtual
Keyboard Device as /devices/virtual/input/input14
Jul 29 19:29:07 ASUS-N56V kernel: [   20.142350] lp: driver loaded but
no devices found
Jul 29 19:29:08 ASUS-N56V kernel: [   20.537491] ppdev: user-space
parallel port driver
Jul 29 19:29:09 ASUS-N56V kernel: [   21.689430] vboxdrv: Found 8
processor cores.
Jul 29 19:29:09 ASUS-N56V kernel: [   21.690092] vboxdrv: fAsync=0
offMin=0x185 offMax=0xd407
Jul 29 19:29:09 ASUS-N56V kernel: [   21.690151] vboxdrv: TSC mode is
'synchronous', kernel timer mode is 'normal'.
Jul 29 19:29:09 ASUS-N56V kernel: [   21.690152] vboxdrv: Successfully
loaded version 4.2.16 (interface 0x001a0005).
Jul 29 19:29:11 ASUS-N56V kernel: [   23.600129] vboxpci: IOMMU not
found (not registered)
Jul 29 19:29:11 ASUS-N56V kernel: [   23.829023] Bluetooth: RFCOMM TTY
layer initialized
Jul 29 19:29:11 ASUS-N56V kernel: [   23.829039] Bluetooth: RFCOMM
socket layer initialized
Jul 29 19:29:11 ASUS-N56V kernel: [   23.829042] Bluetooth: RFCOMM ver 1.11
Jul 29 19:29:11 ASUS-N56V kernel: [   24.119758] Bluetooth: BNEP
(Ethernet Emulation) ver 1.3
Jul 29 19:29:11 ASUS-N56V kernel: [   24.119761] Bluetooth: BNEP
filters: protocol multicast
Jul 29 19:29:11 ASUS-N56V kernel: [   24.119768] Bluetooth: BNEP socket
layer initialized
Jul 29 19:29:25 ASUS-N56V kernel: [   37.639289] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 19:29:25 ASUS-N56V kernel: [   37.843345] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 19:29:28 ASUS-N56V kernel: [   41.194416] wlan0: authenticate
with 00:23:08:3c:6b:25
Jul 29 19:29:28 ASUS-N56V kernel: [   41.213874] wlan0: send auth to
00:23:08:3c:6b:25 (try 1/3)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.216004] wlan0: authenticated
Jul 29 19:29:28 ASUS-N56V kernel: [   41.217047] wlan0: associate with
00:23:08:3c:6b:25 (try 1/3)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.221066] wlan0: RX AssocResp
from 00:23:08:3c:6b:25 (capab=0x411 status=0 aid=2)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.221115] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jul 29 19:29:28 ASUS-N56V kernel: [   41.221154] wlan0: associated
Jul 29 19:29:28 ASUS-N56V kernel: [   41.221180] cfg80211: Calling CRDA
for country: DE
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249008] ath: regdomain 0x8114
updated by CountryIE
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249011] ath: EEPROM regdomain:
0x8114
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249012] ath: EEPROM indicates
we should expect a country code
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249013] ath: doing EEPROM
country->regdmn map search
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249014] ath: country maps to
regdmn code: 0x37
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249015] ath: Country alpha2
being used: DE
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249016] ath: Regpair used: 0x37
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249035] cfg80211: Regulatory
domain changed to country: DE
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249036] cfg80211:   (start_freq
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249037] cfg80211:   (2400000
KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249038] cfg80211:   (5150000
KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249039] cfg80211:   (5250000
KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249040] cfg80211:   (5470000
KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Jul 29 19:29:28 ASUS-N56V kernel: [   41.249041] cfg80211:   (57240000
KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Jul 29 19:38:45 ASUS-N56V kernel: [  598.259012] wlan0: deauthenticating
from 00:23:08:3c:6b:25 by local choice (reason=3)
Jul 29 19:38:46 ASUS-N56V kernel: [  598.296394] cfg80211: Calling CRDA
to update world regulatory domain
Jul 29 19:38:46 ASUS-N56V kernel: [  598.302415] cfg80211: World
regulatory domain updated:
Jul 29 19:38:46 ASUS-N56V kernel: [  598.302417] cfg80211:   (start_freq
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 29 19:38:46 ASUS-N56V kernel: [  598.302419] cfg80211:   (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:38:46 ASUS-N56V kernel: [  598.302420] cfg80211:   (2457000
KHz - 2482000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:38:46 ASUS-N56V kernel: [  598.302421] cfg80211:   (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:38:46 ASUS-N56V kernel: [  598.302422] cfg80211:   (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:38:46 ASUS-N56V kernel: [  598.302423] cfg80211:   (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jul 29 19:38:46 ASUS-N56V kernel: [  598.365944] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 19:38:46 ASUS-N56V kernel: [  598.578716] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 19:38:46 ASUS-N56V kernel: [  598.652967] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 19:38:46 ASUS-N56V kernel: [  598.671195]
_handle_hotplug_event_root: Bus check notify on \_SB_.PCI0
Jul 29 19:38:47 ASUS-N56V kernel: [  599.546762] PM: Syncing filesystems
... done.
Jul 29 20:15:09 ASUS-N56V kernel: [  599.634404] Freezing user space
processes ... (elapsed 0.01 seconds) done.
Jul 29 20:15:09 ASUS-N56V kernel: [  599.645247] Freezing remaining
freezable tasks ... (elapsed 0.01 seconds) done.
Jul 29 20:15:09 ASUS-N56V kernel: [  599.656329] Suspending console(s)
(use no_console_suspend to debug)
Jul 29 20:15:09 ASUS-N56V kernel: [  599.670814] sd 0:0:0:0: [sda]
Synchronizing SCSI cache
Jul 29 20:15:09 ASUS-N56V kernel: [  599.681055] nouveau  [     DRM]
suspending fbcon...
Jul 29 20:15:09 ASUS-N56V kernel: [  599.681058] nouveau  [     DRM]
suspending display...
Jul 29 20:15:09 ASUS-N56V kernel: [  599.681063] nouveau  [     DRM]
unpinning framebuffer(s)...
Jul 29 20:15:09 ASUS-N56V kernel: [  599.681139] nouveau  [     DRM]
evicting buffers...
Jul 29 20:15:09 ASUS-N56V kernel: [  599.681227] mei_me 0000:00:16.0:
suspend
Jul 29 20:15:09 ASUS-N56V kernel: [  599.681843] nouveau  [     DRM]
waiting for kernel channels to go idle...
Jul 29 20:15:09 ASUS-N56V kernel: [  599.681855] nouveau  [     DRM]
suspending client object trees...
Jul 29 20:15:09 ASUS-N56V kernel: [  599.682114] nouveau  [     DRM]
suspending kernel object tree...
Jul 29 20:15:09 ASUS-N56V kernel: [  599.682602] alx 0000:04:00.0 eth0:
wol: ctrl=3, speed=0
Jul 29 20:15:09 ASUS-N56V kernel: [  599.701201] alx 0000:04:00.0:
System wakeup enabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  599.850833] sd 0:0:0:0: [sda]
Stopping disk
Jul 29 20:15:09 ASUS-N56V kernel: [  600.130171] nouveau 0000:01:00.0:
power state changed by ACPI to D3hot
Jul 29 20:15:09 ASUS-N56V kernel: [  600.908402] PM: suspend of devices
complete after 1252.003 msecs
Jul 29 20:15:09 ASUS-N56V kernel: [  600.908498] PM: late suspend of
devices complete after 0.094 msecs
Jul 29 20:15:09 ASUS-N56V kernel: [  600.919185] ehci-pci 0000:00:1d.0:
System wakeup enabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  600.930294] ehci-pci 0000:00:1a.0:
System wakeup enabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  600.952119] xhci_hcd 0000:00:14.0:
System wakeup enabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  600.963130] PM: noirq suspend of
devices complete after 54.629 msecs
Jul 29 20:15:09 ASUS-N56V kernel: [  600.963376] ACPI: Preparing to
enter system sleep state S3
Jul 29 20:15:09 ASUS-N56V kernel: [  603.733262] PM: Saving platform NVS
memory
Jul 29 20:15:09 ASUS-N56V kernel: [  603.734519] Disabling non-boot CPUs ...
Jul 29 20:15:09 ASUS-N56V kernel: [  603.736184] smpboot: CPU 1 is now
offline
Jul 29 20:15:09 ASUS-N56V kernel: [  603.737538] smpboot: CPU 2 is now
offline
Jul 29 20:15:09 ASUS-N56V kernel: [  603.738874] smpboot: CPU 3 is now
offline
Jul 29 20:15:09 ASUS-N56V kernel: [  603.740267] smpboot: CPU 4 is now
offline
Jul 29 20:15:09 ASUS-N56V kernel: [  603.740700] Broke affinity for irq 16
Jul 29 20:15:09 ASUS-N56V kernel: [  603.741728] smpboot: CPU 5 is now
offline
Jul 29 20:15:09 ASUS-N56V kernel: [  603.742035] Broke affinity for irq 17
Jul 29 20:15:09 ASUS-N56V kernel: [  603.743068] smpboot: CPU 6 is now
offline
Jul 29 20:15:09 ASUS-N56V kernel: [  603.743411] Broke affinity for irq 23
Jul 29 20:15:09 ASUS-N56V kernel: [  603.743414] Broke affinity for irq 45
Jul 29 20:15:09 ASUS-N56V kernel: [  603.743415] Broke affinity for irq 46
Jul 29 20:15:09 ASUS-N56V kernel: [  603.744436] smpboot: CPU 7 is now
offline
Jul 29 20:15:09 ASUS-N56V kernel: [  603.745832] ACPI: Low-level resume
complete
Jul 29 20:15:09 ASUS-N56V kernel: [  603.745876] PM: Restoring platform
NVS memory
Jul 29 20:15:09 ASUS-N56V kernel: [  603.746611] Enabling non-boot CPUs ...
Jul 29 20:15:09 ASUS-N56V kernel: [  603.746649] smpboot: Booting Node 0
Processor 1 APIC 0x2
Jul 29 20:15:09 ASUS-N56V kernel: [  603.760388] Intel pstate
controlling: cpu 1
Jul 29 20:15:09 ASUS-N56V kernel: [  603.760451] CPU1 is up
Jul 29 20:15:09 ASUS-N56V kernel: [  603.760471] smpboot: Booting Node 0
Processor 2 APIC 0x4
Jul 29 20:15:09 ASUS-N56V kernel: [  603.774214] Intel pstate
controlling: cpu 2
Jul 29 20:15:09 ASUS-N56V kernel: [  603.774270] CPU2 is up
Jul 29 20:15:09 ASUS-N56V kernel: [  603.774291] smpboot: Booting Node 0
Processor 3 APIC 0x6
Jul 29 20:15:09 ASUS-N56V kernel: [  603.788038] Intel pstate
controlling: cpu 3
Jul 29 20:15:09 ASUS-N56V kernel: [  603.788093] CPU3 is up
Jul 29 20:15:09 ASUS-N56V kernel: [  603.788112] smpboot: Booting Node 0
Processor 4 APIC 0x1
Jul 29 20:15:09 ASUS-N56V kernel: [  603.801834] Intel pstate
controlling: cpu 4
Jul 29 20:15:09 ASUS-N56V kernel: [  603.801879] CPU4 is up
Jul 29 20:15:09 ASUS-N56V kernel: [  603.801894] smpboot: Booting Node 0
Processor 5 APIC 0x3
Jul 29 20:15:09 ASUS-N56V kernel: [  603.815605] Intel pstate
controlling: cpu 5
Jul 29 20:15:09 ASUS-N56V kernel: [  603.815646] CPU5 is up
Jul 29 20:15:09 ASUS-N56V kernel: [  603.815660] smpboot: Booting Node 0
Processor 6 APIC 0x5
Jul 29 20:15:09 ASUS-N56V kernel: [  603.829373] Intel pstate
controlling: cpu 6
Jul 29 20:15:09 ASUS-N56V kernel: [  603.829415] CPU6 is up
Jul 29 20:15:09 ASUS-N56V kernel: [  603.829429] smpboot: Booting Node 0
Processor 7 APIC 0x7
Jul 29 20:15:09 ASUS-N56V kernel: [  603.843152] Intel pstate
controlling: cpu 7
Jul 29 20:15:09 ASUS-N56V kernel: [  603.843193] CPU7 is up
Jul 29 20:15:09 ASUS-N56V kernel: [  603.850539] ACPI: Waking up from
system sleep state S3
Jul 29 20:15:09 ASUS-N56V kernel: [  603.962985] xhci_hcd 0000:00:14.0:
System wakeup disabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  603.984972] ehci-pci 0000:00:1a.0:
System wakeup disabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  604.006973] ehci-pci 0000:00:1d.0:
System wakeup disabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  604.018009] nouveau 0000:01:00.0:
power state changed by ACPI to D0
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051045] PM: noirq resume of
devices complete after 109.690 msecs
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051157] PM: early resume of
devices complete after 0.087 msecs
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051198] i915 0000:00:02.0:
setting latency timer to 64
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051214] xhci_hcd 0000:00:14.0:
setting latency timer to 64
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051261] mei_me 0000:00:16.0:
irq 44 for MSI/MSI-X
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051262] usb usb1: root hub lost
power or was reset
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051263] usb usb2: root hub lost
power or was reset
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051318] ahci 0000:00:1f.2:
setting latency timer to 64
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051337] xhci_hcd 0000:00:14.0:
Slot 1 endpoint 2 not removed from BW list!
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051366] alx 0000:04:00.0:
System wakeup disabled by ACPI
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051432] ehci-pci 0000:00:1a.0:
setting latency timer to 64
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051444] usb usb3: root hub lost
power or was reset
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051471] xhci_hcd 0000:00:14.0:
irq 45 for MSI/MSI-X
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051575] snd_hda_intel
0000:00:1b.0: irq 48 for MSI/MSI-X
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051609] ehci-pci 0000:00:1d.0:
setting latency timer to 64
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051638] usb usb4: root hub lost
power or was reset
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051726] nouveau  [     DRM]
re-enabling device...
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051739] nouveau  [     DRM]
resuming kernel object tree...
Jul 29 20:15:09 ASUS-N56V kernel: [  604.051744] nouveau  [
VBIOS][0000:01:00.0] running init tables
Jul 29 20:15:09 ASUS-N56V kernel: [  604.055327] ehci-pci 0000:00:1a.0:
cache line size of 64 is not supported
Jul 29 20:15:09 ASUS-N56V kernel: [  604.055867] ehci-pci 0000:00:1d.0:
cache line size of 64 is not supported
Jul 29 20:15:09 ASUS-N56V kernel: [  604.058227] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:09 ASUS-N56V kernel: [  604.063262] [drm] Wrong MCH_SSKPD
value: 0x20100406
Jul 29 20:15:09 ASUS-N56V kernel: [  604.063262] [drm] This can cause
pipe underruns and display issues.
Jul 29 20:15:09 ASUS-N56V kernel: [  604.063263] [drm] Please upgrade
your BIOS to fix this.
Jul 29 20:15:09 ASUS-N56V kernel: [  604.064920] mei_me 0000:00:16.0:
wait hw ready failed. status = 0x0
Jul 29 20:15:09 ASUS-N56V kernel: [  604.195829] nouveau  [     DRM]
resuming client object trees...
Jul 29 20:15:09 ASUS-N56V kernel: [  604.195834] nouveau  [     DRM]
resuming display...
Jul 29 20:15:09 ASUS-N56V kernel: [  604.366981] ata3: SATA link up 1.5
Gbps (SStatus 113 SControl 300)
Jul 29 20:15:09 ASUS-N56V kernel: [  604.368461] ata3.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 20:15:09 ASUS-N56V kernel: [  604.368464] ata3.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 20:15:09 ASUS-N56V kernel: [  604.370599] ata3.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 20:15:09 ASUS-N56V kernel: [  604.370612] ata3.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 20:15:09 ASUS-N56V kernel: [  604.371003] ata3.00: configured for
UDMA/100
Jul 29 20:15:09 ASUS-N56V kernel: [  604.516032] usb 1-2: reset
low-speed USB device number 2 using xhci_hcd
Jul 29 20:15:09 ASUS-N56V kernel: [  604.528889] xhci_hcd 0000:00:14.0:
xHCI xhci_drop_endpoint called with disabled ep ffff880221664800
Jul 29 20:15:09 ASUS-N56V kernel: [  604.528917] usb 1-2: ep 0x81 -
rounding interval to 64 microframes, ep desc says 80 microframes
Jul 29 20:15:09 ASUS-N56V kernel: [  604.629985] usb 3-1: reset
high-speed USB device number 2 using ehci-pci
Jul 29 20:15:09 ASUS-N56V kernel: [  604.845994] usb 4-1: reset
high-speed USB device number 2 using ehci-pci
Jul 29 20:15:09 ASUS-N56V kernel: [  605.033012] usb 3-1.3: reset
high-speed USB device number 4 using ehci-pci
Jul 29 20:15:09 ASUS-N56V kernel: [  605.815300] [drm] Enabling RC6
states: RC6 on, RC6p on, RC6pp off
Jul 29 20:15:09 ASUS-N56V kernel: [  606.408937] ata1: SATA link up 3.0
Gbps (SStatus 123 SControl 300)
Jul 29 20:15:09 ASUS-N56V kernel: [  606.415424] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Jul 29 20:15:09 ASUS-N56V kernel: [  606.415509] ata1.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 20:15:09 ASUS-N56V kernel: [  606.415514] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 20:15:09 ASUS-N56V kernel: [  606.428443] ata1.00: ACPI cmd
f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
Jul 29 20:15:09 ASUS-N56V kernel: [  606.428526] ata1.00: ACPI cmd
ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
Jul 29 20:15:09 ASUS-N56V kernel: [  606.428530] ata1.00: ACPI cmd
ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
Jul 29 20:15:09 ASUS-N56V kernel: [  606.435005] ata1.00: configured for
UDMA/133
Jul 29 20:15:09 ASUS-N56V kernel: [  606.446298] sd 0:0:0:0: [sda]
Starting disk
Jul 29 20:15:09 ASUS-N56V kernel: [  606.517982] PM: resume of devices
complete after 2466.853 msecs
Jul 29 20:15:09 ASUS-N56V kernel: [  606.518205] Restarting tasks ... done.
Jul 29 20:15:09 ASUS-N56V kernel: [  606.582142] usb 3-1.1: new
full-speed USB device number 5 using ehci-pci
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622150] ------------[ cut here
]------------
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622166] WARNING: at
/tmp/buildd/linux-aptosid-3.10/debian/build/source_amd64_none/drivers/net/wireless/ath/ath9k/hw.c:780
ar9003_get_pll_sqsum_dvc+0x6b/0xa0 [ath9k_hw]()
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622168] Modules linked in: bnep
rfcomm pci_stub vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
cpufreq_conservative cpufreq_stats parport_pc cpufreq_powersave ppdev lp
parport binfmt_misc uinput af_packet ext3 jbd nls_utf8 nls_cp437 vfat
fat asus_nb_wmi fuse ecryptfs cbc sha256_ssse3 sha256_generic
encrypted_keys trusted dm_crypt ath3k joydev snd_hda_codec_realtek btusb
arc4 ath9k uvcvideo ath9k_common ath9k_hw videobuf2_vmalloc
videobuf2_memops ath videobuf2_core mac80211 snd_hda_intel snd_hda_codec
videodev asus_wmi sparse_keymap media pci_hotplug intel_powerclamp
coretemp bluetooth cfg80211 nouveau snd_hwdep snd_pcm snd_page_alloc
i915 rfkill intel_agp intel_gtt ttm i2c_algo_bit i2c_i801 drm_kms_helper
drm mperf iTCO_wdt iTCO_vendor_support kvm_intel snd_seq snd_seq_device
snd_timer snd i2c_core pcspkr serio_raw kvm evdev processor lpc_ich
mfd_core soundcore battery mxm_wmi video button ac wmi microcode ext4
crc16 jbd2 mbcache dm_mod md_mod sg sd_mod sr_mod crc_t10dif cdrom
hid_generic usbhid hid crc32_pclmul crc32c_intel ghash_clmulni_intel
aesni_intel aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd ahci
libahci libata alx scsi_mod mdio ehci_pci xhci_hcd ehci_hcd usbcore
usb_common thermal [last unloaded: psmouse]
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622237] CPU: 5 PID: 4424 Comm:
kworker/u16:59 Tainted: G           O 3.10-3.slh.2-aptosid-amd64 #1
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622239] Hardware name: ASUSTeK
COMPUTER INC. N56VM/N56VM, BIOS N56VM.204 03/01/2012
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622244] Workqueue: phy0
ath_hw_pll_work [ath9k]
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622246]  0000000000000000
ffffffff81036c2c 0000000000000000 ffff88022370c018
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622248]  0000000000000000
ffff8802253f3578 ffff880220f22200 ffffffffa0486079
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622251]  ffff8802253f3578
ffff8802253f17a0 ffffffffa04df9df ffff880220fc0800
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622253] Call Trace:
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622259]  [<ffffffff81036c2c>] ?
warn_slowpath_common+0x5b/0x70
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622265]  [<ffffffffa0486079>] ?
ar9003_get_pll_sqsum_dvc+0x6b/0xa0 [ath9k_hw]
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622269]  [<ffffffffa04df9df>] ?
ath_hw_pll_work+0x31/0xa0 [ath9k]
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622273]  [<ffffffff8104affa>] ?
process_one_work+0x15a/0x210
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622276]  [<ffffffff8104b47e>] ?
worker_thread+0x139/0x1de
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622278]  [<ffffffff8104b345>] ?
rescuer_thread+0x272/0x272
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622281]  [<ffffffff8104f6aa>] ?
kthread+0x7d/0x85
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622283]  [<ffffffff8104f62d>] ?
__kthread_parkme+0x59/0x59
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622287]  [<ffffffff81355d3c>] ?
ret_from_fork+0x7c/0xb0
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622289]  [<ffffffff8104f62d>] ?
__kthread_parkme+0x59/0x59
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622291] ---[ end trace
e6142c0fcd896dd9 ]---
Jul 29 20:15:09 ASUS-N56V kernel: [  606.622293] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:09 ASUS-N56V kernel: [  606.668913] usb 3-1.1: New USB
device found, idVendor=13d3, idProduct=3362
Jul 29 20:15:09 ASUS-N56V kernel: [  606.668917] usb 3-1.1: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Jul 29 20:15:09 ASUS-N56V kernel: [  606.668918] usb 3-1.1: Product:
Bluetooth USB Host Controller
Jul 29 20:15:09 ASUS-N56V kernel: [  606.668920] usb 3-1.1:
Manufacturer: Atheros Communications
Jul 29 20:15:09 ASUS-N56V kernel: [  606.668921] usb 3-1.1:
SerialNumber: Alaska Day 2006
Jul 29 20:15:09 ASUS-N56V kernel: [  606.735163] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  606.805987] usb 3-1.1: USB
disconnect, device number 5
Jul 29 20:15:10 ASUS-N56V kernel: [  606.848182] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  606.961140] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  606.984059] usb 3-1.1: new
full-speed USB device number 6 using ehci-pci
Jul 29 20:15:10 ASUS-N56V kernel: [  607.070837] usb 3-1.1: New USB
device found, idVendor=13d3, idProduct=3362
Jul 29 20:15:10 ASUS-N56V kernel: [  607.070841] usb 3-1.1: New USB
device strings: Mfr=1, Product=2, SerialNumber=3
Jul 29 20:15:10 ASUS-N56V kernel: [  607.070843] usb 3-1.1: Product:
Bluetooth USB Host Controller
Jul 29 20:15:10 ASUS-N56V kernel: [  607.070845] usb 3-1.1:
Manufacturer: Atheros Communications
Jul 29 20:15:10 ASUS-N56V kernel: [  607.070847] usb 3-1.1:
SerialNumber: Alaska Day 2006
Jul 29 20:15:10 ASUS-N56V kernel: [  607.074141] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  607.187134] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  607.300140] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  607.413138] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  607.526130] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:10 ASUS-N56V kernel: [  607.639083] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  607.752120] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  607.865115] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  607.978100] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  608.091098] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  608.204098] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  608.317131] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  608.430129] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  608.543099] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:11 ASUS-N56V kernel: [  608.656114] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:12 ASUS-N56V kernel: [  608.769106] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:13 ASUS-N56V kernel: [  610.180013] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 20:15:13 ASUS-N56V kernel: [  610.383590] IPv6:
ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 29 20:15:13 ASUS-N56V kernel: [  610.505079] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:13 ASUS-N56V kernel: [  610.618056] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:13 ASUS-N56V kernel: [  610.731078] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  610.844127] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  610.957080] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  611.070055] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  611.183066] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  611.296055] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  611.409084] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  611.522060] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:14 ASUS-N56V kernel: [  611.635083] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  611.748072] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  611.861042] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  611.974084] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  612.087050] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  612.200069] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  612.313053] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  612.426032] ath: phy0: PLL4
meaurement not done
Jul 29 20:15:15 ASUS-N56V kernel: [  612.508185] wlan0: authenticate
with 00:23:08:3c:6b:25
Jul 29 20:15:15 ASUS-N56V kernel: [  612.522391] wlan0: send auth to
00:23:08:3c:6b:25 (try 1/3)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.524363] wlan0: authenticated
Jul 29 20:15:15 ASUS-N56V kernel: [  612.524899] wlan0: associate with
00:23:08:3c:6b:25 (try 1/3)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.528921] wlan0: RX AssocResp
from 00:23:08:3c:6b:25 (capab=0x411 status=0 aid=2)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.528965] wlan0: associated
Jul 29 20:15:15 ASUS-N56V kernel: [  612.528988] IPv6:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jul 29 20:15:15 ASUS-N56V kernel: [  612.529043] cfg80211: Calling CRDA
for country: DE
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532421] ath: regdomain 0x8114
updated by CountryIE
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532424] ath: EEPROM regdomain:
0x8114
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532425] ath: EEPROM indicates
we should expect a country code
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532427] ath: doing EEPROM
country->regdmn map search
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532428] ath: country maps to
regdmn code: 0x37
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532429] ath: Country alpha2
being used: DE
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532430] ath: Regpair used: 0x37
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532450] cfg80211: Regulatory
domain changed to country: DE
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532451] cfg80211:   (start_freq
- end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532453] cfg80211:   (2400000
KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532455] cfg80211:   (5150000
KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532456] cfg80211:   (5250000
KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532457] cfg80211:   (5470000
KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Jul 29 20:15:15 ASUS-N56V kernel: [  612.532459] cfg80211:   (57240000
KHz - 65880000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
Jul 29 20:15:36 ASUS-N56V kernel: [  633.102184] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.102191] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.103865] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.103871] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104471] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104477] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104676] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104679] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104695] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104699] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104804] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104807] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104982] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.104984] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105149] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105152] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105174] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105179] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105363] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105368] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105565] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105570] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105784] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105798] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105815] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105818] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105940] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.105944] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106112] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106115] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106309] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106314] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106331] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106334] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106449] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106452] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106639] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106643] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106799] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106802] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106819] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.106821] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107001] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107004] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107184] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107187] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107412] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107418] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107435] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107438] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107544] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107549] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107732] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107737] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107896] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107901] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107929] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.107932] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108035] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108040] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108216] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108219] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108432] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108450] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108467] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.108470] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110226] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110232] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110576] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110581] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110805] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110811] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110839] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110842] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110963] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.110968] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.111147] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:36 ASUS-N56V kernel: [  633.111152] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.111391] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:36 ASUS-N56V kernel: [  633.111409] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:36 ASUS-N56V kernel: [  633.111426] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.

 ############################### Manually deleted 578370 similar lines
#########################################

Jul 29 20:15:37 ASUS-N56V kernel: [  633.895156] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895171] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895174] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895224] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895229] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895245] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895258] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895276] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895278] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895292] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895295] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895330] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895333] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895347] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895350] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895373] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895380] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895397] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895403] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895422] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895426] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895449] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895451] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895482] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895485] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895500] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895503] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895526] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895529] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895543] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895546] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895564] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895566] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895580] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895583] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895597] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895600] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895611] mei_me 0000:00:16.0: we
can't read the message slots =00000001.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895628] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895631] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895645] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895648] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895679] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895682] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895696] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895698] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895730] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895733] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895747] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895750] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895781] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895784] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895798] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895801] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895832] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895835] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895849] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895852] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895882] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895885] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895899] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895902] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895933] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895936] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895950] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895953] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895983] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.895986] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896000] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896003] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896034] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896037] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896050] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896053] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896084] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896088] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896101] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896104] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896135] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896138] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896152] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896155] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896189] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896192] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896205] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896208] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896239] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896243] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896256] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896259] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896290] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896293] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896307] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896310] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896341] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896344] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896357] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896364] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896384] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896391] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896412] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896417] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896453] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896455] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896472] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896475] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896488] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896490] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896533] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896537] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896551] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896554] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896572] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896574] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896588] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896591] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896622] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896625] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896639] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896642] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896660] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896663] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896677] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896680] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896711] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896715] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896729] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896732] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896750] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896752] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896766] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896769] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896806] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896810] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896824] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896827] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896845] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896847] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896861] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896864] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896901] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896904] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896918] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896922] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896939] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896943] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896957] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896960] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896991] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.896994] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897008] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897011] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897029] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897032] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897046] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897049] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897081] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897084] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897098] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897101] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897119] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897122] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897136] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897139] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897157] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897160] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897174] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897177] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897210] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897213] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897227] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897230] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897248] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897251] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897265] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897268] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897299] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897302] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897316] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897319] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897350] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897353] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897371] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897378] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897399] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897404] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897422] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897427] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897450] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897452] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897466] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897468] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897505] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897517] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897531] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897534] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897547] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897550] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897569] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897572] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897642] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897645] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897659] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897662] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897680] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897683] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897696] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897700] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897731] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897734] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897748] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897751] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897780] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897783] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897797] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897800] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897831] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897835] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897848] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897851] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897869] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897872] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897886] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897889] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897920] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897924] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897938] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897941] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897959] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897962] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897976] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897979] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.897997] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898000] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898014] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898017] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898035] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898038] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898052] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898055] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898073] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898076] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898090] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898093] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898125] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898128] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898142] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898145] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898163] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898166] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898180] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898183] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898233] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898238] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898254] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898268] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898301] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898304] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898317] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898321] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898338] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898342] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898355] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898362] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898377] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898383] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898401] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898407] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898449] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898451] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898465] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898467] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898485] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898487] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898501] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898513] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898530] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898533] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898547] mei_me 0000:00:16.0:
reset: unexpected enumeration response hbm.
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898550] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898567] mei_me 0000:00:16.0:
reset: wrong host start response
Jul 29 20:15:37 ASUS-N56V kernel: [  633.898570] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:16:06 ASUS-N56V kernel: [  663.131847] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:16:06 ASUS-N56V kernel: [  663.131854] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:16:36 ASUS-N56V kernel: [  693.161415] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:16:36 ASUS-N56V kernel: [  693.161435] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:17:06 ASUS-N56V kernel: [  723.190923] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:17:06 ASUS-N56V kernel: [  723.190935] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:17:36 ASUS-N56V kernel: [  753.220501] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:17:36 ASUS-N56V kernel: [  753.220514] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:18:06 ASUS-N56V kernel: [  783.250115] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:18:06 ASUS-N56V kernel: [  783.250135] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:18:36 ASUS-N56V kernel: [  813.279640] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:18:36 ASUS-N56V kernel: [  813.279662] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:19:06 ASUS-N56V kernel: [  843.309229] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:19:06 ASUS-N56V kernel: [  843.309248] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:19:36 ASUS-N56V kernel: [  873.338758] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:19:36 ASUS-N56V kernel: [  873.338770] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:20:06 ASUS-N56V kernel: [  903.368332] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:20:06 ASUS-N56V kernel: [  903.368354] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:20:36 ASUS-N56V kernel: [  933.397905] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:20:36 ASUS-N56V kernel: [  933.397926] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:21:07 ASUS-N56V kernel: [  963.427445] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:21:07 ASUS-N56V kernel: [  963.427458] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:21:37 ASUS-N56V kernel: [  993.457050] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:21:37 ASUS-N56V kernel: [  993.457067] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:22:07 ASUS-N56V kernel: [ 1023.486604] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:22:07 ASUS-N56V kernel: [ 1023.486625] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:22:37 ASUS-N56V kernel: [ 1053.516161] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:22:37 ASUS-N56V kernel: [ 1053.516179] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:23:07 ASUS-N56V kernel: [ 1083.545693] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:23:07 ASUS-N56V kernel: [ 1083.545706] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:23:37 ASUS-N56V kernel: [ 1113.575215] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:23:37 ASUS-N56V kernel: [ 1113.575226] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:24:07 ASUS-N56V kernel: [ 1143.609358] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:24:07 ASUS-N56V kernel: [ 1143.609378] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:24:37 ASUS-N56V kernel: [ 1173.653917] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:24:37 ASUS-N56V kernel: [ 1173.653930] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:25:07 ASUS-N56V kernel: [ 1203.698499] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:25:07 ASUS-N56V kernel: [ 1203.698512] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:25:37 ASUS-N56V kernel: [ 1233.743040] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:25:37 ASUS-N56V kernel: [ 1233.743052] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:26:07 ASUS-N56V kernel: [ 1263.787619] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:26:07 ASUS-N56V kernel: [ 1263.787631] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:26:37 ASUS-N56V kernel: [ 1293.832232] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:26:37 ASUS-N56V kernel: [ 1293.832245] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:27:07 ASUS-N56V kernel: [ 1323.876847] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:27:07 ASUS-N56V kernel: [ 1323.876854] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:27:37 ASUS-N56V kernel: [ 1353.921400] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:27:37 ASUS-N56V kernel: [ 1353.921421] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:28:07 ASUS-N56V kernel: [ 1383.965969] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:28:07 ASUS-N56V kernel: [ 1383.965982] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:28:37 ASUS-N56V kernel: [ 1414.010502] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:28:37 ASUS-N56V kernel: [ 1414.010518] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:29:07 ASUS-N56V kernel: [ 1444.055121] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:29:07 ASUS-N56V kernel: [ 1444.055133] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:29:38 ASUS-N56V kernel: [ 1474.099712] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:29:38 ASUS-N56V kernel: [ 1474.099731] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:30:08 ASUS-N56V kernel: [ 1504.144289] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:30:08 ASUS-N56V kernel: [ 1504.144309] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:30:38 ASUS-N56V kernel: [ 1534.188888] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:30:38 ASUS-N56V kernel: [ 1534.188895] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:31:08 ASUS-N56V kernel: [ 1564.233417] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:31:08 ASUS-N56V kernel: [ 1564.233431] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:31:38 ASUS-N56V kernel: [ 1594.278000] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:31:38 ASUS-N56V kernel: [ 1594.278013] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:32:08 ASUS-N56V kernel: [ 1624.322590] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:32:08 ASUS-N56V kernel: [ 1624.322602] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:32:38 ASUS-N56V kernel: [ 1654.367196] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:32:38 ASUS-N56V kernel: [ 1654.367203] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:33:08 ASUS-N56V kernel: [ 1684.411776] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:33:08 ASUS-N56V kernel: [ 1684.411783] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:33:38 ASUS-N56V kernel: [ 1714.456337] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:33:38 ASUS-N56V kernel: [ 1714.456353] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:34:08 ASUS-N56V kernel: [ 1744.500896] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:34:08 ASUS-N56V kernel: [ 1744.500909] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:34:38 ASUS-N56V kernel: [ 1774.545465] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:34:38 ASUS-N56V kernel: [ 1774.545478] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:35:08 ASUS-N56V kernel: [ 1804.590041] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:35:08 ASUS-N56V kernel: [ 1804.590053] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:35:38 ASUS-N56V kernel: [ 1834.634618] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:35:38 ASUS-N56V kernel: [ 1834.634630] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:36:08 ASUS-N56V kernel: [ 1864.679196] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:36:08 ASUS-N56V kernel: [ 1864.679209] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:36:38 ASUS-N56V kernel: [ 1894.723776] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:36:38 ASUS-N56V kernel: [ 1894.723789] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:37:08 ASUS-N56V kernel: [ 1924.768299] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:37:08 ASUS-N56V kernel: [ 1924.768311] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:37:39 ASUS-N56V kernel: [ 1954.812876] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:37:39 ASUS-N56V kernel: [ 1954.812884] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:38:09 ASUS-N56V kernel: [ 1984.857501] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:38:09 ASUS-N56V kernel: [ 1984.857514] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:38:39 ASUS-N56V kernel: [ 2014.902086] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:38:39 ASUS-N56V kernel: [ 2014.902097] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:39:09 ASUS-N56V kernel: [ 2044.946613] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:39:09 ASUS-N56V kernel: [ 2044.946625] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:39:39 ASUS-N56V kernel: [ 2074.991223] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:39:39 ASUS-N56V kernel: [ 2074.991235] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:40:09 ASUS-N56V kernel: [ 2105.035816] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:40:09 ASUS-N56V kernel: [ 2105.035828] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:40:39 ASUS-N56V kernel: [ 2135.080404] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:40:39 ASUS-N56V kernel: [ 2135.080416] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:41:09 ASUS-N56V kernel: [ 2165.124966] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:41:09 ASUS-N56V kernel: [ 2165.124978] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:41:39 ASUS-N56V kernel: [ 2195.169486] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:41:39 ASUS-N56V kernel: [ 2195.169493] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:42:09 ASUS-N56V kernel: [ 2225.214126] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:42:09 ASUS-N56V kernel: [ 2225.214139] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:42:39 ASUS-N56V kernel: [ 2255.258680] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:42:39 ASUS-N56V kernel: [ 2255.258692] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:43:09 ASUS-N56V kernel: [ 2285.303288] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:43:09 ASUS-N56V kernel: [ 2285.303300] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:43:39 ASUS-N56V kernel: [ 2315.347827] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:43:39 ASUS-N56V kernel: [ 2315.347840] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:44:09 ASUS-N56V kernel: [ 2345.392432] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:44:09 ASUS-N56V kernel: [ 2345.392445] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:44:39 ASUS-N56V kernel: [ 2375.437009] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:44:39 ASUS-N56V kernel: [ 2375.437021] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:45:09 ASUS-N56V kernel: [ 2405.481557] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:45:09 ASUS-N56V kernel: [ 2405.481570] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:45:39 ASUS-N56V kernel: [ 2435.526170] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:45:39 ASUS-N56V kernel: [ 2435.526182] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:46:10 ASUS-N56V kernel: [ 2465.570743] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:46:10 ASUS-N56V kernel: [ 2465.570756] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:46:40 ASUS-N56V kernel: [ 2495.615323] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:46:40 ASUS-N56V kernel: [ 2495.615336] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:47:10 ASUS-N56V kernel: [ 2525.659849] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:47:10 ASUS-N56V kernel: [ 2525.659862] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:47:40 ASUS-N56V kernel: [ 2555.704446] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:47:40 ASUS-N56V kernel: [ 2555.704458] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:48:10 ASUS-N56V kernel: [ 2585.749054] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:48:10 ASUS-N56V kernel: [ 2585.749067] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:48:40 ASUS-N56V kernel: [ 2615.793634] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:48:40 ASUS-N56V kernel: [ 2615.793647] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:49:10 ASUS-N56V kernel: [ 2645.838172] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:49:10 ASUS-N56V kernel: [ 2645.838185] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:49:40 ASUS-N56V kernel: [ 2675.882725] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:49:40 ASUS-N56V kernel: [ 2675.882731] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:50:10 ASUS-N56V kernel: [ 2705.927366] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:50:10 ASUS-N56V kernel: [ 2705.927379] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:50:40 ASUS-N56V kernel: [ 2735.971938] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:50:40 ASUS-N56V kernel: [ 2735.971950] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:51:10 ASUS-N56V kernel: [ 2766.016518] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:51:10 ASUS-N56V kernel: [ 2766.016531] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:51:40 ASUS-N56V kernel: [ 2796.061109] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:51:40 ASUS-N56V kernel: [ 2796.061121] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:52:10 ASUS-N56V kernel: [ 2826.105678] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:52:10 ASUS-N56V kernel: [ 2826.105690] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:52:40 ASUS-N56V kernel: [ 2856.150260] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:52:40 ASUS-N56V kernel: [ 2856.150272] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:53:10 ASUS-N56V kernel: [ 2886.194786] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:53:10 ASUS-N56V kernel: [ 2886.194793] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:53:40 ASUS-N56V kernel: [ 2916.239401] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:53:40 ASUS-N56V kernel: [ 2916.239414] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:54:10 ASUS-N56V kernel: [ 2946.283931] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:54:10 ASUS-N56V kernel: [ 2946.283944] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:54:41 ASUS-N56V kernel: [ 2976.328556] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:54:41 ASUS-N56V kernel: [ 2976.328568] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:55:11 ASUS-N56V kernel: [ 3006.373145] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:55:11 ASUS-N56V kernel: [ 3006.373157] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:55:41 ASUS-N56V kernel: [ 3036.417714] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:55:41 ASUS-N56V kernel: [ 3036.417727] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:56:11 ASUS-N56V kernel: [ 3066.462237] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:56:11 ASUS-N56V kernel: [ 3066.462245] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:56:41 ASUS-N56V kernel: [ 3096.506866] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:56:41 ASUS-N56V kernel: [ 3096.506879] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:57:11 ASUS-N56V kernel: [ 3126.551444] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:57:11 ASUS-N56V kernel: [ 3126.551457] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:57:41 ASUS-N56V kernel: [ 3156.596023] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:57:41 ASUS-N56V kernel: [ 3156.596035] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:58:11 ASUS-N56V kernel: [ 3186.640600] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:58:11 ASUS-N56V kernel: [ 3186.640613] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:58:41 ASUS-N56V kernel: [ 3216.685176] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:58:41 ASUS-N56V kernel: [ 3216.685188] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:59:11 ASUS-N56V kernel: [ 3246.729697] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:59:11 ASUS-N56V kernel: [ 3246.729704] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 20:59:41 ASUS-N56V kernel: [ 3276.774333] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 20:59:41 ASUS-N56V kernel: [ 3276.774346] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:00:11 ASUS-N56V kernel: [ 3306.818959] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:00:11 ASUS-N56V kernel: [ 3306.818966] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:00:41 ASUS-N56V kernel: [ 3336.863429] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:00:41 ASUS-N56V kernel: [ 3336.863436] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:01:11 ASUS-N56V kernel: [ 3366.908067] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:01:11 ASUS-N56V kernel: [ 3366.908079] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:01:41 ASUS-N56V kernel: [ 3396.952647] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:01:41 ASUS-N56V kernel: [ 3396.952660] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:02:11 ASUS-N56V kernel: [ 3426.997223] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:02:11 ASUS-N56V kernel: [ 3426.997236] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:02:42 ASUS-N56V kernel: [ 3457.041793] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:02:42 ASUS-N56V kernel: [ 3457.041805] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:03:12 ASUS-N56V kernel: [ 3487.086373] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:03:12 ASUS-N56V kernel: [ 3487.086386] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:03:42 ASUS-N56V kernel: [ 3517.130952] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:03:42 ASUS-N56V kernel: [ 3517.130965] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:04:12 ASUS-N56V kernel: [ 3547.175485] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:04:12 ASUS-N56V kernel: [ 3547.175498] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:04:42 ASUS-N56V kernel: [ 3577.220052] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:04:42 ASUS-N56V kernel: [ 3577.220064] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:05:12 ASUS-N56V kernel: [ 3607.264694] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:05:12 ASUS-N56V kernel: [ 3607.264707] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:05:42 ASUS-N56V kernel: [ 3637.309261] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:05:42 ASUS-N56V kernel: [ 3637.309274] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:06:12 ASUS-N56V kernel: [ 3667.353838] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:06:12 ASUS-N56V kernel: [ 3667.353851] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:06:42 ASUS-N56V kernel: [ 3697.398414] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:06:42 ASUS-N56V kernel: [ 3697.398426] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:07:12 ASUS-N56V kernel: [ 3727.442990] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:07:12 ASUS-N56V kernel: [ 3727.443002] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:07:42 ASUS-N56V kernel: [ 3757.487572] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:07:42 ASUS-N56V kernel: [ 3757.487584] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:08:12 ASUS-N56V kernel: [ 3787.532149] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:08:12 ASUS-N56V kernel: [ 3787.532162] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:08:42 ASUS-N56V kernel: [ 3817.576725] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:08:42 ASUS-N56V kernel: [ 3817.576737] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:09:12 ASUS-N56V kernel: [ 3847.621301] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:09:12 ASUS-N56V kernel: [ 3847.621314] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:09:42 ASUS-N56V kernel: [ 3877.665883] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:09:42 ASUS-N56V kernel: [ 3877.665896] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:10:12 ASUS-N56V kernel: [ 3907.710458] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:10:12 ASUS-N56V kernel: [ 3907.710471] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:10:42 ASUS-N56V kernel: [ 3937.755029] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:10:42 ASUS-N56V kernel: [ 3937.755041] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:11:13 ASUS-N56V kernel: [ 3967.799584] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:11:13 ASUS-N56V kernel: [ 3967.799596] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:11:43 ASUS-N56V kernel: [ 3997.844148] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:11:43 ASUS-N56V kernel: [ 3997.844160] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:12:13 ASUS-N56V kernel: [ 4027.888769] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:12:13 ASUS-N56V kernel: [ 4027.888781] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:12:43 ASUS-N56V kernel: [ 4057.933342] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:12:43 ASUS-N56V kernel: [ 4057.933355] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:13:13 ASUS-N56V kernel: [ 4087.977925] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:13:13 ASUS-N56V kernel: [ 4087.977938] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:13:43 ASUS-N56V kernel: [ 4118.022459] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:13:43 ASUS-N56V kernel: [ 4118.022473] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:14:13 ASUS-N56V kernel: [ 4148.067035] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:14:13 ASUS-N56V kernel: [ 4148.067048] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:14:43 ASUS-N56V kernel: [ 4178.111613] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:14:43 ASUS-N56V kernel: [ 4178.111626] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156231] mei_me 0000:00:16.0:
reset: init clients timeout hbm_state = 1.
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156244] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156250] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156265] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156269] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156271] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156274] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156278] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156281] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156284] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156288] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156291] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156295] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156298] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156301] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156304] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156308] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156310] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156313] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156316] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156319] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156322] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156326] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156329] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156332] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156335] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156347] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156349] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156351] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156353] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156356] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156358] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156360] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156363] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156367] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156369] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156373] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156384] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156387] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156390] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156394] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156396] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156400] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156403] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156407] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156409] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156413] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156416] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156419] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156422] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156434] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156437] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156440] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156443] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156446] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156449] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156452] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156455] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156458] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156461] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156465] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156467] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156470] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156473] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156476] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156479] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156482] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156485] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156488] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156490] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156493] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156495] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156497] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156499] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156503] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156505] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156508] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156511] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156515] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156526] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156529] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156532] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156536] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156539] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156542] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156545] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156548] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156551] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156555] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156566] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156569] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156572] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156575] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156578] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156581] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156584] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156587] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156590] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156593] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156596] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156599] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156602] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156605] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156608] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156611] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156614] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156617] mei_me 0000:00:16.0:
version message writet failed
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156620] mei_me 0000:00:16.0:
unexpected reset: dev_state = RESETTING
Jul 29 21:15:13 ASUS-N56V kernel: [ 4208.156623] mei_me 0000:00:16.0:
version message writet failed


[6.] A small shell script or example program which triggers the
     problem (sorry, don't have any)

[7.] Environment

[7.1.] Software (add the output of the ver_linux script here)

Linux ASUS-N56V 3.10-3.slh.2-aptosid-amd64 #1 SMP PREEMPT Fri Jul 26
21:23:40 UTC 2013 x86_64 GNU/Linux

Gnu C                  4.8
Gnu make               3.81
binutils               2.23.52.20130727
util-linux             mount                  support
module-init-tools      found
Linux C Library        2.17
Dynamic linker (ldd)   2.17
Procps                 3.3.8
Kbd                    1.15.5
Sh-utils               8.21
Modules Loaded         ecb bnep rfcomm pci_stub vboxpci vboxnetadp
vboxnetflt parport_pc vboxdrv ppdev lp parport cpufreq_conservative
cpufreq_stats cpufreq_powersave binfmt_misc uinput af_packet ext3 jbd
nls_utf8 nls_cp437 vfat fat asus_nb_wmi fuse ecryptfs cbc sha256_ssse3
sha256_generic encrypted_keys trusted dm_crypt snd_hda_codec_realtek
snd_hda_intel snd_hda_codec i915 nouveau snd_hwdep snd_pcm
intel_powerclamp snd_page_alloc ttm asus_wmi joydev sparse_keymap
intel_agp intel_gtt i2c_algo_bit drm_kms_helper coretemp snd_seq
kvm_intel uvcvideo ath3k btusb snd_seq_device videobuf2_vmalloc
videobuf2_memops bluetooth pci_hotplug videobuf2_core drm snd_timer arc4
videodev kvm serio_raw evdev i2c_i801 mxm_wmi media pcspkr snd ath9k
ath9k_common ath9k_hw ath mperf mac80211 iTCO_wdt iTCO_vendor_support
cfg80211 rfkill i2c_core wmi microcode soundcore processor lpc_ich
battery video button ac mfd_core ext4 crc16 jbd2 mbcache dm_mod md_mod
sg sr_mod cdrom sd_mod crc_t10dif hid_generic usbhid hid crc32_pclmul
crc32c_intel ghash_clmulni_intel aesni_intel aes_x86_64 lrw gf128mul
glue_helper ablk_helper cryptd ahci libahci libata scsi_mod ehci_pci alx
ehci_hcd mdio xhci_hcd usbcore usb_common thermal

[7.2.] Processor information (from /proc/cpuinfo):
cat /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 2047.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 3174.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 2024.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 2461.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 4
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 2139.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 5
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 2231.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 6
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 2875.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 58
model name	: Intel(R) Core(TM) i7-3610QM CPU @ 2.30GHz
stepping	: 9
microcode	: 0x10
cpu MHz		: 2898.000
cache size	: 6144 KB
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
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology
nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx
est tm2 ssse3 cx16 xtpr pdcm pcid sse4_1 sse4_2 x2apic popcnt
tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm ida arat epb
xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase
smep erms
bogomips	: 4589.57
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

[7.3.] Module information (from /proc/modules):
modules
ecb 1825 1 - Live 0xffffffffa0265000
bnep 9066 2 - Live 0xffffffffa025c000
rfcomm 26890 0 - Live 0xffffffffa024f000
pci_stub 1293 1 - Live 0xffffffffa024b000
vboxpci 12454 0 - Live 0xffffffffa0243000 (O)
vboxnetadp 17459 0 - Live 0xffffffffa0217000 (O)
vboxnetflt 14497 0 - Live 0xffffffffa020f000 (O)
parport_pc 26894 0 - Live 0xffffffffa0202000
vboxdrv 1782014 3 vboxpci,vboxnetadp,vboxnetflt, Live 0xffffffffa06d1000 (O)
ppdev 4876 0 - Live 0xffffffffa01fb000
lp 8315 0 - Live 0xffffffffa01f4000
parport 26196 3 parport_pc,ppdev,lp, Live 0xffffffffa01e7000
cpufreq_conservative 5664 0 - Live 0xffffffffa01d5000
cpufreq_stats 3331 0 - Live 0xffffffffa01d1000
cpufreq_powersave 886 0 - Live 0xffffffffa014d000
binfmt_misc 5938 1 - Live 0xffffffffa01ca000
uinput 6619 1 - Live 0xffffffffa0166000
af_packet 22931 4 - Live 0xffffffffa01bd000
ext3 105516 1 - Live 0xffffffffa019a000
jbd 38637 1 ext3, Live 0xffffffffa0152000
nls_utf8 1192 1 - Live 0xffffffffa00a9000
nls_cp437 5801 1 - Live 0xffffffffa0139000
vfat 7879 1 - Live 0xffffffffa0128000
fat 41872 1 vfat, Live 0xffffffffa0141000
asus_nb_wmi 6480 0 - Live 0xffffffffa011b000
fuse 60575 5 - Live 0xffffffffa018a000
ecryptfs 63787 0 - Live 0xffffffffa016d000
cbc 2424 0 - Live 0xffffffffa006e000
sha256_ssse3 15535 2 - Live 0xffffffffa00ff000
sha256_generic 9588 1 sha256_ssse3, Live 0xffffffffa00d2000
encrypted_keys 8310 1 ecryptfs, Live 0xffffffffa00cb000
trusted 9144 1 encrypted_keys, Live 0xffffffffa00a5000
dm_crypt 12843 0 - Live 0xffffffffa009b000
snd_hda_codec_realtek 30635 1 - Live 0xffffffffa0065000
snd_hda_intel 27738 1 - Live 0xffffffffa0058000
snd_hda_codec 108258 2 snd_hda_codec_realtek,snd_hda_intel, Live
0xffffffffa002b000
i915 457197 2 - Live 0xffffffffa0d84000
nouveau 723218 0 - Live 0xffffffffa0cb1000
snd_hwdep 5373 1 snd_hda_codec, Live 0xffffffffa0cab000
snd_pcm 62001 2 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0c90000
intel_powerclamp 7493 0 - Live 0xffffffffa0c33000
snd_page_alloc 6106 2 snd_hda_intel,snd_pcm, Live 0xffffffffa0c2a000
ttm 51783 1 nouveau, Live 0xffffffffa0c12000
asus_wmi 13780 1 asus_nb_wmi, Live 0xffffffffa0c0a000
joydev 8259 0 - Live 0xffffffffa0c03000
sparse_keymap 2408 1 asus_wmi, Live 0xffffffffa0bff000
intel_agp 9907 1 i915, Live 0xffffffffa0bf8000
intel_gtt 10611 2 i915,intel_agp, Live 0xffffffffa0bf1000
i2c_algo_bit 4337 2 i915,nouveau, Live 0xffffffffa0bec000
drm_kms_helper 23247 2 i915,nouveau, Live 0xffffffffa0bd2000
coretemp 5326 0 - Live 0xffffffffa0bad000
snd_seq 41693 0 - Live 0xffffffffa0b98000
kvm_intel 115524 0 - Live 0xffffffffa0a70000
uvcvideo 60012 0 - Live 0xffffffffa0a5b000
ath3k 5430 0 - Live 0xffffffffa0a51000
btusb 13531 0 - Live 0xffffffffa0a41000
snd_seq_device 4752 1 snd_seq, Live 0xffffffffa0a3c000
videobuf2_vmalloc 2448 1 uvcvideo, Live 0xffffffffa0a38000
videobuf2_memops 1527 1 videobuf2_vmalloc, Live 0xffffffffa0a34000
bluetooth 165552 12 bnep,rfcomm,ath3k,btusb, Live 0xffffffffa09c6000
pci_hotplug 8973 1 asus_wmi, Live 0xffffffffa09bf000
videobuf2_core 20822 1 uvcvideo, Live 0xffffffffa09b4000
drm 196028 5 i915,nouveau,ttm,drm_kms_helper, Live 0xffffffffa0922000
snd_timer 15348 2 snd_pcm,snd_seq, Live 0xffffffffa0919000
arc4 1800 2 - Live 0xffffffffa0915000
videodev 86623 2 uvcvideo,videobuf2_core, Live 0xffffffffa08f3000
kvm 216791 1 kvm_intel, Live 0xffffffffa069b000
serio_raw 4102 0 - Live 0xffffffffa061f000
evdev 8037 16 - Live 0xffffffffa05fb000
i2c_i801 8462 0 - Live 0xffffffffa05f4000
mxm_wmi 1363 1 nouveau, Live 0xffffffffa05f0000
media 9150 2 uvcvideo,videodev, Live 0xffffffffa05e2000
pcspkr 1800 0 - Live 0xffffffffa05de000
snd 49964 10
snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm,snd_seq,snd_seq_device,snd_timer,
Live 0xffffffffa05c7000
ath9k 70117 0 - Live 0xffffffffa05ac000
ath9k_common 1807 1 ath9k, Live 0xffffffffa05a8000
ath9k_hw 335851 2 ath9k,ath9k_common, Live 0xffffffffa0547000
ath 13801 3 ath9k,ath9k_common,ath9k_hw, Live 0xffffffffa053f000
mperf 1173 0 - Live 0xffffffffa053b000
mac80211 246214 1 ath9k, Live 0xffffffffa04ea000
iTCO_wdt 4639 0 - Live 0xffffffffa04e5000
iTCO_vendor_support 1688 1 iTCO_wdt, Live 0xffffffffa04e1000
cfg80211 156987 3 ath9k,ath,mac80211, Live 0xffffffffa04aa000
rfkill 13206 5 asus_wmi,bluetooth,cfg80211, Live 0xffffffffa04a1000
i2c_core 16995 7
i915,nouveau,i2c_algo_bit,drm_kms_helper,drm,videodev,i2c_i801, Live
0xffffffffa047b000
wmi 7219 3 nouveau,asus_wmi,mxm_wmi, Live 0xffffffffa046c000
microcode 15128 0 - Live 0xffffffffa0429000
soundcore 4346 1 snd, Live 0xffffffffa0423000
processor 26682 0 - Live 0xffffffffa03bb000
lpc_ich 12501 0 - Live 0xffffffffa03b2000
battery 6485 0 - Live 0xffffffffa03ad000
video 10811 3 i915,nouveau,asus_wmi, Live 0xffffffffa039d000
button 4376 2 i915,nouveau, Live 0xffffffffa038b000
ac 3140 0 - Live 0xffffffffa0387000
mfd_core 2537 1 lpc_ich, Live 0xffffffffa0383000
ext4 268364 4 - Live 0xffffffffa032f000
crc16 1287 2 bluetooth,ext4, Live 0xffffffffa032b000
jbd2 48468 1 ext4, Live 0xffffffffa0316000
mbcache 4498 2 ext3,ext4, Live 0xffffffffa0310000
dm_mod 59845 1 dm_crypt, Live 0xffffffffa02f7000
md_mod 86401 0 - Live 0xffffffffa02d7000
sg 18705 0 - Live 0xffffffffa02ce000
sr_mod 13100 0 - Live 0xffffffffa02c6000
cdrom 28773 1 sr_mod, Live 0xffffffffa02b9000
sd_mod 31950 7 - Live 0xffffffffa02ac000
crc_t10dif 1260 1 sd_mod, Live 0xffffffffa02a8000
hid_generic 1081 0 - Live 0xffffffffa02a4000
usbhid 30275 0 - Live 0xffffffffa0297000
hid 73574 2 hid_generic,usbhid, Live 0xffffffffa027e000
crc32_pclmul 2659 0 - Live 0xffffffffa0260000
crc32c_intel 13825 0 - Live 0xffffffffa021e000
ghash_clmulni_intel 3645 0 - Live 0xffffffffa01fe000
aesni_intel 42749 2 - Live 0xffffffffa017e000
aes_x86_64 7247 1 aesni_intel, Live 0xffffffffa016a000
lrw 3239 1 aesni_intel, Live 0xffffffffa015e000
gf128mul 5463 1 lrw, Live 0xffffffffa014f000
glue_helper 3852 1 aesni_intel, Live 0xffffffffa013f000
ablk_helper 1596 1 aesni_intel, Live 0xffffffffa0137000
cryptd 6665 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live
0xffffffffa012b000
ahci 21632 6 - Live 0xffffffffa011f000
libahci 17261 1 ahci, Live 0xffffffffa0115000
libata 138297 2 ahci,libahci, Live 0xffffffffa00dc000
scsi_mod 122920 4 sg,sr_mod,sd_mod,libata, Live 0xffffffffa00ab000
ehci_pci 3272 0 - Live 0xffffffffa00a3000
alx 22900 0 - Live 0xffffffffa0094000
ehci_hcd 31788 1 ehci_pci, Live 0xffffffffa008b000
mdio 3021 1 alx, Live 0xffffffffa0087000
xhci_hcd 69085 0 - Live 0xffffffffa0070000
usbcore 129697 7 uvcvideo,ath3k,btusb,usbhid,ehci_pci,ehci_hcd,xhci_hcd,
Live 0xffffffffa000a000
usb_common 1512 1 usbcore, Live 0xffffffffa0006000
thermal 8036 0 - Live 0xffffffffa0000000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
cat ioports:
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : EC cmd
  0070-0077 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  0200-020f : pnp 00:04
  0400-0453 : pnp 00:04
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-042f : ACPI GPE0_BLK
    0430-0433 : iTCO_wdt
      0430-0433 : iTCO_wdt
    0450-0450 : ACPI PM2_CNT_BLK
  0454-0457 : pnp 00:06
  0458-047f : pnp 00:04
    0460-047f : iTCO_wdt
      0460-047f : iTCO_wdt
  04d0-04d1 : pnp 00:07
  0500-057f : pnp 00:04
  0680-069f : pnp 00:04
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  164e-164f : pnp 00:04
  2000-2fff : PCI Bus 0000:02
  d000-dfff : PCI Bus 0000:04
    d000-d07f : 0000:04:00.0
  e000-efff : PCI Bus 0000:01
    e000-e07f : 0000:01:00.0
  f000-f03f : 0000:00:02.0
  f040-f05f : 0000:00:1f.3
  f060-f07f : 0000:00:1f.2
    f060-f07f : ahci
  f080-f083 : 0000:00:1f.2
    f080-f083 : ahci
  f090-f097 : 0000:00:1f.2
    f090-f097 : ahci
  f0a0-f0a3 : 0000:00:1f.2
    f0a0-f0a3 : ahci
  f0b0-f0b7 : 0000:00:1f.2
    f0b0-f0b7 : ahci
  ffff-ffff : pnp 00:04
    ffff-ffff : pnp 00:04

cat iomem
00000000-00000fff : reserved
00001000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : PCI Bus 0000:00
000c0000-000cebff : Video ROM
000d0000-000d3fff : PCI Bus 0000:00
000d4000-000d7fff : PCI Bus 0000:00
000d8000-000dbfff : PCI Bus 0000:00
000dc000-000dffff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-1fffffff : System RAM
  02000000-0235985c : Kernel code
  0235985d-02556fff : Kernel data
  0264c000-02716fff : Kernel bss
20000000-201fffff : reserved
  20000000-201fffff : pnp 00:0d
20200000-40003fff : System RAM
40004000-40004fff : reserved
  40004000-40004fff : pnp 00:0d
40005000-c90ebfff : System RAM
c90ec000-c912efff : ACPI Non-volatile Storage
c912f000-c9532fff : System RAM
c9533000-c97f8fff : reserved
c97f9000-ca75efff : System RAM
ca75f000-cad7afff : reserved
cad7b000-caffafff : ACPI Non-volatile Storage
caffb000-caffffff : ACPI Tables
cb000000-cbbfffff : RAM buffer
cbc00000-cfdfffff : reserved
cfe00000-feafffff : PCI Bus 0000:00
  cfe00000-cfe00fff : pnp 00:0b
    cfe00000-cfe00fff : pnp 00:0c
  d0000000-dfffffff : 0000:00:02.0
  e0000000-f1ffffff : PCI Bus 0000:01
    e0000000-efffffff : 0000:01:00.0
    f0000000-f1ffffff : 0000:01:00.0
  f2000000-f21fffff : PCI Bus 0000:02
  f2200000-f23fffff : PCI Bus 0000:02
  f6000000-f70fffff : PCI Bus 0000:01
    f6000000-f6ffffff : 0000:01:00.0
    f7000000-f707ffff : 0000:01:00.0
  f7400000-f77fffff : 0000:00:02.0
  f7800000-f78fffff : PCI Bus 0000:04
    f7800000-f783ffff : 0000:04:00.0
      f7800000-f783ffff : alx
  f7900000-f79fffff : PCI Bus 0000:03
    f7900000-f797ffff : 0000:03:00.0
      f7900000-f797ffff : ath9k
    f7980000-f798ffff : 0000:03:00.0
  f7a00000-f7a0ffff : 0000:00:14.0
    f7a00000-f7a0ffff : xhci_hcd
  f7a10000-f7a13fff : 0000:00:1b.0
    f7a10000-f7a13fff : ICH HD audio
  f7a15000-f7a150ff : 0000:00:1f.3
  f7a16000-f7a167ff : 0000:00:1f.2
    f7a16000-f7a167ff : ahci
  f7a17000-f7a173ff : 0000:00:1d.0
    f7a17000-f7a173ff : ehci_hcd
  f7a18000-f7a183ff : 0000:00:1a.0
    f7a18000-f7a183ff : ehci_hcd
  f7a1a000-f7a1a00f : 0000:00:16.0
    f7a1a000-f7a1a00f : mei_me
  f8000000-fbffffff : PCI MMCONFIG 0000 [bus 00-3f]
    f8000000-fbffffff : reserved
      f8000000-fbffffff : pnp 00:0b
fec00000-fec00fff : reserved
  fec00000-fec003ff : IOAPIC 0
fed00000-fed03fff : reserved
  fed00000-fed003ff : HPET 0
fed10000-fed17fff : pnp 00:0b
fed18000-fed18fff : pnp 00:0b
fed19000-fed19fff : pnp 00:0b
fed1c000-fed1ffff : reserved
  fed1c000-fed1ffff : pnp 00:0b
    fed1f410-fed1f414 : iTCO_wdt
      fed1f410-fed1f414 : iTCO_wdt
fed20000-fed3ffff : pnp 00:0b
fed40000-fed44fff : pnp 00:00
fed45000-fed8ffff : pnp 00:0b
fed90000-fed93fff : pnp 00:0b
fee00000-fee00fff : Local APIC
  fee00000-fee00fff : reserved
ff000000-ffffffff : reserved
  ff000000-ffffffff : pnp 00:0b
100000000-22f1fffff : System RAM
22f200000-22fffffff : RAM buffer



[7.5.] PCI information ('lspci -vvv' as root)
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM
Controller (rev 09)
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>

00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core
processor PCI Express Root Port (rev 09) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: f6000000-f70fffff
	Prefetchable memory behind bridge: 00000000e0000000-00000000f1ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: ASUSTeK Computer Inc. N56VZ
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 4181
	Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 8GT/s, Width x16, ASPM L0s L1, Latency L0
<256ns, L1 <8us
			ClockPM- Surprise- LLActRep- BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 75.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis-, LTR-, OBFF
Not Supported ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 8GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed+ WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [140 v1] Root Complex Link
		Desc:	PortNumber=02 ComponentID=01 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=01 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed19000
	Capabilities: [d94 v1] #19
	Kernel driver in use: pcieport

00:02.0 VGA compatible controller: Intel Corporation 3rd Gen Core
processor Graphics Controller (rev 09) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 1477
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 47
	Region 0: Memory at f7400000 (64-bit, non-prefetchable) [size=4M]
	Region 2: Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Region 4: I/O ports at f000 [size=64]
	Expansion ROM at <unassigned> [disabled]
	Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 4142
	Capabilities: [d0] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a4] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: i915

00:14.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB xHCI Host Controller (rev 04) (prog-if 30 [XHCI])
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 45
	Region 0: Memory at f7a00000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [70] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [80] MSI: Enable+ Count=1/8 Maskable- 64bit+
		Address: 00000000fee4400c  Data: 41d1
	Kernel driver in use: xhci_hcd

00:16.0 Communication controller: Intel Corporation 7 Series/C210 Series
Chipset Family MEI Controller #1 (rev 04)
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 44
	Region 0: Memory at f7a1a000 (64-bit, non-prefetchable) [size=16]
	Capabilities: [50] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 41c1
	Kernel driver in use: mei_me

00:1a.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #2 (rev 04) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f7a18000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci-pci

00:1b.0 Audio device: Intel Corporation 7 Series/C210 Series Chipset
Family High Definition Audio Controller (rev 04)
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 48
	Region 0: Memory at f7a10000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
		Address: 00000000feeff00c  Data: 4162
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset+
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0
<64ns, L1 <1us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=01
			Status:	NegoPending- InProgress-
		VC1:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=1 ArbSelect=Fixed TC/VC=22
			Status:	NegoPending- InProgress-
	Capabilities: [130 v1] Root Complex Link
		Desc:	PortNumber=0f ComponentID=00 EltType=Config
		Link0:	Desc:	TargetPort=00 TargetComponent=00 AssocRCRB-
LinkType=MemMapped LinkValid+
			Addr:	00000000fed1c000
	Kernel driver in use: snd_hda_intel

00:1c.0 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 1 (rev c4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 00002000-00002fff
	Memory behind bridge: f2000000-f21fffff
	Prefetchable memory behind bridge: 00000000f2200000-00000000f23fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0 <1us,
L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM L0s L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surprise+
			Slot #0, PowerLimit 0.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 4191
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. N56VZ
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.1 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 2 (rev c4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: f7900000-f79fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #1, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 41a1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. N56VZ
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1c.3 PCI bridge: Intel Corporation 7 Series/C210 Series Chipset
Family PCI Express Root Port 4 (rev c4) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: f7800000-f78fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #4, Speed 5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <16us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+
BWMgmt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surprise-
			Slot #3, PowerLimit 10.000W; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet- LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna+ CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range BC, TimeoutDis+, LTR-, OBFF Not
Supported ARIFwd-
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled ARIFwd-
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: feeff00c  Data: 41b1
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. N56VZ
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport

00:1d.0 USB controller: Intel Corporation 7 Series/C210 Series Chipset
Family USB Enhanced Host Controller #1 (rev 04) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at f7a17000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Capabilities: [98] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ehci-pci

00:1f.0 ISA bridge: Intel Corporation HM76 Express Chipset LPC
Controller (rev 04)
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information: Len=0c <?>
	Kernel driver in use: lpc_ich

00:1f.2 SATA controller: Intel Corporation 7 Series Chipset Family
6-port SATA Controller [AHCI mode] (rev 04) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 46
	Region 0: I/O ports at f0b0 [size=8]
	Region 1: I/O ports at f0a0 [size=4]
	Region 2: I/O ports at f090 [size=8]
	Region 3: I/O ports at f080 [size=4]
	Region 4: I/O ports at f060 [size=32]
	Region 5: Memory at f7a16000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
		Address: fee1100c  Data: 41e1
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA v1.0 BAR4 Offset=00000004
	Capabilities: [b0] PCI Advanced Features
		AFCap: TP+ FLR+
		AFCtrl: FLR-
		AFStatus: TP-
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 7 Series/C210 Series Chipset Family
SMBus Controller (rev 04)
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at f7a15000 (64-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at f040 [size=32]

01:00.0 VGA compatible controller: NVIDIA Corporation GF108M [GeForce GT
630M] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 1477
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at f6000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at e0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at f0000000 (64-bit, prefetchable) [size=32M]
	Region 5: I/O ports at e000 [size=128]
	Expansion ROM at f7000000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0
<256ns, L1 <4us
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [b4] Vendor Specific Information: Len=14 <?>
	Capabilities: [100 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [128 v1] Power Budgeting <?>
	Capabilities: [600 v1] Vendor Specific Information: ID=0001 Rev=1
Len=024 <?>
	Kernel driver in use: nouveau

03:00.0 Network controller: Qualcomm Atheros AR9485 Wireless Network
Adapter (rev 01)
	Subsystem: AzureWave Device 2c97
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: Memory at f7900000 (64-bit, non-prefetchable) [size=512K]
	Expansion ROM at f7980000 [disabled] [size=64K]
	Capabilities: [40] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/4 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [70] Express (v2) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<4us, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+, LTR-, OBFF
Not Supported
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-, LTR-, OBFF
Disabled
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB, EqualizationComplete-,
EqualizationPhase1-
			 EqualizationPhase2-, EqualizationPhase3-, LinkEqualizationRequest-
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap- CGenEn- ChkCap- ChkEn-
	Capabilities: [140 v1] Virtual Channel
		Caps:	LPEVC=0 RefClk=100ns PATEntryBits=1
		Arb:	Fixed- WRR32- WRR64- WRR128-
		Ctrl:	ArbSelect=Fixed
		Status:	InProgress-
		VC0:	Caps:	PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
			Arb:	Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
			Ctrl:	Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
			Status:	NegoPending- InProgress-
	Capabilities: [160 v1] Device Serial Number 00-00-00-00-00-00-00-00
	Kernel driver in use: ath9k

04:00.0 Ethernet controller: Qualcomm Atheros AR8161 Gigabit Ethernet
(rev 08)
	Subsystem: ASUSTeK Computer Inc. N56VZ
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at f7800000 (64-bit, non-prefetchable) [size=256K]
	Region 2: I/O ports at d000 [size=128]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 4096 bytes, PhantFunc 0, Latency L0s unlimited, L1
unlimited
			ExtTag- AttnBtn+ AttnInd+ PwrInd+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr+ FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
unlimited, L1 unlimited
			ClockPM+ Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
	Capabilities: [c0] MSI: Enable- Count=1/16 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [d8] MSI-X: Enable- Count=16 Masked-
		Vector table: BAR=0 offset=00002000
		PBA: BAR=0 offset=00003000
	Capabilities: [100 v1] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP- SDES+ TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP+ BadDLLP- Rollover+ Timeout+ NonFatalErr-
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 14, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [180 v1] Device Serial Number ff-14-bb-d2-10-bf-48-ff
	Kernel driver in use: alx

[7.6.] SCSI information (from /proc/scsi/scsi) n/a

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):

I have seen a crash or two some weeks ago, but it really only became so
frequent a couple of days ago, which effectively means it probably
started with kernel version 3.10-x.

[X.] Other notes, patches, fixes, workarounds:

Blacklisting the module makes the freezes go away.
