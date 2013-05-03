Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763592Ab3ECUq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:46:26 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:37994 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763578Ab3ECUqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:46:25 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] [media] dib8000: Fix dib8000_set_frontend() never setting ret
Date: Fri,  3 May 2013 22:46:22 +0200
Message-Id: <1367613982-28634-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/dvb-frontends/dib8000.c: In function ‘dib8000_set_frontend’:
drivers/media/dvb-frontends/dib8000.c:3556: warning: ‘ret’ is used uninitialized in this function

Remove the variable and return zero instead.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/dvb-frontends/dib8000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/dib8000.c b/drivers/media/dvb-frontends/dib8000.c
index a54182d..9053614 100644
--- a/drivers/media/dvb-frontends/dib8000.c
+++ b/drivers/media/dvb-frontends/dib8000.c
@@ -3406,7 +3406,7 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 {
 	struct dib8000_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &state->fe[0]->dtv_property_cache;
-	int l, i, active, time, ret, time_slave = FE_CALLBACK_TIME_NEVER;
+	int l, i, active, time, time_slave = FE_CALLBACK_TIME_NEVER;
 	u8 exit_condition, index_frontend;
 	u32 delay, callback_time;
 
@@ -3553,7 +3553,7 @@ static int dib8000_set_frontend(struct dvb_frontend *fe)
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static int dib8000_read_status(struct dvb_frontend *fe, fe_status_t * stat)
-- 
1.7.0.4

