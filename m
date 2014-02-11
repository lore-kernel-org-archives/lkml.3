Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118AbaBKUQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:16:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39984 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426AbaBKTGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:06:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonas Gorski <jogo@openwrt.org>,
        Florian Fainelli <florian@openwrt.org>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.12 036/107] spi/bcm63xx: dont substract prepend length from total length
Date: Tue, 11 Feb 2014 11:05:02 -0800
Message-Id: <20140211184749.227133361@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184748.191276235@linuxfoundation.org>
References: <20140211184748.191276235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jogo@openwrt.org>

commit 86b3bde003e6bf60ccb9c09b4115b8a2f533974c upstream.

The spi command must include the full message length including any
prepended writes, else transfers larger than 256 bytes will be
incomplete.

Signed-off-by: Jonas Gorski <jogo@openwrt.org>
Acked-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-bcm63xx.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -169,8 +169,6 @@ static int bcm63xx_txrx_bufs(struct spi_
 			       transfer_list);
 	}
 
-	len -= prepend_len;
-
 	init_completion(&bs->done);
 
 	/* Fill in the Message control register */


