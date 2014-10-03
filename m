Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933773AbaJDAbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:31:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbaJCVmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Jorge A. Ventura" <jorge.araujo.ventura@gmail.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 174/357] spi/omap-mcspi: Fix the spi task hangs waiting dma_rx
Date: Fri,  3 Oct 2014 14:29:20 -0700
Message-Id: <20141003212938.707205922@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Jorge A. Ventura" <jorge.araujo.ventura@gmail.com>

commit 3d0763c006f8da1b44a9f5f9a21187f5b8f674f4 upstream.

The spi hangs waiting the completion of omap2_mcspi_rx_callback.

Signed-off-by: Jorge A. Ventura <jorge.araujo.ventura@gmail.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-omap2-mcspi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -329,7 +329,8 @@ static void omap2_mcspi_set_fifo(const s
 disable_fifo:
 	if (t->rx_buf != NULL)
 		chconf &= ~OMAP2_MCSPI_CHCONF_FFER;
-	else
+
+	if (t->tx_buf != NULL)
 		chconf &= ~OMAP2_MCSPI_CHCONF_FFET;
 
 	mcspi_write_chconf0(spi, chconf);


