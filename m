Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaGHADp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:03:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaGHADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gustavo Maciel Dias Vieira <gustavo@sagui.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 3.4 43/44] ACPI video: ignore BIOS backlight value for HP dm4
Date: Mon,  7 Jul 2014 17:07:33 -0700
Message-Id: <20140707235859.920597091@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Maciel Dias Vieira <gustavo@sagui.org>

commit 771d09b3c4c45d4d534a83a68e6331b97fd82e15 upstream.

On a HP Pavilion dm4 laptop the BIOS sets minimum backlight on boot,
completely dimming the screen. Ignore this initial value for this
machine.

Signed-off-by: Gustavo Maciel Dias Vieira <gustavo@sagui.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wyj: Backported to 3.4: adjust context]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -471,6 +471,14 @@ static struct dmi_system_id video_dmi_ta
 		DMI_MATCH(DMI_PRODUCT_NAME, "HP 1000 Notebook PC"),
 		},
 	},
+	{
+	 .callback = video_ignore_initial_backlight,
+	 .ident = "HP Pavilion dm4",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Hewlett-Packard"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dm4 Notebook PC"),
+		},
+	},
 	{}
 };
 


