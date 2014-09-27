Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaI0GZy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 02:25:54 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38222 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750949AbaI0GZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 02:25:53 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Cc: linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] s390: remove unused Kconfig params
Date: Sat, 27 Sep 2014 08:25:30 +0200
Message-Id: <1411799130-17875-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the below Kconfig parameters, which are no longer
used anywhere in the source code and Makefiles:

HAVE_MARCH_Z900_FEATURES
HAVE_MARCH_Z990_FEATURES

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/s390/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 05c78bb5f570..d8085a9e9ebd 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -156,16 +156,8 @@ source "kernel/Kconfig.freezer"
 
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
@@ -192,7 +184,6 @@ config MARCH_G5
 
 config MARCH_Z900
 	bool "IBM zSeries model z800 and z900"
-	select HAVE_MARCH_Z900_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for model z800/z900 (2064 and
 	  2066 series). This will enable some optimizations that are not
@@ -200,7 +191,6 @@ config MARCH_Z900
 
 config MARCH_Z990
 	bool "IBM zSeries model z890 and z990"
-	select HAVE_MARCH_Z990_FEATURES if 64BIT
 	help
 	  Select this to enable optimizations for model z890/z990 (2084 and
 	  2086 series). The kernel will be slightly faster but will not work
-- 
1.9.1

