Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030389Ab3HBKLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030228Ab3HBKLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 62/99] ACPI / video: ignore BIOS initial backlight value for Fujitsu E753
Date: Fri,  2 Aug 2013 18:08:15 +0800
Message-Id: <20130802100234.666093038@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 9657a565a476d517451c10b0bcc106e300785aff upstream.

The BIOS of FUjitsu E753 reports an incorrect initial backlight value
for WIN8 compatible OS, causing backlight to be dark during startup.
This change causes the incorrect initial value from BIOS to be ignored.

References: https://bugzilla.kernel.org/show_bug.cgi?id=60161
Reported-and-tested-by: Jan Hinnerk Stosch <janhinnerk.stosch@gmail.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -450,6 +450,14 @@ static struct dmi_system_id video_dmi_ta
 	},
 	{
 	 .callback = video_ignore_initial_backlight,
+	 .ident = "Fujitsu E753",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "FUJITSU"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK E753"),
+		},
+	},
+	{
+	 .callback = video_ignore_initial_backlight,
 	 .ident = "HP Pavilion dm4",
 	 .matches = {
 		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),


