Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaK1VEF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 16:04:05 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:52239 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaK1VEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 16:04:01 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: Merge consecutive seq_puts calls
Date: Fri, 28 Nov 2014 22:03:42 +0100
Message-Id: <1417208622-12264-2-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1417208622-12264-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417208622-12264-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These can be done as a single seq_puts call, reducing the code size slightly.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 arch/x86/platform/uv/tlb_uv.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index ab4062c..fe5126b 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1368,17 +1368,13 @@ static int ptc_seq_show(struct seq_file *file, void *data)
 	cpu = *(loff_t *)data;
 	if (!cpu) {
 		seq_puts(file,
-			 "# cpu bauoff sent stime self locals remotes ncpus localhub ");
-		seq_puts(file, "remotehub numuvhubs numuvhubs16 numuvhubs8 ");
-		seq_puts(file,
-			 "numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries ");
-		seq_puts(file,
-			 "rok resetp resett giveup sto bz throt disable ");
-		seq_puts(file,
-			 "enable wars warshw warwaits enters ipidis plugged ");
-		seq_puts(file,
-			 "ipiover glim cong swack recv rtime all one mult ");
-		seq_puts(file, "none retry canc nocan reset rcan\n");
+			 "# cpu bauoff sent stime self locals remotes ncpus localhub "
+			 "remotehub numuvhubs numuvhubs16 numuvhubs8 "
+			 "numuvhubs4 numuvhubs2 numuvhubs1 dto snacks retries "
+			 "rok resetp resett giveup sto bz throt disable "
+			 "enable wars warshw warwaits enters ipidis plugged "
+			 "ipiover glim cong swack recv rtime all one mult "
+			 "none retry canc nocan reset rcan\n");
 	}
 	if (cpu < num_possible_cpus() && cpu_online(cpu)) {
 		bcp = &per_cpu(bau_control, cpu);
-- 
2.0.4

