Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab3HTVLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:11:41 -0400
Received: from mout.gmx.net ([212.227.15.18]:54538 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3HTVLk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:11:40 -0400
From: dl9pf@gmx.de
To: dl9pf@gmx.de
Cc: PaX Team <pageexec@freemail.hu>, Behan Webster <behanw@converseincode.com>,
        Doug Covelli <dcovelli@vmware.com>, Dan Hecht <dhecht@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [TRIVIAL] Remove braces in arch/x86/kernel/cpu/vmware.c to fix build for clang. No functional change otherwise.
Date: Tue, 20 Aug 2013 23:10:12 +0200
Message-Id: <1377033012-19194-1-git-send-email-dl9pf@gmx.de>
X-Mailer: git-send-email 1.8.1.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:Q7ZzjO6lcogfcRbwycl5jurC+yAs1DieMGIaufx4mPF8rnXSrF8
 i+RcbC4zlA15YsAuMlnnZo0I4Zhoalnr/rt3wFKs7X3jgFpEG95XBQzJs0GfU3JjbbfjpFh
 1xVci4RjnDx6sA/MCn+V8FMALxd7oTnhmtoRistd9dPmTu9zEVykWjMiZjIn0AyFUEvx8kt
 smThX5Z6iDTN1rBuVw3sw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Simon Möller <dl9pf@gmx.de>

Author:  PaX Team <pageexec at freemail.hu>
ML-Post: http://lists.cs.uiuc.edu/pipermail/llvm-commits/Week-of-Mon-20120507/142707.html
URL:     http://llvm.linuxfoundation.org

Merge:   Jan-Simon Möller <dl9pf at gmx.de>

Description:
  Clang chokes on the notation "inl (%dx)" but works for "inl %dx";
  GNU as accepts both forms.

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>

CC: Jan-Simon Möller <dl9pf@gmx.de>
CC: PaX Team <pageexec@freemail.hu>
CC: Behan Webster <behanw@converseincode.com>
CC: Doug Covelli <dcovelli@vmware.com>
CC: Dan Hecht <dhecht@vmware.com>
CC: linux-kernel@vger.kernel.org
---
 arch/x86/kernel/cpu/vmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 628a059..32ef12c 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -38,7 +38,7 @@
 #define VMWARE_PORT_CMD_VCPU_RESERVED	31
 
 #define VMWARE_PORT(cmd, eax, ebx, ecx, edx)				\
-	__asm__("inl (%%dx)" :						\
+	__asm__("inl %%dx" :						\
 			"=a"(eax), "=c"(ecx), "=d"(edx), "=b"(ebx) :	\
 			"0"(VMWARE_HYPERVISOR_MAGIC),			\
 			"1"(VMWARE_PORT_CMD_##cmd),			\
-- 
1.8.1.4

