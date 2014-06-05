Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaFEEsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:48:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaFEEVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Hung <alex.hung@canonical.com>, Matthew Garrett <mjg@redhat.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Subject: [PATCH 3.4 121/214] thinkpad-acpi: fix issuing duplicated key events for brightness up/down
Date: Wed,  4 Jun 2014 21:18:04 -0700
Message-Id: <20140605041655.955286991@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@canonical.com>

commit ff413195e830541afeae469fc866ecd0319abd7e upstream.

The tp_features.bright_acpimode will not be set correctly for brightness
control because ACPI_VIDEO_HID will not be located in ACPI. As a result,
a duplicated key event will always be sent. acpi_video_backlight_support()
is sufficient to detect standard ACPI brightness control.

Signed-off-by: Alex Hung <alex.hung@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/thinkpad_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -3402,7 +3402,7 @@ static int __init hotkey_init(struct ibm
 	/* Do not issue duplicate brightness change events to
 	 * userspace. tpacpi_detect_brightness_capabilities() must have
 	 * been called before this point  */
-	if (tp_features.bright_acpimode && acpi_video_backlight_support()) {
+	if (acpi_video_backlight_support()) {
 		pr_info("This ThinkPad has standard ACPI backlight "
 			"brightness control, supported by the ACPI "
 			"video driver\n");


