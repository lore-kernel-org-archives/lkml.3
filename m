Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291AbaCQCfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 22:35:20 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45891 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257AbaCQCfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 22:35:19 -0400
Date: Mon, 17 Mar 2014 03:34:41 +0100
From: Davide Berardi <berardi.dav@gmail.com>
To: gregkh@linuxfoundation.org
Cc: joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fixing some coding style issues on line6 driver.c
Message-ID: <20140317033441.125d2212@White-Rabbit>
In-Reply-To: <1394988926.5689.39.camel@joe-AO722>
References: <20140316132016.388a3f69@White-Rabbit>
	<20140316163700.GA1781@kroah.com>
	<1394988926.5689.39.camel@joe-AO722>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your replies, I've applied your suggestions to the patch.

Davide

Fixed some line over 80 characters.

From: Davide Berardi <berardi.dav@gmail.com>

Signed-off-by: Davide Berardi <berardi.dav@gmail.com>

---
 drivers/staging/line6/driver.c  | 54 ++++++++++++++++++++++-------------------
 drivers/staging/line6/usbdefs.h |  2 +-
 2 files changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
index e7a9d8d..77f1b42 100644
--- a/drivers/staging/line6/driver.c
+++ b/drivers/staging/line6/driver.c
@@ -57,28 +57,32 @@ static const struct usb_device_id line6_id_table[] = {

 MODULE_DEVICE_TABLE(usb, line6_id_table);

+#define L6PROP(dev_bit, dev_id, dev_name, dev_cap)\
+	{.device_bit = LINE6_BIT_##dev_bit, .id = dev_id,\
+	 .name = dev_name, .capabilities = LINE6_BIT_##dev_cap}
+
 /* *INDENT-OFF* */
-static struct line6_properties line6_properties_table[] = {
-	{ LINE6_BIT_BASSPODXT,     "BassPODxt",     "BassPODxt",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_GUITARPORT,    "GuitarPort",    "GuitarPort",       LINE6_BIT_PCM               },
-	{ LINE6_BIT_POCKETPOD,     "PocketPOD",     "Pocket POD",       LINE6_BIT_CONTROL           },
-	{ LINE6_BIT_PODHD300,      "PODHD300",      "POD HD300",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODHD400,      "PODHD400",      "POD HD400",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODHD500,      "PODHD500",      "POD HD500",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODX3,         "PODX3",         "POD X3",           LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODX3LIVE,     "PODX3Live",     "POD X3 Live",      LINE6_BIT_PCM               },
-	{ LINE6_BIT_PODXT,         "PODxt",         "PODxt",            LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODXTLIVE,     "PODxtLive",     "PODxt Live",       LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_PODXTPRO,      "PODxtPro",      "PODxt Pro",        LINE6_BIT_CONTROL_PCM_HWMON },
-	{ LINE6_BIT_TONEPORT_GX,   "TonePortGX",    "TonePort GX",      LINE6_BIT_PCM               },
-	{ LINE6_BIT_TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     LINE6_BIT_PCM               },
-	{ LINE6_BIT_TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     LINE6_BIT_PCM               },
-	{ LINE6_BIT_VARIAX,        "Variax",        "Variax Workbench", LINE6_BIT_CONTROL           },
+static const struct line6_properties line6_properties_table[] = {
+	L6PROP(BASSPODXT,     "BassPODxt",     "BassPODxt",        CTRL_PCM_HW),
+	L6PROP(BASSPODXTLIVE, "BassPODxtLive", "BassPODxt Live",   CTRL_PCM_HW),
+	L6PROP(BASSPODXTPRO,  "BassPODxtPro",  "BassPODxt Pro",    CTRL_PCM_HW),
+	L6PROP(GUITARPORT,    "GuitarPort",    "GuitarPort",       PCM),
+	L6PROP(POCKETPOD,     "PocketPOD",     "Pocket POD",       CONTROL),
+	L6PROP(PODHD300,      "PODHD300",      "POD HD300",        CTRL_PCM_HW),
+	L6PROP(PODHD400,      "PODHD400",      "POD HD400",        CTRL_PCM_HW),
+	L6PROP(PODHD500,      "PODHD500",      "POD HD500",        CTRL_PCM_HW),
+	L6PROP(PODSTUDIO_GX,  "PODStudioGX",   "POD Studio GX",    PCM),
+	L6PROP(PODSTUDIO_UX1, "PODStudioUX1",  "POD Studio UX1",   PCM),
+	L6PROP(PODSTUDIO_UX2, "PODStudioUX2",  "POD Studio UX2",   PCM),
+	L6PROP(PODX3,         "PODX3",         "POD X3",           PCM),
+	L6PROP(PODX3LIVE,     "PODX3Live",     "POD X3 Live",      PCM),
+	L6PROP(PODXT,         "PODxt",         "PODxt",            CTRL_PCM_HW),
+	L6PROP(PODXTLIVE,     "PODxtLive",     "PODxt Live",       CTRL_PCM_HW),
+	L6PROP(PODXTPRO,      "PODxtPro",      "PODxt Pro",        CTRL_PCM_HW),
+	L6PROP(TONEPORT_GX,   "TonePortGX",    "TonePort GX",      PCM),
+	L6PROP(TONEPORT_UX1,  "TonePortUX1",   "TonePort UX1",     PCM),
+	L6PROP(TONEPORT_UX2,  "TonePortUX2",   "TonePort UX2",     PCM),
+	L6PROP(VARIAX,        "Variax",        "Variax Workbench", CONTROL),
 };
 /* *INDENT-ON* */

@@ -152,10 +156,10 @@ int line6_send_raw_message(struct usb_line6 *line6, const char *buffer,
 		int retval;

 		retval = usb_interrupt_msg(line6->usbdev,
-					   usb_sndintpipe(line6->usbdev,
-							  line6->ep_control_write),
-					   (char *)frag_buf, frag_size,
-					   &partial, LINE6_TIMEOUT * HZ);
+					usb_sndintpipe(line6->usbdev,
+						line6->ep_control_write),
+					(char *)frag_buf, frag_size,
+					&partial, LINE6_TIMEOUT * HZ);

 		if (retval) {
 			dev_err(line6->ifcdev,
diff --git a/drivers/staging/line6/usbdefs.h b/drivers/staging/line6/usbdefs.h
index eda0456..2d1cc47 100644
--- a/drivers/staging/line6/usbdefs.h
+++ b/drivers/staging/line6/usbdefs.h
@@ -106,7 +106,7 @@ enum {
 /* device support hardware monitoring */
 #define LINE6_BIT_HWMON (1 << 2)

-#define LINE6_BIT_CONTROL_PCM_HWMON	(LINE6_BIT_CONTROL |	\
+#define LINE6_BIT_CTRL_PCM_HW	(LINE6_BIT_CONTROL |	\
 					 LINE6_BIT_PCM |	\
 					 LINE6_BIT_HWMON)

