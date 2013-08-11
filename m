Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3HKQws (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:52:48 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:4795 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551Ab3HKQwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:12 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717959"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Jason Cooper <jason@lakedaemon.net>
Cc: kernel-janitors@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 15/16] arch/arm/mach-kirkwood: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:56 +0200
Message-Id: <1376239917-15594-16-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
arity of the called function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,f;
@@

f(...,
- ARRAY_AND_SIZE(e)
+ e,ARRAY_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 arch/arm/mach-kirkwood/openrd-setup.c    |    3 ++-
 arch/arm/mach-kirkwood/rd88f6281-setup.c |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-kirkwood/openrd-setup.c b/arch/arm/mach-kirkwood/openrd-setup.c
index 6a6eb54..e5cf841 100644
--- a/arch/arm/mach-kirkwood/openrd-setup.c
+++ b/arch/arm/mach-kirkwood/openrd-setup.c
@@ -158,7 +158,8 @@ static void __init openrd_init(void)
 	kirkwood_mpp_conf(openrd_mpp_config);
 
 	kirkwood_uart0_init();
-	kirkwood_nand_init(ARRAY_AND_SIZE(openrd_nand_parts), 25);
+	kirkwood_nand_init(openrd_nand_parts, ARRAY_SIZE(openrd_nand_parts),
+			   25);
 
 	kirkwood_ehci_init();
 
diff --git a/arch/arm/mach-kirkwood/rd88f6281-setup.c b/arch/arm/mach-kirkwood/rd88f6281-setup.c
index d242231..5154bd2 100644
--- a/arch/arm/mach-kirkwood/rd88f6281-setup.c
+++ b/arch/arm/mach-kirkwood/rd88f6281-setup.c
@@ -87,7 +87,9 @@ static void __init rd88f6281_init(void)
 	kirkwood_init();
 	kirkwood_mpp_conf(rd88f6281_mpp_config);
 
-	kirkwood_nand_init(ARRAY_AND_SIZE(rd88f6281_nand_parts), 25);
+	kirkwood_nand_init(rd88f6281_nand_parts,
+			   ARRAY_SIZE(rd88f6281_nand_parts),
+			   25);
 	kirkwood_ehci_init();
 
 	kirkwood_ge00_init(&rd88f6281_ge00_data);

