Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaBRWra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:47:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbaBRWr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andi Shyti <andi@etezian.org>, Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.13 30/40] [media] cx24117: use a valid dev pointer for dev_err printout
Date: Tue, 18 Feb 2014 14:47:31 -0800
Message-Id: <20140218224434.185360256@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andi Shyti <andi@etezian.org>

commit a33dd5171d141c378df498aba3fa3c9a573cacb6 upstream.

Don't use '&state->priv->i2c->dev' reference to device because
state is still 'NULL'. Use '&i2c->dev' instead.

This bug has been reported by scan.coverity.com

Signed-off-by: Andi Shyti <andi@etezian.org>
Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/dvb-frontends/cx24117.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1166,7 +1166,7 @@ struct dvb_frontend *cx24117_attach(cons
 
 	switch (demod) {
 	case 0:
-		dev_err(&state->priv->i2c->dev,
+		dev_err(&i2c->dev,
 			"%s: Error attaching frontend %d\n",
 			KBUILD_MODNAME, demod);
 		goto error1;


