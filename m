Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaFAVmu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:42:50 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:44308 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbaFAVms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:42:48 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: ia64: kernel: palinfo.c:  Optimization of the Code
Date: Sun,  1 Jun 2014 23:43:39 +0200
Message-Id: <1401659019-17586-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From what I know, AND is faster then modulo.
Not sure if this is worth changing though.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/ia64/kernel/palinfo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/palinfo.c b/arch/ia64/kernel/palinfo.c
index c39c3cd..7915b02 100644
--- a/arch/ia64/kernel/palinfo.c
+++ b/arch/ia64/kernel/palinfo.c
@@ -156,7 +156,8 @@ static void bitregister_process(struct seq_file *m, u64 *reg_info, int max)
 
 	for(; i < max; i++ ) {
 
-		if (i != 0 && (i%64) == 0) value = *++reg_info;
+		if (i != 0 && (i&63) == 0)
+			value = *++reg_info;
 
 		if ((value & 0x1) == 0 && skip == 0) {
 			if (begin  <= i - 2)
-- 
1.7.10.4

