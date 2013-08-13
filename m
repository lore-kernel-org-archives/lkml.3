Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab3HMG5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:57:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab3HMGdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alban Browaeys <prahal@yahoo.com>,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 17/60] media: em28xx: fix assignment of the eeprom data
Date: Mon, 12 Aug 2013 23:33:44 -0700
Message-Id: <20130813063334.560078389@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alban Browaeys <alban.browaeys@gmail.com>

commit f813b5775b471b656382ae8f087bb34dc894261f upstream.

Set the config structure pointer to the eeprom data pointer (data,
here eedata dereferenced) not the pointer to the pointer to
the eeprom data (eedata itself).

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/em28xx/em28xx-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -726,7 +726,7 @@ static int em28xx_i2c_eeprom(struct em28
 
 	*eedata = data;
 	*eedata_len = len;
-	dev_config = (void *)eedata;
+	dev_config = (void *)*eedata;
 
 	switch (le16_to_cpu(dev_config->chip_conf) >> 4 & 0x3) {
 	case 0:


