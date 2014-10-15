Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaJORGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 13:06:09 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:56385 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaJORGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 13:06:05 -0400
Subject: [PATCH v1 03/10] MIPS: CPC: Make mips_cpc_phys_base() static
To: Jason Wessel <jason.wessel@windriver.com>,
        Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>, Eric Paris <eparis@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 15 Oct 2014 11:06:02 -0600
Message-ID: <20141015170602.4063.5577.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20141015165957.4063.66741.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's only one implementation of mips_cpc_phys_base(), and it's only used
within the same file, so it doesn't need to be weak, and it doesn't need an
extern declaration.

Remove the extern mips_cpc_phys_base() declaration and make it static.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-mips@linux-mips.org
---
 arch/mips/include/asm/mips-cpc.h |   10 ----------
 arch/mips/kernel/mips-cpc.c      |    2 +-
 2 files changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/mips/include/asm/mips-cpc.h b/arch/mips/include/asm/mips-cpc.h
index e139a534e0fd..8ff92cd74bde 100644
--- a/arch/mips/include/asm/mips-cpc.h
+++ b/arch/mips/include/asm/mips-cpc.h
@@ -28,16 +28,6 @@ extern void __iomem *mips_cpc_base;
 extern phys_t mips_cpc_default_phys_base(void);
 
 /**
- * mips_cpc_phys_base - retrieve the physical base address of the CPC
- *
- * This function returns the physical base address of the Cluster Power
- * Controller memory mapped registers, or 0 if no Cluster Power Controller
- * is present. It may be overriden by individual platforms which determine
- * this address in a different way.
- */
-extern phys_t __weak mips_cpc_phys_base(void);
-
-/**
  * mips_cpc_probe - probe for a Cluster Power Controller
  *
  * Attempt to detect the presence of a Cluster Power Controller. Returns 0 if
diff --git a/arch/mips/kernel/mips-cpc.c b/arch/mips/kernel/mips-cpc.c
index ba473608a347..36c20ae509d8 100644
--- a/arch/mips/kernel/mips-cpc.c
+++ b/arch/mips/kernel/mips-cpc.c
@@ -21,7 +21,7 @@ static DEFINE_PER_CPU_ALIGNED(spinlock_t, cpc_core_lock);
 
 static DEFINE_PER_CPU_ALIGNED(unsigned long, cpc_core_lock_flags);
 
-phys_t __weak mips_cpc_phys_base(void)
+static phys_t mips_cpc_phys_base(void)
 {
 	u32 cpc_base;
 

