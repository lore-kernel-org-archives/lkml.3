Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbaCaAWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:22:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36317 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752946AbaC3XZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael Krufky" <mkrufky@linuxtv.org>,
        "Dave Jones" <davej@fedoraproject.org>,
        "Mauro Carvalho Chehab" <m.chehab@samsung.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.366299252@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 073/200] [media] mxl111sf: Fix compile when
 CONFIG_DVB_USB_MXL111SF is unset
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jones <davej@fedoraproject.org>

commit 13e1b87c986100169b0695aeb26970943665eda9 upstream.

Fix the following build error:

drivers/media/usb/dvb-usb-v2/
mxl111sf-tuner.h:72:9: error: expected ‘;’, ‘,’ or ‘)’ before ‘struct’
         struct mxl111sf_tuner_config *cfg)

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
@@ -69,7 +69,7 @@ struct dvb_frontend *mxl111sf_tuner_atta
 #else
 static inline
 struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
-					   struct mxl111sf_state *mxl_state
+					   struct mxl111sf_state *mxl_state,
 					   struct mxl111sf_tuner_config *cfg)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);

