Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209AbaAWKjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:39:52 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44214 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbaAWKju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:39:50 -0500
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: gregkh@linuxfoundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] firmware/google: drop 'select EFI' to avoid recursive dependency
Date: Thu, 23 Jan 2014 11:39:48 +0100
Message-Id: <1390473588-23367-1-git-send-email-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GOOGLE_SMI Kconfig symbol depends on DMI and selects EFI. This
causes problems on other archs when introducing DMI support that
depends on EFI, as it results in a recursive dependency:

arch/arm/Kconfig:1845:error: recursive dependency detected!
arch/arm/Kconfig:1845:	symbol DMI depends on EFI

Fix by changing the 'select EFI' to a 'depends on EFI'.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/google/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 2f21b0bfe653..29c8cdda82a1 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -12,8 +12,7 @@ menu "Google Firmware Drivers"
 
 config GOOGLE_SMI
 	tristate "SMI interface for Google platforms"
-	depends on ACPI && DMI
-	select EFI
+	depends on ACPI && DMI && EFI
 	select EFI_VARS
 	help
 	  Say Y here if you want to enable SMI callbacks for Google
-- 
1.8.3.2

