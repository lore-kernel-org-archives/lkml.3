Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685AbaD3CEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:04:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:49109 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbaD3CEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:04:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="523496346"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 07/27] ACPICA: Add support for _LPD and _PRP methods.
Date: Wed, 30 Apr 2014 10:04:13 +0800
Message-Id: <0cf67a729b761df5293d6f31f99febf14d8509dc.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This patch currently only affects acpihelp and iASL which are not shipped
in the Linux kernel.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acpredef.h |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/acpica/acpredef.h b/drivers/acpi/acpica/acpredef.h
index a48d713..34001a9 100644
--- a/drivers/acpi/acpica/acpredef.h
+++ b/drivers/acpi/acpica/acpredef.h
@@ -586,6 +586,10 @@ const union acpi_predefined_info acpi_gbl_predefined_methods[] = {
 	{{"_LID", METHOD_0ARGS,
 	  METHOD_RETURNS(ACPI_RTYPE_INTEGER)}},
 
+	{{"_LPD", METHOD_0ARGS,
+	  METHOD_RETURNS(ACPI_RTYPE_PACKAGE)}},	/* Variable-length (1 Int(rev), n Pkg (2 Int) */
+	PACKAGE_INFO(ACPI_PTYPE2_REV_FIXED, ACPI_RTYPE_INTEGER, 2, 0, 0, 0),
+
 	{{"_MAT", METHOD_0ARGS,
 	  METHOD_RETURNS(ACPI_RTYPE_BUFFER)}},
 
-- 
1.7.10

