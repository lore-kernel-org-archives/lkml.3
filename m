Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbaCDXvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:51:25 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:24573
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756056AbaCDXvX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:51:23 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dIc89bh936eIzz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz17326ah8275bh1de097h186068h5eeeKz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h906i1155h)
Date: Tue, 4 Mar 2014 15:51:15 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
CC: <wg@grandegger.com>, <mkl@pengutronix.de>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Kedareswara rao Appana <appanad@xilinx.com>
Subject: Re: [PATCH v5] can: xilinx CAN controller support.
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <1b9f22ac-4dde-4ecc-885a-3d8081157081@AM1EHSMHS012.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kedar,

On Tue, 2014-03-04 at 06:50PM +0530, Kedareswara rao Appana wrote:
> This patch adds xilinx CAN controller support.
> This driver supports both ZYNQ CANPS and Soft IP
> AXI CAN controller.
> 
[...]
> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> new file mode 100644
> index 0000000..0e57103
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> @@ -0,0 +1,45 @@
> +Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
> +---------------------------------------------------------
> +
> +Required properties:
> +- compatible		: Should be "xlnx,zynq-can-1.00.a" for Zynq CAN
> +			  controllers and "xlnx,axi-can-1.00.a" for Axi CAN
> +			  controllers.
> +- reg			: Physical base address and size of the Axi CAN/Zynq
> +			  CANPS registers map.
> +- interrupts		: Property with a value describing the interrupt
> +			  number.
> +- interrupt-parent	: Must be core interrupt controller
> +- clock-names		: List of input clock names - "ref_clk", "aper_clk"

Let's reconsider these names. These are rather Zynq specific names. Does
the IP documentation use these as well? The names should match the
naming used for the IP, rather than the SOC. Is this the correct data sheet:
http://www.xilinx.com/support/documentation/ip_documentation/axi_can/v1_03_a/ds791_axi_can.pdf
? According to that the names should rather be 's_axi_aclk' and
'can_clk', IMHO.

	Sören


