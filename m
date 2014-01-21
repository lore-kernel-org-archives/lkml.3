Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaAUVYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:24:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:56161 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaAUVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
Subject: [PATCH 07/73] x86: replace __init_or_module with __init in non-modular vsmp_64.c
Date: Tue, 21 Jan 2014 16:22:10 -0500
Message-ID: <1390339396-3479-8-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __init_or_module is from commit 05e12e1c4c09cd35ac9f4e6af1e
("x86: fix 27-rc crash on vsmp due to paravirt during module load").

But as of commit 70511134f61bd6e5eed19f767381f9fb3e762d49
("Revert "x86: don't compile vsmp_64 for 32bit") this file
became obj-y and hence is now only for built-in.  That makes
any "_or_module" support no longer necessary.

We need to distinguish between the two in order to do some
header reorganization between init.h and module.h and we
don't want to be including module.h in non-modular code.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kernel/vsmp_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index 992f890..e72ec17 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -69,7 +69,7 @@ static void vsmp_irq_enable(void)
 }
 PV_CALLEE_SAVE_REGS_THUNK(vsmp_irq_enable);
 
-static unsigned __init_or_module vsmp_patch(u8 type, u16 clobbers, void *ibuf,
+static unsigned __init vsmp_patch(u8 type, u16 clobbers, void *ibuf,
 				  unsigned long addr, unsigned len)
 {
 	switch (type) {
-- 
1.8.4.1

