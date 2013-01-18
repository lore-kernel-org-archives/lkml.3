Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab3ARHQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:16:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62664 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3ARHQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:16:26 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ARM: shmobile: kzm9g: Don't use gic_handle_irq()
Date: Fri, 18 Jan 2013 08:16:13 +0100
Message-Id: <1358493373-28722-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358493373-28722-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358493373-28722-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:G4DznV0ZYqcnW/Ah1w3aZVuzW9LbrBY7nKUbumJAwDL
 uIPl5YevoIKICR55q6+UwdMc9zpp+0h6Mw5WHB7iVcMUaWmqCs
 HLWGds5+USWMkvplv7YzQkuUd5JNruzAknu90b6+Z7US/KKR8y
 kdeHMjeg7HdxcahwdOrX9FWXgVljjAFrNw/TAsWq7Marz5ZapK
 3uCq/TVfFBlTZT7ksntDi1D1mzw3YWIoxXTcugb7/Y02Mh+P7M
 p4+URIdNju605/OPZLUhGRlgNayKIhGH45fK1coo+TA1q3VNVb
 JjLXhakfWpidllS4pzYW/D1NLcA22st3Xtdf8oUfOySl7SfYZI
 JeuHxv5pNR6pmABWxkiTkRv6t912D/X/wxZF9q59xCl236NLbQ
 6Iyg73whoe2AfsJBV01GMQNsMpUfy8Xjt/1bnbzxRcoNsNbtre
 I0gff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is no longer publicly available. However, the sh73a0 setup
code now uses the generic irqchip infrastructure which will implicitly
set the IRQ handler, so it's fine to drop its initialization from the
machine definition.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
Changes in v2:
- new patch with kzm9g board changes

 arch/arm/mach-shmobile/board-kzm9g-reference.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/board-kzm9g-reference.c b/arch/arm/mach-shmobile/board-kzm9g-reference.c
index 04e9ae5..08c95dd 100644
--- a/arch/arm/mach-shmobile/board-kzm9g-reference.c
+++ b/arch/arm/mach-shmobile/board-kzm9g-reference.c
@@ -90,7 +90,6 @@ DT_MACHINE_START(KZM9G_DT, "kzm9g-reference")
 	.init_early	= sh73a0_add_early_devices_dt,
 	.nr_irqs	= NR_IRQS_LEGACY,
 	.init_irq	= sh73a0_init_irq_dt,
-	.handle_irq	= gic_handle_irq,
 	.init_machine	= kzm_init,
 	.init_late	= shmobile_init_late,
 	.init_time	= shmobile_timer_init,
-- 
1.8.1.1

