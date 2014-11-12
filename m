Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaKLC21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:28:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965583AbaKLBs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:48:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: [PATCH 3.14 199/203] i2c: at91: dont account as iowait
Date: Wed, 12 Nov 2014 10:17:49 +0900
Message-Id: <20141112011551.819515147@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa@the-dreams.de>

commit 11cfbfb098b22d3e57f1f2be217cad20e2d48463 upstream.

iowait is for blkio [1]. I2C shouldn't use it.

[1] https://lkml.org/lkml/2014/11/3/317

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-at91.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -434,7 +434,7 @@ static int at91_do_twi_transfer(struct a
 		}
 	}
 
-	ret = wait_for_completion_io_timeout(&dev->cmd_complete,
+	ret = wait_for_completion_timeout(&dev->cmd_complete,
 					     dev->adapter.timeout);
 	if (ret == 0) {
 		dev_err(dev->dev, "controller timed out\n");


