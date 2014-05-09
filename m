Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072AbaEIB3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 21:29:35 -0400
Received: from mail.anarazel.de ([217.115.131.40]:33628 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbaEIB3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 21:29:34 -0400
From: Andres Freund <andres@anarazel.de>
To: Borislav Petkov <bp@suse.de>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] x86: Fix typo preventing msr_set/clear_bit from having an effect
Date: Fri,  9 May 2014 03:29:16 +0200
Message-Id: <1399598957-7011-2-git-send-email-andres@anarazel.de>
X-Mailer: git-send-email 2.0.0.rc2.4.g1dc51c6.dirty
In-Reply-To: <1399598957-7011-1-git-send-email-andres@anarazel.de>
References: <1399598957-7011-1-git-send-email-andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to a typo the msr accessor function introduced in
22085a66c2fab6cf9b9393c056a3600a6b4735de didn't have any lasting
effects because they accidentally wrote the old value back.

After c0a639ad0bc6b178b46996bd1f821a04643e2bde this at the very least
this causes cpuid limits not to be lifted on some cpus leading to
missing capabilities for those.

Signed-off-by: Andres Freund <andres@anarazel.de>
Cc: Borislav Petkov <bp@suse.de>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/lib/msr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/lib/msr.c b/arch/x86/lib/msr.c
index db9db44..4362373 100644
--- a/arch/x86/lib/msr.c
+++ b/arch/x86/lib/msr.c
@@ -76,7 +76,7 @@ static inline int __flip_bit(u32 msr, u8 bit, bool set)
 	if (m1.q == m.q)
 		return 0;
 
-	err = msr_write(msr, &m);
+	err = msr_write(msr, &m1);
 	if (err)
 		return err;
 
-- 
2.0.0.rc2.4.g1dc51c6.dirty

