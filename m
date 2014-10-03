Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbaJCW0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:26:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47561 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaJCW0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:26:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hugo P <saurosii@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.10 101/143] Input: i8042 - add nomux quirk for Avatar AVIU-145A6
Date: Fri,  3 Oct 2014 14:34:56 -0700
Message-Id: <20141003213317.524636694@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit d2682118f4bb3ceb835f91c1a694407a31bb7378 upstream.

The sys_vendor / product_name are somewhat generic unfortunately, so this
may lead to some false positives. But nomux usually does no harm, where as
not having it clearly is causing problems on the Avatar AVIU-145A6.

https://bugzilla.kernel.org/show_bug.cgi?id=77391

Reported-by: Hugo P <saurosii@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -458,6 +458,13 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv4 Notebook PC"),
 		},
 	},
+	{
+		/* Avatar AVIU-145A6 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "IC4I"),
+		},
+	},
 	{ }
 };
 


