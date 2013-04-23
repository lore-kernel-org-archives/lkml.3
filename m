Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab3DWQcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49313 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab3DWQcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Barry Song <Baohua.Song@csr.com>
Subject: [PATCH 09/21] spi/sirf: fix MODULE_DEVICE_TABLE
Date: Tue, 23 Apr 2013 18:30:41 +0200
Message-Id: <1366734653-488286-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:xgxhGcysIoh+6clnktDUTuxzNW80PgHGX6IcpL6AFbo
 pflsubp+eorY4Hxlr8qhf4VamXsQ5fRpbol/C/k5c4mpQEOOoj
 9KsLXD92gNUbR+ftQwWUacvuZJO6Ya1Tz0Kj3aIDgCSErD9/5X
 KRN2MAJNd341Has0swGWUWG1NlFasCMX+qfJmMNVNHAjmya/MQ
 MPfiSUZUyfp5ektxaWEJuq2AL11hbp2bN+czSGhN0/xOvR2lB6
 y+AdlMntoIgWVzFeALgGlvvow8i1gwwaeA8kgNDgRV2LfozCrF
 0ABhoXBl2ChRoXdAEIwZEHRH7tHyFZU17TTki/X7HeGaqjU5As
 gMxQ5svwzF2xN0pHIz8cT0GJz/zdNOSw6CooSj9W7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes building the spi-sirf driver as a loadable module, which uses
an incorrect MODULE_DEVICE_TABLE, by changing the reference to the
correct symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@kernel.org>
Cc: spi-devel-general@lists.sourceforge.net
Cc: Barry Song <Baohua.Song@csr.com>
---
 drivers/spi/spi-sirf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-sirf.c b/drivers/spi/spi-sirf.c
index f59d417..0808cd5 100644
--- a/drivers/spi/spi-sirf.c
+++ b/drivers/spi/spi-sirf.c
@@ -660,7 +660,7 @@ static const struct of_device_id spi_sirfsoc_of_match[] = {
 	{ .compatible = "sirf,marco-spi", },
 	{}
 };
-MODULE_DEVICE_TABLE(of, sirfsoc_spi_of_match);
+MODULE_DEVICE_TABLE(of, spi_sirfsoc_of_match);
 
 static struct platform_driver spi_sirfsoc_driver = {
 	.driver = {
-- 
1.8.1.2

