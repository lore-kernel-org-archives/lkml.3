Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaIWIIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 04:08:55 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:56931 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238AbaIWIIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 04:08:53 -0400
Message-ID: <1411459730.20236.6.camel@x220>
Subject: [PATCH] ARM: shmobile: Remove ARCH_HAS_OPP completely
From: Paul Bolle <pebolle@tiscali.nl>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 23 Sep 2014 10:08:50 +0200
In-Reply-To: <20140916002333.GI9847@verge.net.au>
References: <1406551632.5397.17.camel@x220> <1410511111.31130.4.camel@x220>
	 <20140916000916.GD9847@verge.net.au> <20140916002333.GI9847@verge.net.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2014 08:08:51.0087 (UTC) FILETIME=[9C1B31F0:01CFD705]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol ARCH_HAS_OPP became redundant in v3.16: commit
049d595a4db3 ("PM / OPP: Make OPP invisible to users in Kconfig")
removed the only dependency that used it. Setting it had no effect
anymore.

So commit 78c5e0bb145d ("PM / OPP: Remove ARCH_HAS_OPP") removed it. For
some reason that commit did not remove all select statements for that
symbol. These statements are now useless. Remove one from shmobile too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Sent previously as part of the treewide patch "PM / OPP: Remove
ARCH_HAS_OPP completely". But it turns out the changes for omap2 are
already queued in omap-for-v3.18/soc (but not in linux-next!). Besides,
Simon Horman wanted the shmobile change split off.

Done on top of next-20140922. Tested by grepping the tree. 

 arch/arm/mach-shmobile/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index 21f457b56c01..f59019dd986e 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -36,7 +36,6 @@ menuconfig ARCH_SHMOBILE_MULTI
 	select NO_IOPORT_MAP
 	select PINCTRL
 	select ARCH_REQUIRE_GPIOLIB
-	select ARCH_HAS_OPP
 
 if ARCH_SHMOBILE_MULTI
 
-- 
1.9.3

