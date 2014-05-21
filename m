Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaEUQv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:51:26 -0400
Received: from gloria.sntech.de ([95.129.55.99]:44048 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaEUQvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:51:25 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko.stuebner@bq.com>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        olof@lixom.net, sebastian.hesselbarth@gmail.com, sboyd@codeaurora.org,
        gregory.clement@free-electrons.com, arnd@arndb.de,
        robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 2/6] dt-bindings: add mtk-timer bindings
Date: Wed, 21 May 2014 18:54:20 +0200
Message-ID: <1948139.7c1AZ80ZQt@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <63a3ee29-aa23-4137-9c0c-5b2bdd75a68f@BN1BFFO11FD014.protection.gbl>
References: <1400689583-21119-1-git-send-email-matthias.bgg@gmail.com> <1400689583-21119-3-git-send-email-matthias.bgg@gmail.com> <63a3ee29-aa23-4137-9c0c-5b2bdd75a68f@BN1BFFO11FD014.protection.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 21. Mai 2014, 09:34:10 schrieb Sören Brinkmann:
> Hi Matthias,
> 
> On Wed, 2014-05-21 at 06:26PM +0200, Matthias Brugger wrote:
> > Add binding documentation for the General Porpose Timer driver of
> 
> Typo: Purpose
> 
> > the Mediatek SoCs.
> > 
> > Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> > ---
> > 
> >  .../devicetree/bindings/timer/mediatek,mtk-timer.txt   | 18
> >  ++++++++++++++++++ 1 file changed, 18 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt> 
> > diff --git
> > a/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> > b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt new file
> > mode 100644
> > index 0000000..7d909f7
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> > @@ -0,0 +1,18 @@
> > +Mediatek MT6577, MT6572 and MT6589 Timers
> > +---------------------------------------
> > +
> > +Required properties:
> > +- compatible: Should be "mediatek,mtk6577-timer"
> > +- reg: Should contain location and length for timers register.
> > +- clocks: Clocks driving the timer hardware. This list shoud include two
> > +	clocks. The order is system clock and as second clock the RTC clock.
> > +
> > +Examples:
> > +
> > +	timer {
> 
> The node name should be timer@0x10008000

I think the more commonly used variant is

	timer@10008000

without the 0x. While some dts files really use @0x they are in the minority.


> 
> > +		compatible = "mediatek,mtk6577-timer";
> > +		reg = <0x10008000 0x80>;
> > +		interrupts = <GIC_SPI 113 IRQ_TYPE_LEVEL_LOW>;
> > +		clocks = <&system_clk>, <&rtc_clk>;
> > +		clock-names = "system-clk", "rtc-clk";
> 
> I'm still not convinced that the timer IP calls its clock inputs this
> way, but well.

Maybe this might convince you ;-)

"The GPT includes 5 32-bit timers and one 64-bit timer. Each timer has 4 
operation modes, which are ONE-SHOT,  REPEAT,  KEEP-GO and  FREERUN, and can 
operate on one of the 2 clock sources, RTC clock (32.768kHz) and system clock 
(13MHz)."


Heiko
