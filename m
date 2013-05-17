Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab3EQVpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:45:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54318 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216Ab3EQVhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 077/102] drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set
Date: Fri, 17 May 2013 14:36:32 -0700
Message-Id: <20130517213252.417144362@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit ef57f9e6bb9278720c8a5278728f252ab85d7ac6 upstream.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4659,8 +4659,8 @@ static int drbd_do_features(struct drbd_
 #if !defined(CONFIG_CRYPTO_HMAC) && !defined(CONFIG_CRYPTO_HMAC_MODULE)
 static int drbd_do_auth(struct drbd_tconn *tconn)
 {
-	dev_err(DEV, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
-	dev_err(DEV, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
+	conn_err(tconn, "This kernel was build without CONFIG_CRYPTO_HMAC.\n");
+	conn_err(tconn, "You need to disable 'cram-hmac-alg' in drbd.conf.\n");
 	return -1;
 }
 #else


