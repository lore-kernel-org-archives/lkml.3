Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaJIOqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:46:51 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:56277 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627AbaJIOqm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:46:42 -0400
Date: Thu, 9 Oct 2014 09:46:37 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jason Baron <jbaron@akamai.com>, yrl.pp-manager.tt@hitachi.com,
        Borislav Petkov <bpetkov@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: i915.ko WC writes are slow after ea8596bb2d8d379
Message-ID: <20141009094637.4f3f61e2@as>
In-Reply-To: <20141009130047.GJ12897@nuc-i3427.alporthouse.com>
References: <20141008090336.GD12897@nuc-i3427.alporthouse.com>
	<20141008051059.65566251@as>
	<20141008194955.GF12897@nuc-i3427.alporthouse.com>
	<5435AE71.60304@linux.intel.com>
	<20141009065331.GG12897@nuc-i3427.alporthouse.com>
	<20141009074416.1480426a@as>
	<20141009130047.GJ12897@nuc-i3427.alporthouse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Oct 2014 14:00:47 +0100
Chris Wilson <chris@chris-wilson.co.uk> wrote:

> On Thu, Oct 09, 2014 at 07:44:16AM -0500, Chuck Ebbert wrote:
> > Could you try installing x86info and running "x86info --mtrr
> > --all-cpus" while running the broken kernel?
> 
> # /opt/xorg/src/intel-gpu-tools/tests/gem_gtt_speed 
> IGT-Version: 1.8-g32a0308 (x86_64) (Linux: 3.17.0+ x86_64)
> Time to read 16k through a GTT map:             318.643µs
> Time to write 16k through a GTT map:            203.103µs
> Time to clear 16k through a GTT map:             53.098µs
> Time to clear 16k through a cached GTT map:      49.925µs
> 
> (i.e. bad kernel)
> 
> # x86info --mtrr --all-cpus
> x86info v1.30.  Dave Jones 2001-2011
> Feedback to <davej@redhat.com>.
> 
> Found 4 CPUs.
> CPU #1:
> Extended Family: 0 Extended Model: 2 Family: 6 Model: 42 Stepping: 7
> Type: 0 (Original OEM)
> CPU Model (x86info's best guess): Unknown model. 
> Processor name string (BIOS programmed): Intel(R) Core(TM) i5-2500 CPU @ 3.30GHz
> 
> MTRR registers:
> MTRRcap (0xfe): 0x0000000000000d0a (smrr flag: 0x1, wc flag: 0x1, fix flag: 0x1, vcnt field: 0x0a (10))
> MTRRphysBase0 (0x200): 0x0000000000000006 (physbase field:0x000000 type field: 0x06 (write-back))
> MTRRphysMask0 (0x201): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
> MTRRphysBase1 (0x202): 0x0000000080000006 (physbase field:0x080000 type field: 0x06 (write-back))
> MTRRphysMask1 (0x203): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
> MTRRphysBase2 (0x204): 0x000000008e000000 (physbase field:0x08e000 type field: 0x00 (uncacheable))
> MTRRphysMask2 (0x205): 0x0000000ffe000800 (physmask field:0xffe000 valid flag: 1)
> MTRRphysBase3 (0x206): 0x000000008d000000 (physbase field:0x08d000 type field: 0x00 (uncacheable))
> MTRRphysMask3 (0x207): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
> MTRRphysBase4 (0x208): 0x0000000100000006 (physbase field:0x100000 type field: 0x06 (write-back))
> MTRRphysMask4 (0x209): 0x0000000f80000800 (physmask field:0xf80000 valid flag: 1)
> MTRRphysBase5 (0x20a): 0x0000000170000000 (physbase field:0x170000 type field: 0x00 (uncacheable))
> MTRRphysMask5 (0x20b): 0x0000000ff0000800 (physmask field:0xff0000 valid flag: 1)
> MTRRphysBase6 (0x20c): 0x000000016f000000 (physbase field:0x16f000 type field: 0x00 (uncacheable))
> MTRRphysMask6 (0x20d): 0x0000000fff000800 (physmask field:0xfff000 valid flag: 1)
> MTRRphysBase7 (0x20e): 0x000000016e800000 (physbase field:0x16e800 type field: 0x00 (uncacheable))
> MTRRphysMask7 (0x20f): 0x0000000fff800800 (physmask field:0xfff800 valid flag: 1)
> MTRRfix64K_00000 (0x250): 0x0606060606060606
> MTRRfix16K_80000 (0x258): 0x0606060606060606
> MTRRfix16K_A0000 (0x259): 0x0000000000000000
> MTRRfix4K_C8000 (0x269): 0x0505050505050505
> MTRRfix4K_D0000 0x26a: 0x0000000000000000
> MTRRfix4K_D8000 0x26b: 0x0000000000000000
> MTRRfix4K_E0000 0x26c: 0x0000000000000000
> MTRRfix4K_E8000 0x26d: 0x0505050505050505
> MTRRfix4K_F0000 0x26e: 0x0505050505050505
> MTRRfix4K_F8000 0x26f: 0x0505050505050505
> MTRRdefType (0x2ff): 0x0000000000000c00 (fixed-range flag: 0x1, mtrr flag: 0x1, type field: 0x00 (uncacheable))
> 

<snip>

Well they're all the same.

Hmm, x86info is not dumping all the variable MTRRs. You have 10, but
it only prints the first 8. I don't know if it will show anything
different, but can you try fixing it with this patch?

--- a/mtrr.c
+++ b/mtrr.c
@@ -75,19 +75,23 @@
 		printf("0x%016llx\n", val);
 }
 
