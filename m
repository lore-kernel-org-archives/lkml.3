Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbbANQ6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:58:51 -0500
Received: from mx02.posteo.de ([89.146.194.165]:40892 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917AbbANQ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:57:48 -0500
From: Martin Kepplinger <martink@posteo.de>
To: mingo@kernel.org
Cc: peterz@infradead.org, paulmck@linux.vnet.ibm.com, tytso@mit.edu,
        maxime.coquelin@st.com, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH 3/4] media: stb0899: use sign_extend8 instead of manual work
Date: Wed, 14 Jan 2015 17:56:40 +0100
Message-Id: <1421254601-7242-4-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421254601-7242-1-git-send-email-martink@posteo.de>
References: <1421083370-24924-1-git-send-email-martink@posteo.de>
 <1421254601-7242-1-git-send-email-martink@posteo.de>
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

