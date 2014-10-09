Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaJINBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:01:42 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:64805 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757211AbaJINB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:01:28 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Thu, 9 Oct 2014 14:00:47 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Chuck Ebbert <cebbert.lkml@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>, yrl.pp-manager.tt@hitachi.com,
        Borislav Petkov <bpetkov@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141009130047.GJ12897@nuc-i3427.alporthouse.com>
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
 <20141008051059.65566251@as>
 <20141008194955.GF12897@nuc-i3427.alporthouse.com>
 <5435AE71.60304@linux.intel.com>
 <20141009065331.GG12897@nuc-i3427.alporthouse.com>
 <20141009074416.1480426a@as>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141009074416.1480426a@as>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 07:44:16AM -0500, Chuck Ebbert wrote:
> Could you try installing x86info and running "x86info --mtrr
> --all-cpus" while running the broken kernel?

# /opt/xorg/src/intel-gpu-tools/tests/gem_gtt_speed 
IGT-Version: 1.8-g32a0308 (x86_64) (Linux: 3.17.0+ x86_64)
Time to read 16k through a GTT map:             318.643탎
Time to write 16k through a GTT map:            203.103탎
Time to clear 16k through a GTT map:             53.098탎
Time to clear 16k through a cached GTT map:      49.925탎

(i.e. bad kernel)

# x86info --mtrr --all-cpus
x86info v1.30.  Dave Jones 2001-2011
Feedback to <davej@redhat.com>.

Found 4 CPUs.
CPU #1:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Unknown model. 
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a (smrr flag: 0x1, wc flag: 0x1, fix flag: 0x1, vcnt field: 0x0a (10))
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase field:0x000000 type field: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase field:0x080000 type field: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase field:0x08e000 type field: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask field:0xffe000 valid flag: 1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase field:0x08d000 type field: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase field:0x100000 type field: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase field:0x170000 type field: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase field:0x16f000 type field: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase field:0x16e800 type field: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask field:0xfff800 valid flag: 1)
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
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag: 0x1, mtrr flag: 0x1, type field: 0x00 (uncacheable))

--------------------------------------------------------------------------

CPU #2:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Unknown model. 
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a (smrr flag: 0x1, wc flag: 0x1, fix flag: 0x1, vcnt field: 0x0a (10))
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase field:0x000000 type field: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase field:0x080000 type field: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase field:0x08e000 type field: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask field:0xffe000 valid flag: 1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase field:0x08d000 type field: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase field:0x100000 type field: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase field:0x170000 type field: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase field:0x16f000 type field: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase field:0x16e800 type field: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask field:0xfff800 valid flag: 1)
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
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag: 0x1, mtrr flag: 0x1, type field: 0x00 (uncacheable))

--------------------------------------------------------------------------
CPU #3:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Unknown model. 
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a (smrr flag: 0x1, wc flag: 0x1, fix flag: 0x1, vcnt field: 0x0a (10))
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase field:0x000000 type field: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase field:0x080000 type field: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase field:0x08e000 type field: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask field:0xffe000 valid flag: 1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase field:0x08d000 type field: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase field:0x100000 type field: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase field:0x170000 type field: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase field:0x16f000 type field: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase field:0x16e800 type field: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask field:0xfff800 valid flag: 1)
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
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag: 0x1, mtrr flag: 0x1, type field: 0x00 (uncacheable))

--------------------------------------------------------------------------
CPU #4:
Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
Type: 0 (Original OEM)
CPU Model (x86info's best guess): Unknown model. 
Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz

MTRR registers:
MTRRcap (0xfe): 0x0000000000000d0a (smrr flag: 0x1, wc flag: 0x1, fix flag: 0x1, vcnt field: 0x0a (10))
MTRRphysBase0 (0x200): 0x0000000000000006 (physbase field:0x000000 type field: 0x06 (write-back))
MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase1 (0x202): 0x0000000080000006 (physbase field:0x080000 type field: 0x06 (write-back))
MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase2 (0x204): 0x000000008e000000 (physbase field:0x08e000 type field: 0x00 (uncacheable))
MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask field:0xffe000 valid flag: 1)
MTRRphysBase3 (0x206): 0x000000008d000000 (physbase field:0x08d000 type field: 0x00 (uncacheable))
MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase4 (0x208): 0x0000000100000006 (physbase field:0x100000 type field: 0x06 (write-back))
MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase field:0x170000 type field: 0x00 (uncacheable))
MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase field:0x16f000 type field: 0x00 (uncacheable))
MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase field:0x16e800 type field: 0x00 (uncacheable))
MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask field:0xfff800 valid flag: 1)
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
MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag: 0x1, mtrr flag: 0x1, type field: 0x00 (uncacheable))

--------------------------------------------------------------------------
Total processor threads: 4
This system has 1 dual-core processor with hyper-threading (2 threads per core) running at an estimated 3.30GHz

-- 
Chris Wilson, Intel Open Source Technology Centre
