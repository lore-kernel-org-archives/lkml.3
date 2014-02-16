Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbaBPRIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 12:08:09 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54882 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643AbaBPRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 12:08:08 -0500
Message-ID: <1392570485.28866.10.camel@x220>
Subject: [PATCH] acpi: Remove Kconfig symbol ACPI_PROCFS
From: Paul Bolle <pebolle@tiscali.nl>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 18:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 17:08:06.0022 (UTC) FILETIME=[A8AF3A60:01CF2B39]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing cares about ACPI_PROCFS. This has been the case since v2.6.38.
This Kconfig symbol serves no purpose and its help text is now
misleading. It can safely be removed. If this symbol would be needed
again in the future it can be readded in a commit that adds code that
actually uses it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only.

Michael Opdenacker did a previous attempt in
https://lkml.org/lkml/2013/10/27/15 . That patch that needed some
context changes, so I redid it. I also wrote a new commit explanation.
It also addresses the reasons not to accept Michael's patch.

 drivers/acpi/Kconfig | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 4770de5..436111b 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -43,19 +43,6 @@ config ACPI_SLEEP
 	depends on SUSPEND || HIBERNATION
 	default y
 
-config ACPI_PROCFS
-	bool "Deprecated /proc/acpi files"
-	depends on PROC_FS
-	help
-	  For backwards compatibility, this option allows
-	  deprecated /proc/acpi/ files to exist, even when
-	  they have been replaced by functions in /sys.
-
-	  This option has no effect on /proc/acpi/ files
-	  and functions which do not yet exist in /sys.
-
-	  Say N to delete /proc/acpi/ files that have moved to /sys/
-
 config ACPI_EC_DEBUGFS
 	tristate "EC read/write access through /sys/kernel/debug/ec"
 	default n
-- 
1.8.5.3

