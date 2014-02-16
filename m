Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaBPRPa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:15:30 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:49967 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbaBPRP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:15:29 -0500
Message-ID: <1392570927.28866.12.camel@x220>
Subject: [PATCH] s390: remove HAVE_MARCH_Z9?0_FEATURES
From: Paul Bolle <pebolle@tiscali.nl>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 18:15:27 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 17:15:27.0865 (UTC) FILETIME=[B00B1E90:01CF2B3A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols HAVE_MARCH_Z900_FEATURES and
HAVE_MARCH_Z990_FEATURES were added in v3.5. They have never been used.
Apparently they are not needed. They can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested only with "git grep".

 arch/s390/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 65a0775..b853d0d 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -152,16 +152,8 @@ source "kernel/Kconfig.freezer"
 
 menu "Processor type and features"
 
-config HAVE_MARCH_Z900_FEATURES
-	def_bool n
-
-config HAVE_MARCH_Z990_FEATURES
-	def_bool n
-	select HAVE_MARCH_Z900_FEATURES
-
 config HAVE_MARCH_Z9_109_FEATURES
 	def_bool n
-	select HAVE_MARCH_Z990_FEATURES
 
 config HAVE_MARCH_Z10_FEATURES
 	def_bool n
@@ -188,7 +180,6 @@ config MARCH_G5
 
 config MARCH_Z900
 	bool "IBM zSeries model z800 and z900"
-	select HAVE_MARCH_Z900_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for model z800/z900 (2064 and
 	  2066 series). This will enable some optimizations that are not
@@ -196,7 +187,6 @@ config MARCH_Z900
 
 config MARCH_Z990
 	bool "IBM zSeries model z890 and z990"
-	select HAVE_MARCH_Z990_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for model z890/z990 (2084 and
 	  2086 series). The kernel will be slightly faster but will not work
-- 
1.8.5.3

