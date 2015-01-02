Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbbABSFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:05:17 -0500
Received: from the.earth.li ([46.43.34.31]:44529 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbbABSFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:05:14 -0500
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jan 2015 13:05:14 EST
Date: Fri, 2 Jan 2015 17:55:17 +0000
From: Jonathan McDowell <noodles@earth.li>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH] Fix Mygica T230 support
Message-ID: <20150102175517.GE5209@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2adb177e57417cf8409e86bda2c516e5f99a2099 removed 2 devices
from the cxusb device table but failed to fix up the T230 properties
that follow, meaning that this device no longer gets detected properly.
Adjust the cxusb_table index appropriate so detection works.

Signed-Off-By: Jonathan McDowell <noodles@earth.li>

-----
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 0f345b1..f327c49 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -2232,7 +2232,7 @@ static struct dvb_usb_device_properties cxusb_mygica_t230_properties = {
 		{
 			"Mygica T230 DVB-T/T2/C",
 			{ NULL },
-			{ &cxusb_table[22], NULL },
+			{ &cxusb_table[20], NULL },
 		},
 	}
 };
-----

J.

-- 
"Save usenet: rmgroup ox.colleges.keble" -- Simon Cozens, ox.test
This .sig brought to you by the letter J and the number 47
Product of the Republic of HuggieTag
