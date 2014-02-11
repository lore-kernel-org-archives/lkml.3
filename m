Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbaBKTbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:31:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbaBKTH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:07:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 44/79] media: anysee: fix non-working E30 Combo Plus DVB-T
Date: Tue, 11 Feb 2014 11:05:48 -0800
Message-Id: <20140211184722.220395424@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184720.928667275@linuxfoundation.org>
References: <20140211184720.928667275@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit c57f87e62368c33ebda11a4993380c8e5a19a5c5 upstream.

PLL was attached twice to frontend0 leaving frontend1 without a tuner.
frontend0 is DVB-C and frontend1 is DVB-T.

Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/anysee.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -442,6 +442,7 @@ static struct cxd2820r_config anysee_cxd
  * IOD[0] ZL10353 1=enabled
  * IOE[0] tuner 0=enabled
  * tuner is behind ZL10353 I2C-gate
+ * tuner is behind TDA10023 I2C-gate
  *
  * E7 TC VID=1c73 PID=861f HW=18 FW=0.7 AMTCI=0.5 "anysee-E7TC(LP)"
  * PCB: 508TC (rev0.6)
@@ -956,7 +957,7 @@ static int anysee_tuner_attach(struct dv
 
 		if (fe && adap->fe[1]) {
 			/* attach tuner for 2nd FE */
-			fe = dvb_attach(dvb_pll_attach, adap->fe[0],
+			fe = dvb_attach(dvb_pll_attach, adap->fe[1],
 					(0xc0 >> 1), &d->i2c_adap,
 					DVB_PLL_SAMSUNG_DTOS403IH102A);
 		}


