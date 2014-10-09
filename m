Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbaJIPPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:15:46 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:57993 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756543AbaJIPPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:15:38 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Thu, 9 Oct 2014 16:14:53 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>, yrl.pp-manager.tt@hitachi.com,
        Borislav Petkov <bpetkov@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141009151453.GL12897@nuc-i3427.alporthouse.com>
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
 <20141008051059.65566251@as>
 <20141008194955.GF12897@nuc-i3427.alporthouse.com>
 <5435AE71.60304@linux.intel.com>
 <20141009065331.GG12897@nuc-i3427.alporthouse.com>
 <20141009074416.1480426a@as>
 <20141009130047.GJ12897@nuc-i3427.alporthouse.com>
 <20141009094637.4f3f61e2@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009094637.4f3f61e2@as>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 09:46:37AM -0500, Chuck Ebbert wrote:
> Well they're all the same.
> 
> Hmm, x86info is not dumping all the variable MTRRs. You have 10, but
> it only prints the first 8. I don't know if it will show anything
> different, but can you try fixing it with this patch?

Source (https://github.com/dankamongmen/x86info) was slightly different,
but I followed the drift.

tldr: 8,9 appear to be identical on all cpus as well.

$ sudo ./x86info --mtrr --all-cpus
x86info v1.31pre
Found 4 CPUs.
CPU #1:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Core i7 (SandyBridge)
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a wc:1 fix:1 vcnt:10
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase:0x000000 type: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase:0x080000 type: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase:0x08e000 type: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask:0xffe000 valid:1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase:0x08d000 type: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase:0x100000 type: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase:0x170000 type: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase:0x16f000 type: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase:0x16e800 type: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask:0xfff800 valid:1)
MTRRphysBase8 (0x210): 0x000000016e600000 (physbase:0x16e600 type: 0x00 (uncacheable))
MTRRphysMask8 (0x211): 0x0000000fffe00800 (physmask:0xfffe00 valid:1)
MTRRphysBase9 (0x212): 0x0000000000000000 (physbase:0x000000 type: 0x00 (uncacheable))
MTRRphysMask9 (0x213): 0x0000000000000000 (physmask:0x000000 valid:0)
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0505050505050505
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0505050505050505
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag:1 enable flag:1 default type:0x00 (uncacheable))

--------------------------------------------------------------------------
CPU #2:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Core i7 (SandyBridge)
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a wc:1 fix:1 vcnt:10
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase:0x000000 type: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase:0x080000 type: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase:0x08e000 type: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask:0xffe000 valid:1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase:0x08d000 type: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase:0x100000 type: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase:0x170000 type: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase:0x16f000 type: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase:0x16e800 type: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask:0xfff800 valid:1)
MTRRphysBase8 (0x210): 0x000000016e600000 (physbase:0x16e600 type: 0x00 (uncacheable))
MTRRphysMask8 (0x211): 0x0000000fffe00800 (physmask:0xfffe00 valid:1)
MTRRphysBase9 (0x212): 0x0000000000000000 (physbase:0x000000 type: 0x00 (uncacheable))
MTRRphysMask9 (0x213): 0x0000000000000000 (physmask:0x000000 valid:0)
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0505050505050505
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0505050505050505
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag:1 enable flag:1 default type:0x00 (uncacheable))

--------------------------------------------------------------------------
CPU #3:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Core i7 (SandyBridge)
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a wc:1 fix:1 vcnt:10
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase:0x000000 type: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase:0x080000 type: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase:0x08e000 type: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask:0xffe000 valid:1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase:0x08d000 type: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase:0x100000 type: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase:0x170000 type: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase:0x16f000 type: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase:0x16e800 type: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask:0xfff800 valid:1)
MTRRphysBase8 (0x210): 0x000000016e600000 (physbase:0x16e600 type: 0x00 (uncacheable))
MTRRphysMask8 (0x211): 0x0000000fffe00800 (physmask:0xfffe00 valid:1)
MTRRphysBase9 (0x212): 0x0000000000000000 (physbase:0x000000 type: 0x00 (uncacheable))
MTRRphysMask9 (0x213): 0x0000000000000000 (physmask:0x000000 valid:0)
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0505050505050505
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0505050505050505
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag:1 enable flag:1 default type:0x00 (uncacheable))

--------------------------------------------------------------------------
CPU #4:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Core i7 (SandyBridge)
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a wc:1 fix:1 vcnt:10
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase:0x000000 type: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase:0x080000 type: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase:0x08e000 type: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask:0xffe000 valid:1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase:0x08d000 type: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase:0x100000 type: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask:0xf80000 valid:1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase:0x170000 type: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask:0xff0000 valid:1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase:0x16f000 type: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask:0xfff000 valid:1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase:0x16e800 type: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask:0xfff800 valid:1)
MTRRphysBase8 (0x210): 0x000000016e600000 (physbase:0x16e600 type: 0x00 (uncacheable))
MTRRphysMask8 (0x211): 0x0000000fffe00800 (physmask:0xfffe00 valid:1)
MTRRphysBase9 (0x212): 0x0000000000000000 (physbase:0x000000 type: 0x00 (uncacheable))
MTRRphysMask9 (0x213): 0x0000000000000000 (physmask:0x000000 valid:0)
MTRRfix64K_00000 (0x250): 0x0606060606060606
MTRRfix16K_80000 (0x258): 0x0606060606060606
MTRRfix16K_A0000 (0x259): 0x0000000000000000
MTRRfix4K_C8000 (0x269): 0x0505050505050505
MTRRfix4K_D0000 0x26a: 0x0000000000000000
MTRRfix4K_D8000 0x26b: 0x0000000000000000
MTRRfix4K_E0000 0x26c: 0x0000000000000000
MTRRfix4K_E8000 0x26d: 0x0505050505050505
MTRRfix4K_F0000 0x26e: 0x0505050505050505
MTRRfix4K_F8000 0x26f: 0x0505050505050505
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag:1 enable flag:1 default type:0x00 (uncacheable))

--------------------------------------------------------------------------
Total processor threads: 4
This system has 1 dual-core processor with hyper-threading (2 threads per core) running at an estimated 3.30GHz

-- 
Chris Wilson, Intel Open Source Technology Centre
