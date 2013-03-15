Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3COT5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 15:57:10 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:35164 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab3COT5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 15:57:08 -0400
From: Linn Crosetto <linn@hp.com>
To: rjw@sisk.pl, robert.moore@intel.com, ming.m.lin@intel.com,
        lv.zheng@intel.com, linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [PATCH] acpi: remove length check for large registers
Date: Fri, 15 Mar 2013 13:56:07 -0600
Message-Id: <1363377367-12813-1-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy bit width field in the Generic Address Structure is 1 byte,
limiting the reportable register width to 255 bits. Larger registers
will cause a length mismatch warning to be printed in
acpi_tb_validate_fadt().

To avoid the warning, disable the length mismatch check for registers
larger than 255 bits.

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 drivers/acpi/acpica/tbfadt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 74181bf..e87abcd 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -561,6 +561,7 @@ static void acpi_tb_validate_fadt(void)
 		 * legacy length field and the corresponding 64-bit X length field.
 		 */
 		if (address64->address &&
+		    ACPI_MUL_8(length) <= ACPI_UINT8_MAX &&
 		    (address64->bit_width != ACPI_MUL_8(length))) {
 			ACPI_BIOS_WARNING((AE_INFO,
 					   "32/64X length mismatch in FADT/%s: %u/%u",
-- 
1.7.11.3

