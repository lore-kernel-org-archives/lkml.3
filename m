Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaFPPda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 11:33:30 -0400
Received: from cpanel09.rubas.ch ([195.182.222.79]:57360 "EHLO
	cpanel09.rubas.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbaFPPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 11:33:29 -0400
X-Greylist: delayed 3185 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Jun 2014 11:33:28 EDT
From: =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>
Subject: [PATCH] spi: sh-sci: fix use-after-free in sh_sci_spi_remove()
Date: Mon, 16 Jun 2014 16:39:29 +0200
Message-Id: <1402929569-14500-1-git-send-email-j@bitron.ch>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel09.rubas.ch
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - bitron.ch
X-Get-Message-Sender-Via: cpanel09.rubas.ch: authenticated_id: juerg@bitron.ch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

setbits() uses sp->membase.

Signed-off-by: Jürg Billeter <j@bitron.ch>
---
 drivers/spi/spi-sh-sci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-sh-sci.c b/drivers/spi/spi-sh-sci.c
index 1f56ef6..b83dd73 100644
--- a/drivers/spi/spi-sh-sci.c
+++ b/drivers/spi/spi-sh-sci.c
@@ -175,9 +175,9 @@ static int sh_sci_spi_remove(struct platform_device *dev)
 {
 	struct sh_sci_spi *sp = platform_get_drvdata(dev);
 
-	iounmap(sp->membase);
-	setbits(sp, PIN_INIT, 0);
 	spi_bitbang_stop(&sp->bitbang);
+	setbits(sp, PIN_INIT, 0);
+	iounmap(sp->membase);
 	spi_master_put(sp->bitbang.master);
 	return 0;
 }
-- 
2.0.0

