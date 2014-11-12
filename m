Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932916AbaKLBa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:30:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbaKLBaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:30:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.17 212/319] spi: fsl-dspi: Fix CTAR selection
Date: Wed, 12 Nov 2014 10:15:50 +0900
Message-Id: <20141112011027.910148050@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-fsl-dspi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -46,7 +46,7 @@
 
 #define SPI_TCR			0x08
 
-#define SPI_CTAR(x)		(0x0c + (x * 4))
+#define SPI_CTAR(x)		(0x0c + (((x) & 0x3) * 4))
 #define SPI_CTAR_FMSZ(x)	(((x) & 0x0000000f) << 27)
 #define SPI_CTAR_CPOL(x)	((x) << 26)
 #define SPI_CTAR_CPHA(x)	((x) << 25)
@@ -70,7 +70,7 @@
 
 #define SPI_PUSHR		0x34
 #define SPI_PUSHR_CONT		(1 << 31)
-#define SPI_PUSHR_CTAS(x)	(((x) & 0x00000007) << 28)
+#define SPI_PUSHR_CTAS(x)	(((x) & 0x00000003) << 28)
 #define SPI_PUSHR_EOQ		(1 << 27)
 #define SPI_PUSHR_CTCNT	(1 << 26)
 #define SPI_PUSHR_PCS(x)	(((1 << x) & 0x0000003f) << 16)


