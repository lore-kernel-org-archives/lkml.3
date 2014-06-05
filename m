Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaFETSE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 15:18:04 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44422 "EHLO
	new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbaFETSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 15:18:00 -0400
X-Sasl-enc: NOJhOx8tgdUNNuKl1LtLf6okXS3FuT4fHUQbSKsx11zc 1401995487
From: Andrew Ruder <andrew.ruder@elecsyscorp.com>
To: linux-arm-kernel@lists.infradead.org
Cc: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org,
        Andrew Ruder <andrew.ruder@elecsyscorp.com>
Subject: [PATCH] arm: pxa: call debug_ll_io_init for earlyprintk
Date: Thu,  5 Jun 2014 14:10:57 -0500
Message-Id: <1401995457-24721-2-git-send-email-andrew.ruder@elecsyscorp.com>
X-Mailer: git-send-email 1.9.0.rc3.12.gbc97e2d
In-Reply-To: <1401995457-24721-1-git-send-email-andrew.ruder@elecsyscorp.com>
References: <1401995457-24721-1-git-send-email-andrew.ruder@elecsyscorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is already done automatically for many other ARM platforms by the
ARM core code, but since pxa is using the .map_io callback, it needs to
call it explicitely for earlyprintk support.

Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
---
 arch/arm/mach-pxa/generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 4225417..94f49c2 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -93,5 +93,6 @@ static struct map_desc common_io_desc[] __initdata = {
 
 void __init pxa_map_io(void)
 {
+	debug_ll_io_init();
 	iotable_init(ARRAY_AND_SIZE(common_io_desc));
 }
-- 
1.9.0.rc3.12.gbc97e2d

