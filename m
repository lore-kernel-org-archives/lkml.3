Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaCEHDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 02:03:55 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:23762 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750747AbaCEHDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 02:03:53 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Ic89bh936eI542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh1de097h186068hz2fh95h109h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h906i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Soren Brinkmann <sorenb@xilinx.com>
CC: "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v5] can: xilinx CAN controller support.
Thread-Topic: [PATCH v5] can: xilinx CAN controller support.
Thread-Index: AQHPOAShe+/Jq2y0+ECMRZjewV7XtprR5cfg
Date: Wed, 5 Mar 2014 07:03:46 +0000
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local>
 <20140304235115.GN13293@xsjandreislx>
In-Reply-To: <20140304235115.GN13293@xsjandreislx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.16.46]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <437d1091-d4b4-4b27-8057-b22edeadb28c@TX2EHSMHS035.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s25745ft012881

Hi Soren,

> -----Original Message-----
> From: SÃ¶ren Brinkmann [mailto:soren.brinkmann@xilinx.com]
> Sent: Wednesday, March 05, 2014 5:21 AM
> To: Appana Durga Kedareswara Rao
> Cc: wg@grandegger.com; mkl@pengutronix.de; Michal Simek;
> grant.likely@linaro.org; robh+dt@kernel.org; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; Appana Durga
> Kedareswara Rao
> Subject: Re: [PATCH v5] can: xilinx CAN controller support.
>
> Hi Kedar,
>
> On Tue, 2014-03-04 at 06:50PM +0530, Kedareswara rao Appana wrote:
> > This patch adds xilinx CAN controller support.
> > This driver supports both ZYNQ CANPS and Soft IP AXI CAN controller.
> >
> [...]
> > diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> > b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> > new file mode 100644
> > index 0000000..0e57103
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> > @@ -0,0 +1,45 @@
> > +Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
> > +---------------------------------------------------------
> > +
> > +Required properties:
> > +- compatible               : Should be "xlnx,zynq-can-1.00.a" for Zynq
> CAN
> > +                     controllers and "xlnx,axi-can-1.00.a" for Axi CAN
> > +                     controllers.
> > +- reg                      : Physical base address and size of the Axi CAN/Zynq
> > +                     CANPS registers map.
> > +- interrupts               : Property with a value describing the interrupt
> > +                     number.
> > +- interrupt-parent : Must be core interrupt controller
> > +- clock-names              : List of input clock names - "ref_clk",
> "aper_clk"
>
> Let's reconsider these names. These are rather Zynq specific names. Does
> the IP documentation use these as well? The names should match the
> naming used for the IP, rather than the SOC. Is this the correct data sheet:
> http://www.xilinx.com/support/documentation/ip_documentation/axi_can
> /v1_03_a/ds791_axi_can.pdf
> ? According to that the names should rather be 's_axi_aclk' and 'can_clk',
> IMHO.

Axi CAN driver uses only one clock i.e ref_clk the name in the documentation for this clock is can_clk.
Ok will change the clock name to can_clk.


Regards,
Kedar.

>
>       SÃ¶ren



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
