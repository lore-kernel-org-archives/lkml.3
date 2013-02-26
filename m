Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759894Ab3BZTfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 14:35:20 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:51164 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756797Ab3BZTfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:35:18 -0500
From: Syam Sidhardhan <syamsidhardh@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: syamsidhardh@gmail.com, mchehab@redhat.com
Subject: [PATCH] dvb-usb: Remove redundant NULL check before kfree
Date: Wed, 27 Feb 2013 01:05:01 +0530
Message-Id: <1361907301-2769-1-git-send-email-s.syam@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
 drivers/media/usb/dvb-usb/cinergyT2-fe.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
index 1efc028..c890fe4 100644
--- a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
+++ b/drivers/media/usb/dvb-usb/cinergyT2-fe.c
@@ -300,8 +300,7 @@ static int cinergyt2_fe_set_frontend(struct dvb_frontend *fe)
 static void cinergyt2_fe_release(struct dvb_frontend *fe)
 {
 	struct cinergyt2_fe_state *state = fe->demodulator_priv;
-	if (state != NULL)
-		kfree(state);
+	kfree(state);
 }
 
 static struct dvb_frontend_ops cinergyt2_fe_ops;
-- 
1.7.9.5

