Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785AbaJDAag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:30:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925AbaJCVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mark Brown <broonie@linaro.org>
Subject: [PATCH 3.16 175/357] spi: dw: fix kernel crash due to NULL pointer dereference
Date: Fri,  3 Oct 2014 14:29:21 -0700
Message-Id: <20141003212938.736348968@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 08a707b87874eaaa0f336ab604ecd6e5e9f286dd upstream.

The obvious fix after the commit d9c73bb8a3a5 "spi: dw: add support for gpio
controlled chip select". This patch fixes the issue by using locally defined
temporary variable.

Fixes: d9c73bb8a3a5 (spi: dw: add support for gpio controlled chip select)
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Mark Brown <broonie@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-dw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -271,7 +271,7 @@ static void giveback(struct dw_spi *dws)
 					transfer_list);
 
 	if (!last_transfer->cs_change)
-		spi_chip_sel(dws, dws->cur_msg->spi, 0);
+		spi_chip_sel(dws, msg->spi, 0);
 
 	spi_finalize_current_message(dws->master);
 }


