Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab3LQJWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:22:50 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:33205 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3LQJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:22:47 -0500
Date: Tue, 17 Dec 2013 14:51:55 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        josh@joshtriplett.org, devel@acpica.org
Subject: [PATCH 05/11] drivers: acpi: Include appropriate header file in
 utstate.c
Message-ID: <c8f6f6fbcd7de593a726d091f5d0f6a245f6e0f7.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file acutils.h in acpica/utstate.c because
function acpi_ut_create_pkg_state_and_push() has its prototype declaration
in acutils.h. Also, encloses the function in acpica/utstate.c in ifdef
condition of ACPI_FUTURE_USAGE.

This eliminates the following warning in utstate.c:
drivers/acpi/acpica/utstate.c:64:1: warning: no previous prototype for ‘acpi_ut_create_pkg_state_and_push’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/acpica/utstate.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpica/utstate.c b/drivers/acpi/acpica/utstate.c
index 03c4c2f..0920d23 100644
--- a/drivers/acpi/acpica/utstate.c
+++ b/drivers/acpi/acpica/utstate.c
@@ -43,6 +43,7 @@
 
 #include <acpi/acpi.h>
 #include "accommon.h"
+#include "acutils.h"
 
 #define _COMPONENT          ACPI_UTILITIES
 ACPI_MODULE_NAME("utstate")
@@ -60,6 +61,7 @@ ACPI_MODULE_NAME("utstate")
  * DESCRIPTION: Create a new state and push it
  *
  ******************************************************************************/
+#ifdef  ACPI_FUTURE_USAGE
 acpi_status
 acpi_ut_create_pkg_state_and_push(void *internal_object,
 				  void *external_object,
@@ -79,6 +81,7 @@ acpi_ut_create_pkg_state_and_push(void *internal_object,
 	acpi_ut_push_generic_state(state_list, state);
 	return (AE_OK);
 }
+#endif
 
 /*******************************************************************************
  *
-- 
1.7.9.5

