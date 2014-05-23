Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaEWJYC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:24:02 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:2742
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947AbaEWJX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:23:59 -0400
Date: Fri, 23 May 2014 16:04:46 +0800
From: Huang Shijie <b32955@freescale.com>
To: Dirk Behme <dirk.behme@de.bosch.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 2/2] serial: imx: disable the receiver ready interrupt
 for imx_stop_rx
Message-ID: <20140523080445.GB12044@shlinux1.ap.freescale.net>
References: <1400819575-20435-1-git-send-email-b32955@freescale.com>
 <1400819575-20435-2-git-send-email-b32955@freescale.com>
 <537EE65C.5010700@de.bosch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <537EE65C.5010700@de.bosch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.1;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(51704005)(199002)(189002)(77982001)(46102001)(81342001)(92566001)(77096999)(23726002)(76482001)(81542001)(31966008)(46406003)(4396001)(99396002)(74662001)(92726001)(83506001)(6806004)(47776003)(20776003)(80022001)(19580395003)(97756001)(54356999)(83322001)(76176999)(50466002)(87936001)(50986999)(44976005)(26826002)(64706001)(33656002)(85852003)(79102001)(74502001)(83072002)(21056001)(19580405001)(102836001)(42262001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB475;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:gate-tx3.freescale.com;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0220D4B98D
Authentication-Results: spf=fail (sender IP is 192.88.168.1)
 smtp.mailfrom=shijie.huang@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 08:10:36AM +0200, Dirk Behme wrote:
> On 23.05.2014 06:32, Huang Shijie wrote:
> >This patch disables the receiver ready interrupt for imx_stop_rx.
> >It reduces the interrupt numbers when the uart is going to close
> >or suspend.
> >
> >Signed-off-by: Huang Shijie <b32955@freescale.com>
> >---
> >  drivers/tty/serial/imx.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> >diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> >index ed6cdf7..6026101 100644
> >--- a/drivers/tty/serial/imx.c
> >+++ b/drivers/tty/serial/imx.c
> >@@ -440,6 +440,10 @@ static void imx_stop_rx(struct uart_port *port)
> >
> >  	temp = readl(sport->port.membase + UCR2);
> >  	writel(temp & ~UCR2_RXEN, sport->port.membase + UCR2);
> >+
> >+	/* disable the `Receiver Ready Interrrupt` */
> >+	temp = readl(sport->port.membase + UCR1);
> >+	writel(temp & ~UCR1_RRDYEN, sport->port.membase + UCR1);
> >  }
> 
> While this is about the RX irq, I've a slightly off-topic general
> question regarding the usage of the *TX* irq in TX DMA mode:
> 
> It seems to me that the TX irq is kept enabled while the TX DMA is
Not really :)

We disable the TXMPTYEN when the DMA is enabled.

thanks
Huang Shijie

