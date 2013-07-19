Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965983Ab3GSFi5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:38:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39883 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965674Ab3GSF0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:26:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 33/72] ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan
Date: Thu, 18 Jul 2013 22:25:50 -0700
Message-Id: <20130719052602.133598604@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit eff9a4b62b14cf0d9913e3caf1f26f8b7a6105c9 upstream.

HP Folio 13's BIOS defines CMOS RTC Operation Region and the EC's
_REG method will access that region.  To allow the CMOS RTC region
handler to be installed before the EC _REG method is first invoked,
add ec_skip_dsdt_scan() as HP Folio 13's callback to ec_dmi_table.

References: https://bugzilla.kernel.org/show_bug.cgi?id=54621
Reported-and-tested-by: Stefan Nagy <public@stefan-nagy.at>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/ec.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -983,6 +983,10 @@ static struct dmi_system_id __initdata e
 	ec_enlarge_storm_threshold, "CLEVO hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "M720T/M730T"),}, NULL},
+	{
+	ec_skip_dsdt_scan, "HP Folio 13", {
+	DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13"),}, NULL},
 	{},
 };
 


