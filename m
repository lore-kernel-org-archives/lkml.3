Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352Ab3LFNfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:35:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44344 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161683Ab3LFNDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 165/272] [media] af9015: Don't use dynamic static allocation
Date: Fri,  6 Dec 2013 12:57:34 +0000
Message-Id: <1386334761-25517-166-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index d556042..da47d23 100644
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
 
-- 
1.8.3.2

