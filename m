Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbaAGQYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:24:10 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:62850 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaAGQYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:24:00 -0500
From: Emil Goode <emilgoode@gmail.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>
Subject: [PATCH] ACPI: thermal: remove const from thermal_zone_device_ops declaration
Date: Tue,  7 Jan 2014 17:24:55 +0100
Message-Id: <1389111895-23007-1-git-send-email-emilgoode@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit introduced the requirement to not declare
thermal_zone_device_ops structs as const in order to allow
changing the .get_temp callback.

commit 4e5e4705bf69ea450f58fc709ac5888f321a9299
Author: Eduardo Valentin <eduardo.valentin@ti.com>
Date:   Wed Jul 3 15:35:39 2013 -0400

    thermal: introduce device tree parser

Signed-off-by: Emil Goode <emilgoode@gmail.com>
---
 drivers/acpi/thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 1fd21ad..8349a55 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -861,7 +861,7 @@ acpi_thermal_unbind_cooling_device(struct thermal_zone_device *thermal,
 	return acpi_thermal_cooling_device_cb(thermal, cdev, false);
 }
 
-static const struct thermal_zone_device_ops acpi_thermal_zone_ops = {
+static struct thermal_zone_device_ops acpi_thermal_zone_ops = {
 	.bind = acpi_thermal_bind_cooling_device,
 	.unbind	= acpi_thermal_unbind_cooling_device,
 	.get_temp = thermal_get_temp,
-- 
1.7.10.4

