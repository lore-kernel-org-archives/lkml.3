Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964839Ab3DEB4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:56:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12904 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab3DEB4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:56:06 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-a0-515e2f34d7d4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000b01ce31a0$a9cc7400$fd655c00$%han@samsung.com>
In-reply-to: <000b01ce31a0$a9cc7400$fd655c00$%han@samsung.com>
Subject: [PATCH 2/3] misc: eeprom_93xx46: use spi_get_drvdata() and
 spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:56:04 +0900
Message-id: <000c01ce31a0$baebb160$30c31420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xoKm1XjxbSUlOS4SxFc1W0tdNQgAAAXBA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zQ10T/bhAg8sLRC2aF69ns7i88BKr
	xeVdc9gcmD32z13D7tG3ZRWjx+dNcgHMUVw2Kak5mWWpRfp2CVwZd359Zy/o5qqYfFK1gXEP
	RxcjJ4eEgIlEw7pTLBC2mMSFe+vZuhi5OIQEljFKXDjwkQ2m6PncW4wQiemMEpOPHmSCcH4x
	Srw+voAdpIpNQE3iy5fDYLaIgKnExvdTgDo4OJgFXCSOThMBCQsJ2Epc3P4BrIRTwE7izuq3
	TCC2sEC4xMlLE5lBbBYBVYmXJ9eAXcQLVL9v/R5GCFtQ4sfke2BxZgEtifU7jzNB2PISm9e8
	ZQZZJSGgLvHory7EBUYSPY/2MUOUiEjse/GOEeKXQ+wS82dFQawSkPg2+RALRKusxKYDzBAl
	khIHV9xgmcAoMQvJ4llIFs9CsngWkg0LGFlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYoRE
	38QdjPcPWB9iTAZaP5FZSjQ5Hxi9eSXxhsZmRhamJqbGRuaWZqQJK4nzqrdYBwoJpCeWpGan
	phakFsUXleakFh9iZOLglGpgnP14qrzNvfy5Itcbohf3PNAv0JvfEDzJ99TvBqe+S/FmllVl
	TwpeKd5I3lJw64X7hgR3adGivw+fCN1wm8q8XjNfbrEr906TGU+Pmv3pLryfYJjzwqq+de2V
	V48a9+zkVrJvyV21/J+8cHCwV+z1qT8fb4no1epqu6R3bN432xvGsVknD4lWKrEUZyQaajEX
	FScCAAcL1GbUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV0T/bhAg9YJghbNi9ezWVxeeInV
	4vKuOWwOzB77565h9+jbsorR4/MmuQDmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjDu/vrMXdHNVTD6p2sC4h6OLkZNDQsBE4vncW4wQtpjEhXvr2boYuTiEBKYzSkw+
	epAJwvnFKPH6+AJ2kCo2ATWJL18Og9kiAqYSG99PAerm4GAWcJE4Ok0EJCwkYCtxcfsHsBJO
	ATuJO6vfMoHYwgLhEicvTWQGsVkEVCVenlzDAmLzAtXvW7+HEcIWlPgx+R5YnFlAS2L9zuNM
	ELa8xOY1b5lBVkkIqEs8+qsLcYGRRM+jfcwQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYws
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCo/uZ1A7GlQ0WhxgFOBiVeHgz+mIDhVgTy4or
	cw8xSnAwK4nw7uSLCxTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGDiySuJNzQ2MTOyNDKz
	MDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGxpC/W4vT7/JaslbzevBFzXDfpdm/
	bSvftkyrihkW63bty9wTdDtq8R69xaLnn1w8cWRF1KRpGzw9J4R/yi/nkFyXpeS4KuoN97WJ
	FbU3daZ4nC/cOek52/uwS8ncQscPrjI8J7X/PUuZbrJwtNn3N8udrTMuH3voJ/d1js0SPo0Z
	ycvMX3NnHldiKc5INNRiLipOBAAyjz34MgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/misc/eeprom/eeprom_93xx46.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index a6b5d5e..94cfc12 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -363,7 +363,7 @@ static int eeprom_93xx46_probe(struct spi_device *spi)
 			dev_err(&spi->dev, "can't create erase interface\n");
 	}
 
-	dev_set_drvdata(&spi->dev, edev);
+	spi_set_drvdata(spi, edev);
 	return 0;
 fail:
 	kfree(edev);
@@ -372,13 +372,13 @@ fail:
 
 static int eeprom_93xx46_remove(struct spi_device *spi)
 {
-	struct eeprom_93xx46_dev *edev = dev_get_drvdata(&spi->dev);
+	struct eeprom_93xx46_dev *edev = spi_get_drvdata(spi);
 
 	if (!(edev->pdata->flags & EE_READONLY))
 		device_remove_file(&spi->dev, &dev_attr_erase);
 
 	sysfs_remove_bin_file(&spi->dev.kobj, &edev->bin);
-	dev_set_drvdata(&spi->dev, NULL);
+	spi_set_drvdata(spi, NULL);
 	kfree(edev);
 	return 0;
 }
-- 
1.7.2.5


