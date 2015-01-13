Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbbAMKXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:23:01 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54845 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbAMKW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:22:59 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org, shuahkh@osg.samsung.com
Subject: [PATCH V2 02/12] powerpc, process: Remove the unused extern dscr_default
Date: Tue, 13 Jan 2015 15:52:30 +0530
Message-Id: <1421144560-15901-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011310-0029-0000-0000-000000FC59A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The process context switch code no longer uses dscr_default variable
from the sysfs.c file. The variable became unused when we started
storing the CPU specific DSCR value in the PACA structure instead.
This patch just removes this extern declaration. It was originally
added by the following commit.

efcac658: powerpc: Per process DSCR + some fixes (try#4)

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/process.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index b4cc7be..fe3f682 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1112,8 +1112,6 @@ static void setup_ksp_vsid(struct task_struct *p, unsigned long sp)
 /*
  * Copy a thread..
  */
-extern unsigned long dscr_default; /* defined in arch/powerpc/kernel/sysfs.c */
-
 int copy_thread(unsigned long clone_flags, unsigned long usp,
 		unsigned long arg, struct task_struct *p)
 {
-- 
1.9.3

