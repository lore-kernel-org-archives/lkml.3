Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaLIOPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:15:23 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53282 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaLIOPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:15:19 -0500
Date: Tue, 9 Dec 2014 15:15:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv tree changes for v3.19
Message-ID: <20141209141514.GA1198@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

   # HEAD: 3ab0c49fd6b1e80438d0a649584d292880112262 x86: UV BAU: Increase maximum CPUs per socket/hub

Two small SGI/UV fixes.

 Thanks,

	Ingo

------------------>
James Custer (2):
      x86: UV BAU: Avoid NULL pointer reference in ptc_seq_show
      x86: UV BAU: Increase maximum CPUs per socket/hub


 arch/x86/include/asm/uv/uv_bau.h | 4 ++--
 arch/x86/platform/uv/tlb_uv.c    | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 2d60a7813dfe..fc808b83fccb 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -33,8 +33,8 @@
  * Each of the descriptors is 64 bytes in size (8*64 = 512 bytes in a set).
  */
 
-#define MAX_CPUS_PER_UVHUB		64
-#define MAX_CPUS_PER_SOCKET		32
+#define MAX_CPUS_PER_UVHUB		128
+#define MAX_CPUS_PER_SOCKET		64
 #define ADP_SZ				64 /* hardware-provided max. */
 #define UV_CPUS_PER_AS			32 /* hardware-provided max. */
 #define ITEMS_PER_DESC			8
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 3968d67d366b..570b1b14375b 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1384,6 +1384,10 @@ static int ptc_seq_show(struct seq_file *file, void *data)
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		bcp = &per_cpu(bau_control, cpu);
+		if (bcp->nobau) {
+			seq_printf(file, "cpu %d bau disabled\n", cpu);
+			return 0;
+		}
 		stat = bcp->statp;
 		/* source side statistics */
 		seq_printf(file,
