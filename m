Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaETQdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:33:53 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:3812 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893AbaETQdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:33:51 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEWAM2Ce1NbsnsG/2dsb2JhbABZgwarBwQBAQEBAQEFAYM6lm4CAoEcF3SCUxM/GIECJBOIRQHUI4VViHmERwEDhF4DiluKKwGTIIM6Ow
Date: Tue, 20 May 2014 18:33:49 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/media/dvb-frontends/dib8000.c: replace shift
 loop by ilog2
Message-Id: <20140520183349.5284acfb2a3a5d4dbe93a4d2@skynet.be>
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
 drivers/media/dvb-frontends/dib8000.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index 1632d78..8625634 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -1922,14 +1922,12 @@ static const s32 lut_1000ln_mant[] =
 s32 dib8000_get_adc_power(struct dvb_frontend *fe, u8 mode)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
-	u32 ix = 0, tmp_val = 0, exp = 0, mant = 0;
+	u32 ix = 0, exp = 0, mant = 0;
 	s32 val;
 
 	val = dib8000_read32(state, 384);
 	if (mode) {
-		tmp_val = val;
-		while (tmp_val >>= 1)
-			exp++;
+		exp = ilog2(val);
 		mant = (val * 1000 / (1<<exp));
 		ix = (u8)((mant-1000)/100); /* index of the LUT */
 		val = (lut_1000ln_mant[ix] + 693*(exp-20) - 6908);
-- 
1.8.4.5

