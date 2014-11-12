Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933624AbaKLBfQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:35:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589AbaKLBfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:35:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: [PATCH 3.17 294/319] acer-wmi: Add acpi_backlight=video quirk for the Acer KAV80
Date: Wed, 12 Nov 2014 10:17:12 +0900
Message-Id: <20141112011041.500908658@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 183fd8fcd7f8afb7ac5ec68f83194872f9fecc84 upstream.

The acpi-video backlight interface on the Acer KAV80 is broken, and worse
it causes the entire machine to slow down significantly after a suspend/resume.

Blacklist it, and use the acer-wmi backlight interface instead. Note that
the KAV80 is somewhat unique in that it is the only Acer model where we
fall back to acer-wmi after blacklisting, rather then using the native
(e.g. intel) backlight driver. This is done because there is no native
backlight interface on this model.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1128309
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Darren Hart <dvhart@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -579,6 +579,17 @@ static const struct dmi_system_id video_
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5741"),
 		},
 	},
+	{
+		/*
+		 * Note no video_set_backlight_video_vendor, we must use the
+		 * acer interface, as there is no native backlight interface.
+		 */
+		.ident = "Acer KAV80",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "KAV80"),
+		},
+	},
 	{}
 };
 


