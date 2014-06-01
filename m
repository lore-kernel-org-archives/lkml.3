Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaFAVr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:47:28 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64766 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbaFAVr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:47:26 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "David S. Miller" <davem@davemloft.net>, Kirill Tkhai <tkhai@yandex.ru>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: sparc: kernel: smp_64.c:  Optimization of the Code
Date: Sun,  1 Jun 2014 23:48:18 +0200
Message-Id: <1401659298-18067-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From what I know, AND is faster then modulo.
Not sure if this is worth changing though.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/sparc/kernel/smp_64.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/smp_64.c b/arch/sparc/kernel/smp_64.c
index 745a363..921d924 100644
--- a/arch/sparc/kernel/smp_64.c
+++ b/arch/sparc/kernel/smp_64.c
@@ -179,7 +179,7 @@ static inline long get_delta (long *rt, long *master)
 
 	/* average best_t0 and best_t1 without overflow: */
 	tcenter = (best_t0/2 + best_t1/2);
-	if (best_t0 % 2 + best_t1 % 2 == 2)
+	if ((best_t0 & 1) + (best_t1 & 1) == 2)
 		tcenter++;
 	return tcenter - best_tm;
 }
-- 
1.7.10.4

