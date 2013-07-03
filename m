Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965194Ab3GCTEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:04:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965033Ab3GCTAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:31 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=VmGFjDcfF2QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Amwv8qLLaWoA:10 a=DfNHnWVPAAAA:8 a=danhDmx_AAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=lBRciGGoxdUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184059.268729071@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Hung <alex.hung@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [086/141] ACPI / video: ignore BIOS initial backlight value for HP m4
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0086-ACPI-video-ignore-BIOS-initial-backlight-value-for-H.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

[ Upstream commit fedbe9bc6fd3e14b1ffbb3dac407777ac4a3650c ]

On HP m4 lapops, BIOS reports minimum backlight on boot and
causes backlight to dim completely. This ignores the initial backlight
values and set to max brightness.

References: https://bugs.launchpad.net/bugs/1184501
Cc: All <stable@vger.kernel.org>
Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 3837739..ecdd2d7 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -447,6 +447,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13 - 2000 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion m4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion m4 Notebook PC"),
+		},
+	},
 	{}
 };
 
-- 
1.7.10.4


