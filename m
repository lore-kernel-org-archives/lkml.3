Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaJFKcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 06:32:14 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:57786 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbaJFKcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 06:32:13 -0400
Message-ID: <1412591531.4054.67.camel@x220>
Subject: [PATCH] [TRIVIAL] IBM Akebono: Remove obsolete config select
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Date: Mon, 06 Oct 2014 12:32:11 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2014 10:32:11.0949 (UTC) FILETIME=[C9FD55D0:01CFE150]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alistair Popple <alistair@popple.id.au>

The original implementation of MMC support for Akebono introduced a
new configuration symbol (MMC_SDHCI_OF_476GTR). This symbol has been
dropped in favour of using the generic platform driver however the
select for this symbol was mistakenly left in the platform
configuration.

This patch removes the obsolete symbol selection.

Signed-off-by: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Another triviality that's taking some time to fix. See the thread
starting at http://lkml.kernel.org/r/1398936447.4121.12.camel@x220 for
some background. Perhaps we can speed things up a bit by using trivial
(and inflate the count of commits I handled while we're at it).

Jiri, could you please queue this?

Tested (on my side) with "git grep" only, on top of next-20141003.

 arch/powerpc/platforms/44x/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/platforms/44x/Kconfig b/arch/powerpc/platforms/44x/Kconfig
index 82f2da28cd27..d2ac1c116454 100644
--- a/arch/powerpc/platforms/44x/Kconfig
+++ b/arch/powerpc/platforms/44x/Kconfig
@@ -220,7 +220,6 @@ config AKEBONO
 	select USB_EHCI_HCD_PLATFORM if USB_EHCI_HCD
 	select MMC_SDHCI
 	select MMC_SDHCI_PLTFM
-	select MMC_SDHCI_OF_476GTR
 	select ATA
 	select SATA_AHCI_PLATFORM
 	help
-- 
1.9.3

