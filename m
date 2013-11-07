Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3KGGuP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 01:50:15 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56320 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106Ab3KGGuH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 01:50:07 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579ehz148cI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Jisheng Zhang <jszhang@marvell.com>, "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Subject: RE: [PATCH v2] usb: phy: phy-mxs-usb: set the correct platform
 drvdata
Thread-Topic: [PATCH v2] usb: phy: phy-mxs-usb: set the correct platform
 drvdata
Thread-Index: AQHO22Usj80q91ZVF0C58F4kQXg+OJoZU4sQ
Date: Thu, 7 Nov 2013 06:49:58 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A6498040EB5EF@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1383792949-4521-1-git-send-email-jszhang@marvell.com>
In-Reply-To: <1383792949-4521-1-git-send-email-jszhang@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/usb/phy/phy-mxs-usb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/phy/phy-mxs-usb.c b/drivers/usb/phy/phy-mxs-
> usb.c
> index fdd33b4..545844b 100644
> --- a/drivers/usb/phy/phy-mxs-usb.c
> +++ b/drivers/usb/phy/phy-mxs-usb.c
> @@ -164,7 +164,7 @@ static int mxs_phy_probe(struct platform_device *pdev)
> 
>  	mxs_phy->clk = clk;
> 
> -	platform_set_drvdata(pdev, &mxs_phy->phy);
> +	platform_set_drvdata(pdev, mxs_phy);
> 
>  	ret = usb_add_phy_dev(&mxs_phy->phy);
>  	if (ret)
> --

It is so unlucky the struct usb_phy phy is the first element
of struct mxs_phy, so we haven't run any problems.

Jisheng, thanks for fixing it.

Acked-by: Peter Chen <peter.chen@freescale.com> 


