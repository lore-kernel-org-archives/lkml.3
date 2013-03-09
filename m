Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab3CITIJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 14:08:09 -0500
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:53536 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881Ab3CITII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 14:08:08 -0500
Message-ID: <1362856081.3137.19.camel@x61.thuisdomein>
Subject: [PATCH] ARM: S3C24XX: drop "select MACH_NEO1973"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 09 Mar 2013 20:08:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Mar 2013 19:08:01.0697 (UTC) FILETIME=[6B8A1910:01CE1CF9]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for the Openmoko GTA02 / Freerunner phone selects
MACH_NEO1973. But there is no Kconfig symbol MACH_NEO1973. The select
statement for that symbol is a nop. It can safely be dropped.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "git grep".

1) There appear to be repositories that carry a "config MACH_NEO1973" in
their tree. I guess it is used to collect functionality common to the
GTA01 and the GTA02. But except for this select statement, MACH_NEO1973
was never used in mainline. So if the GTA01 code ever gets merged into
mainline, this select statement might be added once more (if it is
actually needed then).

 arch/arm/mach-s3c24xx/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 7361b9d..bec43fe 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -641,7 +641,6 @@ comment "S3C2442 Boards"
 config MACH_NEO1973_GTA02
 	bool "Openmoko GTA02 / Freerunner phone"
 	select I2C
-	select MACH_NEO1973
 	select MFD_PCF50633
 	select PCF50633_GPIO
 	select POWER_SUPPLY
-- 
1.7.11.7

