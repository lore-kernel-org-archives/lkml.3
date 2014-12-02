Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933919AbaLBT1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:27:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933883AbaLBT1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:27:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Stein <alexander.stein@systec-electronic.com>,
        Mark Brown <broonie@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 030/121] spi: fsl-dspi: Fix CTAR selection
Date: Tue,  2 Dec 2014 11:18:29 -0800
Message-Id: <1417548000-1794-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@systec-electronic.com>

commit 5cc7b04740effa5cc0af53f434134b5859d58b73 upstream.

There are only 4 CTAR registers (CTAR0 - CTAR3) so we can only use the
lower 2 bits of the chip select to select a CTAR register.
SPI_PUSHR_CTAS used the lower 3 bits which would result in wrong bit values
if the chip selects 4/5 are used. For those chip selects SPI_CTAR even
calculated offsets of non-existing registers.

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-fsl-dspi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 49a7346..b8d897c 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -45,7 +45,7 @@
 
 #define SPI_TCR			0x08
 
-#define SPI_CTAR(x)		(0x0c + (x * 4))
+#define SPI_CTAR(x)		(0x0c + (((x) & 0x3) * 4))
 #define SPI_CTAR_FMSZ(x)	(((x) & 0x0000000f) << 27)
 #define SPI_CTAR_CPOL(x)	((x) << 26)
 #define SPI_CTAR_CPHA(x)	((x) << 25)
@@ -69,7 +69,7 @@
 
 #define SPI_PUSHR		0x34
 #define SPI_PUSHR_CONT		(1 << 31)
-#define SPI_PUSHR_CTAS(x)	(((x) & 0x00000007) << 28)
+#define SPI_PUSHR_CTAS(x)	(((x) & 0x00000003) << 28)
 #define SPI_PUSHR_EOQ		(1 << 27)
 #define SPI_PUSHR_CTCNT	(1 << 26)
 #define SPI_PUSHR_PCS(x)	(((1 << x) & 0x0000003f) << 16)
-- 
1.9.1

