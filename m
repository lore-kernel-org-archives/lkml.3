Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaJGTiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 15:38:21 -0400
Received: from gloria.sntech.de ([95.129.55.99]:48311 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaJGTiU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 15:38:20 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kever Yang <kever.yang@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        =?utf-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: enable init rate for clock
Date: Tue, 07 Oct 2014 21:37:48 +0200
Message-ID: <3345042.lGjGYUIfnV@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=WwXXQ6941WuATBiNqZ0sM3EkSo-EHHoqn3uGmZdNvW5w@mail.gmail.com>
References: <1412674438-26160-1-git-send-email-kever.yang@rock-chips.com> <1854393.Qf7h4x8eso@phil> <CAD=FV=WwXXQ6941WuATBiNqZ0sM3EkSo-EHHoqn3uGmZdNvW5w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 7. Oktober 2014, 12:20:38 schrieb Doug Anderson:
> Heiko,
> 
> On Tue, Oct 7, 2014 at 11:27 AM, Heiko Stübner <heiko@sntech.de> wrote:
> > Am Dienstag, 7. Oktober 2014, 10:03:19 schrieb Doug Anderson:
> >> Kever,
> >> 
> >> On Tue, Oct 7, 2014 at 2:33 AM, Kever Yang <kever.yang@rock-chips.com>
> > 
> > wrote:
> >> > We need to initialize PLL rate and some of bus clock rate while
> >> > kernel init, for there is no other module will do that.
> >> > 
> >> > Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> >> > ---
> >> > 
> >> >  arch/arm/boot/dts/rk3288.dtsi | 10 ++++++++++
> >> >  1 file changed, 10 insertions(+)
> >> > 
> >> > diff --git a/arch/arm/boot/dts/rk3288.dtsi
> >> > b/arch/arm/boot/dts/rk3288.dtsi
> >> > index 874e66d..2f4519b 100644
> >> > --- a/arch/arm/boot/dts/rk3288.dtsi
> >> > +++ b/arch/arm/boot/dts/rk3288.dtsi
> >> > @@ -455,6 +455,16 @@
> >> > 
> >> >                 rockchip,grf = <&grf>;
> >> >                 #clock-cells = <1>;
> >> >                 #reset-cells = <1>;
> >> > 
> >> > +               assigned-clocks = <&cru PLL_GPLL>, <&cru PLL_CPLL>,
> >> > +                                 <&cru PLL_NPLL>, <&cru ACLK_CPU>,
> >> > +                                 <&cru HCLK_CPU>, <&cru PCLK_CPU>,
> >> > +                                 <&cru ACLK_PERI>, <&cru HCLK_PERI>,
> >> > +                                 <&cru PCLK_PERI>;
> >> > +               assigned-clock-rates = <594000000>, <400000000>,
> >> > +                                      <500000000>, <300000000>,
> >> 
> >> When I boot up, I see that ACLK_CPU was 297000000.  You specified
> >> 300000000.  Did you expect to get 300?  If you expected 297, I think
> >> you should put 297.  If you expected 300 then we have some debugging
> >> to do.  Note: I'm not quite sure how you'd expect to get 300 given
> >> that none of the PLLs divide evenly to 300...
> > 
> > I'd think 300 is simply the target value. I.e. take the closest rate <=
> > 300
> > MHz, same for 150 etc. I somehow like the approach of specifying what the
> > rate _should_ ideally be :-) .
> > 
> > Also reduces the amount of thougths necessary (and possible
> > head-scratching) when adapting the pll rates to some other constraints
> > (child-clocks already have the target rates and cannot drop to some even
> > stranger value).
> OK, fair enough.  I guess maybe I've overly paranoid and like to make
> sure that someone has thought through exactly what various core clocks
> should be and made sure that the voltage matched and that clocks were
> never out of spec.  ...but if others really like specifying more ideal
> values then I'm OK with it.

Especially as clocks like ACLK_CPU can select from different plls (cpll and 
gpll on the rk3288) it would be even more difficult to predict which path the 
clock selection would take. So it makes sense to specifiy the value we wish for 
and let the common-clock-framework do its magic to select the best sources.


>I will say that I'd really like the PLLs
> to be exact, though.  I think those are now...

agreed. PLL rates should be exact.
