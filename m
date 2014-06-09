Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759AbaFIXL2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:11:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933405AbaFIWpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        Matheus Almeida <Matheus.Almeida@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.14 27/78] MIPS: Fix typo when reporting cache and ftlb errors for ImgTec cores
Date: Mon,  9 Jun 2014 15:48:07 -0700
Message-Id: <20140609224814.224357274@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 721a9205396c4ef2a811dd665ec2a232163b583d upstream.

Introduced by the following two commits:
75b5b5e0a262790fa11043fe45700499c7e3d818
"MIPS: Add support for FTLBs"
6de20451857ed14a4eecc28d08f6de5925d1cf96
"MIPS: Add printing of ES bit for Imgtec cores when cache error occurs"

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Reported-by: Matheus Almeida <Matheus.Almeida@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: Markos Chandras <markos.chandras@imgtec.com>
Patchwork: https://patchwork.linux-mips.org/patch/6980/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/traps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -1429,7 +1429,7 @@ asmlinkage void cache_parity_error(void)
 	       reg_val & (1<<30) ? "secondary" : "primary",
 	       reg_val & (1<<31) ? "data" : "insn");
 	if (cpu_has_mips_r2 &&
-	    ((current_cpu_data.processor_id && 0xff0000) == PRID_COMP_MIPS)) {
+	    ((current_cpu_data.processor_id & 0xff0000) == PRID_COMP_MIPS)) {
 		pr_err("Error bits: %s%s%s%s%s%s%s%s\n",
 			reg_val & (1<<29) ? "ED " : "",
 			reg_val & (1<<28) ? "ET " : "",
@@ -1469,7 +1469,7 @@ asmlinkage void do_ftlb(void)
 
 	/* For the moment, report the problem and hang. */
 	if (cpu_has_mips_r2 &&
-	    ((current_cpu_data.processor_id && 0xff0000) == PRID_COMP_MIPS)) {
+	    ((current_cpu_data.processor_id & 0xff0000) == PRID_COMP_MIPS)) {
 		pr_err("FTLB error exception, cp0_ecc=0x%08x:\n",
 		       read_c0_ecc());
 		pr_err("cp0_errorepc == %0*lx\n", field, read_c0_errorepc());


