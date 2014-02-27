Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaB0PBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:01:20 -0500
Received: from mout.gmx.net ([212.227.17.22]:61831 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725AbaB0PBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:01:18 -0500
From: xypron.glpk@gmx.de
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] Reading array out of bound in ds3000_read_snr
Date: Thu, 27 Feb 2014 16:00:53 +0100
Message-Id: <1393513253-10723-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:JwsyL7p0pAIzJaZ0dNXfh8AHQjOCz1jidaZcCa9Xq+2kTtM+zr3
 2zLFxHoKJuoXiHIdDV8cPNJotWFZUgDWUGZ7lIAe7KAws8mG/8dHbXpwX7PTg4Yi6bNT3B+
 hDXwB7m/KXo0EEmcDVkQRfVswNc6i6T9CN2ehnLRXQtSUUpTEP2fnR6MpQ6j0Qe11Vix30r
 OPPLIf3/e5sNZ9GUnLDuw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

An attempt was made to read dvbs2_snr_tab[80],
though dvbs2_snr_tab has only 80 elements.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/media/dvb-frontends/ds3000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 1e344b0..335daef 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -616,7 +616,7 @@ static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
 			snr_reading = dvbs2_noise_reading / tmp;
 			if (snr_reading > 80)
 				snr_reading = 80;
-			*snr = -(dvbs2_snr_tab[snr_reading] / 1000);
+			*snr = -(dvbs2_snr_tab[snr_reading - 1] / 1000);
 		}
 		dprintk("%s: raw / cooked = 0x%02x / 0x%04x\n", __func__,
 				snr_reading, *snr);
-- 
1.7.10.4

