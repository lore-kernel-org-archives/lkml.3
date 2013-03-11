Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab3CKTQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:16:43 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54242 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468Ab3CKTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:16:40 -0400
Message-ID: <1363029394.3138.3.camel@fafadora.lan>
Subject: [PATCH] acpi: fix suspend and resume on Sony Vaio VGN-FW21M
From: Fabio Valentini <fafatheone@gmail.com>
To: rjw@sisk.pl
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2013 20:16:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    From: Fabio Valentini <fafatheone@gmail.com>

    Add Sony Vaio VGN-FW21M to the device blacklist in drivers/acpi/sleep.c.
    Fixes suspend/resume on this device (device no longer reboots instead of resuming).
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=55001

    Signed-off-by: Fabio Valentini <fafatheone@gmail.com>
---
    Patch applies cleanly to latest master (3.9-rc2) and stable (3.8.2).
     drivers/acpi/sleep.c | 8 ++++++++
     1 file changed, 8 insertions(+)

--- linux/drivers/acpi/sleep.c.orig	2013-03-09 16:46:41.407984555 +0100
+++ linux/drivers/acpi/sleep.c	2013-03-09 16:49:03.693005658 +0100
@@ -193,6 +193,14 @@ static struct dmi_system_id __initdata a
 	},
 	{
 	.callback = init_nvs_nosave,
+	.ident = "Sony Vaio VGN-FW21M",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "VGN-FW21M"),
+		},
+	},
+	{
+	.callback = init_nvs_nosave,
 	.ident = "Sony Vaio VPCEB17FX",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "Sony Corporation"),


