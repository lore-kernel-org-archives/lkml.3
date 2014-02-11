Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaBKMbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:31:35 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:64031 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751347AbaBKMbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:31:34 -0500
Message-ID: <1392121892.13064.9.camel@x220>
Subject: [PATCH] staging: r8188eu: default to "y" in Kconfig
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martin Walch <walch.martin@web.de>, Richard Weinberger <richard@nod.at>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 13:31:32 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 12:31:32.0603 (UTC) FILETIME=[322BACB0:01CF2725]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two Kconfig entries for this driver default to (uppercase) "Y". But in
Kconfig (lowercase) "y" is a magic symbol. "Y" is an ordinary symbol.
As "Y" is never set these Kconfig symbols will also not be set by
default.

So use "default y" here, as was clearly intended.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This patch will enable code that used to be disabled. Since this is in
staging, that should be OK. This might also uncover warnings or errors.
I didn't test it, anyhow.

This patch also deserves a
    Reported-by: Martin Walch <walch.martin@web.de>

line, but that apparently requires Martin's permission.

 drivers/staging/rtl8188eu/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/Kconfig b/drivers/staging/rtl8188eu/Kconfig
index c9c548f..9a57d31 100644
--- a/drivers/staging/rtl8188eu/Kconfig
+++ b/drivers/staging/rtl8188eu/Kconfig
@@ -12,7 +12,7 @@ if R8188EU
 
 config 88EU_AP_MODE
 	bool "Realtek RTL8188EU AP mode"
-	default Y
+	default y
 	---help---
 	This option enables Access Point mode. Unless you know that your system
 	will never be used as an AP, or the target system has limited memory,
@@ -20,7 +20,7 @@ config 88EU_AP_MODE
 
 config 88EU_P2P
 	bool "Realtek RTL8188EU Peer-to-peer mode"
-	default Y
+	default y
 	---help---
 	This option enables peer-to-peer mode for the r8188eu driver. Unless you
 	know that peer-to-peer (P2P) mode will never be used, or the target system has
-- 
1.8.5.3

