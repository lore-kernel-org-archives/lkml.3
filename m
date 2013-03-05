Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3CEJfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:35:07 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:56120 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752148Ab3CEJfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:35:04 -0500
Message-ID: <1362476098.16460.65.camel@x61.thuisdomein>
Subject: [PATCH] ARM: dove: Fix typo "COMMON_CLK_DOVE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 10:34:58 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 09:34:59.0467 (UTC) FILETIME=[B47B25B0:01CE1984]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5b03df9ace680d7cdd34a69dfd85ca5f74159d18 ("ARM: dove: switch to
DT clock providers") added "select COMMON_CLK_DOVE" to Marvell Dove's
Kconfig entry. But there's no Kconfig symbol COMMON_CLK_DOVE, which
makes this select statement a nop. Since the Marvell Dove code includes
<linux/clk-provider.h> we can assume that this entry needs to select
COMMON_CLK instead.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b71469..31acce7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -556,7 +556,7 @@ config ARCH_IXP4XX
 config ARCH_DOVE
 	bool "Marvell Dove"
 	select ARCH_REQUIRE_GPIOLIB
-	select COMMON_CLK_DOVE
+	select COMMON_CLK
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
-- 
1.7.11.7

