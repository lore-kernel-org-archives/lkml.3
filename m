Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932526Ab3IDX73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762552Ab3IDX71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:59:27 -0400
Date: Wed, 4 Sep 2013 19:59:17 -0400
From: Dave Jones <davej@redhat.com>
To: pboettcher@kernellabs.com
Cc: mchehab@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: dvb-usb/technisat-usb2: Fix cut-n-paste thinko
Message-ID: <20130904235917.GC5727@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, pboettcher@kernellabs.com,
	mchehab@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like it was cut and pasted from the code above which does similar checks on txlen,
but someone forgot to change the variable.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 40832a1..98d24ae 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -102,7 +102,7 @@ static int technisat_usb2_i2c_access(struct usb_device *udev,
 	if (rxlen > 62) {
 		err("i2c RX buffer can't exceed 62 bytes (dev 0x%02x)",
 				device_addr);
-		txlen = 62;
+		rxlen = 62;
 	}
 
 	b[0] = I2C_SPEED_100KHZ_BIT;
