Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846AbaEMOmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:42:49 -0400
Received: from mail-by2on0104.outbound.protection.outlook.com ([207.46.100.104]:17776
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759892AbaEMOmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:42:47 -0400
X-Greylist: delayed 5580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 May 2014 10:42:47 EDT
Date: Tue, 13 May 2014 06:08:07 -0700
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
Subject: Re: [PATCH v3 2/6] dt-bindings: add mtk-timer bindings
References: <1399938570-11356-1-git-send-email-matthias.bgg@gmail.com>
 <1399938570-11356-3-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1399938570-11356-3-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <2e93c984-96d9-4504-bb9a-672a247fb710@BL2FFO11FD034.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(438001)(377424004)(199002)(189002)(51704005)(24454002)(19580405001)(83322001)(46102001)(19580395003)(70736001)(23676002)(4396001)(81542001)(102836001)(92726001)(74662001)(81342001)(31696002)(80022001)(47776003)(20776003)(83506001)(50466002)(86362001)(575784001)(74316001)(76482001)(87936001)(77982001)(53416003)(85852003)(85202002)(83072002)(85182001)(50986999)(44976005)(33646001)(74502001)(54356999)(99396002)(79102001)(76176999)(23106003);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2FFO11HUB031;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0210479ED8
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthias,

On Tue, 2014-05-13 at 01:49AM +0200, Matthias Brugger wrote:
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
> index 0000000..d0f2df3
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> @@ -0,0 +1,18 @@
> +Mediatek MT6589, MT6577 and MT6572 Timers
> +---------------------------------------
> +
> +Required properties:
> +- compatible: Should be "mediatek,mtk6589-timer"
> +- reg: Should contain location and length for timers register.
> +- clocks: phandle to the clock source; the first refers to a 13 MHz fixed
> +		system clock and the second handle to a 32 KHz fixed RTC
> +		clock.

Are these frequencies mandatory to the timer or an implementation
detail of the SOC you're working with? I suspect, it might be possible
to see the same timer in a different SOC implementation with different
frequencies? In that case - or probably in general - the frequencies
should not be part of the binding, IMHO.

> +
> +Examples:
> +
> +	timer {
> +		compatible = "mediatek,mtk6589-timer";
> +		reg = <0x10008000 0x80>;
> +		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
> +		clocks = <&system_clk>, <&rtc_clk>;

Might be just my personal preference, but you could also add the clock-names
property which would relax the ordering requirement a bit and would
clearly  identify the IP's clocks.

	Sören
