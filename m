Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568Ab3HNKU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:20:57 -0400
Received: from cluster-g.mailcontrol.com ([208.87.233.190]:60181 "EHLO
	cluster-g.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3HNKUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:20:55 -0400
X-Greylist: delayed 3784 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Aug 2013 06:20:55 EDT
X-PGP-Universal: processed;
	by shaapppus01.asia.root.pri on Wed, 14 Aug 2013 17:16:28 +0800
From: Barry Song <Barry.Song@csr.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "Mark Brown" <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <DL-SHA-WorkGroupLinux@internal.csr.com>
Subject: RE: [PATCH 25/29] drivers/spi/spi-sirf.c: simplify use of
 devm_ioremap_resource
Thread-Topic: [PATCH 25/29] drivers/spi/spi-sirf.c: simplify use of
 devm_ioremap_resource
Thread-Index: AQHOmM5MiT7RzM1nVkuUcysTxhk1M5mUa/Ow
Date: Wed, 14 Aug 2013 09:16:22 +0000
Message-ID: <5EB3BFCD089AD643B9BB63439F5FD5E9012A3BCC66@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376471493-22215-26-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1376471493-22215-26-git-send-email-Julia.Lawall@lip6.fr>
Accept-Language: en-US, zh-CN, en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.125.5.55]
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r7EAL1uw005766

> -----Original Message-----
> From: Julia Lawall [mailto:Julia.Lawall@lip6.fr]
> Sent: Wednesday, August 14, 2013 5:11 PM
> To: Barry Song
> Cc: kernel-janitors@vger.kernel.org; Mark Brown;
> linux-arm-kernel@lists.infradead.org; linux-spi@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH 25/29] drivers/spi/spi-sirf.c: simplify use of
> devm_ioremap_resource
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
> 
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.
> 
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret != 0;
> identifier l;
> @@
> 
> - res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   ... when != res
> - if (res == NULL) { ... \(goto l;\|return ret;\) }
>   ... when != res
> + res = platform_get_resource(pdev, IORESOURCE_MEM, n);
>   e = devm_ioremap_resource(e1, res);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: Barry Song <Baohua.Song@csr.com>

> 
> ---
>  drivers/spi/spi-sirf.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
 


Member of the CSR plc group of companies. CSR plc registered in England and Wales, registered number 4187346, registered office Churchill House, Cambridge Business Park, Cowley Road, Cambridge, CB4 0WZ, United Kingdom
More information can be found at www.csr.com. Follow CSR on Twitter at http://twitter.com/CSR_PLC and read our blog at www.csr.com/blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
