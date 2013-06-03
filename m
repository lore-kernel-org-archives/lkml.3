Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3FCJXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:23:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3FCJXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:23:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 10/10] arm: add basic support for Rockchip RK3066a boards
Date: Mon, 03 Jun 2013 11:22:35 +0200
Message-ID: <9452845.qTGjLPCfXq@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <201306031023.49364.heiko@sntech.de>
References: <201306030055.15413.heiko@sntech.de> <5760087.7O4UgypAot@wuerfel> <201306031023.49364.heiko@sntech.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:Puj2kGZ/RFhLvuRqzUk9KJZLQZRnGGo33X4rtGZNLPB
 A1Bi69t4vFpv0OsNY/VbpjlQcUGyIq6dWYGFnJzKpNjz4Qv8Y6
 Av6bPWU9pmaMsx31qV2gZTA4HZu4laex/MXKOPTE1+/MCyIRil
 rw1rUE+KVdFkhkxqR1FsCrk14tpSLph9y9bijsNFDTZlMT25X3
 cry3F+xmfWMLbP17eg2H5NER5HKPOdKIXMlvCDNuJx6ItbQ1ZE
 TLuVtTzyHN7Y3Tpbs6Bd45Tjox3M9mnvz1VwB4eja4kn9XXifA
 X6EgEkLWhzVViKuxSN/eM9b3rGfWIjSD6G0kOuUjaqNfAq3ISq
 lCUYe4qxxexs21Ger4gQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 10:23:49 Heiko Stübner wrote:
> Am Montag, 3. Juni 2013, 04:15:46 schrieb Arnd Bergmann:
> > 
> > Can't you use
> > 
> > 	of_clk_init(NULL);
> > 	clocksource_of_init();
> > 
> > here and change the two drivers to provide the respective macros?
> 
> hmm, while this would make a lot of things easier I don't see right now how 
> this would work.
> 
> The dw_apb_timer clocksource does not have its own device node, but instead 
> uses two timer devices as clocksource and clockevent.
> 
> Hmm ... one idea would be to wrap them in the dt, like
> 
> 	clocksource {
> 		compatible = "snps,dw-apb-clocksource"
> 
> 		timer@2003a000 {
> 			compatible = "snps,dw-apb-timer-osc";
> 			reg = <0x2003a000 0x100>;
> 			interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
> 			clocks = <&clk_gates1 1>, <&clk_gates7 8>;
> 			clock-names = "timer", "pclk";
> 		};
> 
> 		timer@2000e000 {
> 			compatible = "snps,dw-apb-timer-osc";
> 			reg = <0x2000e000 0x100>;
> 			interrupts = <GIC_SPI 46 IRQ_TYPE_LEVEL_HIGH>;
> 			clocks = <&clk_gates1 2>, <&clk_gates7 9>;
> 			clock-names = "timer", "pclk";
> 		};
> 	};

Can't you just have multiple CLOCKSOURCE_OF_DECLARE() lines, one
for each of the nodes?
 
> > > +DT_MACHINE_START(ROCKCHIP_DT, "Rockchip Cortex-A9 (Device Tree)")
> > > +       .map_io         = debug_ll_io_init,
> > > +       .init_machine   = rockchip_dt_init,
> > > +       .init_time      = rockchip_timer_init,
> > > +       .dt_compat      = rockchip_board_dt_compat,
> > > +MACHINE_END
> > 
> > The map_io line can already get removed.
> 
> Yesterday I did grep thru the linux-next I was using as base looking for the 
> debug_ll_io_init default I read about but was not able to find it ... most 
> likely my linux-next is a tad to old.

Yes, it only showed up in today's linux-next. I thought it was older.

	Arnd
