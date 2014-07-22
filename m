Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaGVTV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:21:26 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44695 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbaGVTVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:21:24 -0400
From: Arjun Sreedharan <arjun024@gmail.com>
To: rjw@rjwysocki.net
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PNPACPI: check return value of pnpacpi_parse_allocated_resource() and pnpacpi_parse_resource_option_data()
Date: Wed, 23 Jul 2014 00:43:39 +0530
Message-Id: <1406056419-3047-1-git-send-email-arjun024@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle error condition since pnpacpi_parse_allocated_resource() and pnpacpi_parse_resource_option_data() could return -EPERM.

Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>
---
 drivers/pnp/pnpacpi/core.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index b81448b..c3214e9 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -272,10 +272,14 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
 		strncpy(dev->name, acpi_device_bid(device), sizeof(dev->name));
 
 	if (dev->active)
-		pnpacpi_parse_allocated_resource(dev);
+		error = pnpacpi_parse_allocated_resource(dev);
+		if (error)
+			return error;
 
 	if (dev->capabilities & PNP_CONFIGURABLE)
-		pnpacpi_parse_resource_option_data(dev);
+		error = pnpacpi_parse_resource_option_data(dev);
+		if (error)
+			return error;
 
 	list_for_each_entry(id, &device->pnp.ids, list) {
 		if (!strcmp(id->id, pnpid))
-- 
1.7.11.7

