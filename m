Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaEUQgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:36:36 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:7220
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752076AbaEUQge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:36:34 -0400
Date: Wed, 21 May 2014 09:34:10 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rdunlap@infradead.org>,
        <linux@arm.linux.org.uk>, <daniel.lezcano@linaro.org>,
        <tglx@linutronix.de>, <thierry.reding@gmail.com>,
        <florian.vaussard@epfl.ch>, <jic23@kernel.org>, <jason@lakedaemon.net>,
        <andrew@lunn.ch>, <silvio.fricke@gmail.com>, <heiko.stuebner@bq.com>,
        <olof@lixom.net>, <sebastian.hesselbarth@gmail.com>,
        <sboyd@codeaurora.org>, <gregory.clement@free-electrons.com>,
        <arnd@arndb.de>, <robherring2@gmail.com>, <marc.zyngier@arm.com>,
        <maxime.ripard@free-electrons.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 2/6] dt-bindings: add mtk-timer bindings
References: <1400689583-21119-1-git-send-email-matthias.bgg@gmail.com>
 <1400689583-21119-3-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400689583-21119-3-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <63a3ee29-aa23-4137-9c0c-5b2bdd75a68f@BN1BFFO11FD014.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(377424004)(51704005)(24454002)(189002)(199002)(81342001)(81542001)(92566001)(92726001)(80022001)(85852003)(54356999)(85182001)(87936001)(21056001)(83072002)(44976005)(31696002)(86362001)(70736001)(76176999)(23676002)(19580395003)(46102001)(50986999)(4396001)(83506001)(74662001)(74502001)(77982001)(53416003)(102836001)(99396002)(31966008)(20776003)(74316001)(47776003)(50466002)(19580405001)(33646001)(76482001)(64706001)(79102001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB012;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On Wed, 2014-05-21 at 06:26PM +0200, Matthias Brugger wrote:
> Add binding documentation for the General Porpose Timer driver of

Typo: Purpose

> the Mediatek SoCs.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  .../devicetree/bindings/timer/mediatek,mtk-timer.txt   | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> 
> diff --git a/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> new file mode 100644
> index 0000000..7d909f7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> @@ -0,0 +1,18 @@
> +Mediatek MT6577, MT6572 and MT6589 Timers
> +---------------------------------------
> +
> +Required properties:
> +- compatible: Should be "mediatek,mtk6577-timer"
> +- reg: Should contain location and length for timers register.
> +- clocks: Clocks driving the timer hardware. This list shoud include two
> +	clocks. The order is system clock and as second clock the RTC clock.
> +
> +Examples:
> +
> +	timer {

The node name should be timer@0x10008000

> +		compatible = "mediatek,mtk6577-timer";
> +		reg = <0x10008000 0x80>;
> +		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
> +		clocks = <&system_clk>, <&rtc_clk>;
> +		clock-names = "system-clk", "rtc-clk";

I'm still not convinced that the timer IP calls its clock inputs this
way, but well.

Other than that ACK.

	Sören
