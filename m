Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaBGNGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:06:36 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41727 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaBGLtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 070/233] [media] anysee: fix non-working E30 Combo Plus DVB-T
Date: Fri,  7 Feb 2014 11:44:49 +0000
Message-Id: <1391773652-25214-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit c57f87e62368c33ebda11a4993380c8e5a19a5c5 upstream.

PLL was attached twice to frontend0 leaving frontend1 without a tuner.
frontend0 is DVB-C and frontend1 is DVB-T.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 90cfa35..eeab79b 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -442,6 +442,7 @@ static struct cxd2820r_config anysee_cxd2820r_config = {
  * IOD[0] ZL10353 1=enabled
  * IOE[0] tuner 0=enabled
  * tuner is behind ZL10353 I2C-gate
+ * tuner is behind TDA10023 I2C-gate
  *
  * E7 TC VID=1c73 PID=861f HW=18 FW=0.7 AMTCI=0.5 "anysee-E7TC(LP)"
  * PCB: 508TC (rev0.6)
@@ -956,7 +957,7 @@ static int anysee_tuner_attach(struct dvb_usb_adapter *adap)
 
 		if (fe && adap->fe[1]) {
 			/* attach tuner for 2nd FE */
-			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
+			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
 					(0xc0 >> 1), &d->i2c_adap,
 					DVB_PLL_SAMSUNG_DTOS403IH102A);
 		}
-- 
1.8.3.2

