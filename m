Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaBSBTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:19:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55719 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751328AbaBSBSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:18:34 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 1/9] ACPI / hotplug / PCI: Do not clear event callback pointer for docks
Date: Wed, 19 Feb 2014 02:27:01 +0100
Message-ID: <2117607.1Rv04qGaoi@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3011875.q18rCmXyYX@vostro.rjw.lan>
References: <3011875.q18rCmXyYX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After recent changes adding dock station handling to the ACPI hotplug
core, it is not necessary to clear the .event() pointer in the
ACPIPHP device hotplug context for dock stations any more, so don't
do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -307,13 +307,6 @@ static acpi_status acpiphp_add_context(a
 	if (acpi_has_method(handle, "_STA"))
 		newfunc->flags |= FUNC_HAS_STA;
 
-	/*
-	 * Dock stations' notify handler should be used for dock devices instead
-	 * of the common one, so clear hp.event in their contexts.
-	 */
-	if (acpi_has_method(handle, "_DCK"))
-		context->hp.event = NULL;
-
 	acpi_unlock_hp_context();
 
 	/* search for objects that share the same slot */

