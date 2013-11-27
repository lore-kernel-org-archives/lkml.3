Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab3K0Wi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 17:38:59 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:53630 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755397Ab3K0Wi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 17:38:57 -0500
From: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Vincent=20Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        Wolfram Sang <wsa@the-dreams.de>, trivial@kernel.org
Subject: [PATCH] i2c: bcm-kona: fix module device table symbol
Date: Wed, 27 Nov 2013 23:38:40 +0100
Message-Id: <1385591920-7714-1-git-send-email-vincent.stehle@laposte.net>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following compilation error when compiling in module:

  drivers/i2c/busses/i2c-bcm-kona.c:894:1: error: ‘__mod_of_device_table’ aliased to undefined symbol ‘kona_i2c_of_match’

Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
Cc: Wolfram Sang <wsa@the-dreams.de>
Cc: trivial@kernel.org
---

Hi,

Compilation breakage can be seen on mainline with e.g. arm allmodconfig.

Best regards,

V.

 drivers/i2c/busses/i2c-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-bcm-kona.c b/drivers/i2c/busses/i2c-bcm-kona.c
index 036cf03..2fefc24 100644
--- a/drivers/i2c/busses/i2c-bcm-kona.c
+++ b/drivers/i2c/busses/i2c-bcm-kona.c
@@ -891,7 +891,7 @@ static const struct of_device_id bcm_kona_i2c_of_match[] = {
 	{.compatible = "brcm,kona-i2c",},
 	{},
 };
-MODULE_DEVICE_TABLE(of, kona_i2c_of_match);
+MODULE_DEVICE_TABLE(of, bcm_kona_i2c_of_match);
 
 static struct platform_driver bcm_kona_i2c_driver = {
 	.driver = {
-- 
1.8.4.3

