Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078AbaFCV3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 17:29:21 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41966 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060AbaFCV3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 17:29:18 -0400
From: Andrea Adami <andrea.adami@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Andrea Adami <andrea.adami@gmail.com>
Subject: [PATCH 1/2] arm: sa1100: collie: revert back to cfi_probe
Date: Tue,  3 Jun 2014 23:29:00 +0200
Message-Id: <1401830941-17086-2-git-send-email-andrea.adami@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401830941-17086-1-git-send-email-andrea.adami@gmail.com>
References: <1401830941-17086-1-git-send-email-andrea.adami@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverts commit d26b17edafc45187c30cae134a5e5429d58ad676
ARM: sa1100: collie.c: fall back to jedec_probe flash detection

Unfortunately the detection was challenged on the defective unit used for tests:
one of the NOR chips did not respond to the CFI query.
Moreover that bad device needed extra delays on erase-suspend/resume cycles.

Tested personally on 3 different units and with feedback of two other users.

Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
---
 arch/arm/mach-sa1100/collie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-sa1100/collie.c b/arch/arm/mach-sa1100/collie.c
index f9874ba..f26aeea 100644
--- a/arch/arm/mach-sa1100/collie.c
+++ b/arch/arm/mach-sa1100/collie.c
@@ -356,7 +356,7 @@ static void collie_flash_exit(void)
 }
 
 static struct flash_platform_data collie_flash_data = {
-	.map_name	= "jedec_probe",
+	.map_name	= "cfi_probe",
 	.init		= collie_flash_init,
 	.set_vpp	= collie_set_vpp,
 	.exit		= collie_flash_exit,
-- 
1.9.1

