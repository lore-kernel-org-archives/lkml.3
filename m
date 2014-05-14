Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaENRqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:46:32 -0400
Received: from dns-bn1lp0143.outbound.protection.outlook.com ([207.46.163.143]:19927
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751683AbaENRq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:46:28 -0400
Date: Wed, 14 May 2014 10:44:42 -0700
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
Subject: Re: [PATCH v4 2/6] dt-bindings: add mtk-timer bindings
References: <1400087579-4250-1-git-send-email-matthias.bgg@gmail.com>
 <1400087579-4250-3-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400087579-4250-3-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <cebe44ba-c543-4f4a-9aeb-810156fe8250@BN1AFFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(24454002)(51704005)(377424004)(189002)(199002)(85182001)(92566001)(50986999)(85852003)(54356999)(99396002)(83072002)(47776003)(76482001)(77982001)(31696002)(87936001)(85202002)(83506001)(74316001)(74502001)(33646001)(50466002)(76176999)(46102001)(31966008)(44976005)(19580395003)(70736001)(83322001)(81342001)(19580405001)(74662001)(23676002)(92726001)(79102001)(53416003)(80022001)(102836001)(81542001)(86362001)(20776003)(4396001)(23106003);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB037;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0211965D06
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On Wed, 2014-05-14 at 07:12PM +0200, Matthias Brugger wrote:
> Add binding documentation for the General Porpose Timer driver of
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
> index 0000000..938adf6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> @@ -0,0 +1,18 @@
> +Mediatek MT6589, MT6577 and MT6572 Timers
> +---------------------------------------
> +
> +Required properties:
> +- compatible: Should be "mediatek,mtk6589-timer"

Don't you want compatible strings for the other supported SOCs too?

> +- reg: Should contain location and length for timers register.
> +- clocks: Clocks driving the timer hardware. This list shoud include two
> +	clocks. The order is system clock and as second clock the RTC clock.

Sorry for being pedantic, but we had so many ugly bindings in our vendor
tree. I'm still getting caught up on the clocks. I have the feeling the SOC
has two clocks (system and rtc) which are used to drive this timer,
while the timer probably refers differently to its clock inputs.
If this was the case, the names 'rtc' and 'system' clock are SOC specific
names/implementation details. From the timer perspective it is probably
just important that it receives two clock inputs. Since the timer is
described here and not the SOC, these SOC specific names should
disappear and be replaced with the names the timer IP uses for its input
clocks.

The clock-names should be listed too, probably as optional properties.

> +
> +Examples:
> +
> +	timer {
> +		compatible = "mediatek,mtk6589-timer";
> +		reg = <0x10008000 0x80>;
> +		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
> +		clocks = <&system_clk>, <&rtc_clk>;
> +		clock-names = "system-clk", "rtc-clk";


	Sören
