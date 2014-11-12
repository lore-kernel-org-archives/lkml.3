Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964974AbaKLBk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:40:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964949AbaKLBkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:40:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.14 064/203] Input: i8042 - add noloop quirk for Asus X750LN
Date: Wed, 12 Nov 2014 10:15:34 +0900
Message-Id: <20141112011545.647626928@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 9ff84a17302aeb8913ff244ecc0d8f9d219fecb5 upstream.

Without this the aux port does not get detected, and consequently the
touchpad will not work.

https://bugzilla.redhat.com/show_bug.cgi?id=1110011

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -101,6 +101,12 @@ static const struct dmi_system_id __init
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "X750LN"),
+		},
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Compaq"),
 			DMI_MATCH(DMI_PRODUCT_NAME , "ProLiant"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "8500"),


