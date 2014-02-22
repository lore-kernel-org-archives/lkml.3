Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844AbaBVTJJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:09:09 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:44339 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaBVTJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:09:07 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 22 Feb 2014 11:08:50 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Andi Kleen <ak@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>, Feng Tang <feng.tang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jacob Shin <jacob.shin@amd.com>, Jan Beulich <JBeulich@suse.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>, Rob Landley <rob@landley.net>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Thomas Renninger <trenn@suse.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 1/2] x86: Drop support for /proc files when !CONFIG_PROC_FS
Message-ID: <296de15c8addece6dada4ddac982b3934d8ff6fa.1393096111.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/cpu/proc.c only exists to support files in /proc; omit that
file when compiling without CONFIG_PROC_FS.

Saves 645 additional bytes on 32-bit x86 when !CONFIG_PROC_FS:

add/remove: 0/5 grow/shrink: 0/0 up/down: 0/-645 (-645)
function                                     old     new   delta
c_stop                                         1       -      -1
c_next                                        11       -     -11
cpuinfo_op                                    16       -     -16
c_start                                       24       -     -24
show_cpuinfo                                 593       -    -593

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/kernel/cpu/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 7fd54f0..64038d8 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -13,10 +13,12 @@ nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_common.o		:= $(nostackp)
 
 obj-y			:= intel_cacheinfo.o scattered.o topology.o
-obj-y			+= proc.o capflags.o powerflags.o common.o
+obj-y			+= capflags.o powerflags.o common.o
 obj-y			+= rdrand.o
 obj-y			+= match.o
 
+obj-$(CONFIG_PROC_FS)	+= proc.o
+
 obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
-- 
1.9.0

