Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaFDXWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaFDXWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 142/228] Input: synaptics - add min/max quirk for the ThinkPad W540
Date: Wed,  4 Jun 2014 16:22:51 -0700
Message-Id: <20140604232352.577706653@linuxfoundation.org>
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

commit 0b5fe736fe923f1f5e05413878d5990e92ffbdf5 upstream.

https://bugzilla.redhat.com/show_bug.cgi?id=1096436

Tested-and-reported-by: ajayr@bigfoot.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/synaptics.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1614,6 +1614,14 @@ static const struct dmi_system_id min_ma
 		.driver_data = (int []){1024, 5112, 2024, 4832},
 	},
 	{
+		/* Lenovo ThinkPad W540 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W540"),
+		},
+		.driver_data = (int []){1024, 5112, 2024, 4832},
+	},
+	{
 		/* Lenovo Yoga S1 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),


