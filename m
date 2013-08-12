Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3HLCe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:34:28 -0400
Received: from [207.46.163.25] ([207.46.163.25]:22156 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755398Ab3HLCe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:34:26 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371I542I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh2a8h668h839h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Shuah Khan <shuah.kh@samsung.com>, "cjb@laptop.org" <cjb@laptop.org>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: RE: [PATCH] mmc:bfin_sdh fix build warning in sdh_dma_irq()
Thread-Topic: [PATCH] mmc:bfin_sdh fix build warning in sdh_dma_irq()
Thread-Index: AQHOld2nN1GQX+hfH0SKTpq4gTTxV5mQ3IuQ
Date: Mon, 12 Aug 2013 02:32:51 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EE31BC1AF6@NWD2MBX7.ad.analog.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
 <1376148055-2539-4-git-send-email-shuah.kh@samsung.com>
In-Reply-To: <1376148055-2539-4-git-send-email-shuah.kh@samsung.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.99.24.94]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7C2YZJ7019569

Acked-by: Sonic Zhang<sonic.zhang@analog.com>

>-----Original Message-----
>From: Shuah Khan [mailto:shuah.kh@samsung.com]
>Sent: Saturday, August 10, 2013 11:21 PM
>To: Zhang, Sonic; cjb@laptop.org
>Cc: Shuah Khan; uclinux-dist-devel@blackfin.uclinux.org; linux-mmc@vger.kernel.org;
>linux-kernel@vger.kernel.org; shuahkhan@gmail.com
>Subject: [PATCH] mmc:bfin_sdh fix build warning in sdh_dma_irq()
>
>Fix the following build warning in sdh_dma_irq()
>drivers/mmc/host/bfin_sdh.c:466:2: warning: format   %lx   expects argument of type
>long unsigned int  , but argument 5 has type   int   [-Wformat]
>       dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04x\n", __func__,
>                get_dma_curr_irqstat(host->dma_ch));
>
>Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
>---
> drivers/mmc/host/bfin_sdh.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c index
>7b3e12f..61157c4 100644
>--- a/drivers/mmc/host/bfin_sdh.c
>+++ b/drivers/mmc/host/bfin_sdh.c
>@@ -463,7 +463,7 @@ static irqreturn_t sdh_dma_irq(int irq, void *devid)  {
>       struct sdh_host *host = devid;
>
>-      dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04lx\n", __func__,
>+      dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04x\n", __func__,
>               get_dma_curr_irqstat(host->dma_ch));
>       clear_dma_irqstat(host->dma_ch);
>       SSYNC();
>--
>1.7.10.4
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
