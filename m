Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaCAC2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 21:28:47 -0500
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:27892
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbaCAC2n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 21:28:43 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh906i1155h)
Date: Fri, 28 Feb 2014 18:28:34 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH 2/2] ARM: zynq: dt: Add I2C nodes to Zynq device tree
References: <1393632046-20062-1-git-send-email-soren.brinkmann@xilinx.com>
 <1393632046-20062-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1393632046-20062-2-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ce5fbea5-de6e-4a29-9807-cccf0f59f654@CO9EHSMHS021.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-28 at 04:00PM -0800, Soren Brinkmann wrote:
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 22 ++++++++++++
>  arch/arm/boot/dts/zynq-zc702.dts | 76 ++++++++++++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/zynq-zc706.dts | 68 +++++++++++++++++++++++++++++++++++
>  3 files changed, 166 insertions(+)
> 
[...]
> diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
> index c913f77a21eb..91a3a560f03b 100644
> --- a/arch/arm/boot/dts/zynq-zc702.dts
> +++ b/arch/arm/boot/dts/zynq-zc702.dts
[...]
> +
> +		i2c@7 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <7>;
> +			hwmon@52 {
> +				compatible = "pmbus,ucd9248";
> +				reg = <52>;
> +			};
> +			hwmon@53 {
> +				compatible = "pmbus,ucd9248";
> +				reg = <53>;
> +			};
> +			hwmon@54 {
> +				compatible = "pmbus,ucd9248";
All these occurrences of 'pmbus' should rather be replaced with 'ti'.
I wasn't aware of how this DT node to I2C probing works - and still
haven't fully understood it - but the vendor prefix is apparently a
don't care and we could simply use the correct one here.
I have no idea how I came up with the description using 'pmbus' (we
carry this in our vendor tree for quite a while already).
Is there any document describing how a DT node is matched to an
appropriate driver? These I2C drivers usually don't have the common
'struct of_device_id'. Hence my preferred way of simply grepping through
the kernel for the compatibility string does not work.

[...]
> diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
> index 88f62c50382e..dab30f80d5b0 100644
> --- a/arch/arm/boot/dts/zynq-zc706.dts
> +++ b/arch/arm/boot/dts/zynq-zc706.dts
[...]
> +		i2c@7 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			reg = <7>;
> +			ucd90120@65 {
> +				compatible = "pmbus,ucd90120";
same here

	Sören


