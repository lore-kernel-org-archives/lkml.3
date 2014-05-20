Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaETQcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:32:25 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:5420 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753125AbaETQcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:32:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEWAJ6Ce1NbsnsG/2dsb2JhbABZgwarBQQBAQEBAQEFAYM6lm4CAoEcF3SCUxM/GIECJBOIRQHUI4VViHmERwEDhF4DiluKKwGTIIM6Ow
Date: Tue, 20 May 2014 18:32:22 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 1/1] drivers/media/dvb-frontends/dib7000p.c: replace shift
 loop by ilog2
Message-Id: <20140520183222.578268622a7c1f25eaacfd99@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/media/dvb-frontends/dib7000p.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib7000p.c b/drivers/media/dvb-frontends/dib7000p.c
index effb87f..d40dcd5 100644
--- a/drivers/media/dvb-frontends/dib7000p.c
+++ b/drivers/media/dvb-frontends/dib7000p.c
@@ -1783,7 +1783,7 @@ static const s32 lut_1000ln_mant[] = {
 static s32 dib7000p_get_adc_power(struct dvb_frontend *fe)
 {
 	struct dib7000p_state *state = fe->demodulator_priv;
-	u32 tmp_val = 0, exp = 0, mant = 0;
+	u32 exp = 0, mant = 0;
 	s32 pow_i;
 	u16 buf[2];
 	u8 ix = 0;
@@ -1793,10 +1793,7 @@ static s32 dib7000p_get_adc_power(struct dvb_frontend *fe)
 	pow_i = (buf[0] << 16) | buf[1];
 	dprintk("raw pow_i = %d", pow_i);
 
-	tmp_val = pow_i;
-	while (tmp_val >>= 1)
-		exp++;
-
+	exp = ilog2(pow_i);
 	mant = (pow_i * 1000 / (1 << exp));
 	dprintk(" mant = %d exp = %d", mant / 1000, exp);
 
-- 
1.8.4.5

