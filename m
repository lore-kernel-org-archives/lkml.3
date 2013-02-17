Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3BQPV1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:21:27 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39026 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755841Ab3BQPVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:21:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 6/7] ACPI / container: Use hotplug profile user space interface
Date: Sun, 17 Feb 2013 16:25:57 +0100
Message-ID: <3779443.WcNOusp6YQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3260206.bhaAobGhpZ@vostro.rjw.lan>
References: <3260206.bhaAobGhpZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make the ACPI container driver register its ACPI scan handler object
using acpi_scan_add_handler_with_hotplug() to allow user space to
manipulate its hotplug profile attributes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/container.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: test/drivers/acpi/container.c
===================================================================
--- test.orig/drivers/acpi/container.c
+++ test/drivers/acpi/container.c
@@ -49,7 +49,7 @@ static int container_device_attach(struc
 	return 1;
 }
 
-static struct acpi_scan_handler container_device_handler = {
+static struct acpi_scan_handler container_handler = {
 	.ids = container_device_ids,
 	.attach = container_device_attach,
 	.hotplug = {
@@ -60,5 +60,5 @@ static struct acpi_scan_handler containe
 
 void __init acpi_container_init(void)
 {
-	acpi_scan_add_handler(&container_device_handler);
+	acpi_scan_add_handler_with_hotplug(&container_handler, "container");
 }
