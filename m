Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaK2Rks (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 12:40:48 -0500
Received: from mout.web.de ([212.227.15.3]:55112 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbaK2Rkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 12:40:46 -0500
Message-ID: <547A050C.5040906@users.sourceforge.net>
Date: Sat, 29 Nov 2014 18:40:28 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] SPI-txx9: Deletion of an unnecessary check before the
 function call "clk_disable"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:iOIhU4oYspCjVuBi9zsdc3iobrErwnP07z7/rt4kIcxtIJGdVqw
 3WdDbLg2FUEgmHUAkUk0kRdJgRLrw3nIzsbYl4RjWKamX/+vdhC84Zf9GzlNLjzYgsQNu7x
 wurCMuWe6Ebve0HqO+vonfW+5VaK8p8P6HffkpRhPUKPjPLQKj+S8P4vYY+XKMpzWQIiWOt
 ebYhHr8N0nCpBe0mYbQNw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 29 Nov 2014 18:34:20 +0100

The clk_disable() function tests whether its argument is NULL and then
returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/spi/spi-txx9.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-txx9.c b/drivers/spi/spi-txx9.c
index 0da7c67..9190124 100644
--- a/drivers/spi/spi-txx9.c
+++ b/drivers/spi/spi-txx9.c
@@ -402,8 +402,7 @@ exit_busy:
 exit:
 	if (c->workqueue)
 		destroy_workqueue(c->workqueue);
-	if (c->clk)
-		clk_disable(c->clk);
+	clk_disable(c->clk);
 	spi_master_put(master);
 	return ret;
 }
-- 
2.1.3

