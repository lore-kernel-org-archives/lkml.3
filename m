Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935992Ab3BOPwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 10:52:46 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:22440 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759267Ab3BOPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 10:52:45 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        spi-devel-general@lists.sourceforge.net,
        Mingkai Hu <Mingkai.hu@freescale.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Joakim Tjernlund <Joakim.Tjernlund@transmode.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v3 2/7] spi: spi-fsl-spi: Make sure in spi_fsl_setup that chipselect becomes inactive
Date: Fri, 15 Feb 2013 16:52:22 +0100
Message-Id: <1360943547-2186-3-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1360943547-2186-1-git-send-email-andreas@gaisler.com>
References: <1360943547-2186-1-git-send-email-andreas@gaisler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is needed for a device in SPI_CS_HIGH mode that otherwise could start out
active for the first transaction.

Acked-by: Anton Vorontsov <anton@enomsg.org>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/spi/spi-fsl-spi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index cf1cffb..527ac35 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -387,6 +387,10 @@ static int fsl_spi_setup(struct spi_device *spi)
 		cs->hw_mode = hw_mode; /* Restore settings */
 		return retval;
 	}
+
+	/* Initialize chipselect - might be active for SPI_CS_HIGH mode */
+	fsl_spi_chipselect(spi, BITBANG_CS_INACTIVE);
+
 	return 0;
 }
 
-- 
1.7.0.4

