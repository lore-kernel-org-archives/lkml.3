Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab3BDR0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 12:26:00 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:52311 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3BDRZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 12:25:59 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: [GIT PULL] drbd build fix in case CONFIG_CRYPTO_HMAC is not set
Date: Mon, 04 Feb 2013 18:25:56 +0100
Message-ID: <2148524.Qc3kYa9ye0@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-36-lowlatency; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit d88c3ab963d4cce09b25ef661b871bd7af6dad0d:

  drbd: only fail empty flushes if no good data is reachable (2013-01-30 10:40:33 +0100)

are available in the git repository at:

  git://git.drbd.org/linux-drbd.git for-jens-3.8-fix

for you to fetch changes up to 78aa7987a223e8542f2735dace439690c6171ac5:

  drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set (2013-02-04 18:14:03 +0100)

----------------------------------------------------------------
Philipp Reisner (1):
      drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set

 drivers/block/drbd/drbd_receiver.c |    4 ++--
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

