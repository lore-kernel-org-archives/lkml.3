Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbaBSWPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 17:15:24 -0500
Received: from top.free-electrons.com ([176.31.233.9]:53031 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754543AbaBSWPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 17:15:19 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>
Subject: [PATCH 2/2] ARM: mvebu: Allows to get the SoC ID even without PCI enabled
Date: Wed, 19 Feb 2014 23:14:56 +0100
Message-Id: <1392848096-17838-3-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1392848096-17838-1-git-send-email-gregory.clement@free-electrons.com>
References: <1392848096-17838-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address translation of a PCI node don't require anymore the PCI
support in the kernel. This translation is mandatory to be able to
read the SoC ID which is stored in the PCI controller of the mvebu
SoCs.

This patch selects the symbol needed to get only this translation for
all the mvebu platforms.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/mach-mvebu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index 5e269d7263ce..df9e7d270810 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -16,6 +16,7 @@ config ARCH_MVEBU
 	select ARCH_REQUIRE_GPIOLIB
 	select MIGHT_HAVE_PCI
 	select PCI_QUIRKS if PCI
+	select OF_ADDRESS_PCI
 
 if ARCH_MVEBU
 
-- 
1.8.1.2

