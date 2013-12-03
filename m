Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3LCN5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:57:50 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:13766
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176Ab3LCN5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:57:47 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z579ehz1432I78fbmzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh1de097h186068h1954cbhz2dh109h2a8h839h8e2h8e3h93fhd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h19ceh1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Chris Ruehl <chris.ruehl@gtsys.com.hk>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3 v4] usb: chipidea: Reallocate regmap only if lpm is
 detected
Thread-Topic: [PATCH 1/3 v4] usb: chipidea: Reallocate regmap only if lpm is
 detected
Thread-Index: AQHO7/33LJ6P14f8b0294Tkv7dxBwZpCUP6AgAAtnVA=
Date: Tue, 3 Dec 2013 13:57:40 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A64980414130E@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1386057710-3848-1-git-send-email-chris.ruehl@gtsys.com.hk>
 <529DBC81.5030805@pengutronix.de>
In-Reply-To: <529DBC81.5030805@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [101.80.166.102]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rB3DvuGO025281


 
> >
> > Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> > Acked-by: Peter Chen <peter.chen@freescale.com>
> > ---
> >  drivers/usb/chipidea/core.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> > index 5d8981c..9a5ef20 100644
> > --- a/drivers/usb/chipidea/core.c
> > +++ b/drivers/usb/chipidea/core.c
> > @@ -208,7 +208,8 @@ static int hw_device_init(struct ci_hdrc *ci, void
> __iomem *base)
> >  	reg = hw_read(ci, CAP_HCCPARAMS, HCCPARAMS_LEN) >>
> >  		__ffs(HCCPARAMS_LEN);
> >  	ci->hw_bank.lpm  = reg;
> > -	hw_alloc_regmap(ci, !!reg);
> > +	if (reg)
> > +		hw_alloc_regmap(ci, !!reg);
> >  	ci->hw_bank.size = ci->hw_bank.op - ci->hw_bank.abs;
> >  	ci->hw_bank.size += OP_LAST;
> >  	ci->hw_bank.size /= sizeof(u32);
> > @@ -642,6 +643,10 @@ static int ci_hdrc_probe(struct platform_device
> *pdev)
> >  			: CI_ROLE_GADGET;
> >  	}
> >
> > +	/* only update vbus status for peripheral */
> > +	if (ci->role == CI_ROLE_GADGET)
> > +		ci_handle_vbus_change(ci);
> > +
> 
> This change seems unrelated to me.
> 
> Marc

Hi Chris. Why above change is there, it is not existed at your v3 patch.

Peter

> 
> >  	ret = ci_role_start(ci, ci->role);
> >  	if (ret) {
> >  		dev_err(dev, "can't start %s role\n", ci_role(ci)->name);
> >
> 
> 
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
