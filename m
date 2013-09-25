Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab3IYAQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:16:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222Ab3IYAQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:16:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [ 081/110] media: mb86a20s: Fix TS parallel mode
Date: Tue, 24 Sep 2013 17:15:19 -0700
Message-Id: <20130925001332.186700909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001323.387158698@linuxfoundation.org>
References: <20130925001323.387158698@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit 9d32069faacdc81fe1dcb5d297c32a3ac81da8f0 upstream.

changeset 768e6dadd74 caused a regression on using mb86a20s
in parallel mode, as the parallel mode selection got
overriden by mb86a20s_init2.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/mb86a20s.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -157,7 +157,6 @@ static struct regdata mb86a20s_init2[] =
 	{ 0x45, 0x04 },				/* CN symbol 4 */
 	{ 0x48, 0x04 },				/* CN manual mode */
 
-	{ 0x50, 0xd5 }, { 0x51, 0x01 },		/* Serial */
 	{ 0x50, 0xd6 }, { 0x51, 0x1f },
 	{ 0x50, 0xd2 }, { 0x51, 0x03 },
 	{ 0x50, 0xd7 }, { 0x51, 0xbf },
@@ -1860,16 +1859,15 @@ static int mb86a20s_initfe(struct dvb_fr
 	dev_dbg(&state->i2c->dev, "%s: IF=%d, IF reg=0x%06llx\n",
 		__func__, state->if_freq, (long long)pll);
 
-	if (!state->config->is_serial) {
+	if (!state->config->is_serial)
 		regD5 &= ~1;
 
-		rc = mb86a20s_writereg(state, 0x50, 0xd5);
-		if (rc < 0)
-			goto err;
-		rc = mb86a20s_writereg(state, 0x51, regD5);
-		if (rc < 0)
-			goto err;
-	}
+	rc = mb86a20s_writereg(state, 0x50, 0xd5);
+	if (rc < 0)
+		goto err;
+	rc = mb86a20s_writereg(state, 0x51, regD5);
+	if (rc < 0)
+		goto err;
 
 	rc = mb86a20s_writeregdata(state, mb86a20s_init2);
 	if (rc < 0)


