Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaI0XIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 19:08:53 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54850 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753224AbaI0XIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 19:08:51 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH] ACPI / SBS: Fix check in acpi_ac_get_present()
Date: Sun, 28 Sep 2014 01:28:43 +0200
Message-ID: <1539043.bcCaecDElK@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Parentheses are missing under an if () statement in
acpi_ac_get_present() which makes the check work differently
from what was intended (at least according to the comment right
above it).  Add the missing parens.

The problem was found by sparse.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/sbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/sbs.c
===================================================================
--- linux-pm.orig/drivers/acpi/sbs.c
+++ linux-pm/drivers/acpi/sbs.c
@@ -441,7 +441,7 @@ static int acpi_ac_get_present(struct ac
 	 * The spec requires that bit 4 always be 1. If it's not set, assume
 	 * that the implementation doesn't support an SBS charger
 	 */
-	if (!(status >> 4) & 0x1)
+	if (!((status >> 4) & 0x1))
 		return -ENODEV;
 
 	sbs->charger_present = (status >> 15) & 0x1;

