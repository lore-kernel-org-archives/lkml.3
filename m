Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbaCNR3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:29:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbaCNR3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:29:34 -0400
From: Colin King <colin.king@canonical.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ds3000: fix array out of bounds access
Date: Fri, 14 Mar 2014 17:29:31 +0000
Message-Id: <1394818171-13052-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

cppcheck reports an array out of bounds access:

[drivers/media/dvb-frontends/ds3000.c:619]: (error) Array
 'dvbs2_snr_tab[80]' accessed at index 80, which is out of bounds.

the index check is off by one, so fix this to avoid the error.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/media/dvb-frontends/ds3000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/ds3000.c b/drivers/media/dvb-frontends/ds3000.c
index 1e344b0..d2bda93 100644
--- a/drivers/media/dvb-frontends/ds3000.c
+++ b/drivers/media/dvb-frontends/ds3000.c
@@ -614,8 +614,8 @@ static int ds3000_read_snr(struct dvb_frontend *fe, u16 *snr)
 			*snr = snr_value * 5 * 655;
 		} else {
 			snr_reading = dvbs2_noise_reading / tmp;
-			if (snr_reading > 80)
-				snr_reading = 80;
+			if (snr_reading > 79)
+				snr_reading = 79;
 			*snr = -(dvbs2_snr_tab[snr_reading] / 1000);
 		}
 		dprintk("%s: raw / cooked = 0x%02x / 0x%04x\n", __func__,
-- 
1.9.0

