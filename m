Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab3GZNGn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:06:43 -0400
Received: from mail-gg0-f178.google.com ([209.85.161.178]:51932 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab3GZNGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:06:40 -0400
Date: Fri, 26 Jul 2013 09:06:35 -0400
From: "tj@kernel.org" <tj@kernel.org>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Zhu Richard-R65037 <r65037@freescale.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: [PATCH] ahci_imx: depend on CONFIG_MFD_SYSCON
Message-ID: <20130726130635.GB3013@htj.dyndns.org>
References: <20130725151253.8b9b53b3a3cf6cacd501dc54@canb.auug.org.au>
 <51F16F17.4030002@infradead.org>
 <0E83723C55F66F43A6041464FE31119D3487F2@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130726040349.GA29268@S2101-09.ap.freescale.net>
 <0E83723C55F66F43A6041464FE31119D34886A@039-SN2MPN1-011.039d.mgd.msft.net>
 <20130726052519.GB29268@S2101-09.ap.freescale.net>
 <20130726111850.GD30786@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130726111850.GD30786@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 867974fc09f93bdd7f98d46ac3733934486bbf4a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 26 Jul 2013 08:57:56 -0400

ahci_imx makes use of regmap but the dependency wasn't specified in
Kconfig leading build failures if CONFIG_AHCI_IMX is enabled but
CONFIG_MFD_SYSCON is not.  Add the Kconfig dependency.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
Applied to libata/for-3.11-fixes.

Thanks.

 drivers/ata/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index a4af0a2..4e73772 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -99,7 +99,7 @@ config SATA_AHCI_PLATFORM
 
 config AHCI_IMX
 	tristate "Freescale i.MX AHCI SATA support"
-	depends on SATA_AHCI_PLATFORM
+	depends on SATA_AHCI_PLATFORM && MFD_SYSCON
 	help
 	  This option enables support for the Freescale i.MX SoC's
 	  onboard AHCI SATA.
-- 
1.8.3.1

