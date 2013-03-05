Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab3CEURY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 15:17:24 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:53508 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748Ab3CEURX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 15:17:23 -0500
Message-ID: <1362514637.16460.117.camel@x61.thuisdomein>
Subject: [PATCH v2] ARM: dove: drop "select COMMON_CLK_DOVE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Russell King <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Jean-Francois Moine <moinejf@free.fr>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Mar 2013 21:17:17 +0100
In-Reply-To: <51363A9E.6090507@gmail.com>
References: <1362476098.16460.65.camel@x61.thuisdomein>
	 <51363A9E.6090507@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Mar 2013 20:17:17.0143 (UTC) FILETIME=[6EB9D670:01CE19DE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 5b03df9ace680d7cdd34a69dfd85ca5f74159d18 ("ARM: dove: switch to
DT clock providers") added "select COMMON_CLK_DOVE" to Marvell Dove's
Kconfig entry. But there's no Kconfig symbol COMMON_CLK_DOVE, which
makes this select statement a nop. It's probably a leftover of some
experimental code that never hit mainline. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2: Sebastian suggested to drop this select entirely.

1) Still untested.

 arch/arm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5b71469..0c990b7 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -556,7 +556,6 @@ config ARCH_IXP4XX
 config ARCH_DOVE
 	bool "Marvell Dove"
 	select ARCH_REQUIRE_GPIOLIB
-	select COMMON_CLK_DOVE
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
-- 
1.7.11.7

