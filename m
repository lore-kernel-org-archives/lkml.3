Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758604Ab3FDRPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:15:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48247 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab3FDQ5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 02/75] drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set
Date: Tue,  4 Jun 2013 09:54:46 -0700
Message-Id: <1370364959-9475-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit ef57f9e6bb9278720c8a5278728f252ab85d7ac6 upstream.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/drbd/drbd_receiver.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a9eccfc..6e27dde 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -4659,8 +4659,8 @@ static int drbd_do_features(struct drbd_tconn *tconn)
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
-- 
1.8.1.2

