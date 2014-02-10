Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbaBJURc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:17:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34611 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbaBJTll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:41:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 017/124] [media] anysee: fix non-working E30 Combo Plus DVB-T
Date: Mon, 10 Feb 2014 11:39:17 -0800
Message-Id: <1392061264-28124-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit c57f87e62368c33ebda11a4993380c8e5a19a5c5 upstream.

PLL was attached twice to frontend0 leaving frontend1 without a tuner.
frontend0 is DVB-C and frontend1 is DVB-T.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index d05c5b5..ea5ca9a 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -445,6 +445,7 @@ static struct cxd2820r_config anysee_cxd2820r_config = {
  * IOD[0] ZL10353 1=enabled
  * IOE[0] tuner 0=enabled
  * tuner is behind ZL10353 I2C-gate
+ * tuner is behind TDA10023 I2C-gate
  *
  * E7 TC VID=1c73 PID=861f HW=18 FW=0.7 AMTCI=0.5 "anysee-E7TC(LP)"
  * PCB: 508TC (rev0.6)
@@ -960,7 +961,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 
 		if (fe && adap->fe[1]) {
 			/* attach tuner for 2nd FE */
-			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
+			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
 					(0xc0 >> 1), &d->i2c_adap,
 					DVB_PLL_SAMSUNG_DTOS403IH102A);
 		}
-- 
1.8.3.2

