Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbaEMIvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:51:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:64604 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759058AbaEMIvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:51:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1042,1389772800"; 
   d="scan'208";a="539478291"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH] Tables: Restore old behavor to favor 32-bit FADT addresses.
Date: Tue, 13 May 2014 16:50:30 +0800
Message-Id: <6018e562465c35d11cf98f181baedf3b8483e812.1399970899.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <38907770.bupFXhytsS@vostro.rjw.lan>
References: <38907770.bupFXhytsS@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to find a smarter way to switch to 64-bit FADT addresses according
to the bug report.  This patch reverts Linux to the original behavior.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=74021
Reported-by: Oswald Buddenhagen <ossi@kde.org>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Oswald Buddenhagen <ossi@kde.org>
Cc: <stable@vger.kernel.org> # 3.14.x: 0249ed24: ACPICA: Add option to favor 32-bit FADT addresses
---
 include/acpi/acpixf.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 4e3044c..b66b6a8 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -190,7 +190,7 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt, FALSE);
  * some machines have been found to have a corrupted non-zero 64-bit
  * address. Default is FALSE, do not favor the 32-bit addresses.
  */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, FALSE);
+ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, TRUE);
 
 /*
  * Optionally truncate I/O addresses to 16 bits. Provides compatibility
-- 
1.7.10

