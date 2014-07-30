Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaG3EUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:20:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:53224 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbaG3EUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="551067812"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 01/17] ACPICA: Work around an ancient GCC bug.
Date: Wed, 30 Jul 2014 12:20:26 +0800
Message-Id: <241406a9c052e09c383b26eded49497a3749ae52.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

warning: cast from function call of type 'char *' to non-matching type 'long unsigned int'

Since acpi_ut_format_number() hasn't been enabled for the Linux kernel,
this patch doesn't affect the Linux kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/utprint.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpica/utprint.c b/drivers/acpi/acpica/utprint.c
index 1031164..080e22a 100644
--- a/drivers/acpi/acpica/utprint.c
+++ b/drivers/acpi/acpica/utprint.c
@@ -242,6 +242,7 @@ static char *acpi_ut_format_number(char *string,
 				   u64 number,
 				   u8 base, s32 width, s32 precision, u8 type)
 {
+	char *pos;
 	char sign;
 	char zero;
 	u8 need_prefix;
@@ -289,9 +290,8 @@ static char *acpi_ut_format_number(char *string,
 
 	/* Generate full string in reverse order */
 
-	i = ACPI_PTR_DIFF(acpi_ut_put_number
-			  (reversed_string, number, base, upper),
-			  reversed_string);
+	pos = acpi_ut_put_number(reversed_string, number, base, upper);
+	i = ACPI_PTR_DIFF(pos, reversed_string);
 
 	/* Printing 100 using %2d gives "100", not "00" */
 
-- 
1.7.10

