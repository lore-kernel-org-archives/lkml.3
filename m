Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbaLLGR7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:17:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51880 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760023AbaLLGRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:19 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Hans de Goede" <hdegoede@redhat.com>,
        "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.962369462@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 056/164] Input: i8042 - add noloop quirk for Asus X750LN
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 9ff84a17302aeb8913ff244ecc0d8f9d219fecb5 upstream.

Without this the aux port does not get detected, and consequently the
touchpad will not work.

https://bugzilla.redhat.com/show_bug.cgi?id=1110011

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/input/serio/i8042-x86ia64io.h | 6 ++++++
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

