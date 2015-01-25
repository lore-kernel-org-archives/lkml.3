Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451AbbAYOWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 09:22:25 -0500
Received: from mx02.posteo.de ([89.146.194.165]:48947 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbbAYOWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 09:22:22 -0500
From: Martin Kepplinger <martink@posteo.de>
To: mchehab@osg.samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Kepplinger <martink@posteo.de>
Subject: [PATCH] media: (stb0899) use sign_extend32() for sign extension
Date: Sun, 25 Jan 2015 15:22:05 +0100
Message-Id: <1422195725-23577-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
 drivers/media/dvb-frontends/stb0899_algo.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb-frontends/stb0899_algo.c b/drivers/media/dvb-frontends/stb0899_algo.c
index 93596e0..7bbcfde 100644
--- a/drivers/media/dvb-frontends/stb0899_algo.c
+++ b/drivers/media/dvb-frontends/stb0899_algo.c
@@ -19,6 +19,7 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include <linux/bitops.h>
 #include "stb0899_drv.h"
 #include "stb0899_priv.h"
 #include "stb0899_reg.h"
@@ -1490,9 +1491,7 @@ enum stb0899_status stb0899_dvbs2_algo(struct stb0899_state *state)
 		/* Store signal parameters	*/
 		offsetfreq = STB0899_READ_S2REG(STB0899_S2DEMOD, CRL_FREQ);
 
-		/* sign extend 30 bit value before using it in calculations */
-		if (offsetfreq & (1 << 29))
-			offsetfreq |= -1 << 30;
+		offsetfreq = sign_extend32(offset_freq, 29);
 
 		offsetfreq = offsetfreq / ((1 << 30) / 1000);
 		offsetfreq *= (internal->master_clk / 1000000);
-- 
2.1.4

