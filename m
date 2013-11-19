Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab3KSOMG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:12:06 -0500
Received: from etezian.org ([198.101.225.253]:58707 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab3KSOMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:12:05 -0500
From: Andi Shyti <andi@etezian.org>
To: m.chehab@samsung.com, mkrufky@linuxtv.org, ljalvs@gmail.com, crope@iki.fi
Cc: andi@etezian.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: cx24117: use a valid dev pointer for dev_err printout
Date: Tue, 19 Nov 2013 15:11:58 +0100
Message-Id: <1384870318-27768-1-git-send-email-andi@etezian.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1384868977-24211-1-git-send-email-andi@etezian.org>
References: <1384868977-24211-1-git-send-email-andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use '&state->priv->i2c->dev' reference to device because
state is still 'NULL'. Use '&i2c->dev' instead.

This bug has been reported by scan.coverity.com

Signed-off-by: Andi Shyti <andi@etezian.org>
---

Hi,

please apply this patch after my previous patch, forgot to
format them together.

Thanks,
Andi

---
 drivers/media/dvb-frontends/cx24117.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index 07a9894..083830b 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1166,7 +1166,7 @@ struct dvb_frontend *cx24117_attach(const struct cx24117_config *config,
 
 	switch (demod) {
 	case 0:
-		dev_err(&state->priv->i2c->dev,
+		dev_err(&i2c->dev,
 			"%s: Error attaching frontend %d\n",
 			KBUILD_MODNAME, demod);
 		goto error1;
-- 
1.8.4.3

