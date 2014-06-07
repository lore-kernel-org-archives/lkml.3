Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaFGBca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:32:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36121 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbaFGBXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matthew Garrett" <mjg@redhat.com>,
        "Alex Hung" <alex.hung@canonical.com>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.36905540@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 27/92] thinkpad-acpi: fix issuing duplicated key
 events for brightness up/down
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

commit ff413195e830541afeae469fc866ecd0319abd7e upstream.

The tp_features.bright_acpimode will not be set correctly for brightness
control because ACPI_VIDEO_HID will not be located in ACPI. As a result,
a duplicated key event will always be sent. acpi_video_backlight_support()
is sufficient to detect standard ACPI brightness control.

Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/thinkpad_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3405,7 +3405,7 @@ static int __init hotkey_init(struct ibm
 	/* Do not issue duplicate brightness change events to
 	 * userspace. tpacpi_detect_brightness_capabilities() must have
 	 * been called before this point  */
-	if (tp_features.bright_acpimode && acpi_video_backlight_support()) {
+	if (acpi_video_backlight_support()) {
 		pr_info("This ThinkPad has standard ACPI backlight "
 			"brightness control, supported by the ACPI "
 			"video driver\n");

