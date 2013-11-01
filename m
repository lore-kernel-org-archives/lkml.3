Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab3KAPgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 11:36:07 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:34992 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3KAPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 11:36:04 -0400
Date: Fri, 1 Nov 2013 21:06:25 +0530 (IST)
From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
X-X-Sender: hydrogen@arch
To: Christophe Leroy <christophe.leroy@c-s.fr>
cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Krzysztof Halasa <khc@pm.waw.pl>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        jerome.chantelauze.ext@c-s.fr
Subject: Re: [PATCH v2] WAN: Adding support for Infineon PEF2256 E1 chipset
 (FALC56)
In-Reply-To: <201311011501.rA1F1suj007279@localhost.localdomain>
Message-ID: <alpine.LNX.2.03.1311012057090.2407@gmail.com>
References: <201311011501.rA1F1suj007279@localhost.localdomain>
User-Agent: Alpine 2.03 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 Nov 2013, Christophe Leroy wrote:

> diff -urN a/drivers/net/wan/pef2256.c b/drivers/net/wan/pef2256.c
[..]
> +static int pef2256_remove(struct platform_device *pdev)
> +{
> +	struct net_device *ndev = dev_get_drvdata(&pdev->dev);
> +	struct pef2256_dev_priv *priv = dev_to_hdlc(ndev)->priv;
> +
> +
> +	device_remove_file(priv->dev, &dev_attr_regs);
> +	device_remove_file(priv->dev, &dev_attr_Tx_TS);
> +	device_remove_file(priv->dev, &dev_attr_Rx_TS);
> +	device_remove_file(priv->dev, &dev_attr_mode);
> +
> +	unregister_hdlc_device(priv->netdev);
> +
> +	free_netdev(priv->netdev);
> +
> +	iounmap(priv->base_addr);
> +
> +	kfree(priv);
> +
> +	dev_set_drvdata(&pdev->dev, NULL);

dev_set_drvdata is not necessary. driver core clears the driver data to NULL
after device_release or on probe failure.

//govind
