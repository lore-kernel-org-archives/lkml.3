Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaFDX7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:59:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40449 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbaFDXXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 206/228] ACPI / video: Revert native brightness quirk for ThinkPad T530
Date: Wed,  4 Jun 2014 16:23:55 -0700
Message-Id: <20140604232354.669568030@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 07d1d29ee1e194b932328ad2dc1d40297062ab7f upstream.

Seems it helps some users, but causes issues for other users:
https://bugzilla.redhat.com/show_bug.cgi?id=1089545

So lets drop it for now until we've figured out a better fix.

Fixes: 43d949024425 (ACPI / video: Add use_native_backlight quirks for more systems)
References: https://bugzilla.redhat.com/show_bug.cgi?id=1089545
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -475,14 +475,6 @@ static struct dmi_system_id video_dmi_ta
 	},
 	{
 	 .callback = video_set_use_native_backlight,
-	 .ident = "ThinkPad T530",
-	 .matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T530"),
-		},
-	},
-	{
-	.callback = video_set_use_native_backlight,
 	.ident = "ThinkPad X1 Carbon",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),


