Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaFRPFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:05:51 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58049 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656AbaFRPFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:05:49 -0400
Message-ID: <1403103947.1984.124.camel@x220>
Subject: [PATCH] staging: Remove useless "default N" lines
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martin Walch <walch.martin@web.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Wed, 18 Jun 2014 17:05:47 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Jun 2014 15:05:48.0068 (UTC) FILETIME=[C951CE40:01CF8B06]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two Kconfig entries default to (uppercase) "N". It was clearly intended
to use "default n". But since (lowercase) "n" is the default anyway,
these lines might as well be removed.

Reported-by: Martin Walch <walch.martin@web.de>
Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "make menuconfig"and "make oldconfig". I think Martin's
report predates one of these two lines, but that's a detail.

 drivers/staging/rtl8192ee/Kconfig | 1 -
 drivers/staging/rtl8821ae/Kconfig | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8192ee/Kconfig b/drivers/staging/rtl8192ee/Kconfig
index beb07ac24e80..8d77f28399d3 100644
--- a/drivers/staging/rtl8192ee/Kconfig
+++ b/drivers/staging/rtl8192ee/Kconfig
@@ -7,7 +7,6 @@ config R8192EE
 	select EEPROM_93CX6
 	select CRYPTO
 	select FW_LOADER
-	default N
 	---help---
 	This is the driver for Realtek RTL8192EE 802.11 PCIe
 	wireless network adapters.
diff --git a/drivers/staging/rtl8821ae/Kconfig b/drivers/staging/rtl8821ae/Kconfig
index abccc9dabd65..1a89b25647ed 100644
--- a/drivers/staging/rtl8821ae/Kconfig
+++ b/drivers/staging/rtl8821ae/Kconfig
@@ -6,6 +6,5 @@ config R8821AE
 	select WEXT_PRIV
 	select EEPROM_93CX6
 	select CRYPTO
-	default N
 	---help---
 	  If built as a module, it will be called r8821ae.ko.
-- 
1.9.3

