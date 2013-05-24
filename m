Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964Ab3EXCvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 22:51:03 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:28352 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759671Ab3EXCvA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 22:51:00 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz9371I542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Libo Chen <libo.chen@huawei.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>
CC: "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>
Subject: RE: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
Thread-Topic: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
Thread-Index: AQHOV61VKrVzWXmFgUal2R2gwcOch5kTnxWg
Date: Fri, 24 May 2013 02:49:35 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EE010634@NWD2MBX7.ad.analog.com>
References: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.64.72.242]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Libo,

>-----Original Message-----
>From: Libo Chen [mailto:libo.chen@huawei.com]
>Sent: Thursday, May 23, 2013 8:00 PM
>To: wsa@the-dreams.de
>Cc: guz.fnst@cn.fujitsu.com; Zhang, Sonic; uclinux-dist-
>devel@blackfin.uclinux.org; linux-i2c@vger.kernel.org; linux-
>kernel@vger.kernel.org; lizefan@huawei.com; libo.chen@huawei.com
>Subject: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
>
>peripheral_request_list has got free if any one faild, so no need to free again in err
>case.
>aovid this, convert them to devm_* API
>
>Signed-off-by: Libo Chen <libo.chen@huawei.com>
>---
> drivers/i2c/busses/i2c-bfin-twi.c |   38 +++++++++---------------------------
> 1 files changed, 10 insertions(+), 28 deletions(-)
>
>diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
>index 05080c4..2b99c48 100644
>--- a/drivers/i2c/busses/i2c-bfin-twi.c
>+++ b/drivers/i2c/busses/i2c-bfin-twi.c
>@@ -621,35 +621,27 @@ static int i2c_bfin_twi_probe(struct platform_device
>*pdev)
>       int rc;
>       unsigned int clkhilow;
>
>-      iface = kzalloc(sizeof(struct bfin_twi_iface), GFP_KERNEL);
>+      iface = devm_kzalloc(&pdev->dev, sizeof(struct bfin_twi_iface),
>+                      GFP_KERNEL);
>       if (!iface) {
>               dev_err(&pdev->dev, "Cannot allocate memory\n");
>-              rc = -ENOMEM;
>-              goto out_error_nomem;
>+              return -ENOMEM;
>       }
>
>       spin_lock_init(&(iface->lock));
>
>       /* Find and map our resources */
>       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>-      if (res == NULL) {
>-              dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
>-              rc = -ENOENT;
>-              goto out_error_get_res;
>-      }

Why remove the resource mem check?

Regards,

Sonic

