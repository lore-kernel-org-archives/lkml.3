Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaIJIW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:22:28 -0400
Received: from mail-bn1bon0143.outbound.protection.outlook.com ([157.56.111.143]:8588
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751048AbaIJIW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:22:26 -0400
Date: Wed, 10 Sep 2014 16:28:55 +0800
From: Robin Gong <b38343@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <broonie@kernel.org>,
        <marex@denx.de>, <shawn.guo@linaro.org>, <Frank.Li@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linux-spi@vger.kernel.org>
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
Message-ID: <20140910082853.GA29906@Robin-OptiPlex-780>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
 <5412055.BAOgFikuh9@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5412055.BAOgFikuh9@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(199003)(24454002)(51704005)(189002)(105606002)(46102001)(110136001)(23726002)(6806004)(81156004)(104016003)(21056001)(80022001)(95666004)(90102001)(85306004)(76482001)(92566001)(107046002)(92726001)(76176999)(50986999)(106466001)(54356999)(81342001)(84676001)(44976005)(4396001)(33656002)(50466002)(20776003)(77982001)(79102001)(83506001)(68736004)(69596002)(97756001)(87936001)(83072002)(46406003)(85852003)(74662001)(81542001)(99396002)(83322001)(19580395003)(19580405001)(64706001)(31966008)(102836001)(33716001)(97736003)(47776003)(74502001)(26826002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB494;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 10:17:14AM +0200, Arnd Bergmann wrote:
> On Wednesday 10 September 2014 09:30:04 Robin Gong wrote:
> > Enable DMA support on i.mx6. The read speed can increase from 600KB/s
> > to 1.2MB/s on i.mx6q. You can disable or enable dma function in dts.
> > If not set "dma-names" in dts, spi will use PIO mode. This patch only
> > validate on i.mx6, not i.mx5, but encourage ones to apply this patch
> > on i.mx5 since they share the same IP.
> > 
> > Note:
> >   Sometime, there is a weid data in rxfifo after one full tx/rx
> > transfer finish by DMA on i.mx6dl, so we disable dma functhion on
> > i.mx6dl.
> > 
> > Signed-off-by: Frank Li <Frank.Li@freescale.com>
> > Signed-off-by: Robin Gong <b38343@freescale.com>
> > 
> > 
> 
> The patch looks good to me, but you need to also update the
> Documentation/devicetree/bindings/spi/fsl-imx-cspi.txt file to
> document the additional optional properties.
> 
> 	Arnd
Thanks for your reminding, I'll add it in the v6.