-static void decode_mtrrcap(int cpu, int msr)
+unsigned int decode_mtrrcap(int cpu, int msr)
 {
 	unsigned long long val;
+	unsigned int vcnt = 0;
 	int ret;
 
 	ret = mtrr_value(cpu,msr,&val);
 	if (ret) {
+		vcnt = (unsigned int)(val & IA32_MTRRCAP_VCNT);
 		printf("0x%016llx ", val);
 		printf("(smrr flag: 0x%01x, ",(unsigned int) (val & IA32_MTRRCAP_SMRR) >> 11 );
 		printf("wc flag: 0x%01x, ",(unsigned int) (val&IA32_MTRRCAP_WC) >> 10);
 		printf("fix flag: 0x%01x, ",(unsigned int) (val&IA32_MTRRCAP_FIX) >> 8);
-		printf("vcnt field: 0x%02x (%d))\n",(unsigned int) (val&IA32_MTRRCAP_VCNT) , (int) (val&IA32_MTRRCAP_VCNT));
+		printf("vcnt field: 0x%02x (%u))\n", vcnt, vcnt);
 	}
+
+	return vcnt;
 }
 
 static void decode_mtrr_deftype(int cpu, int msr)
@@ -142,7 +146,7 @@
 void dump_mtrrs(struct cpudata *cpu)
 {
 	unsigned long long val = 0;
-	unsigned int i;
+	unsigned int i, vcnt;
 
 	if (!(cpu->flags_edx & (X86_FEATURE_MTRR)))
 		return;
@@ -157,11 +161,11 @@
 	printf("MTRR registers:\n");
 
 	printf("MTRRcap (0xfe): ");
-	decode_mtrrcap(cpu->number, 0xfe);
+	vcnt = decode_mtrrcap(cpu->number, 0xfe);
 
 	set_max_phy_addr(cpu);
 
-	for (i = 0; i < 16; i+=2) {
+	for (i = 0; i < 2 * vcnt; i += 2) {
 		printf("MTRRphysBase%u (0x%x): ", i/2, (unsigned int) 0x200+i);
 		decode_mtrr_physbase(cpu->number, 0x200+i);
 		printf("MTRRphysMask%u (0x%x): ", i/2, (unsigned int) 0x201+i);
