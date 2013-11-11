Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3KKLqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:46:37 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:40542 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3KKLq2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:46:28 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCHv2] staging: go7007: fix use of uninitialised pointer
In-Reply-To: <20131110210647.GA5302@mwanda>
Organization: http://mina86.com/
References: <1384108677-23476-1-git-send-email-mpn@google.com> <20131110185210.GA9633@kroah.com> <87fvr480o9.fsf@mina86.com> <20131110210647.GA5302@mwanda>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:m.chehab@samsung.com::wZ6+4HlIltROikeZ:000000000000000000000000000000000000000000FdK
X-Hashcash: 1:20:131111:dan.carpenter@oracle.com::knAyvAbyDioa1Oey:000000000000000000000000000000000000026Tb
X-Hashcash: 1:20:131111:gregkh@linuxfoundation.org::2GAju+MCG5LRnJzW:000000000000000000000000000000000002ZRD
X-Hashcash: 1:20:131111:devel@driverdev.osuosl.org::mTBQkAvan4mGO5WI:0000000000000000000000000000000000028ax
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::F+3JSlM4s2G+zbJG:0000000000000000000000000000000004QfE
X-Hashcash: 1:20:131111:hans.verkuil@cisco.com::VLtzUmh7pAFYb+wX:0000000000000000000000000000000000000006+yU
X-Hashcash: 1:20:131111:linux-media@vger.kernel.org::vrTWjoPwtGhIPo7Y:0000000000000000000000000000000000567N
Date: Mon, 11 Nov 2013 12:46:24 +0100
Message-ID: <xa1tzjpbxisv.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

go variable is initialised only after the switch case so it cannot be
dereferenced prior to that happening.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/staging/media/go7007/go7007-usb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

On Sun, Nov 10 2013, Dan Carpenter wrote:
> There are 3 other uses before "go" gets initialized.

Argh...  Other occurrences of the letters “GO” deceived my eyes.  Sorry
about that and thanks.

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da..ee8ab89 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	dev_dbg(&intf->dev, "probing new GO7007 USB board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
@@ -1097,13 +1097,13 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_px_tv402u;
 		break;
 	case GO7007_BOARDID_LIFEVIEW_LR192:
-		dev_err(go->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
+		dev_err(&intf->dev, "The Lifeview TV Walker Ultra is not supported. Sorry!\n");
 		return -ENODEV;
 		name = "Lifeview TV Walker Ultra";
 		board = &board_lifeview_lr192;
 		break;
 	case GO7007_BOARDID_SENSORAY_2250:
-		dev_info(go->dev, "Sensoray 2250 found\n");
+		dev_info(&intf->dev, "Sensoray 2250 found\n");
 		name = "Sensoray 2250/2251";
 		board = &board_sensoray_2250;
 		break;
@@ -1112,7 +1112,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 		board = &board_ads_usbav_709;
 		break;
 	default:
-		dev_err(go->dev, "unknown board ID %d!\n",
+		dev_err(&intf->dev, "unknown board ID %d!\n",
 				(unsigned int)id->driver_info);
 		return -ENODEV;
 	}
-- 
1.8.4.1

