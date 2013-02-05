Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab3BEPFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:05:00 -0500
Received: from zimbra.linbit.com ([212.69.161.123]:36492 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab3BEPE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:04:59 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com
Subject: Re: [GIT PULL] drbd build fix in case CONFIG_CRYPTO_HMAC is not set
Date: Tue, 05 Feb 2013 16:04:57 +0100
Message-ID: <2355532.pBFWGRxpbY@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-36-lowlatency; KDE/4.8.5; x86_64; ; )
In-Reply-To: <20130205131955.GT15092@kernel.dk>
References: <2148524.Qc3kYa9ye0@fat-tyre> <20130205131955.GT15092@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> NOT pulled. Base the branch off my for-linus. When I pull the below into
> that, I don't get a small patch, I get all changes from 3.7 to 3.8-rc5.

Ok, now based on your for-linus.


The following changes since commit 1383923d1985cef2bceb8128094fbe5e05de7435:

  Merge branch 'for-jens' of git://git.drbd.org/linux-drbd into for-linus (2013-01-22 08:22:11 -0700)

are available in the git repository at:


  git://git.drbd.org/linux-drbd.git for-jens-3.8-fix

for you to fetch changes up to 23c275cba16615ac8cd3815cb1a86fd64cf12aa6:

  drbd: Fix build error when CONFIG_CRYPTO_HMAC is not set (2013-02-05 15:58:34 +0100)

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


