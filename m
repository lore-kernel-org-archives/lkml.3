Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3LBTdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:33:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab3LBTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3.12 189/212] media: af9015: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:16:20 -0800
Message-Id: <20131202191309.849159907@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 65e2f1cb3fe0f0630834b9517ba8f631936f325c upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb-v2/af9015.c:433:1: warning: 'af9015_eeprom_hash' uses dynamic stack allocation [enabled by default]
In this specific case, it is a gcc bug, as the size is a const, but
it is easy to just change it from const to a #define, getting rid of
the gcc warning.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/af9015.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -397,12 +397,13 @@ error:
 	return ret;
 }
 
+#define AF9015_EEPROM_SIZE 256
+
 /* hash (and dump) eeprom */
 static int af9015_eeprom_hash(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
 	int ret, i;
-	static const unsigned int AF9015_EEPROM_SIZE = 256;
 	u8 buf[AF9015_EEPROM_SIZE];
 	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, NULL};
 


