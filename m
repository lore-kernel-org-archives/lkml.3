Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab3EIFYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 01:24:14 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:33240
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750905Ab3EIFYM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 01:24:12 -0400
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 May 2013 01:24:11 EDT
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(z5105h2005kz9371I1433M542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1155h)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>
CC: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Li Zefan <lizefan@huawei.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [uclinux-dist-devel] [PATCH 1/2] i2c: i2c-bfin-twi: don`t free
 peripheral before it`s init successful
Thread-Topic: [uclinux-dist-devel] [PATCH 1/2] i2c: i2c-bfin-twi: don`t free
 peripheral before it`s init successful
Thread-Index: AQHOTAe0uPKJ5kakBUmcPyQKtHRxAZj8TRgQ
Date: Thu, 9 May 2013 05:07:48 +0000
Message-ID: <B168F8A49F4BCF4C84FD23DA5F6363EEA618@NWD2MBX7.ad.analog.com>
References: <5187ABF6.4000907@huawei.com>
In-Reply-To: <5187ABF6.4000907@huawei.com>
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
>From: uclinux-dist-devel-bounces@blackfin.uclinux.org [mailto:uclinux-dist-devel-
>bounces@blackfin.uclinux.org] On Behalf Of Libo Chen
>Sent: Monday, May 06, 2013 9:11 PM
>To: wsa@the-dreams.de
>Cc: uclinux-dist-devel@blackfin.uclinux.org; Li Zefan; linux-i2c@vger.kernel.org;
>linux-kernel@vger.kernel.org
>Subject: [uclinux-dist-devel] [PATCH 1/2] i2c: i2c-bfin-twi: don`t free peripheral
>before it`s init successful
>
>
>down out_error_no_irq. When platform_get_irq fail, no need to free peripheral
>
>Signed-off-by: Libo Chen <libo.chen@huawei.com>
>---
> drivers/i2c/busses/i2c-bfin-twi.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
>index 05080c4..d38e05a 100644
>--- a/drivers/i2c/busses/i2c-bfin-twi.c
>+++ b/drivers/i2c/busses/i2c-bfin-twi.c
>@@ -709,8 +709,8 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
> out_error_add_adapter:
>       free_irq(iface->irq, iface);
> out_error_req_irq:
>-out_error_no_irq:
>       peripheral_free_list((unsigned short *)pdev->dev.platform_data);
>+out_error_no_irq:
> out_error_pin_mux:
>       iounmap(iface->regs_base);
> out_error_ioremap:

You should exchange line out_error_no_irq: and line out_error_pin_mux: other than.
Could you send me a new patch?

Regards,

Sonic

