Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab3JHUgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:36:41 -0400
Received: from sauhun.de ([89.238.76.85]:52224 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab3JHUgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:36:05 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] spi: spi-omap-uwire: replace platform_driver_probe to support deferred probing
Date: Tue,  8 Oct 2013 22:35:39 +0200
Message-Id: <1381264542-29396-8-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
References: <1381264542-29396-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subsystems like pinctrl and gpio rightfully make use of deferred probing at
core level. Now, deferred drivers won't be retried if they don't have a .probe
function specified in the driver struct. Fix this driver to have that, so the
devices it supports won't get lost in a deferred probe.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/spi/spi-omap-uwire.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index a6a8f09..9313fd3 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -557,7 +557,8 @@ static struct platform_driver uwire_driver = {
 		.name		= "omap_uwire",
 		.owner		= THIS_MODULE,
 	},
-	.remove		= uwire_remove,
+	.probe = uwire_probe,
+	.remove = uwire_remove,
 	// suspend ... unuse ck
 	// resume ... use ck
 };
@@ -579,7 +580,7 @@ static int __init omap_uwire_init(void)
 		omap_writel(val | 0x00AAA000, OMAP7XX_IO_CONF_9);
 	}
 
-	return platform_driver_probe(&uwire_driver, uwire_probe);
+	return platform_driver_register(&uwire_driver);
 }
 
 static void __exit omap_uwire_exit(void)
-- 
1.8.4.rc3

