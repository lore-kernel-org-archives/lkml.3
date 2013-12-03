Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3LCO1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:27:41 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:46884 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481Ab3LCO1f convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:27:35 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(z579ehz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3 v4] usb: chipidea: hw_phymode_configure moved before
  ci_usb_phy_init
Thread-Topic: [PATCH 3/3 v4] usb: chipidea: hw_phymode_configure moved
 before  ci_usb_phy_init
Thread-Index: AQHO7/34jSzvs6mMskiVXzEa7q0YoJpCgwiQ
Date: Tue, 3 Dec 2013 14:27:31 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A6498041413EB@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1386057710-3848-3-git-send-email-chris.ruehl@gtsys.com.hk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.185.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> usb: chipidea: hw_phymode_configure moved before ci_usb_phy_init

usb: chipidea: put hw_phymode_configure before ci_usb_phy_init
Besides, a blank line is needed between your subject and commit log.

> hw_phymode_configure configures the PORTSC registers and allow the
> following phy_inits to operate on the right parameters. This fix a
> problem
> where the UPLI (ISP1504) could not detected,
					    ^^be

> because the Viewport was not
> available and read the viewport return 0's only.
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> Acked-by: Peter Chen <peter.chen@freescale.com>
> ---
>  drivers/usb/chipidea/core.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 2834801..43897dd 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -564,6 +564,8 @@ static int ci_hdrc_probe(struct platform_device *pdev)
>  		return -ENODEV;
>  	}
> 
> +	hw_phymode_configure(ci);
> +
>  	ret = ci_usb_phy_init(ci);
>  	if (ret) {
>  		dev_err(dev, "unable to init phy: %d\n", ret);
> @@ -581,8 +583,6 @@ static int ci_hdrc_probe(struct platform_device *pdev)
> 
>  	ci_get_otg_capable(ci);
> 
> -	hw_phymode_configure(ci);
> -
>  	dr_mode = ci->platdata->dr_mode;
>  	/* initialize role(s) before the interrupt is requested */
>  	if (dr_mode == USB_DR_MODE_OTG || dr_mode == USB_DR_MODE_HOST) {
> --
> 1.7.10.4
> 


