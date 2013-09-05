Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965Ab3IEUhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:37:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52132 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092Ab3IEU2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 32/36] ACPI / EC: Add ASUSTEK L4R to quirk list in order to validate ECDT
Date: Thu,  5 Sep 2013 13:28:01 -0700
Message-Id: <20130905202706.067602382@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202702.289738686@linuxfoundation.org>
References: <20130905202702.289738686@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 524f42fab787a9510be826ce3d736b56d454ac6d upstream.

The ECDT of ASUSTEK L4R doesn't provide correct command and data
I/O ports.  The DSDT provides the correct information instead.

For this reason, add this machine to quirk list for ECDT validation
and use the EC information from the DSDT.

[rjw: Changelog]
References: https://bugzilla.kernel.org/show_bug.cgi?id=60765
Reported-and-tested-by: Daniele Esposti <expo@expobrain.net>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -987,6 +987,10 @@ static struct dmi_system_id __initdata e
 	ec_skip_dsdt_scan, "HP Folio 13", {
 	DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
 	DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13"),}, NULL},
+	{
+	ec_validate_ecdt, "ASUS hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTek Computer Inc."),
+	DMI_MATCH(DMI_PRODUCT_NAME, "L4R"),}, NULL},
 	{},
 };
 


