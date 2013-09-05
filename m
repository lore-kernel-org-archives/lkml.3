Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935748Ab3IELgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:36:46 -0400
Received: from vms173025pub.verizon.net ([206.46.173.25]:60369 "EHLO
	vms173025pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935594Ab3IELgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:36:45 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
        "Jordan_Hargrave@Dell.com" <Jordan_Hargrave@Dell.com>,
        Jordan Hargrave <jordan_hargrave@Dell.com>,
        Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 3/4] Add MODULE_ALIAS for autoloading ipmi driver on ACPI
 systems
Date: Thu, 05 Sep 2013 06:36:35 -0500
Message-id: <1378380996-4844-4-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1378380996-4844-1-git-send-email-minyard@acm.org>
References: <1378380996-4844-1-git-send-email-minyard@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Jordan_Hargrave@Dell.com" <Jordan_Hargrave@Dell.com>

I'd submitted this about a year ago but it never made it upstream.

The latest versions of the kernel drivers for ipmi can use ACPI to
determine the type of BMC device used in the system.  The following
patch adds a module alias so that udev will autoload the ipmi_si
driver.

Signed-off-by: Jordan Hargrave <jordan_hargrave@dell.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index af4b23f..810372c 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2279,6 +2279,8 @@ static struct pnp_driver ipmi_pnp_driver = {
 	.remove		= ipmi_pnp_remove,
 	.id_table	= pnp_dev_table,
 };
+
+MODULE_DEVICE_TABLE(pnp, pnp_dev_table);
 #endif
 
 #ifdef CONFIG_DMI
-- 
1.7.9.5

