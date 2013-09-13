Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751844Ab3IMEp6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 00:45:58 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:32527 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575Ab3IMEp5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 00:45:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz9371I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Duan Fugang-B38611 <B38611@freescale.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Estevam Fabio-R49496 <r49496@freescale.com>
CC: "frank.li@freescale.net" <frank.li@freescale.net>,
        "jim_baxter@mentor.com" <jim_baxter@mentor.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fec: remove deprecated IRQF_DISABLED
Thread-Topic: [PATCH] net: fec: remove deprecated IRQF_DISABLED
Thread-Index: AQHOsDOYqfL9byZCGEGxuCPPmOA86JnDF13Q
Date: Fri, 13 Sep 2013 04:45:54 +0000
Message-ID: <9848F2DB572E5649BA045B288BE08FBE016DAF7D@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1379043878-6376-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1379043878-6376-1-git-send-email-michael.opdenacker@free-electrons.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.233]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker [mailto:michael.opdenacker@free-electrons.com]
Data: Friday, September 13, 2013 11:45 AM

> To: davem@davemloft.net; Estevam Fabio-R49496
> Cc: frank.li@freescale.net; Duan Fugang-B38611; jim_baxter@mentor.com;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Michael Opdenacker
> Subject: [PATCH] net: fec: remove deprecated IRQF_DISABLED
> 
> This patch proposes to remove the IRQF_DISABLED flag from
> drivers/net/ethernet/freescale/fec_main.c
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c
> b/drivers/net/ethernet/freescale/fec_main.c
> index f9aacf5..b2793b9 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -2199,7 +2199,7 @@ fec_probe(struct platform_device *pdev)
>  			goto failed_irq;
>  		}
>  		ret = devm_request_irq(&pdev->dev, irq, fec_enet_interrupt,
> -				       IRQF_DISABLED, pdev->name, ndev);
> +				       0, pdev->name, ndev);
>  		if (ret)
>  			goto failed_irq;

Can you remove the flag for all net driver such as:

/linux-next/linux-2.6$ grep -nr "IRQF_DISABLED" drivers/net/ethernet/
drivers/net/ethernet/adi/bfin_mac.c:533:                                 IRQF_DISABLED, "EMAC_WAKE", dev);
drivers/net/ethernet/adi/bfin_mac.c:1689:                       IRQF_DISABLED, "EMAC_RX", ndev);
drivers/net/ethernet/lantiq_etop.c:285:                 request_irq(irq, ltq_etop_dma_irq, IRQF_DISABLED,
drivers/net/ethernet/lantiq_etop.c:294:                 request_irq(irq, ltq_etop_dma_irq, IRQF_DISABLED,
drivers/net/ethernet/micrel/ks8851_mll.c:918:#define    KS_INT_FLAGS    (IRQF_DISABLED|IRQF_TRIGGER_LOW)
drivers/net/ethernet/pasemi/pasemi_mac.c:1222:  ret = request_irq(mac->tx->chan.irq, pasemi_mac_tx_intr, IRQF_DISABLED,
drivers/net/ethernet/pasemi/pasemi_mac.c:1233:  ret = request_irq(mac->rx->chan.irq, pasemi_mac_rx_intr, IRQF_DISABLED,
drivers/net/ethernet/amd/sun3lance.c:361:       if (request_irq(LANCE_IRQ, lance_interrupt, IRQF_DISABLED, "SUN3 Lance", dev) < 0) {
drivers/net/ethernet/dec/tulip/de4x5.c:356:                       Added IRQF_DISABLED temporary fix from
drivers/net/ethernet/dec/tulip/de4x5.c:1324:    if (request_irq(dev->irq, de4x5_interrupt, IRQF_DISABLED | IRQF_SHARED,
drivers/net/ethernet/freescale/fec_main.c:2212:                                IRQF_DISABLED, pdev->name, ndev);
drivers/net/ethernet/smsc/smc91x.h:274:#define SMC_IRQ_FLAGS            (IRQF_DISABLED)
drivers/net/ethernet/smsc/smsc9420.c:1359:      result = request_irq(irq, smsc9420_isr, IRQF_SHARED | IRQF_DISABLED,
drivers/net/ethernet/ibm/ehea/ehea_main.c:1288:                           IRQF_DISABLED, port->int_aff_name, port);
drivers/net/ethernet/ibm/ehea/ehea_main.c:1306:                                   IRQF_DISABLED, pr->int_send_name,
drivers/net/ethernet/ibm/ehea/ehea_main.c:3323:                           ehea_interrupt_neq, IRQF_DISABLED,
drivers/net/ethernet/korina.c:999:                      IRQF_DISABLED, "Korina ethernet Rx", dev);
drivers/net/ethernet/korina.c:1006:                     IRQF_DISABLED, "Korina ethernet Tx", dev);
drivers/net/ethernet/korina.c:1015:                     IRQF_DISABLED, "Ethernet Overflow", dev);
drivers/net/ethernet/korina.c:1024:                     IRQF_DISABLED, "Ethernet Underflow", dev);
drivers/net/ethernet/marvell/pxa168_eth.c:1127:                   IRQF_DISABLED, dev->name, dev);
drivers/net/ethernet/natsemi/jazzsonic.c:86:    retval = request_irq(dev->irq, sonic_interrupt, IRQF_DISABLED,
drivers/net/ethernet/natsemi/xtsonic.c:98:      retval = request_irq(dev->irq, sonic_interrupt, IRQF_DISABLED,
drivers/net/ethernet/toshiba/ps3_gelic_net.c:1729:                           IRQF_DISABLED, netdev->name, card);
drivers/net/ethernet/hp/hp100.c:1100:                   HP100_BUS_EISA ? IRQF_SHARED : IRQF_DISABLED,
drivers/net/ethernet/broadcom/bcm63xx_enet.c:929:       ret = request_irq(priv->irq_rx, bcm_enet_isr_dma, IRQF_DISABLED,
drivers/net/ethernet/broadcom/bcm63xx_enet.c:935:                         IRQF_DISABLED, dev->name, dev);
drivers/net/ethernet/broadcom/bcm63xx_enet.c:2159:                        IRQF_DISABLED, dev->name, dev);
drivers/net/ethernet/broadcom/bcm63xx_enet.c:2165:                                IRQF_DISABLED, dev->name, dev);

Thanks,
Andy

