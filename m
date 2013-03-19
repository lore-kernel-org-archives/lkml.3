Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab3CSKlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:41:08 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:53271 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750708Ab3CSKlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:41:06 -0400
Message-ID: <1363689661.1390.9.camel@x61.thuisdomein>
Subject: [PATCH] ACPI: remove "config ACPI_DEBUG_FUNC_TRACE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 11:41:01 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Mar 2013 10:41:01.0704 (UTC) FILETIME=[3FF10880:01CE248E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig symbol ACPI_DEBUG_FUNC_TRACE was only used (through its
corresponding macro) in drivers/acpi/acpica/acmacros.h. That macro was
removed from that header in v3.8, with commit
86ff0e508f88eda6e479a897476026055831d2d8 ("ACPICA: Fix unmerged
acmacros.h divergences."). That commit did not explain why that macro
was removed. But it seems that ACPI_DEBUG_FUNC_TRACE can now be removed
too, as it is unused.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested.

 drivers/acpi/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 92ed969..006b714 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -298,14 +298,6 @@ config ACPI_DEBUG
 	  Documentation/kernel-parameters.txt to control the type and
 	  amount of debug output.
 
-config ACPI_DEBUG_FUNC_TRACE
-	bool "Additionally enable ACPI function tracing"
-	default n
-	depends on ACPI_DEBUG
-	help
-	  ACPI Debug Statements slow down ACPI processing. Function trace
-	  is about half of the penalty and is rarely useful.
-
 config ACPI_PCI_SLOT
 	bool "PCI slot detection driver"
 	depends on SYSFS
-- 
1.7.11.7

