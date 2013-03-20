Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab3CTLNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 07:13:35 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55735 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab3CTLNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 07:13:33 -0400
Message-ID: <1363778011.1390.96.camel@x61.thuisdomein>
Subject: [PATCH] S3C24XX: remove unneeded "config SMDK2440_CPU2442"
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 12:13:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2013 11:13:31.0857 (UTC) FILETIME=[F4BC8410:01CE255B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for SMDK2440_CPU2442 was moved from one Kconfig file
to another in commit acf2d41d8595829eb0ac7bf6891f4875a78d4d6e ("ARM:
S3C24XX: Move mach-s3c2440/ pll into mach-s3c24xx/"). In that move it
also lost its statement to select CPU_S3C2442. That was not needed
anymore because it now depended on that same symbol.

But without its select this entry became a nop: enabling it has no
effect, as it changes no code. It can safely be removed.

Fix a related, and trivial, comment typo too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/mach-s3c24xx/Kconfig | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 37f513d..92c07a2 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -663,10 +663,7 @@ config MACH_RX1950
 	help
 	   Say Y here if you're using HP iPAQ rx1950
 
-config SMDK2440_CPU2442
-	bool "SMDM2440 with S3C2442 CPU module"
-
-endif	# CPU_S3C2440
+endif	# CPU_S3C2442
 
 if CPU_S3C2443 || CPU_S3C2416
 
-- 
1.7.11.7

