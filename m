Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3AOVHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 16:07:10 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:38379 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637Ab3AOVHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 16:07:08 -0500
Date: Tue, 15 Jan 2013 22:07:02 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>, Antti Palosaari <crope@iki.fi>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Evgeny Plehov <EvgenyPlehov@ukr.net>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v] media: dvb-frontends: remove unnecessary null pointer check
Message-ID: <20130115210700.GA12272@gmail.com>
References: <1358282897-8530-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358282897-8530-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address of a variable is impossible to be null, so we remove the check.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
sorry for sending again. I didn't notice there are another 2 places with the
same issue.
 - cong

 drivers/media/dvb-frontends/stv0900_core.c |   14 ++++----------
 drivers/media/dvb-frontends/stv0900_sw.c   |    7 ++-----
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/media/dvb-frontends/stv0900_core.c b/drivers/media/dvb-frontends/stv0900_core.c
index 0fb34e1..e5a87b5 100644
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
@@ -552,11 +549,8 @@ void stv0900_set_bandwidth(struct dvb_frontend *fe, u32 bandwidth)
 	struct dvb_frontend_ops *frontend_ops = NULL;
 	struct dvb_tuner_ops *tuner_ops = NULL;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+	frontend_ops = &fe->ops;
+	tuner_ops = &frontend_ops->tuner_ops;
 
 	if (tuner_ops->set_bandwidth) {
 		if ((tuner_ops->set_bandwidth(fe, bandwidth)) < 0)
diff --git a/drivers/media/dvb-frontends/stv0900_sw.c b/drivers/media/dvb-frontends/stv0900_sw.c
index 4af2078..0a40edf 100644
--- a/drivers/media/dvb-frontends/stv0900_sw.c
+++ b/drivers/media/dvb-frontends/stv0900_sw.c
@@ -1167,11 +1167,8 @@ static u32 stv0900_get_tuner_freq(struct dvb_frontend *fe)
 	struct dvb_tuner_ops *tuner_ops = NULL;
 	u32 freq = 0;
 
-	if (&fe->ops)
-		frontend_ops = &fe->ops;
-
-	if (&frontend_ops->tuner_ops)
-		tuner_ops = &frontend_ops->tuner_ops;
+	frontend_ops = &fe->ops;
+	tuner_ops = &frontend_ops->tuner_ops;
 
 	if (tuner_ops->get_frequency) {
 		if ((tuner_ops->get_frequency(fe, &freq)) < 0)
-- 
1.7.10.4

