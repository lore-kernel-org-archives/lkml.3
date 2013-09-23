Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab3IWBYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:24:14 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:54812 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab3IWBYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:24:12 -0400
From: Felipe Pena <felipensp@gmail.com>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Kautuk Consul <consul.kautuk@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCHv2 1/1] arch/parisc: mm: fix uninitialized variable usage
Date: Sun, 22 Sep 2013 22:24:10 -0300
Message-Id: <1379899450-27552-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FAULT_FLAG_WRITE flag has been set based on uninitialized variable

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 arch/parisc/mm/fault.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/mm/fault.c b/arch/parisc/mm/fault.c
index d10d27a..00c0ed3 100644
--- a/arch/parisc/mm/fault.c
+++ b/arch/parisc/mm/fault.c
@@ -182,6 +182,9 @@ void do_page_fault(struct pt_regs *regs, unsigned long code,
 
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
+
+	acc_type = parisc_acctyp(code, regs->iir);
+
 	if (acc_type & VM_WRITE)
 		flags |= FAULT_FLAG_WRITE;
 retry:
@@ -196,8 +199,6 @@ retry:
 
 good_area:
 
-	acc_type = parisc_acctyp(code,regs->iir);
-
 	if ((vma->vm_flags & acc_type) != acc_type)
 		goto bad_area;
 
-- 
1.7.10.4

