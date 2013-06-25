Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab3FYSee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:34:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41188 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3FYSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:34:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [ 94/95] spi/pxa2xx: use GFP_ATOMIC in sg table allocation
Date: Tue, 25 Jun 2013 11:33:21 -0700
Message-Id: <20130625182204.273910254@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 5548f98c46538d1da04eff179a52e50537d11465 upstream.

pxa2xx_spi_map_dma_buffer() gets called in tasklet context so we can't
sleep when we allocate a new sg table. Use GFP_ATOMIC here instead.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pxa2xx-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-pxa2xx-dma.c
+++ b/drivers/spi/spi-pxa2xx-dma.c
@@ -59,7 +59,7 @@ static int pxa2xx_spi_map_dma_buffer(str
 		int ret;
 
 		sg_free_table(sgt);
-		ret = sg_alloc_table(sgt, nents, GFP_KERNEL);
+		ret = sg_alloc_table(sgt, nents, GFP_ATOMIC);
 		if (ret)
 			return ret;
 	}


