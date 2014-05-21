Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaEURX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:23:59 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:39631
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751857AbaEURX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:23:57 -0400
Date: Wed, 21 May 2014 10:21:44 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko.stuebner@bq.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <linux@arm.linux.org.uk>,
        <daniel.lezcano@linaro.org>, <tglx@linutronix.de>,
        <thierry.reding@gmail.com>, <florian.vaussard@epfl.ch>,
        <jic23@kernel.org>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <silvio.fricke@gmail.com>, <olof@lixom.net>,
        <sebastian.hesselbarth@gmail.com>, <sboyd@codeaurora.org>,
        <gregory.clement@free-electrons.com>, <arnd@arndb.de>,
        <robherring2@gmail.com>, <marc.zyngier@arm.com>,
        <maxime.ripard@free-electrons.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 2/6] dt-bindings: add mtk-timer bindings
References: <1400689583-21119-1-git-send-email-matthias.bgg@gmail.com>
 <1948139.7c1AZ80ZQt@phil>
 <3a9b6824-e088-4774-b125-7a33b5a895dc@BN1AFFO11FD022.protection.gbl>
 <1615424.OJcNQb1ONt@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1615424.OJcNQb1ONt@phil>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <57d6737a-47c8-4297-b668-65bbe6e00369@BY2FFO11FD028.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(51704005)(199002)(189002)(377424004)(24454002)(81542001)(46102001)(23676002)(31966008)(80022001)(74662001)(44976005)(4396001)(70736001)(81342001)(79102001)(92726001)(50466002)(92566001)(77982001)(33646001)(74316001)(76482001)(83506001)(64706001)(54356999)(87936001)(85182001)(99396002)(20776003)(50986999)(47776003)(85852003)(76176999)(74502001)(102836001)(86362001)(53416003)(21056001)(83072002)(31696002);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB028;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0218A015FA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 07:18PM +0200, Heiko Stübner wrote:
> Am Mittwoch, 21. Mai 2014, 09:53:57 schrieb Sören Brinkmann:
> > On Wed, 2014-05-21 at 06:54PM +0200, Heiko Stübner wrote:
> > > Am Mittwoch, 21. Mai 2014, 09:34:10 schrieb Sören Brinkmann:
> > > > Hi Matthias,
> > > > 
> > > > On Wed, 2014-05-21 at 06:26PM +0200, Matthias Brugger wrote:
> > > > > +		compatible = "mediatek,mtk6577-timer";
> > > > > +		reg = <0x10008000 0x80>;
> > > > > +		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
> > > > > +		clocks = <&system_clk>, <&rtc_clk>;
> > > > > +		clock-names = "system-clk", "rtc-clk";
> > > > 
> > > > I'm still not convinced that the timer IP calls its clock inputs this
> > > > way, but well.
> > > 
> > > Maybe this might convince you ;-)
> > > 
> > > "The GPT includes 5 32-bit timers and one 64-bit timer. Each timer has 4
> > > operation modes, which are ONE-SHOT,  REPEAT,  KEEP-GO and  FREERUN, and
> > > can operate on one of the 2 clock sources, RTC clock (32.768kHz) and
> > > system clock (13MHz)."
> > 
> > Is this copied from the timer data sheet or the SOC documentation?
> 
> That is from the processor datasheet containing the timer documentation.
> I don't think it's customary for soc vendors to provide additional individual 
> documentation for self-developed IPs contained in a SoC.

May be, but that is what might create the problem I'm talking about. The
next generation SOC using the same IP may use different clocks to
drive it. Now you're stuck with RTC and system clock as names, but they
don't apply to the latest integration anymore. That's why I advocate
using the IP's naming for its clock signals as opposed to the SOC's
clock names.
So, my concern is still standing. But I see, that this might not be
resolvable, in case such information is not available. Nevertheless,
I see the currently used names as implementation details of the SOC
and not a property of the here described timer IP. But might be that
this is as good as it gets.

	Sören
