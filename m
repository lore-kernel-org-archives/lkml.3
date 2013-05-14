Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3ENHJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:09:21 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64728 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3ENHJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:09:14 -0400
MIME-Version: 1.0
In-Reply-To: <CAHrpEqQRPiJqkFoLCGa+QmbnAa++50HRQHvw69uxN7y8zgiR3Q@mail.gmail.com>
References: <1368473874-9569-1-git-send-email-laurent.navet@gmail.com>
	<CAHrpEqQRPiJqkFoLCGa+QmbnAa++50HRQHvw69uxN7y8zgiR3Q@mail.gmail.com>
Date: Tue, 14 May 2013 09:09:13 +0200
Message-ID: <CAH7P7NgZPS_AJtkaM661uGUD8rteora=EaGa4XzJZEY+vYr+6g@mail.gmail.com>
Subject: Re: [PATCH] net: ethernet: freescale: use devm_ioremap_resource()
From: Laurent Navet <laurent.navet@gmail.com>
To: Frank Li <lznuaa@gmail.com>
Cc: David Miller <davem@davemloft.net>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, joe@perches.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -1843,8 +1843,6 @@ fec_probe(struct platform_device *pdev)
>>                 pdev->id_entry = of_id->data;
>>
>>         r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -       if (!r)
>> -               return -ENXIO;
>>
>
> why remove this check?

it's already checked in devm_ioremap_resource in a better way,

void __iomem *devm_ioremap_resource(struct device *dev, struct resource *res)
 {
...
         if (!res || resource_type(res) != IORESOURCE_MEM) {
                 dev_err(dev, "invalid resource\n");
                 return ERR_PTR(-EINVAL);
         }
...

Laurent.
