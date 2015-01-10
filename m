Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbbAJFlB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:41:01 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36198 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbbAJFgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:36:45 -0500
From: Chris Rorvick <chris@rorvick.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chris Rorvick <chris@rorvick.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Davide Berardi <berardi.dav@gmail.com>, devel@driverdev.osuosl.org,
        Fabian Mewes <architekt@coding4coffee.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Jerry Snitselaar <dev@snitselaar.org>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>,
        linux-kernel@vger.kernel.org, Mikhail Boiko <mm.boiko@yandex.ru>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Stefan Hajnoczi <stefanha@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 11/25] staging: line6: Use explicit indexes when defining properties
Date: Fri,  9 Jan 2015 23:35:57 -0600
Message-Id: <1420868171-2031-12-git-send-email-chris@rorvick.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1420868171-2031-1-git-send-email-chris@rorvick.com>
References: <1420868171-2031-1-git-send-email-chris@rorvick.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Specify the index of the properties entry explicitly to define this
structure more robustly.  Also, drop the `L6PROP' macro in favor of
initializing each member explicitly on its own line since horizontal
space is limited and more attributes will be added later.

Signed-off-by: Chris Rorvick <chris@rorvick.com>
---
 drivers/staging/line6/driver.c | 112 +++++++++++++++++++++++++++++++++--------
 1 file changed, 90 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index 4ec87a3..c988b78 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -57,29 +57,97 @@ static const struct usb_device_id line6_id_table[] = {
 
 MODULE_DEVICE_TABLE(usb, line6_id_table);
 
-#define L6PROP(dev_id, dev_name, dev_cap)\
-	{.id = dev_id,\
-	 .name = dev_name, .capabilities = LINE6_CAP_##dev_cap}
-
 static const struct line6_properties line6_properties_table[] = {
-	L6PROP("BassPODxt",     "BassPODxt",        CTRL_PCM_HW),
-	L6PROP("BassPODxtLive", "BassPODxt Live",   CTRL_PCM_HW),
-	L6PROP("BassPODxtPro",  "BassPODxt Pro",    CTRL_PCM_HW),
-	L6PROP("GuitarPort",    "GuitarPort",       PCM),
-	L6PROP("PocketPOD",     "Pocket POD",       CONTROL),
-	L6PROP("PODHD300",      "POD HD300",        CTRL_PCM_HW),
-	L6PROP("PODHD400",      "POD HD400",        CTRL_PCM_HW),
-	L6PROP("PODHD500",      "POD HD500",        CTRL_PCM_HW),
-	L6PROP("PODStudioGX",   "POD Studio GX",    PCM),
-	L6PROP("PODStudioUX1",  "POD Studio UX1",   PCM),
-	L6PROP("PODStudioUX2",  "POD Studio UX2",   PCM),
-	L6PROP("PODxt",         "PODxt",            CTRL_PCM_HW),
-	L6PROP("PODxtLive",     "PODxt Live",       CTRL_PCM_HW),
-	L6PROP("PODxtPro",      "PODxt Pro",        CTRL_PCM_HW),
-	L6PROP("TonePortGX",    "TonePort GX",      PCM),
-	L6PROP("TonePortUX1",   "TonePort UX1",     PCM),
-	L6PROP("TonePortUX2",   "TonePort UX2",     PCM),
-	L6PROP("Variax",        "Variax Workbench", CONTROL),
+	[LINE6_BASSPODXT] = {
+		.id = "BassPODxt",
+		.name = "BassPODxt",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_BASSPODXTLIVE] = {
+		.id = "BassPODxtLive",
+		.name = "BassPODxt Live",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_BASSPODXTPRO] = {
+		.id = "BassPODxtPro",
+		.name = "BassPODxt Pro",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_GUITARPORT] = {
+		.id = "GuitarPort",
+		.name = "GuitarPort",
+		.capabilities = LINE6_CAP_PCM,
+	},
+	[LINE6_POCKETPOD] = {
+		.id = "PocketPOD",
+		.name = "Pocket POD",
+		.capabilities = LINE6_CAP_CONTROL,
+	},
+	[LINE6_PODHD300] = {
+		.id = "PODHD300",
+		.name = "POD HD300",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_PODHD400] = {
+		.id = "PODHD400",
+		.name = "POD HD400",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_PODHD500] = {
+		.id = "PODHD500",
+		.name = "POD HD500",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_PODSTUDIO_GX] = {
+		.id = "PODStudioGX",
+		.name = "POD Studio GX",
+		.capabilities = LINE6_CAP_PCM,
+	},
+	[LINE6_PODSTUDIO_UX1] = {
+		.id = "PODStudioUX1",
+		.name = "POD Studio UX1",
+		.capabilities = LINE6_CAP_PCM,
+	},
+	[LINE6_PODSTUDIO_UX2] = {
+		.id = "PODStudioUX2",
+		.name = "POD Studio UX2",
+		.capabilities = LINE6_CAP_PCM,
+	},
+	[LINE6_PODXT] = {
+		.id = "PODxt",
+		.name = "PODxt",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_PODXTLIVE] = {
+		.id = "PODxtLive",
+		.name = "PODxt Live",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_PODXTPRO] = {
+		.id = "PODxtPro",
+		.name = "PODxt Pro",
+		.capabilities = LINE6_CAP_CTRL_PCM_HW,
+	},
+	[LINE6_TONEPORT_GX] = {
+		.id = "TonePortGX",
+		.name = "TonePort GX",
+		.capabilities = LINE6_CAP_PCM,
+	},
+	[LINE6_TONEPORT_UX1] = {
+		.id = "TonePortUX1",
+		.name = "TonePort UX1",
+		.capabilities = LINE6_CAP_PCM,
+	},
+	[LINE6_TONEPORT_UX2] = {
+		.id = "TonePortUX2",
+		.name = "TonePort UX2",
+		.capabilities = LINE6_CAP_PCM,
+	},
+	[LINE6_VARIAX] = {
+		.id = "Variax",
+		.name = "Variax Workbench",
+		.capabilities = LINE6_CAP_CONTROL,
+	}
 };
 
 /*
-- 
2.1.0

