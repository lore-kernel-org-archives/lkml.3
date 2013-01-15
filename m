Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3AOMUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:20:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:30967 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab3AOMUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:20:04 -0500
X-IronPort-AV: E=Sophos;i="4.84,473,1355097600"; 
   d="scan'208";a="3780032"
Date: Tue, 15 Jan 2013 12:19:59 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v7u1 00/31] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
In-Reply-To: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1301151214480.4978@kaball.uk.xensource.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2013, Yinghai Lu wrote:
> Now we have limit kdump reseved under 896M, because kexec has the limitation.
> and also bzImage need to stay under 4g.
> 
> To make kexec/kdump could use range above 4g, we need to make bzImage and
> ramdisk could be loaded above 4g.
> During booting bzImage will be unpacked on same postion and stay high.
> 
> The patches add fields in setup_header and boot_params to
> 1. get info about ramdisk position info above 4g from bootloader/kexec
> 2. get info about cmd_line_ptr info above 4g from bootloader/kexec
> 3. set xloadflags bit0 in header for bzImage and bootloader/kexec load
>    could check that to decide if it could to put bzImage high.
> 4. use sentinel to make sure ext_* fields in boot_params could be used.
> 
> This patches is tested with kexec tools with local changes and they are sent
> to kexec list later.
> 
> could be found at:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-x86-boot

I tried to boot this kernel as PV guest with 2GB of RAM, but
unfortunately it crashes early on at boot (earlyprintk=xen log
appended).



mapping kernel into physical memory
about to get started...
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 3.8.0-rc3+ (sstabellini@st22) (gcc version 4.4.5 (Debian 4.4.5-8) ) #4 SMP Tue Jan 15 12:11:59 UTC 2013
[    0.000000] Command line: root=/dev/xvda1 rw loglevel=9 debug console=hvc0 earlyprintk=xen
[    0.000000] ACPI in unprivileged domain disabled
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] Xen: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] Xen: [mem 0x00000000000a0000-0x00000000000fffff] reserved
[    0.000000] Xen: [mem 0x0000000000100000-0x000000007fffffff] usable
[    0.000000] bootconsole [xenboot0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI not present or invalid.
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] No AGP bridge found
[    0.000000] e820: last_pfn = 0x80000 max_arch_pfn = 0x400000000
[    0.000000] Base memory trampoline at [ffff88000009a000] 9a000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x7fe00000-0x7fffffff]
[    0.000000]  [mem 0x7fe00000-0x7fffffff] page 4k
[    0.000000] BRK [0x023b8000, 0x023b8fff] PGTABLE
[    0.000000] BRK [0x023b9000, 0x023b9fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x7c000000-0x7fdfffff]
[    0.000000]  [mem 0x7c000000-0x7fdfffff] page 4k
[    0.000000] BRK [0x023ba000, 0x023bafff] PGTABLE
[    0.000000] BRK [0x023bb000, 0x023bbfff] PGTABLE
[    0.000000] BRK [0x023bc000, 0x023bcfff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x00100000-0x7bffffff]
[    0.000000]  [mem 0x00100000-0x7bffffff] page 4k
(XEN) d15:v0: unhandled page fault (ec=0000)
(XEN) Pagetable walk from ffffea0000080330:
(XEN)  L4[0x1d4] = 0000000000000000 ffffffffffffffff
(XEN) domain_crash_sync called from entry.S
(XEN) Domain 15 (vcpu#0) crashed on cpu#3:
(XEN) ----[ Xen-4.3-unstable  x86_64  debug=y  Not tainted ]----
(XEN) CPU:    3
(XEN) RIP:    e033:[<ffffffff810052e4>]
(XEN) RFLAGS: 0000000000000206   EM: 1   CONTEXT: pv guest
(XEN) rax: ffffea0000000000   rbx: 000000000200c000   rcx: 0000000080000000
(XEN) rdx: 0000000000080300   rsi: 000000000200c000   rdi: 0000000000000000
(XEN) rbp: ffffffff82001dd8   rsp: ffffffff82001d90   r8:  0000000000000000
(XEN) r9:  0000000000000083   r10: 0000000000000000   r11: 0000000000000000
(XEN) r12: 0000000000000000   r13: 0000001000000000   r14: 0000000000000000
(XEN) r15: 0000000000100000   cr0: 000000008005003b   cr4: 00000000000026f0
(XEN) cr3: 0000000184cc8000   cr2: ffffea0000080330
(XEN) ds: 0000   es: 0000   fs: 0000   gs: 0000   ss: e02b   cs: e033
(XEN) Guest stack trace from rsp=ffffffff82001d90:
(XEN)    0000000080000000 0000000000000000 0000000000000000 ffffffff810052e4
(XEN)    000000010000e030 0000000000010006 ffffffff82001dd8 000000000000e02b
(XEN)    ffffffff81005299 ffffffff82001e08 ffffffff8100768c 0000000080000000
(XEN)    0000000080000000 0000001000000000 000000007ff00000 ffffffff82001e48
(XEN)    ffffffff82161b3a ffffffff82001e48 0000000001000000 00000000017cb000
(XEN)    0000000000000000 0000000000000000 0000000000000000 ffffffff82001ed8
(XEN)    ffffffff821529cc ffffffff821d7920 0000000000000000 0000000000000000
(XEN)    0000000000000000 ffffffff82001f00 ffffffff819a8e6f 0000000000000010
(XEN)    ffffffff82001ee8 ffffffff82001ea8 0000000000000000 ffffffff82001ec8
(XEN)    ffffffffffffffff ffffffff821d7920 0000000000000000 0000000000000000
(XEN)    0000000000000000 ffffffff82001f28 ffffffff8214bb69 ffffffff82001f28
(XEN)    ffffffff810556e6 ae32416208683d40 ffffffff821e12e0 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 ffffffff82001f38
(XEN)    ffffffff8214b4fc ffffffff82001ff8 ffffffff8214f3b3 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 0000000000000000 0000000000000000 0000000000000000
(XEN)    0000000000000000 809822011f898975 000106a506100800 0000000000000001
(XEN)    0000000000000000 0000000000000000 0f00000060c0c748 ccccccccccccc305
