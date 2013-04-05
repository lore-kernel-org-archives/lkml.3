Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161078Ab3DEBsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:48:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17880 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932335Ab3DEBsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:48:19 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-28-515e2d6206a4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
In-reply-to: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
Subject: [PATCH 3/7] rtc: rtc-r9701: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:48:17 +0900
Message-id: <000301ce319f$a4f58d00$eee0a700$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xn4fH39zvwb7bR32L9HOXANRbigAABL9w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI90k3bhAg8fH2C2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKeH/7NmPBEdaKdb/WsDYwHmPpYuTkkBAwkfg6aQ0rhC0mceHeerYuRi4OIYFljBLn
	G26ywRStmnSRBSKxiFHi0sW3UFW/GCWuvnrHDlLFJqAm8eXLYSCbg0NEQF+irUUDpIZZoJdR
	4kzvbrAaIQFbidV/esBWcwrYSXydt4ERxBYWsJJYOHUbWA2LgKrEkz8bwDbzAtX/nPmCFcIW
	lPgx+R5YL7OAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcX4gQjidYGLogKEYl9L94xgpwjIXCL
	XeLhll4WiFUCEt8mH2KBaJWV2HSAGeJfSYmDK26wTGCUmIVk8Swki2chWTwLyYoFjCyrGEVT
	C5ILipPSi4z1ihNzi0vz0vWS83M3MUIitX8H490D1ocYk4HWT2SWEk3OB0Z6Xkm8obGZkYWp
	iamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYt67nP53y4Jy88k2h
	Fq3CzYXbT13e6Wwcc+Q+V3wwX0L+k461Lt0NS27aLymQ8lnw3uBDq+uk1mq7kDnH5Jm0djnt
	Xd5y9G3tyuTDsUqet9W25wkem1vkFXnfwvh4zbKUNYf7dJ+tmnrAQqJKfNPsBUUNbT9+3PXr
	zOTa0BaZx39HW0k4aeonJZbijERDLeai4kQAcGZjiOoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd0k3bhAg1MHmS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHh/+zZjwRHWinW/1rA2MB5j6WLk5JAQMJFY
	NekilC0mceHeerYuRi4OIYFFjBKXLr6Fcn4xSlx99Y4dpIpNQE3iy5fDQDYHh4iAvkRbiwZI
	DbNAL6PEmd7dYDVCArYSq//0gE3lFLCT+DpvAyOILSxgJbFw6jawGhYBVYknfzawgdi8QPU/
	Z75ghbAFJX5MvgfWyyygJbF+53EmCFteYvOat8wgeyUE1CUe/dWFOMFIorWBC6JCRGLfi3eM
	ExiFZiEZNAvJoFlIBs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAaeCa9g3FV
	g8UhRgEORiUe3oy+2EAh1sSy4srcQ4wSHMxKIrw7+eIChXhTEiurUovy44tKc1KLDzEmA/05
	kVlKNDkfmKLySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoFR
	nzk7kvH6MQ1W5vcTfU7LOew8euyPRLrh/2Tr5bX5H673fr+3/r1Zo6zdxNfSCw7MXmU6f/ur
	ypAlbcfNbXxq2q1D46PLfm6q/5vYvCKnl2/PyXP2std7jif8yvy0b3PfjIZ4/2rfhMYf2vEq
	p73n/vC29bHN2tJgf1B9beMyz0XCkxvlphYqsRRnJBpqMRcVJwIAPw8hXkcDAAA=
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
 drivers/rtc/rtc-r9701.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-r9701.c b/drivers/rtc/rtc-r9701.c
index 0adf5b5..feeedbd 100644
--- a/drivers/rtc/rtc-r9701.c
+++ b/drivers/rtc/rtc-r9701.c
@@ -159,7 +159,7 @@ static int r9701_probe(struct spi_device *spi)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-	dev_set_drvdata(&spi->dev, rtc);
+	spi_set_drvdata(spi, rtc);
 
 	return 0;
 }
-- 
1.7.2.5


