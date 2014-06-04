Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbaFDXXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaFDXXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 196/228] ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.
Date: Wed,  4 Jun 2014 16:23:45 -0700
Message-Id: <20140604232354.322453264@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lv Zheng <lv.zheng@intel.com>

commit 85dbd5801f62b66e2aa7826aaefcaebead44c8a6 upstream.

We need to find a smarter way to switch to 64-bit FADT addresses according
to the bug report.  This patch reverts Linux to the original behavior.

Fixes: 0249ed2444d6 (ACPICA: Add option to favor 32-bit FADT addresses.)
References: https://bugzilla.kernel.org/show_bug.cgi?id=74021
Reported-and-tested-by: Oswald Buddenhagen <ossi@kde.org>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/acglobal.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -132,9 +132,9 @@ u8 ACPI_INIT_GLOBAL(acpi_gbl_do_not_use_
  * address. Although ACPICA adheres to the ACPI specification which
  * requires the use of the corresponding 64-bit address if it is non-zero,
  * some machines have been found to have a corrupted non-zero 64-bit
- * address. Default is FALSE, do not favor the 32-bit addresses.
+ * address. Default is TRUE, favor the 32-bit addresses.
  */
-u8 ACPI_INIT_GLOBAL(acpi_gbl_use32_bit_fadt_addresses, FALSE);
+u8 ACPI_INIT_GLOBAL(acpi_gbl_use32_bit_fadt_addresses, TRUE);
 
 /*
  * Optionally truncate I/O addresses to 16 bits. Provides compatibility


