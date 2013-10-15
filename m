Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab3JOUUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:20:36 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:26382 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759533Ab3JOUUd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:20:33 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551bizbb2dI98dI9371Ic89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Tue, 15 Oct 2013 13:20:16 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH RFC 4/5] net: macb: Use devm_request_irq()
References: <1381795140-10792-1-git-send-email-soren.brinkmann@xilinx.com>
 <1381795140-10792-5-git-send-email-soren.brinkmann@xilinx.com>
 <525D95A4.3020706@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <525D95A4.3020706@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ffb65abe-36e2-45c3-9d40-02050545184d@TX2EHSMHS038.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 11:21:08PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/15/2013 03:58 AM, Soren Brinkmann wrote:
> 
> >Use the device managed interface to request the IRQ, simplifying error
> >paths.
> 
> >Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >---
> >  drivers/net/ethernet/cadence/macb.c | 8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> >diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> >index 436aecc31732..603844b1d483 100644
> >--- a/drivers/net/ethernet/cadence/macb.c
> >+++ b/drivers/net/ethernet/cadence/macb.c
> >@@ -1825,7 +1825,8 @@ static int __init macb_probe(struct platform_device *pdev)
> >  	}
> >
> >  	dev->irq = platform_get_irq(pdev, 0);
> >-	err = request_irq(dev->irq, macb_interrupt, 0, dev->name, dev);
> >+	err = devm_request_irq(&pdev->dev, dev->irq, macb_interrupt, 0,
> >+			dev->name, dev);
> 
>    You should start the continuation line right under &.
Actually this one is a good example why I don't do such alignment: You
do a simple search & replace - in this case request_irq ->
devm_request_irq - and all alignment is gone.

	Sören


