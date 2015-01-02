Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbbABU6V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:58:21 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58538 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbABU6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:58:19 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Robert Moore <robert.moore@intel.com>, Lv Zheng <lv.zheng@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: acpica: utstate:  Remove unused function
Date: Fri,  2 Jan 2015 22:01:20 +0100
Message-Id: <1420232480-3252-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function acpi_ut_create_pkg_state_and_push() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/acpi/acpica/acutils.h |    8 --------
 drivers/acpi/acpica/utstate.c |   33 ---------------------------------
 2 files changed, 41 deletions(-)

diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index 486d342..ef2ad3c 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -539,14 +539,6 @@ acpi_ut_create_update_state_and_push(union acpi_operand_object *object,
 				     u16 action,
 				     union acpi_generic_state **state_list);
 
-#ifdef	ACPI_FUTURE_USAGE
-acpi_status
-acpi_ut_create_pkg_state_and_push(void *internal_object,
-				  void *external_object,
-				  u16 index,
-				  union acpi_generic_state **state_list);
-#endif				/* ACPI_FUTURE_USAGE */
-
 union acpi_generic_state *acpi_ut_create_control_state(void);
 
 void acpi_ut_delete_generic_state(union acpi_generic_state *state);
diff --git a/drivers/acpi/acpica/utstate.c b/drivers/acpi/acpica/utstate.c
index 1cc97a7..fa932e9 100644
--- a/drivers/acpi/acpica/utstate.c
+++ b/drivers/acpi/acpica/utstate.c
@@ -49,39 +49,6 @@ ACPI_MODULE_NAME("utstate")
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ut_create_pkg_state_and_push
- *
- * PARAMETERS:  object          - Object to be added to the new state
- *              action          - Increment/Decrement
- *              state_list      - List the state will be added to
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Create a new state and push it
- *
- ******************************************************************************/
-acpi_status
-acpi_ut_create_pkg_state_and_push(void *internal_object,
-				  void *external_object,
-				  u16 index,
-				  union acpi_generic_state **state_list)
-{
-	union acpi_generic_state *state;
-
-	ACPI_FUNCTION_ENTRY();
-
-	state =
-	    acpi_ut_create_pkg_state(internal_object, external_object, index);
-	if (!state) {
-		return (AE_NO_MEMORY);
-	}
-
-	acpi_ut_push_generic_state(state_list, state);
-	return (AE_OK);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ut_push_generic_state
  *
  * PARAMETERS:  list_head           - Head of the state stack
-- 
1.7.10.4

