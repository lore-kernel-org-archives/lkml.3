Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933480AbaJDAVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:21:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbaJCVnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.16 200/357] ACPI / video: disable native backlight for ThinkPad X201s
Date: Fri,  3 Oct 2014 14:29:46 -0700
Message-Id: <20141003212939.487266549@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 789eeea128925741e0a105357bebf8855d3bcdee upstream.

The ThinkPad X201s has a working ACPI video backlight interface and is
shipped before Win8; then there is BIOS update that starts to query
_OSI("Windows 2012") and that would make our video module stop creating
backlight interface and caused problem for the user. Add it to the DMI
table to disable native backlight to fix this problem.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=81691
Link: https://bugzilla.kernel.org/show_bug.cgi?id=51231
Reported-and-tested-by: Yves-Alexis Perez <corsac@debian.org>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -675,6 +675,14 @@ static struct dmi_system_id video_dmi_ta
 		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T520"),
 		},
 	},
+	{
+	 .callback = video_disable_native_backlight,
+	 .ident = "ThinkPad X201s",
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
+		},
+	},
 
 	/* The native backlight controls do not work on some older machines */
 	{


