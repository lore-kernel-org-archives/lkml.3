Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169Ab3FEVo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:44:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690Ab3FEVgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bastian Triller <bastian.triller@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 104/127] ACPI / video: Add "Asus UL30A" to ACPI video detect blacklist
Date: Wed,  5 Jun 2013 14:34:31 -0700
Message-Id: <20130605213229.839829965@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastian Triller <bastian.triller@gmail.com>

commit c8f6d8351ba8c89d5cd4c562552ec7ec29274e31 upstream.

Like on UL30VT, the ACPI video driver can't control backlight correctly on
Asus UL30A.  Vendor driver (asus-laptop) can work.  This patch is to
add "Asus UL30A" to ACPI video detect blacklist in order to use
asus-laptop for video control on the "Asus UL30A" rather than ACPI
video driver.

Signed-off-by: Bastian Triller <bastian.triller@gmail.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video_detect.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -164,6 +164,14 @@ static struct dmi_system_id video_detect
 		DMI_MATCH(DMI_PRODUCT_NAME, "UL30VT"),
 		},
 	},
+	{
+	.callback = video_detect_force_vendor,
+	.ident = "Asus UL30A",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "UL30A"),
+		},
+	},
 	{ },
 };
 


