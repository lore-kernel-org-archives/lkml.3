Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbaBUNZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:25:27 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47597 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994AbaBUNBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:01:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jones <davej@fedoraproject.org>, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 07/60] [media] mxl111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset
Date: Fri, 21 Feb 2014 13:00:34 +0000
Message-Id: <1392987687-15367-8-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - file rename: drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h ->
    drivers/media/dvb/dvb-usb/mxl111sf-tuner.h ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/dvb/dvb-usb/mxl111sf-tuner.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
index ff33396..10b93c4 100644
--- a/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
+++ b/drivers/media/dvb/dvb-usb/mxl111sf-tuner.h
@@ -69,7 +69,7 @@ struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
 #else
 static inline
 struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
-					   struct mxl111sf_state *mxl_state
+					   struct mxl111sf_state *mxl_state,
 					   struct mxl111sf_tuner_config *cfg)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-- 
1.9.0

