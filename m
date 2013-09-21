Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3IUW3C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 18:29:02 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:60461 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3IUW2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 18:28:40 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: m.chehab@samsung.com
Cc: hfvogt@gmx.net, crope@iki.fi, peter.senna@gmail.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 05/19] media: Change variable type to bool
Date: Sun, 22 Sep 2013 00:27:37 +0200
Message-Id: <1379802471-30252-5-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable vco_select is only assigned the values true and false.
Change its type to bool.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@exists@
type T;
identifier b;
@@
- T
+ bool
  b = ...;
  ... when any
  b = \(true\|false\)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/tuners/fc0012.c | 2 +-
 drivers/media/tuners/fc0013.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/tuners/fc0012.c b/drivers/media/tuners/fc0012.c
index f4d0e79..d74e920 100644
--- a/drivers/media/tuners/fc0012.c
+++ b/drivers/media/tuners/fc0012.c
@@ -139,7 +139,7 @@ static int fc0012_set_params(struct dvb_frontend *fe)
 	unsigned char reg[7], am, pm, multi, tmp;
 	unsigned long f_vco;
 	unsigned short xtal_freq_khz_2, xin, xdiv;
-	int vco_select = false;
+	bool vco_select = false;
 
 	if (fe->callback) {
 		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
diff --git a/drivers/media/tuners/fc0013.c b/drivers/media/tuners/fc0013.c
index bd8f0f1..b416231 100644
--- a/drivers/media/tuners/fc0013.c
+++ b/drivers/media/tuners/fc0013.c
@@ -233,7 +233,7 @@ static int fc0013_set_params(struct dvb_frontend *fe)
 	unsigned char reg[7], am, pm, multi, tmp;
 	unsigned long f_vco;
 	unsigned short xtal_freq_khz_2, xin, xdiv;
-	int vco_select = false;
+	bool vco_select = false;
 
 	if (fe->callback) {
 		ret = fe->callback(priv->i2c, DVB_FRONTEND_COMPONENT_TUNER,
-- 
1.8.3.1

