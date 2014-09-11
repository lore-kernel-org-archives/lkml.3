Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaIKMn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:43:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51657 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755445AbaIKMeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:08 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sergiu Giurgiu" <sgiurgiu11@gmail.com>,
        "Takashi Iwai" <tiwai@suse.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.233889257@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 047/131] ALSA: virtuoso: Xonar DSX support
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sergiu Giurgiu <sgiurgiu11@gmail.com>

commit 4492363251235c4499a2d073c5f09121ea23d39d upstream.

This patch adds support for ASUS - Xonar DSX sound cards. Tested on
openSUSE 12.2 with kernel:
Linux 3.4.6-2.10-desktop #1 SMP PREEMPT Thu Jul 26 09:36:26 UTC 2012 (641c197) x86_64 x86_64 x86_64 GNU/Linux
Works:
 - play sounds
 - adjust volume on master channel.
 - mute .

Since Xonar DS uses the same chip, everything that works for DS should
work for DSX as well.

Signed-off-by: Sergiu Giurgiu <sgiurgiu11@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/oxygen/virtuoso.c     | 1 +
 sound/pci/oxygen/xonar_wm87x6.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/sound/pci/oxygen/virtuoso.c
+++ b/sound/pci/oxygen/virtuoso.c
@@ -52,6 +52,7 @@ static DEFINE_PCI_DEVICE_TABLE(xonar_ids
 	{ OXYGEN_PCI_SUBID(0x1043, 0x835d) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x835e) },
 	{ OXYGEN_PCI_SUBID(0x1043, 0x838e) },
+	{ OXYGEN_PCI_SUBID(0x1043, 0x8522) },
 	{ OXYGEN_PCI_SUBID_BROKEN_EEPROM },
 	{ }
 };
--- a/sound/pci/oxygen/xonar_wm87x6.c
+++ b/sound/pci/oxygen/xonar_wm87x6.c
@@ -1255,7 +1255,6 @@ static void dump_wm87x6_registers(struct
 }
 
 static const struct oxygen_model model_xonar_ds = {
-	.shortname = "Xonar DS",
 	.longname = "Asus Virtuoso 66",
 	.chip = "AV200",
 	.init = xonar_ds_init,
@@ -1325,6 +1324,11 @@ int __devinit get_xonar_wm87x6_model(str
 	switch (id->subdevice) {
 	case 0x838e:
 		chip->model = model_xonar_ds;
+		chip->model.shortname = "Xonar DS";
+		break;
+	case 0x8522:
+		chip->model = model_xonar_ds;
+		chip->model.shortname = "Xonar DSX";
 		break;
 	case 0x835e:
 		chip->model = model_xonar_hdav_slim;

