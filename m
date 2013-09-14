Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3INAtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 20:49:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37459 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab3INAt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 20:49:26 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: <linux-kernel@vger.kernel.org>
Cc: linuxppc-dev@ozlabs.org, Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: [PATCH 6/8][v4] powerpc: Rename branch_opcode() to instr_opcode()
Date: Fri, 13 Sep 2013 17:49:13 -0700
Message-Id: <1379119755-21025-7-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091400-9332-0000-0000-0000016A97FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The logic used in branch_opcode() to extract the opcode for an instruction
applies to non branch instructions also. So rename to instr_opcode().

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 arch/powerpc/lib/code-patching.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 17e5b23..2bc9db3 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -72,19 +72,19 @@ unsigned int create_cond_branch(const unsigned int *addr,
 	return instruction;
 }
 
-static unsigned int branch_opcode(unsigned int instr)
+static unsigned int instr_opcode(unsigned int instr)
 {
 	return (instr >> 26) & 0x3F;
 }
 
 static int instr_is_branch_iform(unsigned int instr)
 {
-	return branch_opcode(instr) == 18;
+	return instr_opcode(instr) == 18;
 }
 
 static int instr_is_branch_bform(unsigned int instr)
 {
-	return branch_opcode(instr) == 16;
+	return instr_opcode(instr) == 16;
 }
 
 int instr_is_relative_branch(unsigned int instr)
-- 
1.7.9.5

