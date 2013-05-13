Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3EMKQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:16:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:41899 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3EMKQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:16:16 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Rob Herring <robherring2@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 2/4] ARM: highbank: remove the .map_io declaration
Date: Mon, 13 May 2013 12:16:07 +0200
Message-Id: <1368440169-29088-3-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the ARM core code calls debug_ll_io_init, we can remove it from
the machine_desc declaration.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/mach-highbank/highbank.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index e7df2dd..dc5d6be 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -176,7 +176,6 @@ static const char *highbank_match[] __initconst = {
 
 DT_MACHINE_START(HIGHBANK, "Highbank")
 	.smp		= smp_ops(highbank_smp_ops),
-	.map_io		= debug_ll_io_init,
 	.init_irq	= highbank_init_irq,
 	.init_time	= highbank_timer_init,
 	.init_machine	= highbank_init,
-- 
1.8.1.2

