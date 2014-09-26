Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205AbaIZVYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 17:24:11 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53964 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbaIZVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 17:24:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, Mark Brown <broonie@linaro.org>,
        Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dma: imx-sdma: fix another incorrect __init annotation
Date: Fri, 26 Sep 2014 23:24 +0200
Message-ID: <38530464.3ymIRX74DK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:sdGCD2BhDn9RZe2SCg9BaS667ME6vdYn2P39GwXZVgi
 1TqQ5Te8UQw9D9piwHWLmtWQ+IGBBGTlKU31iRulxSyCFYqwph
 zJtq07prBEEx9K+/7DLuYAfpj1NN6Lp4SDIhabIWTlz/Q0i6ud
 u6buvkzzpbJ8vphov3v2Xn2t7tyA/v4MpsYOHUuqN6NhGwE1XK
 l08qf8atcOLuGFO0Wv6S/c/3cpbvevylAbGQQ1IwFOKqmTDdxh
 SaCXa+QMaL6TLJO4sWDl5qOHmrCKUqVDohol34MPmsWNMHS1/o
 1vJlzmU2tS3FCfNC7sFKAW5CkMvkiJJh2mihx6WHnGJIIdzHf6
 VAjoEST4wyGMKEwK64G8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In e34b731faa7d1 ("dma: imx-sdma: Remove spurious __init annotation on
sdma_probe()"), Mark found an extraneous __init label and fixed it.

However, he missed another one, because now we get this other warning:

WARNING: drivers/dma/imx-sdma.o(.text+0x3bb4): Section mismatch in reference from the function sdma_probe() to the function .init.text:sdma_get_firmware()
The function sdma_probe() references
the function __init sdma_get_firmware().

Same reasoning as the last time, the function may get called at
runtime, so it can't be __init.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 52ce1d21154c..88afc48c2ca7 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1334,7 +1334,7 @@ err_firmware:
 	release_firmware(fw);
 }
 
-static int __init sdma_get_firmware(struct sdma_engine *sdma,
+static int sdma_get_firmware(struct sdma_engine *sdma,
 		const char *fw_name)
 {
 	int ret;

