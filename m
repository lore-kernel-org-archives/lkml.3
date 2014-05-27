Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaE0R3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:29:22 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63548 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaE0R3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:29:18 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Oswald Buddenhagen <ossi@kde.org>
Subject: [RFC PATCH 6/6] ACPICA: Tables: Enable default 64-bit FADT addresses favor.
Date: Wed, 28 May 2014 01:29:08 +0800
Message-Id: <815bd8a45e4bd1d78e0ed605f6f542e22c277da6.1401210685.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1401210684.git.lv.zheng@intel.com>
References: <38907770.bupFXhytsS@vostro.rjw.lan> <cover.1401210684.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

With enough protections, this patch re-enables 64-bit FADT addresses by
default. If regressions are reported against such change, this patch should
be bisected and reverted.
Note that 64-bit FACS favor and 64-bit firmware waking vector favor are
excluded by this commit in order not to break OSPMs. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Oswald Buddenhagen <ossi@kde.org>
---
 include/acpi/acpixf.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 0f79659..6a9100a 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -188,9 +188,9 @@ ACPI_INIT_GLOBAL(u8, acpi_gbl_do_not_use_xsdt, FALSE);
  * address. Although ACPICA adheres to the ACPI specification which
  * requires the use of the corresponding 64-bit address if it is non-zero,
  * some machines have been found to have a corrupted non-zero 64-bit
- * address. Default is TRUE, favor the 32-bit addresses.
+ * address. Default is FALSE, do not favor the 32-bit addresses.
  */
-ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, TRUE);
+ACPI_INIT_GLOBAL(u8, acpi_gbl_use32_bit_fadt_addresses, FALSE);
 
 /*
  * Optionally use 32-bit FACS table addresses.
-- 
1.7.10

