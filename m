Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaB1N1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:27:47 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:21327
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbaB1N1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:27:44 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275dh1de097h186068h1954cbhz2fh95h109h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24ach24d7h2516h2545h255eh906i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v4] can: xilinx CAN controller support.
Thread-Topic: [PATCH v4] can: xilinx CAN controller support.
Thread-Index: AQHPMnBMZEwPglt3TUmAMsU8apdwWZrHhtZVgAAnVUOAAqxFHIAASeaWgAAFkOyAAAB8YA==
Date: Fri, 28 Feb 2014 13:27:37 +0000
References: <74d607e9-ac9c-4a9b-ac49-e84ae49d20c2@TX2EHSMHS031.ehs.local>
 <530D0A9C.5090402@pengutronix.de>
 <cd00fb2d-c8a7-423d-8aa0-2b413e9ac101@CO9EHSMHS017.ehs.local>
 <530DEA7C.6010609@pengutronix.de>
 <678ca296-8687-4e7c-9014-ae69d886a068@CO9EHSMHS014.ehs.local>
 <530E0B92.5010903@pengutronix.de>
 <2e3bfd38-37d5-4102-af79-821196c6c732@CH1EHSMHS006.ehs.local>
 <53104995.4010305@pengutronix.de>
 <48409965-e214-43b7-8b6a-08bf075707e1@CO9EHSMHS001.ehs.local>
 <53108798.7090902@pengutronix.de>
 <4902b8d8-139a-4fd0-9e6e-a30ce7e6683b@CH1EHSMHS019.ehs.local>
 <53108BEF.1020308@pengutronix.de>
In-Reply-To: <53108BEF.1020308@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.19.46]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <f7b303dd-bf23-40f2-bbd4-4594cba8f345@CO9EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1SDRvKt015367

Hi Marc,


> -----Original Message-----
> From: Marc Kleine-Budde [mailto:mkl@pengutronix.de]
> Sent: Friday, February 28, 2014 6:45 PM
> To: Appana Durga Kedareswara Rao; wg@grandegger.com; Michal Simek;
> grant.likely@linaro.org; robh+dt@kernel.org; linux-can@vger.kernel.org
> Cc: netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org
> Subject: Re: [PATCH v4] can: xilinx CAN controller support.
>
> On 02/28/2014 02:07 PM, Appana Durga Kedareswara Rao wrote:
> >>>> What happens if the interrupt handler is delayed? For example in a
> >>>> RT enabled system the interrupt handler runs as a thread. There
> >>>> might be other threads with higher priority. The hardware will
> >>>> probably send all CAN frames in the FIFO, so you want to reduce the
> >>>> overhead and loop in the tx complete handler.
> >>>>
> >>> Yes I agree with your comment.
> >>> It will be good to have a loop in the Tx interrupt handler I am
> >>> modifying the Tx interrupt handler like below.
> >>>
> >>> static void xcan_tx_interrupt(struct net_device *ndev, u32 isr) {
> >>>         struct xcan_priv *priv = netdev_priv(ndev);
> >>>         struct net_device_stats *stats = &ndev->stats;
> >>>
> >>>         while (priv->tx_head - priv->tx_tail > 0) {
> >>>                 if (!(isr & XCAN_IXR_TXOK_MASK)) {
> >>>                         break;
> >>>                 }
> >>>                 can_get_echo_skb(ndev, priv->tx_tail %
> >>>                                         priv->xcan_echo_skb_max_tx);
> >>>                 priv->tx_tail++;
> >>>                 stats->tx_packets++;
> >>>                 can_led_event(ndev, CAN_LED_EVENT_TX);
>
> Probably first clear the interrupt, because you've just handled it, then check
> if it's still present. The question is, do you have to clear the IRQ for each
> transmitted frame, or does one clean of the interrupt clear the bit for more
> then one transmitted frame?
>

We already were clearing it in the interrupt routine (xcan_interrupt). That's why clearing it at the end of the loop.
We have to clear the IRQ (TXOK) for each transmitted frame.

Regards,
Kedar.


> >>>                 isr = priv->read_reg(priv, XCAN_ISR_OFFSET);
> >             --> clear Tx OK interrupt.
>
> >
> >>>         }
> >>>         netif_wake_queue(ndev);
> >>> }
> >>>
> >>> Are you Ok with this?
>
> Were getting there :)
>
> Marc
> --
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
