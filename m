Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3AOUtl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 15:49:41 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55388 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989Ab3AOUtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 15:49:39 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Antti Palosaari <crope@iki.fi>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Evgeny Plehov <EvgenyPlehov@ukr.net>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] media: dvb-frontends/stv0900_core.c: remove unnecessary null pointer check
Date: Tue, 15 Jan 2013 21:48:13 +0100
Message-Id: <1358282897-8530-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address of a variable is impossible to be null, so we remove the check.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/media/dvb-frontends/stv0900_core.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index 0fb34e1..612b872 100644
--- a/drivers/media/dvb-frontends/stv0900_core.c
+++ b/drivers/media/dvb-frontends/stv0900_core.c
@@ -524,11 +524,8 @@ void stv0900_set_tuner(struct dvb_frontend *fe, u32 frequency,
 	struct dvb_frontend_ops *frontend_ops = NULL;
 	struct dvb_tuner_ops *tuner_ops = NULL;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+	frontend_ops = &fe->ops;
+	tuner_ops = &frontend_ops->tuner_ops;
 
 	if (tuner_ops->set_frequency) {
 		if ((tuner_ops->set_frequency(fe, frequency)) < 0)
-- 
1.7.10.4

