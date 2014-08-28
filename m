Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965792AbaH1KIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 06:08:19 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:6938
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934847AbaH1KIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 06:08:17 -0400
Date: Thu, 28 Aug 2014 17:59:41 +0800
From: Robin Gong <b38343@freescale.com>
To: sanjeev sharma <sanjeevsharmaengg@gmail.com>
CC: <broonie@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-spi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <Frank.Li@freescale.com>,
        <shawn.guo@linaro.org>, <marex@denx.de>
Subject: Re: [PATCH v4] spi: spi-imx: add DMA support
Message-ID: <20140828095939.GA13274@Robin-OptiPlex-780>
References: <1408752835-10995-1-git-send-email-b38343@freescale.com>
 <CAGUYZuQre3RAQy+qqwq5HthrjnT85V5RKu2xwXOC=gL6Yk33TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAGUYZuQre3RAQy+qqwq5HthrjnT85V5RKu2xwXOC=gL6Yk33TQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(51704005)(199003)(377454003)(24454002)(15202345003)(33656002)(106466001)(83322001)(81342001)(26826002)(21056001)(44976005)(19580395003)(19580405001)(81542001)(6806004)(104016003)(85852003)(15975445006)(50986999)(83072002)(87936001)(20776003)(107046002)(92566001)(92726001)(74502001)(105606002)(68736004)(47776003)(31966008)(74662001)(84676001)(64706001)(97736001)(80022001)(90102001)(46406003)(1411001)(76482001)(85306004)(76176999)(33716001)(99396002)(95666004)(46102001)(77982001)(4396001)(50466002)(83506001)(69596002)(23726002)(54356999)(102836001)(79102001)(110136001)(81156004)(97756001)(42262002);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB483;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 031763BCAF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:12:08AM +0530, sanjeev sharma wrote:
> On Sat, Aug 23, 2014 at 5:43 AM, Robin Gong <b38343@freescale.com> wrote:
> 
> > +       /*
> > +        * Configure the DMA register: setup the watermark
> > +        * and enable DMA request.
> > +        */
> > +       if (spi_imx->dma_is_inited) {
> > +               dma = readl(spi_imx->base + MX51_ECSPI_DMA);
> > +
> > +               spi_imx->tx_wml = spi_imx_get_fifosize(spi_imx) / 2;
> > +               spi_imx->rx_wml = spi_imx_get_fifosize(spi_imx) / 2;
> > +               spi_imx->rxt_wml = spi_imx_get_fifosize(spi_imx) / 2;
> > +               rx_wml_cfg = spi_imx->rx_wml <<
> > MX51_ECSPI_DMA_RX_WML_OFFSET;
> > +               tx_wml_cfg = spi_imx->tx_wml <<
> > MX51_ECSPI_DMA_TX_WML_OFFSET;
> > +               rxt_wml_cfg = spi_imx->rxt_wml <<
> > MX51_ECSPI_DMA_RXT_WML_OFFSET;
> > +               dma = (dma & ~MX51_ECSPI_DMA_TX_WML_MASK
> > +                               & ~MX51_ECSPI_DMA_RX_WML_MASK
> > +                               & ~MX51_ECSPI_DMA_RXT_WML_MASK)
> > +                               | rx_wml_cfg | tx_wml_cfg | rxt_wml_cfg
> > +                               |(1 << MX51_ECSPI_DMA_TEDEN_OFFSET)
> > +                               |(1 << MX51_ECSPI_DMA_RXDEN_OFFSET)
> > +                               |(1 << MX51_ECSPI_DMA_RXTDEN_OFFSET);
> > +
> >
> 
> IMO, we should have an seperate function for dmactrl,rx_threshold &
> tx_threshold for better visiblity.
> 
>
I understood your concern, but I don't want to create one function only for
setting some bit fields of the register.
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
