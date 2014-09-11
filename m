Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaIKBbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 21:31:07 -0400
Received: from mail-by2on0144.outbound.protection.outlook.com ([207.46.100.144]:25910
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751475AbaIKBbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 21:31:05 -0400
X-Greylist: delayed 73269 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Sep 2014 21:31:05 EDT
Date: Thu, 11 Sep 2014 09:37:38 +0800
From: Robin Gong <b38343@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-spi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <marex@denx.de>,
        <shawn.guo@linaro.org>, <Frank.Li@freescale.com>
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
Message-ID: <20140911013737.GA366@Robin-OptiPlex-780>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
 <20140910102105.GR2601@sirena.org.uk>
 <20140910112258.GA30794@Robin-OptiPlex-780>
 <20140910114530.GD7960@sirena.org.uk>
 <20140910151759.GA31462@Robin-OptiPlex-780>
 <20140910155216.GI7960@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140910155216.GI7960@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(24454002)(189002)(105606002)(81342001)(68736004)(83072002)(4396001)(54356999)(76176999)(99396002)(33656002)(83322001)(87936001)(85852003)(92566001)(92726001)(50986999)(102836001)(26826002)(90102001)(31966008)(104016003)(97756001)(33716001)(77982001)(95666004)(46102001)(46406003)(50466002)(107046002)(74662001)(21056001)(81542001)(80022001)(76482001)(84676001)(110136001)(74502001)(83506001)(97736003)(44976005)(106466001)(6806004)(47776003)(85306004)(64706001)(79102001)(20776003)(93886004)(23726002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB495;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 04:52:16PM +0100, Mark Brown wrote:
> On Wed, Sep 10, 2014 at 11:18:01PM +0800, Robin Gong wrote:
> > On Wed, Sep 10, 2014 at 12:45:30PM +0100, Mark Brown wrote:
> 
> > > > Yes, you're right. I should use "transfer->tx_sg->sgl == NULL" or
> > > > "transfer->rx_sg->sgl == NULL" instead of usedma flag in driver, right?
> 
> > > Right.
> 
> > But looks spi core framework can make sure every rx or tx transfer in sequence.
> > If so, can_dma will never be called until this transfer finished
> > (spi_pump_messages), and my usedma flag also never be modified until next
> > transfer start. Please correct me if I am wrong, thanks.
> 
> Even if that were true currently this would still not be good code since
> it would break in the face of SPI core changes.  In any case the
> assumption isn't true for the current SPI core, the DMA mapping is done
> for all transfers in a message before we start running them and it's
> entirely likely that we will have patterns like a short PIO transfer
> followed by a big data block.
Understood, will improve it in v6.Thanks.

