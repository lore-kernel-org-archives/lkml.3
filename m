Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaFAVpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:45:54 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51043 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaFAVpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:45:53 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arch: ia64: kernel: smpboot.c:  Optimization of the Code
Date: Sun,  1 Jun 2014 23:46:45 +0200
Message-Id: <1401659205-17907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From what I know, AND is faster then modulo.
Not sure if this is worth changing though.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/ia64/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 547a48d..8d41119 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -237,7 +237,7 @@ get_delta (long *rt, long *master)
 
 	/* average best_t0 and best_t1 without overflow: */
 	tcenter = (best_t0/2 + best_t1/2);
-	if (best_t0 % 2 + best_t1 % 2 == 2)
+	if ((best_t0 & 1) + (best_t1 & 1) == 2)
 		++tcenter;
 	return tcenter - best_tm;
 }
-- 
1.7.10.4

