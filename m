Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaDVG5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:57:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12523 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaDVG5a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:57:30 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-51-535612d81668
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Fariya Fatima'" <fariyaf@gmail.com>,
        "'John W. Linville'" <linville@tuxdriver.com>,
        "'Chris Ball'" <chris@printf.net>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Subject: [PATCH] linux-next: rsi: fix using of removed stuff from mmc
Date: Tue, 22 Apr 2014 15:57:28 +0900
Message-id: <000c01cf5df8$1fecf810$5fc6e830$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9d+B9bVJ93/DIISpuD3zPohcsW7Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zY90bQmHBBgfeGVtMuLyd0aJh0hNW
	ixu/2lgtLu+aw2Zx5H8/o8XBhW2MFlt7JCy27r3KbnF8bbgDp0fjjRtsHjtn3WX3uHNtD5vH
	jVcLmTz6tqxi9LjyfTWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZkw48Zy/4z1Mx68NK9gbGp1xd
	jJwcEgImEn2LDrJB2GISF+6tB7K5OIQEljFKrOl5xdLFyAFW9GenI0R8EaNE+4pFTBDOH0aJ
	rqtnGUG62QS0JP6+ecMMkhABSezqaWMCSTALRErsnH4ZzBYWcJXYdfAhM4jNIqAqcftaB1ic
	V8BWYvHMk8wQtqDEj8n3wDYzC6hLTJmSCzFGW+LJuwusEAepSzz6qwsSFhHQk/j6YznUJhGJ
	fS/eMYKcICHwll2iZe5UqFUCEt8mH4J6RlZi0wFmiIclJQ6uuMEygVFsFpLFsxAWz0KyeBaS
	DQsYWVYxiqYWJBcUJ6UXmeoVJ+YWl+al6yXn525ihMTrxB2M9w9YH2JMBto+kVlKNDkfGO95
	JfGGxmZGFqYmpsZG5pZmpAkrifOmP0oKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBoudh2
	89xjL/ZadE9XNzvB6dEyMyaqwvrDxkw5TwPPdPZvOh836pSeYJq4JeiWbrb0JSXOxuSb266z
	tzy2fKCay2mWm7VvtnbovvtCPK+dne5P1vjANPOydJfqu5kc8kdV1J47FC1W/Rn427E9UPcz
	9/TtB8O3GR41dJLt+2hqraGcHaIU6KDEUpyRaKjFXFScCAB08WYU7QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jAd0bQmHBBvcm6FtMuLyd0aJh0hNW
	ixu/2lgtLu+aw2Zx5H8/o8XBhW2MFlt7JCy27r3KbnF8bbgDp0fjjRtsHjtn3WX3uHNtD5vH
	jVcLmTz6tqxi9LjyfTWjx+dNcgHsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaW
	FuZKCnmJuam2Si4+AbpumTlAlykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkAD
	CesYMyYdeM5e8J+nYtaHlewNjE+5uhg5OCQETCT+7HTsYuQEMsUkLtxbz9bFyMUhJLCIUaJ9
	xSImCOcPo0TX1bOMIFVsAloSf9+8YQZJiIAkdvW0MYEkmAUiJXZOvwxmCwu4Suw6+JAZxGYR
	UJW4fa0DLM4rYCuxeOZJZghbUOLH5HssIFcwC6hLTJmSCzFGW+LJuwusEMepSzz6qwsSFhHQ
	k/j6YznUJhGJfS/eMU5gFJiFZNAshEGzkAyahaRjASPLKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzgZPBMegfjqgaLQ4wCHIxKPLwSBqHBQqyJZcWVuYcYJTiYlUR40/8AhXhTEiurUovy
	44tKc1KLDzEmA705kVlKNDkfmKjySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2a
	WpBaBLOFiYNTqoFRIDvnosn733+DXZO3pH0KCNmk5rZ1V2Esy46QLYnG0z2YfQ6dP31i+nH5
	vjfi84pkNd8f8XM9uSeYc0vGg3nvn0256sd0ZbKGyOLWE97LODZdXLnMozh6y/0vWe4LjNz7
	9opPmhATp36/VKrluZ4V/85zH24Yy+p/zz579Jq3XDpHgdbP3/wGSizFGYmGWsxFxYkAp2SE
	CkoDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As commit 3957848(mmc: drop the speed mode of card's state) applies,
this change should be followed.

drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED' undeclared (first use in this function)
drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration of function 'mmc_card_set_highspeed' [-Werror=implicit-function-declaration]
drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration of function 'mmc_card_highspeed' [-Werror=implicit-function-declaration]

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 2e39d38..46e7af4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -285,7 +285,6 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 		if (err) {
 			rsi_dbg(ERR_ZONE, "%s: CCCR speed reg read failed: %d\n",
 				__func__, err);
-			card->state &= ~MMC_STATE_HIGHSPEED;
 		} else {
 			err = rsi_cmd52writebyte(card,
 						 SDIO_CCCR_SPEED,
@@ -296,14 +295,13 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 					__func__, err);
 				return;
 			}
-			mmc_card_set_highspeed(card);
 			host->ios.timing = MMC_TIMING_SD_HS;
 			host->ops->set_ios(host, &host->ios);
 		}
 	}
 
 	/* Set clock */
-	if (mmc_card_highspeed(card))
+	if (mmc_card_hs(card))
 		clock = 50000000;
 	else
 		clock = card->cis.max_dtr;
-- 
1.7.0.4


