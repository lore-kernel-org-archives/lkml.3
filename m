Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbaIJPLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:11:30 -0400
Received: from mail-bn1bon0137.outbound.protection.outlook.com ([157.56.111.137]:52704
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752522AbaIJPL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:11:27 -0400
Date: Wed, 10 Sep 2014 23:18:01 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <marex@denx.de>,
        <shawn.guo@linaro.org>, <Frank.Li@freescale.com>
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
Message-ID: <20140910151759.GA31462@Robin-OptiPlex-780>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
 <20140910102105.GR2601@sirena.org.uk>
 <20140910112258.GA30794@Robin-OptiPlex-780>
 <20140910114530.GD7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140910114530.GD7960@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(979002)(6009001)(199003)(51704005)(24454002)(189002)(85852003)(83072002)(79102001)(87936001)(80022001)(20776003)(77982001)(47776003)(4396001)(64706001)(26826002)(104016003)(102836001)(33656002)(46406003)(81542001)(92726001)(81342001)(92566001)(46102001)(93886004)(85306004)(99396002)(68736004)(83322001)(44976005)(33716001)(110136001)(74662001)(74502001)(31966008)(97756001)(50466002)(21056001)(106466001)(105606002)(6806004)(107046002)(76482001)(23726002)(97736003)(95666004)(90102001)(83506001)(76176999)(54356999)(50986999)(84676001)(42262002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BLUPR03MB485;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 12:45:30PM +0100, Mark Brown wrote:
> On Wed, Sep 10, 2014 at 07:22:59PM +0800, Robin Gong wrote:
> > On Wed, Sep 10, 2014 at 11:21:05AM +0100, Mark Brown wrote:
> 
> > > This isn't going to work, anything that looks at the usedma flag will
> > > see the result of the last thing that was checked which may or may not
> > > be the transfer that it's handling.  The driver should check to see if
> > > the core mapped the transfer for DMA.
> 
> > Yes, you're right. I should use "transfer->tx_sg->sgl == NULL" or
> > "transfer->rx_sg->sgl == NULL" instead of usedma flag in driver, right?
> 
> Right.
But looks spi core framework can make sure every rx or tx transfer in sequence.
If so, can_dma will never be called until this transfer finished
(spi_pump_messages), and my usedma flag also never be modified until next
transfer start. Please correct me if I am wrong, thanks.

