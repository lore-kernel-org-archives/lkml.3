Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaDAMDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:03:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaDALRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:17:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 050/144] ACPI / EC: Fix incorrect placement of __initdata
Date: Tue,  1 Apr 2014 12:14:14 +0100
Message-Id: <1396350948-29910-51-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 6cef74970186797c45b3add1e73a14aa71d338d1 upstream.

__initdata should be placed between the variable name and equal
sign for the variable to be placed in the intended section.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/acpi/ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 1ad5a4f..c69ac14 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -949,7 +949,7 @@ static int ec_enlarge_storm_threshold(const struct dmi_system_id *id)
 	return 0;
 }
 
-static struct dmi_system_id __initdata ec_dmi_table[] = {
+static struct dmi_system_id ec_dmi_table[] __initdata = {
 	{
 	ec_skip_dsdt_scan, "Compal JFL92", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
-- 
1.9.1

